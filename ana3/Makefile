all:
		latexmk -e "\$$hash_calc_ignore_pattern{'pdf'} = '^/(CreationDate|ModDate|ID) ';" -pdf -pdflatex="pdflatex --shell-escape %O %S" vorlesung.tex;
view:
		xdg-open vorlesung.pdf;

clean:
		rm -f *.aux *.bbl *.bib *.bcf *.blg *.dvi *.lof *.log *.fdb_latexmk *.fls *.idx *.ilg *.ind *.out *.ps *.run.xml *.thm *.toc

distclean: clean
