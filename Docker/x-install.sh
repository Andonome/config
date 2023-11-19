#!/bin/sh

xbps-install -Sy xbps
xbps-install -Sy git git-lfs \
	inkscape \
	tar \
	bash \
	make \
	qrencode \
	ImageMagick \
	texlive-latexmk \
	texlive-bin 

git lfs install
