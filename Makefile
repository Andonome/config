pdfs += rules.pdf character_sheets.pdf $(DROSS)/test.pdf markets.pdf

output: docs.pdf

include vars

$(DROSS)/docs.pdf: images/extracted/wide.jpg

dependence += magick

images/extracted/wide.jpg: images/extracted/
	magick -size 100x60 xc:skyblue -fill white -stroke black  -draw "ellipse 50,30 40,20 45,270" $@

.PHONY: test
test: $(DROSS)/test.pdf
$(DROSS)/test.pdf: $(wildcard *.sty) $(wildcard spells/*.tex) $(DROSS)/
	$(RUN) test.tex
	$(GLOS) test
	$(RUN) test.tex

docs.pdf: images/extracted/wide.jpg ## Make documentation

character_sheets.pdf: ## Character sheets
markets.pdf: ## Current price sheets

$(DROSS)/p_1.pdf: $(DROSS)/booklet.pdf
	pdfjam --angle '90' $< 1 --outfile $@
$(DROSS)/p_2.pdf: $(DROSS)/booklet.pdf
	pdfjam --angle '-90' $< 2 --outfile $@
rules.pdf: $(DROSS)/p_1.pdf $(DROSS)/p_2.pdf ## One-page rules summary
	pdfunite $^ $@

