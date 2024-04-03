include vars

output: docs.pdf

rubbish/:
	mkdir rubbish

images:
	mkdir images
images/wide.jpg:| images
	convert -size 100x60 xc:skyblue -fill white -stroke black  -draw "ellipse 50,30 40,20 45,270" images/wide.jpg

ALL_FILES = $(wildcard *.tex) $(wildcard *.sty) | rubbish/

rubbish/test.pdf: test.tex $(ALL_FILES)
	$(RUN) test.tex

docs.pdf: images/wide.jpg $(ALL_FILES)
	$(RUN) docs.tex
	$(CP) rubbish/docs.pdf docs.pdf
resources.pdf: $(ALL_FILES)
	$(RUN) resources.tex
	$(CP) rubbish/resources.pdf resources.pdf
rules.pdf: images/wide.jpg $(ALL_FILES)
	$(RUN) rules.tex
	$(CP) rubbish/rules.pdf rules.pdf

.PHONY: all clean
all: docs.pdf resources.pdf rules.pdf rubbish/test.pdf 
clean:
	$(CLEAN) images/wide.jpg
