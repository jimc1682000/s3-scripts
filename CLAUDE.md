# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a collection of three Bash utility scripts for AWS S3 file management operations. The scripts are standalone tools without complex build systems or dependencies beyond AWS CLI and standard Unix utilities.

## Script Architecture

### change-name.sh
- **Function**: Batch rename S3 files with suffix addition
- **Input dependency**: `filelist.csv` (user-created, one file ID per line)
- **Configuration**: Bucket name on line 3, subfolder paths on line 6
- **Safety feature**: `--dryrun` option on line 7 (commented by default)
- **Operation pattern**: Loops through file IDs and renames `{id}.doc` to `{id}-M.doc`

### file-checker.sh
- **Function**: Generate CSV inventory of S3 bucket contents
- **Configuration variables**: S3_BUCKET, BASE_PATH, AWS_PROFILE (lines 3-5)
- **Output**: Daily timestamped CSV files `{YYYY-MM-DD}_result.csv`
- **Processing chain**: AWS CLI listing → awk parsing → CSV formatting
- **Optional PyPy integration**: Lines 9-12 and 26 for performance optimization

### gzip-logs.sh
- **Function**: Compress all first-level directories to tar.gz
- **Directory discovery**: Uses `find` with depth restrictions (line 6)
- **Output location**: Creates `tar/` directory for compressed files
- **Compression options**: Standard gzip (line 18) or parallel pigz (line 20, commented)
- **Safety exclusions**: Ignores hidden folders and `tar/` directory itself

## Common Operations

### Testing Scripts Safely
```bash
# For change-name.sh: Enable dry-run mode
sed -i '' 's/# aws s3 mv.*--dryrun/aws s3 mv $bucket\/$fileid\/$subfolder$fileid.doc $bucket\/$fileid\/$subfolder$fileid-M.doc --dryrun/' change-name.sh
sed -i '' 's/aws s3 mv.*[^-]$/# &/' change-name.sh
```

### Configuration Updates
- **S3 credentials**: Scripts use AWS CLI profiles, configure via `aws configure --profile {name}`
- **Bucket settings**: Update bucket variables in script headers before execution
- **Performance tuning**: For large operations, uncomment pigz in gzip-logs.sh or PyPy in file-checker.sh

## Key File Dependencies

- `filelist.csv`: Input file for change-name.sh (gitignored, user-created)
- `tar/`: Output directory for gzip-logs.sh (gitignored, auto-created)
- `*_result.csv`: Output files from file-checker.sh (gitignored, timestamped)

## AWS Requirements

All scripts require AWS CLI with appropriate S3 permissions:
- **change-name.sh**: s3:GetObject, s3:PutObject, s3:DeleteObject
- **file-checker.sh**: s3:ListBucket, s3:GetObject
- **gzip-logs.sh**: No AWS permissions (local operation only)

## Script Modification Patterns

When modifying scripts:
1. **Bucket/path changes**: Update variables at script headers
2. **File patterns**: Modify extension matching in awk commands or file loops
3. **Performance optimization**: Toggle between standard and parallel processing options
4. **Safety features**: Always test with dry-run modes before live execution

## Documentation

- `README.md`: English documentation with complete usage instructions
- `README_zh-TW.md`: Traditional Chinese documentation (translation)
- Both READMs contain detailed setup, configuration, and customization guidance