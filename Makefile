OUT_DIR=output
STYLE=resume

resume.pdf: init
	FILE_NAME='resume'; \
	echo $$FILE_NAME.pdf; \
	pandoc --standalone --template $(STYLE).tex \
		--from markdown --to context \
		--variable papersize=A4 \
		--output $(OUT_DIR)/$$FILE_NAME.tex $$FILE_NAME.md > /dev/null; \
	mtxrun --path=$(OUT_DIR) --result=$$FILE_NAME.pdf --script context $$FILE_NAME.tex > $(OUT_DIR)/context_$$FILE_NAME.log 2>&1;

all: resume.pdf #resume.docx resume.rtf

# resume.docx: init
# 	FILE_NAME=`basename $$f | sed 's/.md//g'`; \
# 	echo $$FILE_NAME.docx; \
# 	pandoc --standalone $$SMART $$f --output $(OUT_DIR)/$$FILE_NAME.docx;

# resume.rtf: init
# 	FILE_NAME=`basename $$f | sed 's/.md//g'`; \
# 	echo $$FILE_NAME.rtf; \
# 	pandoc --standalone $$SMART $$f --output $(OUT_DIR)/$$FILE_NAME.rtf;

init: dir version

dir:
	mkdir -p $(OUT_DIR)

version:
	PANDOC_VERSION=`pandoc --version | head -1 | cut -d' ' -f2 | cut -d'.' -f1`; \
	if [ "$$PANDOC_VERSION" -eq "2" ]; then \
		SMART=-smart; \
	else \
		SMART=--smart; \
	fi \

clean:
	rm -f $(OUT_DIR)/*