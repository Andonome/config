output: docs.pdf

images:
	mkdir images
images/wide.jpg: images
	convert -size 100x60 xc:skyblue -fill white -stroke black  -draw "ellipse 50,30 40,20 45,270" images/wide.jpg

docs.pdf: images/wide.jpg $(wildcard *.sty) docs.tex
	pdflatex -shell-escape docs.tex
test.pdf: test.tex $(wildcard *.sty) $(wildcard *.tex)
	pdflatex -shell-escape test.tex
	makeglossaries test
resources.pdf: $(wildcard *.tex) $(wildcard *.sty) 
	pdflatex -shell-escape resources.tex
rules.pdf: rules.tex rules $(wildcard *.sty)
	pdflatex -shell-escape rules.tex

all: docs.pdf test.pdf resources.pdf rules.pdf
clean:
	rm -rf *pdf *.aux *.toc *.acn *.acr *.log *.ptc *.out *.idx *.ist *.alg \
    *glo \
	*slo \
	*sls \
	*slg \
	*glg \
	*gls \
	*.ind \
	*.ilg \
  images/wide.jpg \
	svg-inkscape
