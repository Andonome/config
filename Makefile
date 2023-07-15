filename=docs
output: ${filename}.pdf
${filename}.pdf: ${filename}.aux bind.sty monsters.sty
	pdflatex ${filename}.tex
docs.aux: images/wide.jpg
	pdflatex --shell-escape docs.tex
	pdflatex docs.tex
docs: docs.aux
	pdflatex docs.tex
test:
	pdflatex --shell-escape test.tex

resources.pdf: config/bind.sty
	pdflatex resources.tex
images:
	mkdir images
images/wide.jpg: images
	convert -size 100x60 xc:skyblue -fill white -stroke black  -draw "ellipse 50,30 40,20 45,270" images/wide.jpg
all: docs test resources.pdf
clean:
	rm -rf *pdf *.aux *.toc *.acn *.acr *.log *.ptc *.out *.idx *.ist *.alg *.glo \
	*.slo \
	*.sls \
	*.glg \
	*.gls \
	svg-inkscape
