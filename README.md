# S3 Scripts Collection

A collection of utility scripts for managing AWS S3 files, including file renaming, compression, and inventory checking.

## 📋 Scripts Overview

| Script | Purpose | Input | Output |
|--------|---------|--------|--------|
| `change-name.sh` | Rename S3 files in batch | `filelist.csv` | Modified S3 files |
| `gzip-logs.sh` | Compress directories | Local folders | `.tar.gz` files in `tar/` |
| `file-checker.sh` | Generate S3 inventory | S3 bucket path | `{date}_result.csv` |

## 🛠️ Script Usage

### change-name.sh - Batch File Renaming

**Purpose**: Rename multiple S3 files by adding a suffix (e.g., `-M`) to their names.

**Prerequisites**:
- AWS CLI configured with appropriate permissions
- S3 bucket read/write access

**Setup**:
1. Edit the script to set your bucket name:
   ```bash
   bucket="s3://your-bucket-name"  # Change this to your actual bucket
   ```

2. Create `filelist.csv` with one file ID per line:
   ```
   file001
   file002
   file003
   ```

**Usage**:
```bash
./change-name.sh
```

**What it does**:
- Reads file IDs from `filelist.csv`
- Renames files from `{fileid}.doc` to `{fileid}-M.doc`
- Works on predefined subfolders (`abc/def/`)

**⚠️ Safety**: The script includes a `--dryrun` option (commented out). Uncomment line 7 and comment line 8 for testing.

---

### gzip-logs.sh - Directory Compression

**Purpose**: Compress all first-level directories into `.tar.gz` files for archival.

**Features**:
- Ignores hidden folders (`.folder`)
- Excludes the output `tar/` directory
- Supports parallel compression with `pigz`

**Usage**:
```bash
./gzip-logs.sh
```

**Process**:
1. Scans for directories (depth 1)
2. Creates `tar/` directory if it doesn't exist
3. Compresses each directory to `tar/{dirname}.tar.gz`
4. Uses gzip level 9 (best compression)

**Performance Options**:
- **Standard**: Uses `gzip -9` (single-threaded)
- **Fast**: Uncomment line 20 and comment line 18 to use `pigz` (parallel compression)

**Output**: Compressed files in `tar/` directory

---

### file-checker.sh - S3 Inventory Generation

**Purpose**: Generate a CSV inventory of all files in an S3 bucket path.

**Prerequisites**:
- AWS CLI installed and configured
- AWS profile with S3 read permissions
- Optional: PyPy environment for performance

**Setup**:
1. Configure your S3 details:
   ```bash
   S3_BUCKET="your-bucket-name"    # Your S3 bucket name
   BASE_PATH="/your/base/path"     # S3 path to scan
   AWS_PROFILE="checker"           # AWS CLI profile name
   ```

2. Optional PyPy setup (for better performance):
   ```bash
   # Uncomment lines 9-12 and 26 if using PyPy
   export PYENV_ROOT="/opt/pypy3envs"
   export PYENV_VERSION="file-checker"
   ```

**Usage**:
```bash
./file-checker.sh
```

**Output**: 
- File: `{YYYY-MM-DD}_result.csv`
- Format: `date,time,size,parent_folder,filename,extension`

**Process**:
1. Lists all files in S3 path recursively
2. Parses and formats the output using `awk`
3. Creates a structured CSV report
4. Sets file permissions to 666 for easy access

## 📁 File Structure

```
s3-scripts/
├── README.md           # This documentation
├── change-name.sh      # S3 file renaming utility
├── file-checker.sh     # S3 inventory generator  
├── gzip-logs.sh        # Directory compression tool
├── filelist.csv        # Input file for change-name.sh (create as needed)
└── tar/               # Output directory (created by gzip-logs.sh)
```

## ⚙️ Configuration Requirements

### AWS CLI Setup
```bash
# Install AWS CLI
pip install awscli

# Configure credentials
aws configure --profile your-profile-name
```

### Required Permissions
- S3 read access: `s3:GetObject`, `s3:ListBucket`
- S3 write access: `s3:PutObject`, `s3:DeleteObject` (for change-name.sh)

### Optional Tools
- **pigz**: For parallel compression (`brew install pigz` on macOS)
- **PyPy**: For improved Python performance in file-checker.sh

## 🔧 Customization

### change-name.sh
- Modify `bucket` variable for your S3 bucket
- Update subfolder paths in the loop (line 6)
- Change file extension pattern (currently `.doc`)
- Adjust naming suffix (currently `-M`)

### gzip-logs.sh  
- Modify compression level (1-9) in line 18
- Switch to `pigz` for parallel processing
- Adjust directory depth (`-mindepth 1 -maxdepth 1`)

### file-checker.sh
- Update S3 bucket and path variables
- Modify AWS profile name
- Customize output CSV format in awk commands
- Enable PyPy environment if available

## 📝 Notes

- Always test scripts with `--dryrun` options when available
- Ensure proper AWS permissions before running S3 operations
- Monitor costs when processing large S3 buckets
- Consider using `pigz` for better compression performance on multi-core systems
