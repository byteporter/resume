# This Makefile targets GNU make

# TODO:
# 1) Try to change rtf and docx generation to use the ConTeXt file as its source rather than markdown
# 2) reminplement install and uninstall

SHELL := /bin/sh

STYLE ?= pdftemplate
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

.PHONY: all hardcopy install uninstall

all: resume hardcopy

hardcopy: web/static-root/resume.pdf web/static-root/resume.docx web/static-root/resume.rtf

# install: all
# 	@printf "$(BLU)Installing output files...$(END)\n";
# 	@cp $(OUT_DIR)/$(FILE_NAME).pdf $(INSTALL_DIR);
# 	@cp $(OUT_DIR)/$(FILE_NAME).rtf $(INSTALL_DIR);
# 	@cp $(OUT_DIR)/$(FILE_NAME).docx $(INSTALL_DIR);
# 	@printf "$(GRN)Done!$(END)\n\n";

# uninstall:
# 	@printf "$(BLU)Uninstalling output files...$(END)\n";
# 	@rm $(INSTALL_DIR)/$(FILE_NAME).pdf ||:;
# 	@rm $(INSTALL_DIR)/$(FILE_NAME).rtf ||:;
# 	@rm $(INSTALL_DIR)/$(FILE_NAME).docx ||:;
# 	@printf "$(GRN)Done!$(END)\n\n";

clean:
	@printf "$(BLU)Cleaning up files...$(END)\n";
	@rm web/static-root/resume.pdf ||:;
	@rm web/static-root/resume.docx ||:;
	@rm web/static-root/resume.rtf ||:;
	@rm web/static-root/resume.rst ||:;
	@rm tools/genhardcopy/resume.log ||:;
	@rm tools/genhardcopy/resume.tuc ||:;
	@rm tools/genhardcopy/resume.tex ||:;
	@rm resume ||:;
	@printf "$(GRN)Done!$(END)\n\n";

# Uncomment this if you need to keep the .tex file for inspection
# .PRECIOUS: tools/genhardcopy/resume.tex

resume: cmd/resume/resume.go
	@printf "$(BLU)***Building application $(CYN)$@$(BLU)...$(END)\n";
	go build -o $@ $^;
	@printf "$(GRN)***Done!$(END)\n\n";

tools/genhardcopy/resume.tex: tools/genhardcopy/$(STYLE).tex web/resume.md
	@printf "$(BLU)***Building $(CYN)$@$(BLU)...$(END)\n";
	pandoc --standalone --template $< \
		--from markdown --to context \
		--variable papersize=$(PAPER_SIZE) \
		--output $@ web/resume.md;
	@printf "$(GRN)Done!$(END)\n\n"

web/static-root/resume.pdf: tools/genhardcopy/resume.tex
	@printf "$(BLU)***Building $(CYN)$@$(BLU)...$(END)\n";
	mtxrun --path=$(dir $<) --script context --result=$(notdir $@) $(notdir $<);
	mv $(dir $<)$(notdir $@) $@;
	@printf "$(GRN)Done!$(END)\n\n"

web/static-root/resume.rtf: web/resume.md
	@printf "$(BLU)***Building $(CYN)$@$(BLU)...$(END)\n";
	pandoc --standalone $(if $(PANDOC_VERSION_2),--from markdown+smart,--smart) $< --output $@;
	@printf "$(GRN)Done!$(END)\n\n"

web/static-root/resume.docx: web/resume.md
	@printf "$(BLU)***Building $(CYN)$@$(BLU)...$(END)\n";
	pandoc --standalone $(if $(PANDOC_VERSION_2),--from markdown+smart,--smart) $< --output $@;
	@printf "$(GRN)Done!$(END)\n\n"

web/static-root/resume.rst: web/resume.md
	@printf "$(BLU)***Building $(CYN)$@$(BLU)...$(END)\n";
	pandoc --standalone --from markdown --to rst $< --output $@
	@printf "$(GRN)Done!$(END)\n\n"