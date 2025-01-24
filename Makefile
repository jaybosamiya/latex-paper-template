# LaTeX Makefile
#   Version: 0.4.11
#   Author: Jay Bosamiya <jaybosamiya AT gmail DOT com>
#
# Always find the latest version at
#    https://github.com/jaybosamiya/latex-paper-template/
#
# Alternatively, run `make update-makefile` to pull the latest
# version.

#   ____             __ _                       _   _
#  / ___|___  _ __  / _(_) __ _ _   _ _ __ __ _| |_(_) ___  _ __
# | |   / _ \| '_ \| |_| |/ _` | | | | '__/ _` | __| |/ _ \| '_ \
# | |__| (_) | | | |  _| | (_| | |_| | | | (_| | |_| | (_) | | | |
#  \____\___/|_| |_|_| |_|\__, |\__,_|_|  \__,_|\__|_|\___/|_| |_|
#                         |___/

# If set to 't', all .tex files in the current directory should be
# compiled over to .pdf files.
ALL_FILES_MODE?=

# If set then MAIN_TARGET is used as the root tex file of the project
# to be built.
MAIN_TARGET?=

# If set to git commits, separated by spaces, then `make diff` will
# produce diffs against each commit. Additionally, `make diff-REV`
# will produce a diff against revision REV. Requires `latexdiff` to be
# installed on the system.
#
# Caveat: Works only in MAIN_TARGET mode (for now).
DIFF_REVISIONS?=

# If set to a non-empty value, generates a nice HTML copy of the
# PDF. Requires pdf2htmlex to be installed.
HTML_GENERATION?=

# If set to 't', ensures indentation of all the .tex files is
# normalized using the ./.latexindent.yaml settings.
ALWAYS_REINDENT?=

# If set to 't', unwraps lines when reindenting
REINDENT_UNWRAPS_LINES?=

# If set to 't', places places one sentence per-line when reindenting
REINDENT_ONE_SENTENCE_PER_LINE?=

# Any directories here should be built before anything else for `all` target.
# The default picks up all directories with a Makefile in them (obviously
# skipping the current directory).
BUILD_DIRECTORIES_FIRST?=$(dir $(shell find . -name Makefile -not -path ./Makefile))

# If set to a `.tex` file, fills in git information into it on each build
GIT_INFO_TEX?=

# When spellchecking with `make spellcheck`, skip these files
SPELLCHECK_EXCLUDES?=

################## DON'T CHANGE ANYTHING BEYOND THIS LINE ####################

#     _         _                        _   _        ____        _
#    / \  _   _| |_ ___  _ __ ___   __ _| |_(_) ___  |  _ \ _   _| | ___  ___
#   / _ \| | | | __/ _ \| '_ ` _ \ / _` | __| |/ __| | |_) | | | | |/ _ \/ __|
#  / ___ \ |_| | || (_) | | | | | | (_| | |_| | (__  |  _ <| |_| | |  __/\__ \
# /_/   \_\__,_|\__\___/|_| |_| |_|\__,_|\__|_|\___| |_| \_\\__,_|_|\___||___/
#

.PHONY: all
TEXFILES:=$(wildcard *.tex)

AUTOPICK:=main.tex paper.tex writeup.tex

ALL_TARGET:=

ifeq ($(ALWAYS_REINDENT), t)
all: indent
endif

ifeq ($(ALL_FILES_MODE), t)
ifneq ($(MAIN_TARGET),)
all:
	@echo "Both ALL_FILES_MODE and MAIN_TARGET are set."
	@echo ""
	@echo "Do you mean to compile all of them individually to PDFs?"
	@echo "  If so, please change over to ALL_FILES_MODE"
	@echo ""
	@echo "Do you mean to compile it to a single PDF?"
	@echo "  If so, please set MAIN_TARGET"
	@echo ""
	@echo "Quitting."
else
ALL_TARGET:=$(TEXFILES:.tex=.pdf)
endif
# End of ALL_FILES_MODE
else ifneq ($(MAIN_TARGET),)
ALL_TARGET:=$(MAIN_TARGET:.tex=).pdf
# End of MAIN_TARGET
else
all:
ifeq ($(words $(TEXFILES)), 1)
ALL_TARGET:=$(TEXFILES:.tex=.pdf)
else ifeq ($(words $(filter $(AUTOPICK),$(TEXFILES))), 0)
all:
	@echo "Found $(words $(TEXFILES)) .tex files."
	@echo ""
ifeq ($(words $(TEXFILES)), 0)
else
	@echo "Do you mean to compile all of them individually to PDFs?"
	@echo "  If so, please change over to ALL_FILES_MODE"
	@echo ""
	@echo "Do you mean to compile it to a single PDF?"
	@echo "  If so, please set MAIN_TARGET"
	@echo ""
endif
	@echo "Quitting."
else
AUTOROOTCHOICE:=$(firstword $(foreach V,$(AUTOPICK),$(filter $(V),$(TEXFILES))))
all: $(warning Found multiple .tex files. Automatically chosing likely root as $(AUTOROOTCHOICE). Set either MAIN_TARGET or ALL_FILES_MODE to squash this warning.) $(AUTOROOTCHOICE:.tex=.pdf)
endif
endif

ifneq ($(ALL_TARGET),)
ifeq ($(HTML_GENERATION),)
all: $(ALL_TARGET)
else
all: $(ALL_TARGET:.pdf=.html)
endif
endif

# If any extra directories exist, they must be built before anything else
ifneq ($(BUILD_DIRECTORIES_FIRST),)
build_directories_first: FORCE
	@for i in $(BUILD_DIRECTORIES_FIRST); do \
		echo "Building in $$i"; \
		$(MAKE) -C $$i; \
	done

$(ALL_TARGET): build_directories_first
endif

# If GIT_INFO_TEX is set, set up the file
ifneq ($(GIT_INFO_TEX),)
$(GIT_INFO_TEX): FORCE
	@echo "Setting up $@"
	@echo "\\\\newcommand{\\\\gitcommit}[0]{\\\\texttt{$$(git rev-parse --short HEAD)$$(git diff --quiet || echo ' (dirty)')}\\\\xspace}" > $@
	@echo "\\\\newcommand{\\\\gitcommitdate}[0]{$$(git show --no-patch --format=%cs HEAD)\\\\xspace}" >> $@
	@echo "\\\\newcommand{\\\\gitcommitauthordate}[0]{$$(git show --no-patch --format=%as HEAD)\\\\xspace}" >> $@

$(ALL_TARGET): $(GIT_INFO_TEX)
endif

LATEXRUN:=python3 ./.latexrun --latex-args='--synctex=1' -O .latex.out
# Note: The original version of latexrun can be found at
# https://github.com/aclements/latexrun ; a somewhat more up-to-date fork is
# available at https://github.com/Nadrieril/latexrun ; the version we use in
# this repo forks that further and makes small changes ; the definitive version
# of the latest fork can be found at
# https://github.com/jaybosamiya/latex-paper-template

# Use the correct sed necessary, based upon OS
UNAME_S:=$(shell uname -s)
ifeq ($(UNAME_S),Linux)
SED:=sed
else
ifeq ($(UNAME_S),Darwin)
SED:=gsed
else
$(error Unrecognized OS "$(UNAME_S)" when trying to autodetect sed)
endif
endif

.PHONY: FORCE
%.pdf: FORCE ./.latexrun
	@$(LATEXRUN) $*.tex
	@cp .latex.out/*.synctex.gz .
	@echo "Finished building $@"

%.html: %.pdf
	@echo "Generating $@"
	@pdf2htmlEX --zoom 2 --process-outline 0 $<

.PHONY: clean
clean: ./.latexrun
	@$(LATEXRUN) --clean-all
	@rm -rf *.synctex.gz ./.latexindent-cruft
	@echo "Finished cleaning up"

LATEXINDENT_ARGS:=\
	'--silent' \
	'--overwrite' \
	'--cruft=.latexindent-cruft/'
ifeq ($(REINDENT_ONE_SENTENCE_PER_LINE),t)
LATEXINDENT_ARGS += '--modifylinebreaks' '--yaml=modifyLineBreaks:oneSentencePerLine:manipulateSentences:1'
else
ifeq ($(REINDENT_UNWRAPS_LINES),t)
LATEXINDENT_ARGS += '--modifylinebreaks' '--yaml=modifyLineBreaks:textWrapOptions:columns:-1'
endif
endif

.PHONY: indent
indent: ./.latexindent.yaml ./.latexindent-cruft
	@find . -name \*.tex -exec 'latexindent' $(LATEXINDENT_ARGS) '--local=$<'  '{}' ';'
	@echo "Finished reindenting"

./.latexindent-cruft:
	@mkdir -p $@

./.latexrun:
	@echo "Unable to find .latexrun in the current directory."
	@echo "Downloading it!"
	@wget https://raw.githubusercontent.com/jaybosamiya/latex-paper-template/master/.latexrun -O $@

./changebarmodified.sty:
	@echo "Unable to find $@"
	@echo "Downloading it!"
	@wget https://raw.githubusercontent.com/jaybosamiya/latex-paper-template/master/changebarmodified.sty -O $@

./.latexindent.yaml:
	@echo "Unable to find $@"
	@echo "Downloading it!"
	@wget https://raw.githubusercontent.com/jaybosamiya/latex-paper-template/master/.latexindent.yaml -O $@

.PHONY: update-makefile
update-makefile:
	@echo "Updating the current Makefile in-place"
	@wget --quiet --unlink https://raw.githubusercontent.com/jaybosamiya/latex-paper-template/master/Makefile -O Makefile

ifneq ($(MAIN_TARGET),)
.PHONY: diff-%
diff-%: FORCE ./.latexrun ./changebarmodified.sty
	@echo "Generating diff against revision $*"
	@latexdiff-vc --git -r $* --flatten --exclude-textcmd="author" -t CCHANGEBAR --force $(MAIN_TARGET:.tex=).tex >/dev/null
	@echo "Modern LaTeX has issues with the very old changebar package when floats get involved. Making sure to use the local version of changebar."
	@$(SED) -i 's/{changebar}/{changebarmodified}/' $(MAIN_TARGET:.tex=)-diff$*.tex
	@echo "Generated $(MAIN_TARGET:.tex=)-diff$*.tex. Attempting to compile it."
	@$(LATEXRUN) $(MAIN_TARGET:.tex=)-diff$*.tex
	@echo "Generated $(MAIN_TARGET:.tex=)-diff$*.pdf."

ifneq ($(DIFF_REVISIONS),)
diff: FORCE ./.latexrun
	@$(MAKE) $(patsubst %,diff-%,$(DIFF_REVISIONS))
endif
endif

__SCREENCLEAR: FORCE
	clear

ifneq ($(MAIN_TARGET),)
snap: all FORCE
	cp $(ALL_TARGET) $(ALL_TARGET:.pdf=)-$(shell date +%Y%m%d)-$(shell git rev-parse --short HEAD).pdf
endif

.PHONY: watch
watch: all
	@echo "Finished initial (re)build. Now watching."
	fswatch --event Created --event Updated --event Removed --event Renamed --one-per-batch $(shell find . -name \*.tex $(if $(GIT_INFO_TEX),-not -path ./$(GIT_INFO_TEX),)) $(shell find . -name \*.bib) $(shell find . -name \*.sty) | xargs -I'{}' make __SCREENCLEAR all

ifneq ($(MAIN_TARGET),)
.PHONY: spellcheck
spellcheck:
	for i in $$(find . -name \*.tex $(foreach exclude,$(SPELLCHECK_EXCLUDES),'!' -path './$(exclude)')); do aspell check --mode=tex --personal=$(shell pwd)/.aspelldict "$$i" ; done
endif

ifneq ($(MAIN_TARGET),)
.PHONY: texmaster
texmaster:
	@for i in $$(find . -name \*.tex); do \
		if [ "$$(head -n 1 $$i | grep -c 'mode: latex')" -eq 0 ]; then \
			echo "Inserting TeX-master into $$i"; \
			TEX_MASTER_REL_PATH=$$(realpath --relative-to=$$(dirname $$i) $(MAIN_TARGET)); \
			(echo "% -*- mode: latex; TeX-master: \"$$TEX_MASTER_REL_PATH\" -*-"; echo; cat $$i) > $$i.tmp; \
			mv $$i.tmp $$i; \
		fi; \
	done
endif

ifneq ($(MAIN_TARGET),)
.PHONY: chktex
chktex:
	@WARNS=$$(mktemp); \
	find . -name \*.tex -not -name "$(GIT_INFO_TEX)" -print0 | \
		sort --zero-terminated | \
		xargs -0 chktex --quiet --verbosity=0 --inputfiles=0 2>"$$WARNS"; \
	if [ -s "$$WARNS" ]; then \
		echo "" 1>&2; \
		echo "De-duplicated stderr:" 1>&2; \
		sort -u "$$WARNS" 1>&2; \
	fi; \
	rm -f "$$WARNS"
endif

# Force all intermediate files to be saved even in chains of implicits
.SECONDARY:
