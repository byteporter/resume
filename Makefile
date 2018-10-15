# This Makefile targets GNU make

SHELL := /bin/sh

STYLE ?= pdftemplate
PAPER_SIZE ?= letter
INSTALL_DIR ?= output/usr/share/resume/
BIN_DIR ?= output/go/bin/

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

install: manifest

$(INSTALL_DIR):
	@mkdir -p $(INSTALL_DIR);

$(BIN_DIR):
	@mkdir -p $(BIN_DIR);

manifest: resume web/static-root/resume.pdf web/static-root/resume.docx web/static-root/resume.rtf | $(INSTALL_DIR) $(BIN_DIR)
	@printf "$(BLU)Installing output files...$(END)\n";
	@cp -r web/ $(INSTALL_DIR);
	@find $(INSTALL_DIR)web -printf "%d\t%p\n" >manifest;
	@cp resume $(BIN_DIR);
	@find $(BIN_DIR)resume -printf "%d\t%p\n" >>manifest;
	@sort -r -o manifest manifest;
	@printf "$(GRN)Done!$(END)\n\n";

uninstall:
	@printf "$(BLU)Uninstalling output files...$(END)\n";
	@while IFS= read -r line <&3; do \
		FILENAME="$$(printf '%s' "$$line" | cut -f2)"; \
		if [ -f "$$FILENAME" ]; then \
			rm "$$FILENAME"; \
		fi; \
	done 3< manifest;
	@while IFS= read -r line <&3; do \
		DIRNAME="$$(printf '%s' "$$line" | cut -f2)"; \
		if [ -d "$$DIRNAME" ]; then \
			rmdir "$$DIRNAME" ||:; \
		fi; \
	done 3< manifest;
	@rmdir $(INSTALL_DIR) ||:;
	@rm manifest;
	@printf "$(GRN)Done!$(END)\n\n";

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
	CGO_ENABLED=0 GOOS=linux go build -a -ldflags '-extldflags "-static"' -o $@ $^;
	@printf "$(GRN)***Done!$(END)\n\n";

tools/genhardcopy/resume.tex: tools/genhardcopy/$(STYLE).tex web/resume.md
	@printf "$(BLU)***Building $(CYN)$@$(BLU)...$(END)\n";
	pandoc --standalone --template $< \
		--from markdown --to context \
		--variable papersize=$(PAPER_SIZE) \
		--output $@ web/resume.md;
	@printf "$(GRN)Done!$(END)\n\n";

web/static-root/resume.pdf: tools/genhardcopy/resume.tex
	@printf "$(BLU)***Building $(CYN)$@$(BLU)...$(END)\n";
	mtxrun --path=$(dir $<) --script context --result=$(notdir $@) $(notdir $<);
	mv $(dir $<)$(notdir $@) $@;
	@printf "$(GRN)Done!$(END)\n\n";

web/static-root/resume.rtf: web/resume.md
	@printf "$(BLU)***Building $(CYN)$@$(BLU)...$(END)\n";
	pandoc --standalone $(if $(PANDOC_VERSION_2),--from markdown+smart,--smart) $< --output $@;
	@printf "$(GRN)Done!$(END)\n\n";

web/static-root/resume.docx: web/resume.md
	@printf "$(BLU)***Building $(CYN)$@$(BLU)...$(END)\n";
	pandoc --standalone $(if $(PANDOC_VERSION_2),--from markdown+smart,--smart) $< --output $@;
	@printf "$(GRN)Done!$(END)\n\n";

web/static-root/resume.rst: web/resume.md
	@printf "$(BLU)***Building $(CYN)$@$(BLU)...$(END)\n";
	pandoc --standalone --from markdown --to rst $< --output $@;
	@printf "$(GRN)Done!$(END)\n\n";