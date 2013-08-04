# TARGET has to be specified

PDFLATEX_OPTIONS += -synctex=1
LATEXMK     ?= latexmk -recorder -pdf -pdflatex="pdflatex $(PDFLATEX_OPTIONS) %O %S"
PDFVIEWER   ?= xdg-open
PDFLATEX    ?= pdflatex -synctex=1
BIBTEX      ?= bibtex

ifneq ($(strip $(TARGET)),)
PDFTARGETS  += $(TARGET).pdf
endif

export TEXINPUTS = $(shell git rev-parse --show-toplevel)/common:
INCLUDEDIR = $(shell git rev-parse --show-toplevel)/common

LATEXMK_VERSION := $(shell latexmk --version 2> /dev/null)


all: $(PDFTARGETS)

view: $(PDFTARGETS)
	$(PDFVIEWER) $(PDFTARGETS)


ifdef LATEXMK_VERSION
#================================
# Using latexmk
#--------------------------------
$(info latexmk installed.)


.PHONY: FORCE_MAKE

%.pdf: %.tex FORCE_MAKE
	$(LATEXMK) $<

#clean:
#	$(LATEXMK) -c $<
#
#distclean: clean
#	$(LATEXMK) -C



else
#================================
# Using pdflatex with make rules
#--------------------------------
$(info latexmk not installed, falling back to pdflatex make rules.)



# grep bibtex dependencies
ifneq ($(strip $(TARGET)),)
BIBFILES = $(patsubst %,%.bib,\
		$(shell grep '^[^%]*\\bibliography{' $(TARGET).tex | \
			sed -e 's/^[^%]*\\bibliography{\([^}]*\)}.*/\1/' \
			    -e 's/, */ /g'))
endif


#---------------------------------
# \input and \include dependencies
ifneq ($(strip $(TARGET)),)
INCLUDEDTEX := $(patsubst %,%.tex,\
		$(shell sed -rn 's/^[^%]*\\(input|include)\{([^\.\}]*)(\.tex)?\}/\2/p' $(TARGET).tex))
# second depth
ifneq ($(strip $(INCLUDEDTEX)),)
INCLUDEDTEX += $(foreach INCFILE,$(INCLUDEDTEX),$(patsubst %,%.tex,\
		$(shell sed -rn 's/^[^%]*\\(input|include)\{([^\.\}]*)(\.tex)?\}/\2/p' $(INCFILE))))
endif
endif
# quick-hack to get sty dependency (TODO: a clean solution)
INCLUDEDPKG = $(wildcard $(INCLUDEDIR)/*.sty) $(wildcard $(INCLUDEDIR)/*.cls)
#---------------------------------

AUXFILES = $(PDFTARGETS:.pdf=.aux)
AUXFILES += $(INCLUDEDTEX:.tex=.aux)
LOGFILES = $(AUXFILES:.aux=.log)

# short git revision
REVISION := $(shell git rev-parse --short HEAD)

.PHONY: all clean distclean pdf view

# to generate aux but not pdf from pdflatex, use -draftmode
.SECONDARY: $(AUXFILES)

$(AUXFILES): %.aux: | %.tex
	$(PDFLATEX) -draftmode $*;

# introduce BibTeX dependency if we found a \bibliography
ifneq ($(strip $(BIBFILES)),)
BIBDEPS = %.bbl
%.bbl: $(BIBFILES) %.aux
	$(BIBTEX) $*
endif

#$(PDFTARGETS): %.pdf: %.tex %.aux $(BIBDEPS) $(INCLUDEDTEX)
$(PDFTARGETS): %.pdf: %.tex $(INCLUDEDTEX) $(INCLUDEDPKG) | $(BIBDEPS)
	$(PDFLATEX) $*
ifneq ($(strip $(BIBFILES)),)
	@if grep -q "undefined references" $*.log; then \
		$(BIBTEX) $* && $(PDFLATEX) $*; fi
endif
	@while grep -q "Rerun to" $*.log; do \
		$(PDFLATEX) $*; done




endif


clean:
	rm -f $(foreach T,$(PDFTARGETS:.pdf=), \
		$(T).out $(T).thm $(T).blg $(T).bbl \
		$(T).lof $(T).lot $(T).toc $(T).idx \
		$(T).nav $(T).snm $(T)-pics.pdf \
		$(T).fdb_latexmk $(T).synctex.gz \
		$(T).log $(T).fls $(T).aux) \
		$(AUXFILES) $(LOGFILES)

distclean: clean
	rm -f $(PDFTARGETS)
