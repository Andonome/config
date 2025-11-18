#!/bin/sh
# This file has the recommended LaTeX packages.
# First install tlmgr (likely in the package 
# texlive or texlive-bin) and texlive${year}-bin.
#
# If compiling fails, you *might* also need the cm-super package.

packages='
latex-bin
l3packages
biber
biblatex
luatextra
fontspec
luatexbase
metalogo
luacode
svn-prov
tools
fgruler bookcover
qrcode
lipsum
xcolor
gfsartemisia
epsdice
starfont
appendix
geometry
svg
txfonts
bookhands
wrapfig
epigraph
microtype
float
microtype
colortbl
contour
amsmath
amsfonts
etoolbox
hyperref
glossaries
glossaries-extra
imakeidx
splitindex
infwarerr
koma-script
trimspaces
ifplatform
catchfile
kvoptions
transparent
nextpage
markdown
pgf
paralist
csvsimple
fancyvrb
babel-english
babel-german
gobble
titlesec
fancyhdr
adforn
needspace
psnfss
tcolorbox
visualtikz
tikzfill
pdfcol
epstopdf-pkg
environ
pdfjam pdflscape pdfpages
collection-fontsrecommended
cm-unicode'

check_packages(){
    for p in $packages; do
        kpsewhich "$p".sty >/dev/null || \
        tlmgr search $p | grep -q "^$p " || {
            echo "Missing LaTeX package: $p"
            required="$required $p"
        }
    done
    [ -z "$required" ] || exit 1
}

install_packages(){
    tlmgr install $packages
}

####################

for p in kpsewhich tlmgr; do
    command -v "$p" >/dev/null || {
        echo "Cannot find $p.
        It looks like you don't have LaTeX installed."
        exit 1
    }
done

if [ "$1" = "check" ]; then
    check_packages
else
    install_packages
fi
