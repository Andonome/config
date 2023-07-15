output: resources.pdf
resources.pdf: config/bind.sty
	pdflatex resources.tex
config/bind.sty:
	git submodule update --init
clean:
	rm -fr *.aux *.sls *.slo *.slg *.toc *.acn *.log *.ptc *.out *.idx *.ist *.glo *.glg *.gls *.acr *.alg *.ilg *.ind *.pdf
