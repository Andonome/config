VERSION != git tag | tail -1
QR_TARGET != grep mailto: README.md | cut -d: -f2,3 | tail -c+2
QR_CODE=\qrcode[height=.2\textwidth]{$(QR_TARGET)}

COMPRESS = gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.5 -dNOPAUSE -dQUIET -dBATCH -dPrinted=false -sOutputFile=$@ $<

CP := ln -f
BOOK != basename "$(shell pwd)"
TITLE != head -1 README.md | tail -c+3 | tr ' ' '_'
DROSS = rubbish
DBOOK ?= $(DROSS)/$(BOOK).pdf
COMPILER = latexmk \
	-e '$$max_repeat=6' \
	-file-line-error \
	-output-directory=$(DROSS) \
	-pdflua \
	-interaction=nonstopmode \
	-halt-on-error \
	-shell-escape \
	-r config/.latexmkrc

RELEASE = $(TITLE).pdf
GLOS := makeglossaries -d $(DROSS)
RUN := lualatex -output-directory $(DROSS) -shell-escape

# 'EXTERNAL_REFERENTS' will usually include 'core', and 'judgement',
# so these lines will include '../aux/core.aux' and copy it to
# 'rubbish/core.aux'.
AUX_DIR = ../aux_share
AUX_EXTERNAL = $(foreach referent, $(EXTERNAL_REFERENTS), \
			$(wildcard $(AUX_DIR)/$(referent).aux) \
	)

AUX_REFERENCES = $(patsubst $(AUX_DIR)/%.aux, $(DROSS)/%.aux, $(AUX_EXTERNAL))

DEPS += $(wildcard config/*.sty)
DEPS += $(AUX_REFERENCES)
DEPS += $(wildcard *.tex)

.PHONY: book
book: $(RELEASE) ## Compile the pdf
$(RELEASE): $(DBOOK)
	@$(CP) $< $@

$(DBOOK): main.tex $(DEPS)
	$(COMPILER) -jobname=$(BOOK) $<

vpath %.tex config/share

# Story time!
# If the page count for the book is 54, then it'll get a miniature rulebook and
# maybe a character sheet or handout at the end, bringing the page count up to
# 58.  But the A3 version has 12-page signatures, which means 2 blank pages. 
# Oh no!  We need to add more copies of things (and put the first one aside for
# later).
# 
# So 58 % 12 leaves 10 remaining pages.
# 12 - 10 shows we need two more pages.
# But then the formula sometimes works out as '12 - 0', which means needing 12
# more pages (nonsense!), so we find the remainder again, and 12%12 = 0.
# 
# The extra pages will always be double-facing, so we can half what's left (and
# add the one put aside earlier).

config/$(DROSS)/.count.tex: $(DBOOK)
	page_count="$$(pdfinfo $(DBOOK) | grep -m1 '^Pages:' | awk '{print $$2}')" && \
		pages_required=$$(( 12-( page_count + 4 )%12 )) && \
		cs_required=$$(( pages_required%12 / 2 + 1 )) && \
		echo "\setcounter{track}{$$cs_required}" > $@

pdfs += $(RELEASE)

%/:
	mkdir $@
	echo '*' > $@.gitignore

$(DROSS)/$(BOOK)-switch-gls:| $(DROSS)/
	touch $@

$(DROSS)/%.pdf: %.tex $(wildcard config/*.sty) | $(DROSS)/
	$(COMPILER) -jobname=$(basename $(@F)) $<
%.pdf: $(DROSS)/%.pdf
	$(CP) $(DROSS)/$@ $@

$(DROSS)/%.pdf: %/main.tex $(wildcard config/*sty) | $(DROSS)/
	$(COMPILER) -jobname=$(<D) $<

$(AUX_REFERENCES): $(DROSS)/%.aux: $(AUX_DIR)/%.aux | $(DROSS)/
	cp $< $@

.PHONY: refs
refs: $(AUX_DIR)/$(BOOK).aux
$(AUX_DIR)/$(BOOK).aux: $(DROSS)/$(BOOK).aux | $(AUX_DIR)/
	cp $< $@
$(DROSS)/$(BOOK).aux: $(DBOOK)

qr.tex: README.md
	printf '%s' '\qrcode[height=.2\textwidth]{$(QR_TARGET)}' > qr.tex

output += qr.tex svg-inkscape

images/extracted/inclusion.tex: images/extracted/
	printf '%s\n' '\externaldocument{$(BOOK)}' > $@
	printf '%s\n' '\newcommand\bookTitle{$(TITLE)}' | tr '_' ' ' >> $@

output += images/extracted/

output += $(DROSS)/

dependencies += git git-lfs lualatex latexmk inkscape

.PHONY: check
check: ## Check you have the project dependencies
	@$(foreach program, $(dependencies), \
	command -v $(program) >/dev/null || { echo install $(program) && exit 1 ;} ;)

help: ## Print the help message
	@awk 'BEGIN {FS = ":.*?## "} /^[0-9a-zA-Z._-]+:.*?## / {printf "\033[36m%s\033[0m : %s\n", $$1, $$2}' $(MAKEFILE_LIST) | \
		sort | \
		column -s ':' -t

.PHONY: graph
graph: ## Show a dependency graph (needs graph-easy and make2graph)
	make -Bind $(TARG) | make2graph | graph-easy --boxart

######## Automated Materials Check ########

text_shadows = $(patsubst $(DROSS)/%.pdf, $(DROSS)/%.txt, $(wildcard $(DROSS)/*.pdf))

$(text_shadows): $(DROSS)/%.txt: $(DROSS)/%.pdf
	pdftotext $< $@

.PHONY: report
report: $(text_shadows) ## Check for missing references and repetition in all pdfs.
	@command -v pdftotext >/dev/null || { echo install pdftotext ; exit 1 ;}
	@test -f '$<' || exit 1
	@! grep -F '??' $^
	@grep --color=always -nE '(\b\S+\b)\s+\b\1\b' $^ || echo "No problems found."

######## A3 12 signature pdfs ########
%_A3_12_signature.pdf: %.pdf
	pdfjam --landscape --paper a3paper --nup 1x1 --signature 12 $< -o $@

A3_pdfs = $(patsubst %.pdf, %_A3_12_signature.pdf, $(pdfs))

.PHONY: printables
printables: $(A3_pdfs)

######## A7 pdf booklets ########

vpath a7%.tex booklets

# The A7 booklet has 16 pages to the signature
layout = 16:

# The layout lists page indexes, so '0' means 'page 1', and '0L' means 'page 1
# but turn 90 degrees to the left'
layout += 3L(1w,0h)+12L(1w,0.25h)+15L(1w,0.5h)+0L(1w,0.75h)+4R(0w,0.25h)+11R(0w,0.5h)+8R(0w,0.75h)+7R(0w,1h),

# The first block ends with a comma, which indicates that we are working on the
# back-page.
layout += 5L(1w,0h)+10L(1w,0.25h)+9L(1w,0.5h)+6L(1w,0.75h)+2R(0w,0.25h)+13R(0w,0.5h)+14R(0w,0.75h)+1R(0w,1h)

# 'make' adds spaces between variables, but `pstops` will not be happy with those spaces.
a7_layout != printf '%s' '$(layout)' | tr -d ' '

landscape_layout = 16:
landscape_layout += 3U(1w,0.25h)+12U(1w,0.5h)+15U(1w,0.75h)+0(0.5w,0.75h)+4(0w,0.0h)+11(0w,0.25h)+8(0w,0.5h)+7(0w,0.75h),
landscape_layout += 5U(1w,0.25h)+10U(1w,0.5h)+9U(1w,0.75h)+6U(1w,1h)+2(0w,0h)+13(0w,0.25h)+14(0w,0.5h)+1(0w,0.75h)
a7_landscape_layout != printf '%s' '$(landscape_layout)' | tr -d ' '

$(DROSS)/a7%.ps: $(DROSS)/a7%.pdf
	pdftops $< $@

$(DROSS)/onepage_%.ps: $(DROSS)/a7_%.ps
	pstops -pa4 '$(a7_layout)' $< $@

$(DROSS)/onepage_%.ps: $(DROSS)/a7l_%.ps
	pstops -pa4 '$(a7_landscape_layout)' $< $@

$(DROSS)/onepage_%.pdf: $(DROSS)/onepage_%.ps
	ps2pdf -dPDFSETTINGS=/prepress $< $@

%.pdf: $(DROSS)/onepage_%.pdf
	$(CP) $< $@

####### Spell Books #############
# Each a7l_cs.pdf character generates spell books in $(DROSS)/Spells-*.tex

mini_cs_spheres = $(wildcard $(DROSS)/Spells-*.tex)

mini_spell_tex = $(patsubst $(DROSS)/Spells-%.tex, booklets/a7_%-Spellbook.tex, $(mini_cs_spheres) )

mini_spell_pdf = $(patsubst $(DROSS)/Spells-%.tex, %-Spellbook.pdf, $(mini_cs_spheres) )

$(mini_spell_tex): booklets/a7_%-Spellbook.tex: $(DROSS)/Spells-%.tex config/booklets/a7_spells.tex | booklets/
	sed '/begin{document}/a \\\input{$<}' config/booklets/a7_spells.tex > $@

zines += $(mini_spell_pdf)

### Standard Zine Header ###

define zineheader#
\documentclass[10pt,twoside]{book}
\usepackage{config/bind}\usepackage{config/booklet}
\externalReferent{core}
\externalReferent{stories}
\externalReferent{judgement}
\begin{document}
endef

####### Phone Zines #############

screen_zines = $(patsubst %.pdf, a7_%.pdf, $(zines) )

.PHONY: screenz
screenz: $(screen_zines) ## Screen-readable booklets

#################################

targets += $(pdfs)
targets += $(zines)
output += $(targets)

.PHONY: all
all: $(targets) ## All standard targets

.PHONY: clean
clean: ## Clean repo, including cross-reference files
	$(RM) -r $(output) $(wildcard *.pdf)
