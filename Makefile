# LaTeX Makefile
#
# Author: Jay Bosamiya <jaybosamiya AT gmail DOT com>

#   ____             __ _                       _   _
#  / ___|___  _ __  / _(_) __ _ _   _ _ __ __ _| |_(_) ___  _ __
# | |   / _ \| '_ \| |_| |/ _` | | | | '__/ _` | __| |/ _ \| '_ \
# | |__| (_) | | | |  _| | (_| | |_| | | | (_| | |_| | (_) | | | |
#  \____\___/|_| |_|_| |_|\__, |\__,_|_|  \__,_|\__|_|\___/|_| |_|
#                         |___/

# If set to 't', all .tex files in the current directory should be
# compiled over to .pdf files.
ALL_FILES_MODE:=

# If set then MAIN_TARGET is used as the root tex file of the project
# to be built.
MAIN_TARGET:=

################## DON'T CHANGE ANYTHING BEYOND THIS LINE ####################

#     _         _                        _   _        ____        _
#    / \  _   _| |_ ___  _ __ ___   __ _| |_(_) ___  |  _ \ _   _| | ___  ___
#   / _ \| | | | __/ _ \| '_ ` _ \ / _` | __| |/ __| | |_) | | | | |/ _ \/ __|
#  / ___ \ |_| | || (_) | | | | | | (_| | |_| | (__  |  _ <| |_| | |  __/\__ \
# /_/   \_\__,_|\__\___/|_| |_| |_|\__,_|\__|_|\___| |_| \_\\__,_|_|\___||___/
#

.PHONY: all
TEXFILES:=$(wildcard *.tex)

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
all: $(TEXFILES:.tex=.pdf)
endif
# End of ALL_FILES_MODE
else ifneq ($(MAIN_TARGET),)
all: $(MAIN_TARGET:.tex=).pdf
# End of MAIN_TARGET
else
all:
ifeq ($(words $(TEXFILES)), 1)
all: $(TEXFILES:.tex=.pdf)
else
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
endif
endif

LATEXRUN:=python3 ./.latexrun -O .latex.out
# Note: We use latexrun from a slightly more up-to-date fork available
# at https://github.com/Nadrieril/latexrun
# The original can be found at https://github.com/aclements/latexrun

.PHONY: FORCE
%.pdf: FORCE ./.latexrun
	@$(LATEXRUN) $*.tex

.PHONY: clean
clean: ./.latexrun
	@$(LATEXRUN) --clean-all
	@echo "Finished cleaning up"

./.latexrun:
	$(error Unable to find .latexrun in current directory. Are you sure you copied it in?)
