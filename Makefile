pdfs += character_sheets.pdf $(DROSS)/test.pdf markets.pdf
pdfs += docs.pdf 
targets += rules.pdf
targets += cs.pdf

dependencies += magick
dependencies += pstops ps2pdf pdftops

include vars

$(DROSS)/docs.pdf: images/extracted/wide.jpg

images/extracted/wide.jpg: images/extracted/
	magick -size 100x60 xc:skyblue -fill white -stroke black  -draw "ellipse 50,30 40,20 45,270" $@

.PHONY: test
test: $(DROSS)/test.pdf
$(DROSS)/test.pdf: $(wildcard *.sty) $(wildcard spells/*.tex) $(DROSS)/
	$(RUN) test.tex
	$(GLOS) test
	$(RUN) test.tex

character_sheets.pdf: csCommands.sty CS.tex backpage.tex ## Character sheets
markets.pdf: market.sty $(wildcard markets/*.tex) ## Current price sheets
rules.pdf: ## one-page copy of the rules

