pdfs += character_sheets.pdf $(DROSS)/test.pdf markets.pdf
pdfs += docs.pdf 
zines += rules.pdf
zines += spells.pdf
targets += cs.pdf

dependencies += magick
dependencies += pstops ps2pdf pdftops

include common.mk

$(DROSS)/docs.pdf: images/extracted/wide.jpg

images/extracted/wide.jpg: images/extracted/
	magick -size 100x60 xc:skyblue -fill white -stroke black  -draw "ellipse 50,30 40,20 45,270" $@

.PHONY: test
test: $(DROSS)/test.pdf ## Compile test document
$(DROSS)/test.pdf: share/test.tex $(wildcard *.sty) $(wildcard spells/*.tex) | $(DROSS)/
	$(RUN) $<
	$(GLOS) $(basename $(@F))
	$(RUN) $<

character_sheets.pdf: csCommands.sty $(wildcard $(DROSS)/.count.tex) ## Character sheets
markets.pdf: market.sty $(wildcard markets/*.tex) ## Current price sheets
rules.pdf: ## one-page copy of the rules
cs.pdf: ## tiny character sheet

