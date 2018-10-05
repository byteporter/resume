# This Makefile uses non-standard features from GNU make

OUT_DIR = output
STYLE = resume
FILE_NAME = resume

PANDOC_VERSION := $(shell echo `pandoc --version | head -1 | cut -d' ' -f2 | cut -d'.' -f1`)
SMART := $(shell if [ "$(PANDOC_VERSION)" -eq "2" ]; then echo '-smart'; else echo '--smart'; fi)

$(OUT_DIR)/resume.pdf: | $(OUT_DIR)
	@echo Building $@...;
	pandoc --standalone --template $(STYLE).tex \
		--from markdown --to context \
		--variable papersize=A4 \
		--output $(OUT_DIR)/$(FILE_NAME).tex $(FILE_NAME).md > /dev/null;
	mtxrun --path=$(OUT_DIR) --result=$(FILE_NAME).pdf --script context $(FILE_NAME).tex > $(OUT_DIR)/context_$(FILE_NAME).log 2>&1;

$(OUT_DIR):
	mkdir -p $(OUT_DIR)

all: $(OUT_DIR)/resume.pdf #resume.docx resume.rtf

clean:
	rm -rf $(OUT_DIR)

.PHONY: all clean

# resume.docx: init
# 	echo $(FILE_NAME).docx; \
# 	pandoc --standalone $$SMART $(FILE_NAME).md --output $(OUT_DIR)/$(FILE_NAME).docx;

# resume.rtf: init
# 	echo $(FILE_NAME).rtf; \
# 	pandoc --standalone $$SMART $(FILE_NAME).md --output $(OUT_DIR)/$(FILE_NAME).rtf;
