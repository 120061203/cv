# Markdown Resume Makefile

# 主要目標文件
TARGET = resume
MD_FILE = $(TARGET).md
TIMESTAMP = $(shell date +%Y%m%d_%H%M%S)
OUTPUT_FILE = songlinchen_$(TARGET)_$(TIMESTAMP).md

# 預設目標
all: $(OUTPUT_FILE)

# 複製並重命名 Markdown 文件
$(OUTPUT_FILE): $(MD_FILE)
	@echo "📝 生成 Markdown 履歷..."
	@cp $(MD_FILE) $(OUTPUT_FILE)
	@echo "✅ 生成完成：$(OUTPUT_FILE)"

# 清理文件
clean:
	@echo "🧹 清理 Markdown 文件..."
	@rm -f songlinchen_*.md
	@echo "✅ 清理完成"

# 顯示幫助
help:
	@echo "可用的命令："
	@echo "  make        - 生成帶時間戳的 Markdown 履歷"
	@echo "  make clean  - 清理生成的 Markdown 文件"
	@echo "  make help   - 顯示此幫助信息"

.PHONY: all clean help
