#!/bin/sh

xbps-install -Sy xbps
xbps-install -Sy git git-lfs \
	inkscape \
	bash \
	make \
	texlive-latexmk \
	texlive2023-bin 

git lfs install

ln -sf /usr/bin/bash /usr/bin/sh
