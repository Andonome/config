filename=docs
output: ${filename}.pdf
${filename}.pdf: ${filename}.aux bind.sty monsters.sty
	pdflatex ${filename}.tex
docs.aux:
	pdflatex --shell-escape docs.tex
	pdflatex docs.tex
docs: docs.aux
	pdflatex docs.tex
test:
	pdflatex --shell-escape test.tex
all: docs test
clean:
	rm -rf *pdf *.aux *.toc *.acn *.acr *.log *.ptc *.out *.idx *.ist *.alg *.glo svg-inkscape
