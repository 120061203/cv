# 統一履歷編譯 Makefile
# 預設：目前線上／PDF 使用的 songlinchen_20260321（LaTeX + Markdown 快照）
# 舊版長履歷：make resume

LATEX = pdflatex
LATEX_FLAGS = -interaction=nonstopmode

DATE = $(shell date +%Y%m%d)
TIME = $(shell date +%H%M%S)
TIMESTAMP = $(DATE)_$(TIME)

# --- 目前主要履歷（GitHub Pages、output/songlinchen_20260321.pdf）---
CV_STEM = songlinchen_20260321
CV_TEX = src/$(CV_STEM).tex
CV_MD_SRC = markdown/$(CV_STEM).md
CV_PDF = output/$(CV_STEM).pdf
CV_MD_STAMPED = markdown/$(CV_STEM)_$(TIMESTAMP).md

# --- 舊版 resume.tex 長履歷 ---
RESUME_STEM = resume
RESUME_TEX = src/$(RESUME_STEM).tex
RESUME_MD_SRC = markdown/$(RESUME_STEM).md
RESUME_PDF_STAMPED = output/songlinchen_$(RESUME_STEM)_$(TIMESTAMP).pdf
RESUME_MD_STAMPED = markdown/songlinchen_$(RESUME_STEM)_$(TIMESTAMP).md

.PHONY: all pdf md clean distclean watch help check-deps status resume resume-pdf resume-md

# 預設：產出固定檔名 PDF + 帶時間戳的 Markdown 快照
all: pdf md
	@echo "🎉 履歷編譯完成！"
	@echo "📄 PDF（線上連結用）: $(CV_PDF)"
	@echo "📝 Markdown 快照: $(CV_MD_STAMPED)"

pdf: $(CV_PDF)

md: $(CV_MD_STAMPED)

$(CV_PDF): $(CV_TEX)
	@echo "📄 編譯 LaTeX（$(CV_STEM)）..."
	@mkdir -p output
	cd src && $(LATEX) $(LATEX_FLAGS) -output-directory=../output $(CV_STEM).tex
	cd src && $(LATEX) $(LATEX_FLAGS) -output-directory=../output $(CV_STEM).tex
	@rm -f output/$(CV_STEM).aux output/$(CV_STEM).log output/$(CV_STEM).out
	@echo "✅ PDF: $(CV_PDF)"

$(CV_MD_STAMPED): $(CV_MD_SRC)
	@echo "📝 產生 Markdown 時間戳版本..."
	@cp $(CV_MD_SRC) $(CV_MD_STAMPED)
	@echo "✅ $(CV_MD_STAMPED)"

# 舊版：resume.tex → 帶時間戳的 PDF / MD
resume: resume-pdf resume-md
	@echo "🎉 長版履歷（resume）編譯完成！"
	@echo "📄 PDF: $(RESUME_PDF_STAMPED)"
	@echo "📝 Markdown: $(RESUME_MD_STAMPED)"

resume-pdf: $(RESUME_TEX)
	@echo "📄 編譯 LaTeX（$(RESUME_STEM)）..."
	@mkdir -p output
	cd src && $(LATEX) $(LATEX_FLAGS) -jobname=songlinchen_$(RESUME_STEM)_$(TIMESTAMP) -output-directory=../output $(RESUME_STEM).tex
	cd src && $(LATEX) $(LATEX_FLAGS) -jobname=songlinchen_$(RESUME_STEM)_$(TIMESTAMP) -output-directory=../output $(RESUME_STEM).tex
	@rm -f output/songlinchen_$(RESUME_STEM)_$(TIMESTAMP).aux output/songlinchen_$(RESUME_STEM)_$(TIMESTAMP).log output/songlinchen_$(RESUME_STEM)_$(TIMESTAMP).out
	@echo "✅ PDF: $(RESUME_PDF_STAMPED)"

resume-md: $(RESUME_MD_SRC)
	@echo "📝 產生 Markdown 時間戳版本..."
	@cp $(RESUME_MD_SRC) $(RESUME_MD_STAMPED)
	@echo "✅ $(RESUME_MD_STAMPED)"

# 快速（不清理 .log 等，除錯用）
quick-pdf: $(CV_TEX)
	@mkdir -p output
	cd src && $(LATEX) $(LATEX_FLAGS) -output-directory=../output $(CV_STEM).tex

quick-md: $(CV_MD_SRC)
	@cp $(CV_MD_SRC) $(CV_MD_STAMPED)
	@echo "✅ $(CV_MD_STAMPED)"

quick: quick-pdf quick-md

clean:
	@echo "🧹 清理輔助文件..."
	@rm -f src/*.aux src/*.log src/*.out src/*.toc src/*.synctex.gz src/*.fdb_latexmk src/*.fls
	@rm -f output/*.aux output/*.log output/*.out output/*.toc output/*.synctex.gz
	@echo "🎉 完成"

distclean: clean
	@echo "🗑️  移除時間戳 Markdown 快照（songlinchen_20260321_*.md）..."
	@rm -f markdown/songlinchen_20260321_*.md
	@echo "（保留 output/$(CV_STEM).pdf 與 markdown/$(CV_STEM).md 主檔）"

watch:
	@echo "👀 監視：$(CV_TEX)"
	@if command -v latexmk >/dev/null 2>&1; then \
		cd src && latexmk -pdf -pvc -output-directory=../output $(CV_STEM).tex; \
	else \
		echo "❌ 請安裝 latexmk"; exit 1; \
	fi

help:
	@echo "📋 主要命令（目前履歷 songlinchen_20260321）："
	@echo "  make / make all  — PDF: output/songlinchen_20260321.pdf + Markdown 快照"
	@echo "  make pdf         — 只編譯 PDF"
	@echo "  make md          — 只從 markdown/songlinchen_20260321.md 複製時間戳版本"
	@echo ""
	@echo "舊版長履歷（resume.tex）："
	@echo "  make resume      — 產出 songlinchen_resume_<時間戳>.pdf 與 .md"
	@echo ""
	@echo "  make clean / make distclean / make watch / make status"

check-deps:
	@echo "🔍 檢查依賴..."
	@command -v $(LATEX) >/dev/null 2>&1 || (echo "❌ 請安裝 LaTeX"; exit 1)
	@test -f "$(CV_TEX)" || (echo "❌ 缺少 $(CV_TEX)"; exit 1)
	@test -f "$(CV_MD_SRC)" || (echo "❌ 缺少 $(CV_MD_SRC)"; exit 1)
	@echo "✅ OK"

status:
	@echo "📊 主履歷源檔: $(CV_TEX) / $(CV_MD_SRC)"
	@echo "📄 固定 PDF:   $(CV_PDF) $(if $(wildcard $(CV_PDF)),✅,❌)"
	@echo "📝 最新快照:   $$(ls -t markdown/songlinchen_20260321_*.md 2>/dev/null | head -1 || echo 無)"
