# LaTeX Resume Makefile

# 主要目標文件
TARGET = resume
TEX_FILE = src/$(TARGET).tex
DATE = $(shell date +%Y%m%d)
TIME = $(shell date +%H%M%S)
TIMESTAMP = $(DATE)_$(TIME)
PDF_FILE = output/songlinchen_$(TARGET)_$(TIMESTAMP).pdf

# LaTeX編譯器
LATEX = pdflatex
LATEX_FLAGS = -interaction=nonstopmode

# 預設目標
all: $(PDF_FILE)

# 編譯PDF
$(PDF_FILE): $(TEX_FILE)
	cd src && $(LATEX) $(LATEX_FLAGS) -jobname=songlinchen_$(TARGET)_$(TIMESTAMP) -output-directory=../output $(TARGET).tex
	cd src && $(LATEX) $(LATEX_FLAGS) -jobname=songlinchen_$(TARGET)_$(TIMESTAMP) -output-directory=../output $(TARGET).tex  # 執行兩次以確保交叉引用正確
	@echo "🧹 清理輔助文件..."
	@rm -f output/*.aux output/*.log output/*.out output/*.toc output/*.synctex.gz

# 清理臨時文件
clean:
	rm -f src/*.aux src/*.log src/*.out src/*.toc src/*.fdb_latexmk src/*.fls src/*.synctex.gz
	rm -f output/*.aux output/*.log output/*.out output/*.toc output/*.fdb_latexmk output/*.fls output/*.synctex.gz

# 完全清理（包括PDF）
distclean: clean
	rm -f output/songlinchen_resume_*.pdf

# 快速編譯（不清理）
quick:
	cd src && $(LATEX) $(LATEX_FLAGS) -jobname=songlinchen_$(TARGET)_$(TIMESTAMP) -output-directory=../output $(TARGET).tex

# 監視文件變化並自動重新編譯（需要安裝latexmk）
watch:
	cd src && latexmk -pdf -pvc -output-directory=../output $(TARGET).tex

# 顯示幫助
help:
	@echo "可用的命令："
	@echo "  make        - 編譯履歷PDF"
	@echo "  make clean  - 清理臨時文件"
	@echo "  make distclean - 清理所有生成的文件"
	@echo "  make quick  - 快速編譯"
	@echo "  make watch  - 監視文件變化並自動重新編譯"
	@echo "  make help   - 顯示此幫助信息"

.PHONY: all clean distclean quick watch help
