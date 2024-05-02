#======================================
# A Makefile designed for proposals
# Author: Endadul Hoque 
#======================================

PRJ = main
#LATEX = xelatex 
LATEX = pdflatex
SUMMARY = summary
VIEWER = open
BIBDIR = bibs
CONTENTDIR = contents
# BIODIR = bios-tex

### OS specific PDF viewer
UNAME := $(shell uname)
ifeq ($(UNAME), Linux)
  VIEWER = xdg-open
endif


# Small cheat to allow synchronization between PDF and .tex for supported editors (run `make S=1`)
ifdef S
  EXTRA := -synctex=1
endif

EXTRA := ${EXTRA} -shell-escape

all : ${PRJ}.pdf

# To check the parameters provided to pdflatex command
xx:
	echo XX ${EXTRA}



# ${PRJ}.pdf : *.tex *.bib ${BIODIR}/*.tex

${PRJ}.pdf : ${CONTENTDIR}/*.tex ${BIBDIR}/*.bib 
	${LATEX} ${EXTRA} ${PRJ}
	- (ls *.aux | xargs -n 1 bibtex)
	${LATEX} ${EXTRA} ${PRJ} && ${LATEX} ${EXTRA} ${PRJ}

me: view

view : ${PRJ}.pdf
	${VIEWER} ${PRJ}.pdf

clean:
	@/bin/rm -f *.toc *.aux *.bbl *.blg *.log *~* *.bak *.out *synctex.gz ${PRJ}.pdf cut.sh *.ps *.aux *.dvi *.fls *.fdb_latexmk *.ent
	@/bin/rm -rf _minted-*/

# - (ls ${BIODIR} | xargs -n 1 -i make -C {} clean | echo "ok")

distclean: clean
	/bin/rm -f ${PRJ}*.pdf

# Adjust pages before running cut
cut : ${PRJ}.pdf cut.sh
	bash cut.sh

summary: summary.txt
summary.txt: ${SUMMARY}.tex
	pandoc -f latex -t plain --ascii --wrap=none $< -o $@
