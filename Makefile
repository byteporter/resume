# This Makefile targets GNU make

# TODO:
# 1) Try to change rtf and docx generation to use the ConTeXt file as its source rather than markdown

OUT_DIR ?= output
INSTALL_DIR ?= static_root
STYLE ?= pdftemplate
FILE_NAME ?= resume
PAPER_SIZE ?= letter
LOG_DIR ?= makelog

ifeq ($(shell echo `pandoc --version | head -1 | cut -d' ' -f2 | cut -d'.' -f1`), 2)
	PANDOC_VERSION_2 := true
endif

# Terminal color control strings
RED=\e[1;31m
GRN=\e[1;32m
YEL=\e[1;33m
BLU=\e[1;34m
MAG=\e[1;35m
CYN=\e[1;36m
END=\e[0m

all: pdf rtf docx

install: all
	@printf "$(BLU)Installing output files...$(END)\n";
	@cp $(OUT_DIR)/$(FILE_NAME).pdf $(INSTALL_DIR);
	@cp $(OUT_DIR)/$(FILE_NAME).rtf $(INSTALL_DIR);
	@cp $(OUT_DIR)/$(FILE_NAME).docx $(INSTALL_DIR);
	@printf "$(GRN)Done!$(END)\n\n";

uninstall:
	@printf "$(BLU)Uninstalling output files...$(END)\n";
	@rm $(INSTALL_DIR)/$(FILE_NAME).pdf ||:;
	@rm $(INSTALL_DIR)/$(FILE_NAME).rtf ||:;
	@rm $(INSTALL_DIR)/$(FILE_NAME).docx ||:;
	@printf "$(GRN)Done!$(END)\n\n";

pdf: $(OUT_DIR)/$(FILE_NAME).pdf

docx: $(OUT_DIR)/$(FILE_NAME).docx

rtf: $(OUT_DIR)/$(FILE_NAME).rtf

clean:
	@printf "$(BLU)Cleaning up files...$(END)\n";
	@rm $(OUT_DIR)/$(FILE_NAME).pdf ||:;
	@rm $(OUT_DIR)/$(FILE_NAME).docx ||:;
	@rm $(OUT_DIR)/$(FILE_NAME).rtf ||:;
	@rm $(OUT_DIR)/context_$(FILE_NAME).log ||:;
	@rm $(OUT_DIR)/$(FILE_NAME).log ||:;
	@rm $(OUT_DIR)/$(FILE_NAME).tex ||:;
	@rm $(OUT_DIR)/$(FILE_NAME).tuc ||:;
	@rmdir $(OUT_DIR);
	@printf "$(GRN)Done!$(END)\n\n";

.PHONY: all clean pdf docx rtf install uninstall

# Uncomment this if you need to keep the .tex file for inspection
# .PRECIOUS: $(OUT_DIR)/%.tex

$(OUT_DIR):
	mkdir -p $(OUT_DIR)

$(OUT_DIR)/%.tex: $(STYLE).tex %.md | $(OUT_DIR)
	@printf "$(BLU)***Building $(CYN)$@$(BLU)...$(END)\n";
	pandoc --standalone --template $(STYLE).tex \
		--from markdown --to context \
		--variable papersize=$(PAPER_SIZE) \
		--output $(OUT_DIR)/$*.tex $*.md;
	@printf "$(GRN)Done!$(END)\n\n"
	
$(OUT_DIR)/%.pdf: $(OUT_DIR)/%.tex | $(OUT_DIR)
	@printf "$(BLU)***Building $(CYN)$@$(BLU)...$(END)\n";
	mtxrun --path=$(OUT_DIR) --result=$*.pdf --script context $*.tex;
	@printf "$(GRN)Done!$(END)\n\n"

$(OUT_DIR)/%.rtf: %.md | $(OUT_DIR)
	@printf "$(BLU)***Building $(CYN)$@$(BLU)...$(END)\n";
	pandoc --standalone $(if $(PANDOC_VERSION_2),--from markdown+smart,--smart) $< --output $@;
	@printf "$(GRN)Done!$(END)\n\n"

$(OUT_DIR)/%.docx: %.md | $(OUT_DIR)
	@printf "$(BLU)***Building $(CYN)$@$(BLU)...$(END)\n";
	pandoc --standalone $(if $(PANDOC_VERSION_2),--from markdown+smart,--smart) $< --output $@;
	@printf "$(GRN)Done!$(END)\n\n"