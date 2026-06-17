#!/bin/sh

xbps-install -Sy xbps
xbps-install -Sy git git-lfs \
	inkscape \
	psutils \
    recutils \
    biber \
	tar \
	bash \
	make \
    recutils \
	ImageMagick \
	texlive-bin 

git lfs install

xbps-remove -Oo
