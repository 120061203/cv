# 📄 Song Lin Chen's LaTeX Resume Project

這是一個專業的 LaTeX 履歷專案，專為 Song Lin Chen 設計，提供現代化、美觀且易於維護的履歷模板。

## 🌐 線上履歷

- **GitHub Pages**: [https://120061203.github.io/cv/](https://120061203.github.io/cv/)
- **最新 PDF**: [output/songlinchen_resume_20251001_135642.pdf](output/songlinchen_resume_20251001_135642.pdf)

## ✨ 專案特色

- 🎨 **現代化設計**：使用專業的 LaTeX 排版，支援中英文混合
- 📱 **響應式佈局**：優化的頁面佈局，適合各種閱讀環境
- 🏷️ **個人化標識**：文件名包含個人姓名和時間戳記
- 🔧 **自動化編譯**：使用 Makefile 簡化編譯流程
- 📁 **清晰結構**：源文件和輸出文件分離管理
- 🧹 **自動清理**：編譯後自動清理輔助文件

## 🎯 專案目標

為 Song Lin Chen 提供一個專業、美觀且易於維護的履歷模板，支援：
- 快速編譯和版本管理
- 個人化文件名格式
- 專業的排版效果
- 易於修改和擴展

## 📁 專案結構

```
cv/
├── src/                           # 📝 LaTeX源文件目錄
│   └── resume.tex                 # 主要的LaTeX履歷文件
├── output/                        # 📄 LaTeX輸出文件目錄
│   ├── songlinchen_resume_20251001_124311.pdf
│   ├── songlinchen_resume_20251001_124205.pdf
│   └── ...                        # 其他編譯生成的PDF文件
├── markdown/                      # 📝 Markdown版本目錄
│   ├── resume.md                  # Markdown履歷文件
│   ├── Makefile                   # Markdown編譯腳本
│   ├── README.md                  # Markdown說明文件
│   └── songlinchen_resume_*.md    # 生成的Markdown文件
├── Makefile                       # 🔧 LaTeX編譯腳本
└── README.md                      # 📖 專案說明文件
```

### 📋 文件說明

#### LaTeX 版本
- **`src/resume.tex`**：主要的 LaTeX 源文件，包含完整的履歷內容
- **`output/`**：存放所有編譯生成的 PDF 文件，文件名格式為 `songlinchen_resume_YYYYMMDD_HHMMSS.pdf`
- **`Makefile`**：LaTeX 自動化編譯腳本，支援多種編譯選項

#### Markdown 版本
- **`markdown/resume.md`**：Markdown 格式的履歷文件，易於編輯和查看
- **`markdown/Makefile`**：Markdown 自動化腳本，生成帶時間戳的版本
- **`markdown/README.md`**：Markdown 版本的使用說明

#### 專案文檔
- **`README.md`**：完整的專案說明文件

## 🛠️ 系統需求

### 必要軟體
- **LaTeX 發行版**：TeX Live、MiKTeX 或 MacTeX
- **Make 工具**：用於自動化編譯
- **文字編輯器**：支援 UTF-8 編碼的編輯器

### 📦 依賴套件
本專案使用以下 LaTeX 套件：
- `geometry` - 頁面佈局控制
- `enumitem` - 列表格式設定
- `titlesec` - 標題格式設定
- `xcolor` - 顏色支援
- `hyperref` - 超連結支援
- `fontawesome5` - 圖標支援
- `paracol` - 多欄佈局
- `changepage` - 頁面調整
- `bookmark` - 書籤支援

## 🚀 使用方法

### 🎯 統一編譯（推薦）
```bash
make                # 同時生成 PDF 和 Markdown 履歷
make pdf           # 只生成 PDF 履歷
make md            # 只生成 Markdown 履歷
```
**功能**：一個命令同時生成兩種格式的履歷
**輸出**：
- PDF：`output/songlinchen_resume_YYYYMMDD_HHMMSS.pdf`
- Markdown：`markdown/songlinchen_resume_YYYYMMDD_HHMMSS.md`
**特點**：自動清理輔助文件，保持目錄整潔

### ⚡ 快速編譯
```bash
make quick          # 快速編譯（不清理輔助文件）
make quick-pdf     # 快速編譯 PDF
make quick-md      # 快速生成 Markdown
```
**功能**：快速編譯，不進行清理
**適用**：開發過程中的快速測試

### 🧹 清理功能
```bash
make clean          # 清理臨時文件
make distclean     # 完全清理（包括所有生成的文件）
```

### 👀 監視模式
```bash
make watch
```
**功能**：監視文件變化並自動重新編譯
**需求**：需要安裝 `latexmk`
**適用**：持續編輯時的即時預覽

### 📊 專案狀態
```bash
make status         # 顯示專案狀態和統計
make check-deps     # 檢查編譯依賴
```

### 📋 查看幫助
```bash
make help
```
**功能**：顯示所有可用的編譯選項

## 📝 Markdown 版本

### 🌐 線上履歷
- **GitHub Pages**: [https://120061203.github.io/cv/](https://120061203.github.io/cv/)
- **最新 Markdown**: [https://120061203.github.io/cv/resume.md]()

### 統一編譯（推薦）
```bash
make                   # 同時生成 PDF 和 Markdown
make md               # 只生成 Markdown 履歷
```

### 獨立編譯（舊方式）
```bash
cd markdown
make                    # 生成帶時間戳的 Markdown 文件
make clean            # 清理生成的 Markdown 文件
```

### Markdown 特色
- **輕量級**：純 Markdown 格式，易於編輯
- **跨平台**：可在任何支援 Markdown 的平台上查看
- **版本控制**：與 Git 完美整合
- **協作友好**：支援多人協作編輯
- **線上展示**：透過 GitHub Pages 自動部署
- **統一管理**：與 LaTeX 版本使用相同的編譯流程

## ✏️ 自訂履歷內容

### 📝 編輯源文件
編輯 `src/resume.tex` 文件，修改以下部分：

1. **👤 個人資訊**：姓名、聯絡方式、地址、LinkedIn、GitHub
2. **📋 個人簡介**：簡短描述專業背景和職業目標
3. **🎓 教育背景**：學歷資訊、GPA、相關課程
4. **💼 工作經驗**：工作經歷、職責、成就和貢獻
5. **🛠️ 技能**：技術技能、程式語言、工具和語言能力
6. **🚀 專案經驗**：重要專案、技術棧、成果和影響
7. **🏆 獲獎記錄**：競賽獲獎、榮譽和認證
8. **📚 其他資訊**：興趣、志願服務、證照等

### 🎨 格式說明
- 使用 `\section{}` 創建主要章節
- 使用 `\subsection{}` 創建子章節
- 使用 `\item` 創建列表項目
- 使用 `\textbf{}` 加粗文字
- 使用 `\textit{}` 斜體文字
- 使用 `\href{}{}` 創建超連結

## ⚠️ 注意事項

1. **編譯流程**：LaTeX 需要執行兩次以確保交叉引用正確
2. **套件依賴**：確保所有必要的 LaTeX 套件已安裝
3. **文件編碼**：建議使用 UTF-8 編碼保存文件
4. **頁面設定**：可根據需要調整頁面邊距和字體大小

## 🔧 故障排除

### 常見問題
1. **LaTeX 未安裝**：請安裝 TeX Live、MiKTeX 或 MacTeX
2. **套件缺失**：確保所有依賴套件已安裝
3. **編碼問題**：確保文件使用 UTF-8 編碼
4. **語法錯誤**：檢查 LaTeX 語法是否正確

### 調試步驟
```bash
# 檢查 LaTeX 安裝
pdflatex --version

# 查看編譯日誌
cat output/*.log

# 清理並重新編譯
make distclean && make
```

## 🎨 自訂樣式

### 可調整的設定
- **頁面邊距**：修改 `geometry` 套件設定
- **字體大小**：調整 `\documentclass` 選項
- **顏色主題**：修改 `\definecolor` 和 `\color` 設定
- **標題格式**：調整 `\titleformat` 設定
- **列表樣式**：修改 `\renewcommand\labelitemi` 設定

### 進階自訂
- 添加新的章節類型
- 自訂頁眉頁腳
- 調整行距和段落間距
- 添加背景圖案或邊框

## 🌟 專案特色

### 📄 文件名管理
- **個人化命名**：`songlinchen_resume_YYYYMMDD_HHMMSS.pdf`
- **時間戳記**：精確到秒的編譯時間記錄
- **版本控制**：每次編譯都有唯一文件名
- **自動清理**：編譯後自動清理輔助文件

### 🎨 設計特色
- **現代化佈局**：使用專業的 LaTeX 排版
- **響應式設計**：適應不同閱讀環境
- **中英文混合**：完美支援中英文內容
- **圖標支援**：使用 FontAwesome 圖標
- **超連結支援**：支援外部連結和書籤

### 🔧 技術特色
- **自動化編譯**：使用 Makefile 簡化流程
- **依賴管理**：智能的增量編譯
- **錯誤處理**：詳細的編譯日誌
- **跨平台支援**：支援 macOS、Linux、Windows

## 📊 專案統計

- **文件數量**：4 個核心文件
- **支援語言**：中文、英文
- **編譯時間**：約 1-2 秒
- **文件大小**：約 170KB
- **頁數**：1 頁（A4）

## 📝 版本歷史

- **v1.0** - 初始版本，基本 LaTeX 履歷模板
- **v1.1** - 添加時間戳記和個人化文件名
- **v1.2** - 優化目錄結構，分離源文件和輸出文件
- **v1.3** - 改進時間戳格式，添加自動清理功能
- **v1.4** - 完善 README 文檔，添加詳細使用說明

## 🤝 貢獻指南

歡迎對本專案提出建議和改進：
1. 報告問題或建議新功能
2. 優化 LaTeX 模板設計
3. 改進編譯流程
4. 完善文檔說明

## 📞 聯絡資訊

- **作者**：Song Lin Chen
- **專案類型**：個人履歷模板
- **維護狀態**：活躍開發中
- **最後更新**：2025年10月1日
