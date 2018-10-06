# This Makefile targets GNU make

OUT_DIR = output
STYLE = resume
FILE_NAME = resume
PAPER_SIZE = letter

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

pdf: $(OUT_DIR)/$(FILE_NAME).pdf

docx: $(OUT_DIR)/$(FILE_NAME).docx

rtf: $(OUT_DIR)/$(FILE_NAME).rtf

clean:
	rm $(OUT_DIR)/$(FILE_NAME).pdf ||:
	rm $(OUT_DIR)/$(FILE_NAME).docx ||:
	rm $(OUT_DIR)/$(FILE_NAME).rtf ||:
	rm $(OUT_DIR)/context_$(FILE_NAME).log ||:
	rm $(OUT_DIR)/$(FILE_NAME).log ||:
	rm $(OUT_DIR)/$(FILE_NAME).tex ||:
	rm $(OUT_DIR)/$(FILE_NAME).tuc ||:
	rmdir $(OUT_DIR)

.PHONY: all clean pdf docx rtf

# Uncomment this if you need to keep the .tex file for inspection
# .PRECIOUS: $(OUT_DIR)/%.tex

$(OUT_DIR):
	mkdir -p $(OUT_DIR)

$(OUT_DIR)/%.tex: $(STYLE).tex %.md | $(OUT_DIR)
	@printf "$(BLU)***Building $(CYN)$@$(BLU)...$(END)\n";
	pandoc --standalone --template $(STYLE).tex \
		--from markdown --to context \
		--variable papersize=$(PAPER_SIZE) \
		--output $(OUT_DIR)/$*.tex $*.md > /dev/null;
	@printf "$(GRN)Done!$(END)\n\n"
	
$(OUT_DIR)/%.pdf: $(OUT_DIR)/%.tex | $(OUT_DIR)
	@printf "$(BLU)***Building $(CYN)$@$(BLU)...$(END)\n";
	mtxrun --path=$(OUT_DIR) --result=$*.pdf --script context $*.tex > $(OUT_DIR)/context_$*.log 2>&1;
	@printf "$(GRN)Done!$(END)\n\n"

$(OUT_DIR)/%.rtf: %.md | $(OUT_DIR)
	@printf "$(BLU)***Building $(CYN)$@$(BLU)...$(END)\n";
	pandoc --standalone $(if $(PANDOC_VERSION_2),--from markdown+smart,--smart) $< --output $@;
	@printf "$(GRN)Done!$(END)\n\n"

$(OUT_DIR)/%.docx: %.md | $(OUT_DIR)
	@printf "$(BLU)***Building $(CYN)$@$(BLU)...$(END)\n";
	pandoc --standalone $(if $(PANDOC_VERSION_2),--from markdown+smart,--smart) $< --output $@;
	@printf "$(GRN)Done!$(END)\n\n"