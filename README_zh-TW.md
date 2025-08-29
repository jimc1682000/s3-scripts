# S3 腳本工具集

用於管理 AWS S3 檔案的實用腳本集合，包含檔案重新命名、壓縮與清單檢查功能。

## 📋 腳本總覽

| 腳本 | 功能 | 輸入 | 輸出 |
|--------|---------|--------|--------|
| `change-name.sh` | 批次重新命名 S3 檔案 | `filelist.csv` | 修改後的 S3 檔案 |
| `gzip-logs.sh` | 壓縮目錄 | 本地資料夾 | `tar/` 內的 `.tar.gz` 檔案 |
| `file-checker.sh` | 產生 S3 清單 | S3 儲存桶路徑 | `{日期}_result.csv` |

## 🛠️ 腳本使用方式

### change-name.sh - 批次檔案重新命名

**用途**：批次重新命名多個 S3 檔案，在檔名後加上後綴（如 `-M`）。

**前置需求**：
- 已設定適當權限的 AWS CLI
- S3 儲存桶讀寫存取權限

**設定**：
1. 編輯腳本設定您的儲存桶名稱：
   ```bash
   bucket="s3://your-bucket-name"  # 修改為您實際的儲存桶
   ```

2. 建立 `filelist.csv`，每行一個檔案 ID：
   ```
   file001
   file002
   file003
   ```

**使用方式**：
```bash
./change-name.sh
```

**執行內容**：
- 從 `filelist.csv` 讀取檔案 ID
- 將檔案從 `{fileid}.doc` 重新命名為 `{fileid}-M.doc`
- 針對預定義的子資料夾（`abc/def/`）執行操作

**⚠️ 安全提醒**：腳本包含 `--dryrun` 選項（已註解）。測試時請取消註解第 7 行，並註解第 8 行。

---

### gzip-logs.sh - 目錄壓縮

**用途**：將所有第一層目錄壓縮成 `.tar.gz` 檔案以供封存。

**特色**：
- 忽略隱藏資料夾（`.folder`）
- 排除輸出目錄 `tar/`
- 支援使用 `pigz` 進行平行壓縮

**使用方式**：
```bash
./gzip-logs.sh
```

**執行流程**：
1. 掃描目錄（深度 1）
2. 如果 `tar/` 目錄不存在則建立
3. 將每個目錄壓縮為 `tar/{目錄名}.tar.gz`
4. 使用 gzip 等級 9（最佳壓縮）

**效能選項**：
- **標準模式**：使用 `gzip -9`（單執行緒）
- **快速模式**：取消註解第 20 行並註解第 18 行以使用 `pigz`（平行壓縮）

**輸出**：壓縮檔案儲存於 `tar/` 目錄

---

### file-checker.sh - S3 清單產生

**用途**：產生 S3 儲存桶路徑中所有檔案的 CSV 清單。

**前置需求**：
- 已安裝並設定 AWS CLI
- 具有 S3 讀取權限的 AWS 設定檔
- 選用：PyPy 環境以提升效能

**設定**：
1. 設定您的 S3 詳細資料：
   ```bash
   S3_BUCKET="your-bucket-name"    # 您的 S3 儲存桶名稱
   BASE_PATH="/your/base/path"     # 要掃描的 S3 路徑
   AWS_PROFILE="checker"           # AWS CLI 設定檔名稱
   ```

2. 選用的 PyPy 設定（提升效能）：
   ```bash
   # 如果使用 PyPy，請取消註解第 9-12 行和第 26 行
   export PYENV_ROOT="/opt/pypy3envs"
   export PYENV_VERSION="file-checker"
   ```

**使用方式**：
```bash
./file-checker.sh
```

**輸出**：
- 檔案：`{YYYY-MM-DD}_result.csv`
- 格式：`日期,時間,大小,父資料夾,檔案名稱,副檔名`

**執行流程**：
1. 遞迴列出 S3 路徑中的所有檔案
2. 使用 `awk` 解析並格式化輸出
3. 建立結構化的 CSV 報告
4. 設定檔案權限為 666 以便存取

## 📁 檔案結構

```
s3-scripts/
├── README.md           # 英文說明文件
├── README_zh-TW.md     # 繁體中文說明文件
├── change-name.sh      # S3 檔案重新命名工具
├── file-checker.sh     # S3 清單產生器
├── gzip-logs.sh        # 目錄壓縮工具
├── filelist.csv        # change-name.sh 的輸入檔案（需要時建立）
└── tar/               # 輸出目錄（由 gzip-logs.sh 建立）
```

## ⚙️ 設定需求

### AWS CLI 設定
```bash
# 安裝 AWS CLI
pip install awscli

# 設定認證
aws configure --profile your-profile-name
```

### 必要權限
- S3 讀取存取：`s3:GetObject`, `s3:ListBucket`
- S3 寫入存取：`s3:PutObject`, `s3:DeleteObject`（用於 change-name.sh）

### 選用工具
- **pigz**：用於平行壓縮（macOS 使用 `brew install pigz`）
- **PyPy**：用於提升 file-checker.sh 的 Python 效能

## 🔧 客製化設定

### change-name.sh
- 修改 `bucket` 變數設定您的 S3 儲存桶
- 更新迴圈中的子資料夾路徑（第 6 行）
- 變更副檔名模式（目前為 `.doc`）
- 調整命名後綴（目前為 `-M`）

### gzip-logs.sh
- 修改第 18 行的壓縮等級（1-9）
- 切換到 `pigz` 進行平行處理
- 調整目錄深度（`-mindepth 1 -maxdepth 1`）

### file-checker.sh
- 更新 S3 儲存桶和路徑變數
- 修改 AWS 設定檔名稱
- 自訂 awk 指令中的輸出 CSV 格式
- 如果可用，啟用 PyPy 環境

## 🚨 重要注意事項

- 有 `--dryrun` 選項時務必先測試腳本
- 執行 S3 操作前確保擁有適當的 AWS 權限
- 處理大型 S3 儲存桶時注意成本監控
- 在多核心系統上考慮使用 `pigz` 以獲得更好的壓縮效能

## 📞 支援與回饋

如果您在使用過程中遇到問題或有改進建議，歡迎：
- 檢查腳本設定是否正確
- 確認 AWS 認證和權限設定
- 參考錯誤訊息進行除錯
- 使用 `--dryrun` 模式進行安全測試

## 📄 授權

此專案採用開放原始碼授權，歡迎自由使用和修改。