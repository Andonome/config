output: docs.pdf

include vars

images:
	mkdir images
images/wide.jpg:| images
	convert -size 100x60 xc:skyblue -fill white -stroke black  -draw "ellipse 50,30 40,20 45,270" images/wide.jpg

ALL_FILES := LOCTEX STYLE_FILES | $(DROSS)

.PHONY: test
test: $(DROSS)/test.pdf
$(DROSS)/test.pdf: $(ALL_FILES) $(DROSS)
	$(RUN) test.tex
	$(GLOS) test
	$(RUN) test.tex

$(DBOOK): docs.pdf
	$(CP) $< $@
docs.pdf: images/wide.jpg STYLE_FILES | $(DROSS) ## Make documentation
	$(RUN) docs.tex
	$(GLOS) docs
	$(RUN) docs.tex
	$(CP) $(DROSS)/docs.pdf docs.pdf
character_sheets.pdf: HANDOUTS STYLE_FILES | $(DROSS) ## Character sheets
	$(RUN) character_sheets.tex
	$(RUN) character_sheets.tex
	$(CP) $(DROSS)/character_sheets.pdf character_sheets.pdf

booklet.pdf: | STYLE_FILES HANDOUTS $(DROSS)
	$(RUN) booklet.tex
	$(RUN) booklet.tex
	$(CP) $(DROSS)/booklet.pdf booklet.pdf

/tmp/p_1.pdf: booklet.pdf
	pdfjam --angle '90' $< 1 --outfile $@

/tmp/p_2.pdf: booklet.pdf
	pdfjam --angle '-90' $< 2 --outfile $@
rules.pdf: /tmp/p_1.pdf /tmp/p_2.pdf ## One-page rules summary
	pdfunite $^ $@

markets.pdf: config/market.sty $(wildcard config/markets/*) | $(DROSS) ## Price-sheets for baileys and town
	$(RUN) -jobname markets markets/all.tex
	$(RUN) -jobname markets markets/all.tex
	$(CP) $(DROSS)/$@ .

targets += docs.pdf rules.pdf character_sheets.pdf $(DROSS)/test.pdf markets.pdf
output += images/wide.jpg
