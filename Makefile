output: docs.pdf

images:
	mkdir images
images/wide.jpg: images
	convert -size 100x60 xc:skyblue -fill white -stroke black  -draw "ellipse 50,30 40,20 45,270" images/wide.jpg

docs.pdf: images/wide.jpg
	pdflatex -shell-escape docs.tex
test.pdf:
	pdflatex -shell-escape test.tex
resources.pdf:
	pdflatex -shell-escape resources.tex
rules.pdf:
	pdflatex -shell-escape rules.tex

all: docs.pdf test.pdf resources.pdf rules.pdf
clean:
	rm -rf *pdf *.aux *.toc *.acn *.acr *.log *.ptc *.out *.idx *.ist *.alg *.glo \
	*.slo \
	*.sls \
	*.glg \
	*.gls \
	svg-inkscape
