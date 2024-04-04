include vars

output: docs.pdf

$(DROSS):
	mkdir $(DROSS)

images:
	mkdir images
images/wide.jpg:| images
	convert -size 100x60 xc:skyblue -fill white -stroke black  -draw "ellipse 50,30 40,20 45,270" images/wide.jpg

ALL_FILES := $(wildcard *.tex) $(wildcard *.sty) | $(DROSS)

$(DROSS)/test.pdf: test.tex $(ALL_FILES)
	$(RUN) test.tex

docs.pdf: images/wide.jpg $(ALL_FILES)
	$(RUN) docs.tex
	$(GLOS) docs
	$(RUN) docs.tex
	$(CP) $(DROSS)/docs.pdf docs.pdf
resources.pdf: $(ALL_FILES)
	$(RUN) resources.tex
	$(CP) $(DROSS)/resources.pdf resources.pdf
rules.pdf: images/wide.jpg $(ALL_FILES)
	$(RUN) rules.tex
	$(CP) $(DROSS)/rules.pdf rules.pdf

.PHONY: all clean
all: docs.pdf resources.pdf rules.pdf $(DROSS)/test.pdf 
clean:
	$(CLEAN) images/wide.jpg
