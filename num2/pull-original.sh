#!/bin/bash

URL="http://www.mathematik.uni-stuttgart.de/~harrach/lehre/Numerik2.tex";
TARGET="Numerik2.tex";

git stash -q && \
git checkout -q num2-original && \
git pull --ff-only;
if [[ $? != 0 ]]; then
	exit $?;
fi


# Getting tex file
echo "Fetching original tex from $URL to $TARGET … ";
wget -qO "$TARGET" "$URL";
if [ $? -eq 0 ]; then

	# charset conversion
	CHARSET="$( file -bi "$TARGET"|awk -F "=" '{print $2}')"
	if [ "$CHARSET" != "utf-8" ]; then
		echo "Converting from $CHARSET to utf8 …";

		iconv -f "$CHARSET" -t utf8 "$TARGET" -o "${TARGET}.tmp";
		mv "${TARGET}.tmp" "${TARGET}";
	fi

	# line-endings conversion
	echo "Stripping carriage-returns …";
	tr -d '\r' < "${TARGET}" > "${TARGET}.tmp";
	mv "${TARGET}.tmp" "${TARGET}";

	git diff --quiet;
	if [ $? -ne 0 ]; then
		echo "There were changes, committing …"
		# Änderungen commiten
		git add "${TARGET}" && \
		git commit -m "num2: Änderungen des Orginalskripts" && \
		git push origin num2-original:num2-original;
	else
		echo "There were no changes, finishing …"
	fi

else
	echo "ERROR: Couldn't fetch $URL.";
fi
git checkout -q master && \
git stash pop -q;
