INPUT-SOURCE = examples
INPUT-TMP = last-run
INPUT-BIB = literatura
HTML-DIR = html

all : view

view : $(INPUT-TMP).pdf	
	acroread $(INPUT-TMP).pdf &

$(INPUT-TMP).pdf : $(INPUT-TMP).tex $(INPUT-TMP).bbl $(INPUT-BIB).bib
	pdfcslatex $(INPUT-TMP).tex
	pdfcslatex $(INPUT-TMP).tex

$(INPUT-TMP).bbl : $(INPUT-BIB).bib $(INPUT-TMP).tex
	rm -f $(INPUT-TMP).bbl
	pdfcslatex $(INPUT-TMP).tex
	bibtex $(INPUT-TMP)

$(INPUT-TMP).tex : $(INPUT-SOURCE).tex
	cp $(INPUT-SOURCE).tex $(INPUT-SOURCE).tex~
	cp $(INPUT-SOURCE).tex $(INPUT-TMP).tex
	vlna -l $(INPUT-TMP).tex
	vlna -l -v ai $(INPUT-TMP).tex

clean :
	rm -rf *.log *.aux *.toc $(INPUT-TMP).* $(HTML-DIR)/

html : $(INPUT-TMP).tex $(INPUT-TMP).bbl $(INPUT-BIB).bib
	latex2html -dir $(HTML-DIR) -mkdir -split 0 -lcase_tags -nonavigation -numbered_footnotes -noinfo -html_version 4.0,latin2,unicode,math,tables $(INPUT-TMP).tex
	sed -i 's/&#305;/í/g' $(HTML-DIR)/*.html
