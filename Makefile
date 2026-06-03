.DEFAULT_GOAL := help

# Find .tex files in the src directory.
TEX_FILES := $(wildcard src/*.tex)
# Define .pdf files to be generated from .tex files (e.g., src/resume.tex -> resume.pdf)
PDF_FILES := $(patsubst src/%.tex,%.pdf,$(TEX_FILES))
# Only convert resume.pdf to png for the README.
PNG_FILES := resume.png
MMD_DIR := src/assets/diagrams
MMD_FILES := $(wildcard $(MMD_DIR)/*.mmd)
DIAGRAM_PNG_FILES := $(patsubst $(MMD_DIR)/%.mmd,src/assets/%.png,$(MMD_FILES))
PUPPETEER_CONFIG := $(MMD_DIR)/puppeteer-config.json

# Shows available make targets and their descriptions.
help:
	@awk '\
		/^[[:space:]]*#/ { \
			sub(/^[[:space:]]*# ?/, "", $$0); \
			comment = $$0; \
			next; \
		} \
		/^[a-zA-Z0-9_.-]+[[:space:]]*[:+?]?=/ { \
			comment = ""; \
			next; \
		} \
		/^[a-zA-Z0-9_%.-]+:([^=]|$$)/ { \
			target = $$1; \
			sub(/:$$/, "", target); \
			printf "\033[36m%-30s\033[0m %s\n", target, comment; \
			comment = ""; \
			next; \
		} \
		{ comment = "" } \
	' $(MAKEFILE_LIST)

# Generates all pdf and png files when 'make' or 'make all' is run.
all: $(PDF_FILES) $(PNG_FILES)

# Generates png files from Mermaid diagrams.
diagrams: $(DIAGRAM_PNG_FILES)

# PDF generation rule: Creates A.pdf from src/A.tex.
%.pdf: src/%.tex
	TEXINPUTS=.:./assets: pdflatex -output-directory=$(@D) $<

# PNG generation rule: Creates A.png from A.pdf.
%.png: %.pdf
	pdftoppm -png -singlefile -rx 200 -ry 200 $< $(basename $@)

# Mermaid diagram generation rule: Creates src/assets/A.png from src/assets/diagrams/A.mmd.
src/assets/%.png: $(MMD_DIR)/%.mmd $(PUPPETEER_CONFIG)
	mmdc -p $(PUPPETEER_CONFIG) -i $< -o $@

# Removes generated files when 'make clean' is run.
clean:
	rm -f *.pdf *.png *.log *.aux
