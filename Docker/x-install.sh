#!/bin/sh

xbps-install -Sy xbps
xbps-install -Sy git git-lfs \
	inkscape \
	psutils \
	tar \
	bash \
	make \
    recutils \
	ImageMagick \
	texlive-latexmk \
	texlive-bin 

git lfs install

xbps-remove -Oo
