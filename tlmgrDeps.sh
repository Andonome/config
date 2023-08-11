#!/bin/sh
# This file has the recommended LaTeX packages.
# First install tlmgr (likely in the package 
# texlive or texlive-bin) and texlive2023-bin.
#
# Some of these packages might not be necessary, but after so long messing with the tlmgr search tool I got bored.

TLMGR=$(which tlmgr) 2>/dev/null || TLMGR=$(find /opt/ -name tlmgr) 2>/dev/null || (echo Cannot find tlmgr. You must install it. Try searching for texlive && exit 1)

$TLMGR install \
tools \
lipsum \
xcolor \
gfsartemisia \
epsdice \
starfont \
appendix \
geometry \
svg \
wrapfig \
epigraph \
microtype \
float \
microtype \
colortbl \
contour \
amsmath \
amsfonts \
etoolbox \
hyperref \
glossaries \
glossaries-extra \
imakeidx \
infwarerr \
euler \
koma-script \
trimspaces \
ifplatform \
catchfile \
kvoptions \
transparent \
nextpage \
markdown \
pgf \
paralist \
csvsimple \
fancyvrb \
babel-english \
gobble \
titlesec \
fancyhdr \
fourier \
needspace \
psnfss \
tcolorbox \
visualtikz \
tikzfill \
pdfcol \
epstopdf-pkg \
environ \
collection-fontsrecommended
