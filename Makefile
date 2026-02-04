# Find .tex files in the src directory.
TEX_FILES := $(wildcard src/*.tex)
# Define .pdf files to be generated from .tex files (e.g., src/resume.tex -> resume.pdf)
PDF_FILES := $(patsubst src/%.tex,%.pdf,$(TEX_FILES))
# Only convert resume.pdf to png for the README.
PNG_FILES := resume.png

# Generates all pdf and png files when 'make' or 'make all' is run.
all: $(PDF_FILES) $(PNG_FILES)

# PDF generation rule: Creates A.pdf from src/A.tex.
%.pdf: src/%.tex
	pdflatex -output-directory=$(@D) $<

# PNG generation rule: Creates A.png from A.pdf.
%.png: %.pdf
	pdftoppm -png -singlefile -rx 200 -ry 200 $< $(basename $@)

# Removes generated files when 'make clean' is run.
clean:
	rm -f *.pdf *.png *.log *.aux
