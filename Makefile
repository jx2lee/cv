# src 디렉토리에서 .tex 파일 목록을 찾습니다.
TEX_FILES := $(wildcard src/*.tex)
# .tex 목록을 기반으로 생성될 .pdf 파일 목록을 정의합니다. (예: src/resume.tex -> resume.pdf)
PDF_FILES := $(patsubst src/%.tex,%.pdf,$(TEX_FILES))
# 생성될 .png 파일 목록을 정의합니다.
PNG_FILES := $(patsubst %.pdf,%.png,$(PDF_FILES))

# 'make' 또는 'make all' 실행 시 모든 pdf와 png를 생성합니다.
all: $(PDF_FILES) $(PNG_FILES)

# PDF 생성 규칙: src/A.tex 파일로 A.pdf 파일을 만듭니다.
# $<: 첫 번째 종속성 파일(src/%.tex)
# $@: 타겟 파일(%.pdf)
# A.pdf를 만들기 위해 src/A.tex가 필요하며, pdflatex를 실행할 때
# 생성되는 aux, log 파일들이 pdf와 같은 위치에 생기도록
# -output-directory를 설정하고, 소스 파일을 찾아 컴파일합니다.
%.pdf: src/%.tex
	pdflatex -output-directory=$(@D) $<

# PNG 생성 규칙: A.pdf 파일로 A.png 파일을 만듭니다.
# $<: 첫 번째 종속성 파일(%.pdf)
# $@: 타겟 파일(%.png)
# `basename $@`는 .png 확장자를 제외한 파일 이름을 추출합니다.
%.png: %.pdf
	pdftoppm -png -singlefile -rx 200 -ry 200 $< $(basename $@)

# 'make clean' 실행 시 생성된 파일들을 삭제합니다.
clean:
	rm -f *.pdf *.png *.log *.aux
