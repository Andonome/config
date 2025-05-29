pdfs += character_sheets.pdf $(DROSS)/test.pdf markets.pdf
pdfs += a7_rules.pdf 

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

character_sheets.pdf: csCommands.sty CS.tex backpage.tex ## Character sheets
markets.pdf: market.sty $(wildcard markets/*.tex) ## Current price sheets

######## Booklets ########

# The A7 booklet has 16 pages to the signature
layout = 16:

# The layout lists page indexes, so '0' means 'page 1', and '0L' means 'page 1
# but turn 90 degrees to the left'
layout += 4L(1w,0h)+12L(1w,0.25h)+15L(1w,0.5h)+0L(1w,0.75h)+3R(0w,0.25h)+11R(0w,0.5h)+8R(0w,0.75h)+7R(0w,1h),

# The first block ends with a comma, which indicates that we are working on the
# back-page.
layout += 5L(1w,0h)+10L(1w,0.25h)+9L(1w,0.5h)+6L(1w,0.75h)+2R(0w,0.25h)+13R(0w,0.5h)+14R(0w,0.75h)+1R(0w,1h)

# 'make' adds spaces between variables, but `pstops` will not be happy with those spaces.
a7_layout != printf '%s' '$(layout)' | tr -d ' '

$(DROSS)/%.ps: $(DROSS)/%.pdf
	pdftops $< $@

$(DROSS)/a7_%.ps: $(DROSS)/%.ps
	pstops -pa4 '$(a7_layout)' $< $@

$(DROSS)/a7_%.pdf: $(DROSS)/a7_%.ps
	ps2pdf $< $@


