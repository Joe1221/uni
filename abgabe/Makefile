LATEXMKFLAGS = -silent
TEX_SOURCES = $(wildcard *.tex)
PDF_TARGETS = $(patsubst %.tex,%.pdf,$(TEX_SOURCES))

%.pdf: %.tex
	@echo "Kompiliere $< …";
	@latexmk $(LATEXMKFLAGS) -pdf $< &> /dev/null;

all: $(PDF_TARGETS)

clean:
	rm -f *.aux *.bbl *.bib *.bcf *.blg *.dvi *.lof *.log *.fdb_latexmk *.fls *.idx *.ilg *.ind *.out *.ps *.run.xml *.thm *.toc

distclean: clean
	rm -f $(PDF_TARGETS)
