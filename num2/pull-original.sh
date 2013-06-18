#!/bin/bash

URL="http://www.mathematik.uni-stuttgart.de/~harrach/lehre/Numerik2.tex";
target="Numerik2.tex";

git checkout num2-original
if [[ $? != 0 ]]; then
	exit $?;
fi
git pull --ff-only;


# Getting tex file
echo "Fetching original tex from $URL to $target … ";
wget -qO "$target" "$URL";

# charset conversion
CHARSET="$( file -bi "$target"|awk -F "=" '{print $2}')"
if [ "$CHARSET" != "utf-8" ]; then
	echo "Converting from $CHARSET to utf8 …";

	iconv -f "$CHARSET" -t utf8 "$target" -o "${target}.tmp";
	mv "${target}.tmp" "${target}";
fi

# line-endings conversion
echo "Stripping carriage-returns …";
tr -d '\r' < "${target}" > "${target}.tmp";
mv "${target}.tmp" "${target}";


# Änderungen commiten
git add "${target}" &&
git commit -m "num2: Änderungen des Orginalskripts" &&
git push origin num2-original:num2-original;
git checkout master;
