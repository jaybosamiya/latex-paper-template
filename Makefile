#   ____             __ _                       _   _
#  / ___|___  _ __  / _(_) __ _ _   _ _ __ __ _| |_(_) ___  _ __
# | |   / _ \| '_ \| |_| |/ _` | | | | '__/ _` | __| |/ _ \| '_ \
# | |__| (_) | | | |  _| | (_| | |_| | | | (_| | |_| | (_) | | | |
#  \____\___/|_| |_|_| |_|\__, |\__,_|_|  \__,_|\__|_|\___/|_| |_|
#                         |___/

# Provide the name of the base/root tex file (without the .tex/.pdf)
MAIN_TARGET=paper

#     _         _                        _   _        ____        _
#    / \  _   _| |_ ___  _ __ ___   __ _| |_(_) ___  |  _ \ _   _| | ___  ___
#   / _ \| | | | __/ _ \| '_ ` _ \ / _` | __| |/ __| | |_) | | | | |/ _ \/ __|
#  / ___ \ |_| | || (_) | | | | | | (_| | |_| | (__  |  _ <| |_| | |  __/\__ \
# /_/   \_\__,_|\__\___/|_| |_| |_|\__,_|\__|_|\___| |_| \_\\__,_|_|\___||___/
#

# Rules that automatically use above configuration.
# Should NOT require changing.
.PHONY: all
all: $(MAIN_TARGET).pdf

.PHONY: FORCE
$(MAIN_TARGET).pdf: FORCE
	@python3 ./latexrun $(MAIN_TARGET).tex

.PHONY: clean
clean:
	@python3 ./latexrun --clean-all
	@echo "Cleaned up intermediates"
