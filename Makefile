# This Makefile targets GNU make

SHELL := /bin/sh

PAPER_SIZE ?= letter
INSTALL_DIR ?= output/usr/share/resume/
BIN_DIR ?= output/go/bin/

GOOS ?= linux
GOARCH ?= amd64

# Terminal color control strings
RED=\e[1;31m
GRN=\e[1;32m
YEL=\e[1;33m
BLU=\e[1;34m
MAG=\e[1;35m
CYN=\e[1;36m
END=\e[0m

.PHONY: all hardcopy install uninstall

all: resume hardcopy web/static-root/resources/resume.min.css

hardcopy: web/static-root/resume.pdf

install: manifest

$(INSTALL_DIR):
	@mkdir -p $(INSTALL_DIR)

$(BIN_DIR):
	@mkdir -p $(BIN_DIR)

manifest: resume web/static-root/resources/resume.min.css web/static-root/resume.pdf web/templates/resume.gohtml | $(INSTALL_DIR) $(BIN_DIR)
	@printf "$(BLU)Installing output files...$(END)\n"
	@cp -r web/. $(INSTALL_DIR)
	@find $(INSTALL_DIR) -printf "%d\t%p\n" >manifest
	@cp resume $(BIN_DIR)
	@find $(BIN_DIR)resume -printf "%d\t%p\n" >>manifest
	@sort -r -o manifest manifest
	@printf "$(GRN)Done!$(END)\n\n"

uninstall:
	@printf "$(BLU)Uninstalling output files...$(END)\n"
	while IFS= read -r line <&3; do \
		FILENAME="$$(printf '%s' "$$line" | cut -f2)"; \
		if [ -f "$$FILENAME" ]; then \
			rm "$$FILENAME"; \
		fi \
	done 3< manifest
	while IFS= read -r line <&3; do \
		DIRNAME="$$(printf '%s' "$$line" | cut -f2)"; \
		if [ -d "$$DIRNAME" ]; then \
			rmdir "$$DIRNAME" ||:; \
		fi \
	done 3< manifest
	rm manifest
	@printf "$(GRN)Done!$(END)\n\n"

clean:
	@printf "$(BLU)Cleaning up files...$(END)\n"
	rm web/static-root/resume.pdf ||:
	rm tools/genhardcopy/resume.log ||:
	rm tools/genhardcopy/resume.tuc ||:
	rm tools/genhardcopy/resume.tex ||:
	rm resume ||:
	@printf "$(GRN)Done!$(END)\n\n"

resume: cmd/resume/resume.go
	@printf "$(BLU)***Building application $(CYN)$@$(BLU)...$(END)\n"
	CGO_ENABLED=0 GOOS=$(GOOS) GOARCH=$(GOARCH) go build -a -ldflags '-extldflags "-static"' -o $@ $^
	@printf "$(GRN)***Done!$(END)\n\n"

# Uncomment this if you need to keep the .tex file for inspection
# .PRECIOUS: tools/genhardcopy/resume.tex

tools/style-templates/resume.css: tools/style-templates/resume.css.m4 tools/style-templates/shared-style-config.m4
	@printf "$(BLU)***Building $(CYN)$@$(BLU)...$(END)\n"
	m4 -P -I$(dir $<) $< >/tmp/$(notdir $@) && cp /tmp/$(notdir $@) $@
	@printf "$(GRN)***Done!$(END)\n\n"

web/static-root/resources/resume.min.css: tools/style-templates/resume.css
	@printf "$(BLU)***Building $(CYN)$@$(BLU)...$(END)\n"
	uglifycss $< --output $@
	@printf "$(GRN)***Done!$(END)\n\n"

tools/genhardcopy/pdftemplate.tex: tools/style-templates/pdftemplate.tex.m4 tools/style-templates/shared-style-config.m4
	@printf "$(BLU)***Building $(CYN)$@$(BLU)...$(END)\n"
	m4 -P -I$(dir $<) $(notdir $<) >/tmp/$(notdir $@) && cp /tmp/$(notdir $@) $@
	@printf "$(GRN)***Done!$(END)\n\n"

tools/genhardcopy/resume.tex: tools/genhardcopy/pdftemplate.tex web/resume.md
	@printf "$(BLU)***Building $(CYN)$@$(BLU)...$(END)\n"
	pandoc --standalone --template $< \
		--from markdown --to context \
		--variable papersize=$(PAPER_SIZE) \
		--output $@ web/resume.md
	@printf "$(GRN)Done!$(END)\n\n"
	
web/static-root/resume.pdf: tools/genhardcopy/resume.tex
	@printf "$(BLU)***Building $(CYN)$@$(BLU)...$(END)\n"
	mtxrun --path=$(dir $<) --script context --result=$(notdir $@) $(notdir $<)
	mv $(dir $<)$(notdir $@) $@
	@printf "$(GRN)Done!$(END)\n\n"
