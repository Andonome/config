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

docs.pdf: images/wide.jpg STYLE_FILES | $(DROSS)
	$(RUN) docs.tex
	$(GLOS) docs
	$(RUN) docs.tex
	$(CP) $(DROSS)/docs.pdf docs.pdf
resources.pdf: HANDOUTS STYLE_FILES | $(DROSS)
	$(RUN) resources.tex
	$(RUN) resources.tex
	$(CP) $(DROSS)/resources.pdf resources.pdf

booklet.pdf: STYLE_FILES HANDOUTS | $(DROSS)
	$(RUN) booklet.tex
	$(RUN) booklet.tex
	@pdfjam --angle 90 $(DROSS)/booklet.pdf --no-landscape --outfile $@

.PHONY: all clean
all: docs.pdf booklet.pdf resources.pdf $(DROSS)/test.pdf 
clean:
	$(CLEAN) images/wide.jpg
