# 統一履歷編譯 Makefile
# 支援 LaTeX PDF 和 Markdown 版本同時生成

# 主要目標文件
TARGET = resume
LATEX = pdflatex
LATEX_FLAGS = -interaction=nonstopmode

# 時間戳記設定
DATE = $(shell date +%Y%m%d)
TIME = $(shell date +%H%M%S)
TIMESTAMP = $(DATE)_$(TIME)

# 文件路徑
TEX_FILE = src/$(TARGET).tex
MD_FILE = markdown/$(TARGET).md
PDF_FILE = output/songlinchen_$(TARGET)_$(TIMESTAMP).pdf
OUTPUT_MD_FILE = markdown/songlinchen_$(TARGET)_$(TIMESTAMP).md

# 預設目標：同時生成 PDF 和 Markdown
all: pdf md
	@echo "🎉 履歷編譯完成！"
	@echo "📄 PDF: $(PDF_FILE)"
	@echo "📝 Markdown: $(OUTPUT_MD_FILE)"

# 只生成 PDF
pdf: $(PDF_FILE)
	@echo "✅ PDF 履歷生成完成：$(PDF_FILE)"

# 只生成 Markdown
md: $(OUTPUT_MD_FILE)
	@echo "✅ Markdown 履歷生成完成：$(OUTPUT_MD_FILE)"

# PDF 編譯規則
$(PDF_FILE): $(TEX_FILE)
	@echo "📄 編譯 LaTeX 履歷..."
	@mkdir -p output
	cd src && $(LATEX) $(LATEX_FLAGS) -jobname=songlinchen_$(TARGET)_$(TIMESTAMP) -output-directory=../output $(TARGET).tex
	cd src && $(LATEX) $(LATEX_FLAGS) -jobname=songlinchen_$(TARGET)_$(TIMESTAMP) -output-directory=../output $(TARGET).tex  # 執行兩次以確保交叉引用正確
	@echo "🧹 清理輔助文件..."
	@rm -f output/*.aux output/*.log output/*.out output/*.toc output/*.synctex.gz
	@echo "✅ PDF 編譯完成：$(PDF_FILE)"

# Markdown 生成規則
$(OUTPUT_MD_FILE): $(MD_FILE)
	@echo "📝 生成 Markdown 履歷..."
	@cp $(MD_FILE) $(OUTPUT_MD_FILE)
	@echo "✅ Markdown 生成完成：$(OUTPUT_MD_FILE)"

# 快速編譯（不清理輔助文件）
quick: quick-pdf quick-md
	@echo "⚡ 快速編譯完成！"

quick-pdf: $(TEX_FILE)
	@echo "⚡ 快速編譯 PDF..."
	@mkdir -p output
	cd src && $(LATEX) $(LATEX_FLAGS) -jobname=songlinchen_$(TARGET)_$(TIMESTAMP) -output-directory=../output $(TARGET).tex
	@echo "✅ 快速 PDF 編譯完成"

quick-md: $(MD_FILE)
	@echo "⚡ 快速生成 Markdown..."
	@cp $(MD_FILE) $(OUTPUT_MD_FILE)
	@echo "✅ 快速 Markdown 生成完成"

# 清理功能
clean:
	@echo "🧹 清理輔助文件..."
	@rm -f src/*.aux src/*.log src/*.out src/*.toc src/*.synctex.gz src/*.fdb_latexmk src/*.fls
	@rm -f output/*.aux output/*.log output/*.out output/*.toc output/*.synctex.gz
	@echo "🎉 輔助文件清理完成！"

# 完全清理（包括所有生成的文件）
distclean: clean
	@echo "🗑️  完全清理..."
	@rm -f output/songlinchen_$(TARGET)_*.pdf
	@rm -f markdown/songlinchen_$(TARGET)_*.md
	@echo "🎉 完全清理完成！"

# 監視模式（需要 latexmk）
watch:
	@echo "👀 啟動監視模式..."
	@echo "監視文件：$(TEX_FILE)"
	@echo "按 Ctrl+C 停止監視"
	@if command -v latexmk >/dev/null 2>&1; then \
		cd src && latexmk -pdf -pvc -jobname=songlinchen_$(TARGET)_$(TIMESTAMP) -output-directory=../output $(TARGET).tex; \
	else \
		echo "❌ 錯誤：未找到 latexmk，請安裝後重試"; \
		exit 1; \
	fi

# 顯示幫助
help:
	@echo "📋 可用的編譯命令："
	@echo ""
	@echo "🎯 主要命令："
	@echo "  make        - 同時生成 PDF 和 Markdown 履歷"
	@echo "  make pdf    - 只生成 PDF 履歷"
	@echo "  make md     - 只生成 Markdown 履歷"
	@echo ""
	@echo "⚡ 快速命令："
	@echo "  make quick     - 快速編譯（不清理輔助文件）"
	@echo "  make quick-pdf - 快速編譯 PDF"
	@echo "  make quick-md  - 快速生成 Markdown"
	@echo ""
	@echo "🧹 清理命令："
	@echo "  make clean     - 清理輔助文件"
	@echo "  make distclean - 完全清理（包括所有生成的文件）"
	@echo ""
	@echo "👀 監視命令："
	@echo "  make watch     - 監視文件變化並自動重新編譯"
	@echo ""
	@echo "📖 幫助命令："
	@echo "  make help      - 顯示此幫助信息"
	@echo ""
	@echo "📁 文件結構："
	@echo "  src/$(TARGET).tex           - LaTeX 源文件"
	@echo "  markdown/$(TARGET).md       - Markdown 源文件"
	@echo "  output/songlinchen_*.pdf    - 生成的 PDF 文件"
	@echo "  markdown/songlinchen_*.md   - 生成的 Markdown 文件"

# 檢查依賴
check-deps:
	@echo "🔍 檢查編譯依賴..."
	@if ! command -v $(LATEX) >/dev/null 2>&1; then \
		echo "❌ 錯誤：未找到 $(LATEX)，請安裝 LaTeX 發行版"; \
		exit 1; \
	fi
	@if [ ! -f "$(TEX_FILE)" ]; then \
		echo "❌ 錯誤：未找到 LaTeX 源文件：$(TEX_FILE)"; \
		exit 1; \
	fi
	@if [ ! -f "$(MD_FILE)" ]; then \
		echo "❌ 錯誤：未找到 Markdown 源文件：$(MD_FILE)"; \
		exit 1; \
	fi
	@echo "✅ 所有依賴檢查通過！"

# 顯示專案狀態
status:
	@echo "📊 專案狀態："
	@echo "📁 源文件："
	@echo "  LaTeX:   $(TEX_FILE) $(if $(wildcard $(TEX_FILE)),✅,❌)"
	@echo "  Markdown: $(MD_FILE) $(if $(wildcard $(MD_FILE)),✅,❌)"
	@echo ""
	@echo "📄 最新輸出："
	@echo "  PDF: $(shell ls -t output/songlinchen_*.pdf 2>/dev/null | head -1 || echo '無')"
	@echo "  Markdown: $(shell ls -t markdown/songlinchen_*.md 2>/dev/null | head -1 || echo '無')"
	@echo ""
	@echo "📈 統計："
	@echo "  PDF 文件數量: $(shell ls output/songlinchen_*.pdf 2>/dev/null | wc -l || echo 0)"
	@echo "  Markdown 文件數量: $(shell ls markdown/songlinchen_*.md 2>/dev/null | wc -l || echo 0)"

.PHONY: all pdf md quick quick-pdf quick-md clean distclean watch help check-deps status