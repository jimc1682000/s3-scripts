# Security Policy

## Code Signing and Verification

### GPG Signatures
All commits in this repository are signed using GPG to ensure authenticity and integrity.

**Current Signing Key**: `6DCE833EFCCC91A0`
- **Key Type**: RSA 4096-bit
- **Owner**: Jimmy Chen <jimc1682000@gmail.com>
- **Created**: 2025-08-21

### Verifying Commits
To verify commit signatures:

```bash
# Verify the latest commit
git log --show-signature -1

# Verify a specific commit
git verify-commit <commit-hash>

# Import the public key (if needed)
gpg --recv-keys 6DCE833EFCCC91A0
```

### Key Management
- Primary signing key: `6DCE833EFCCC91A0`
- All repository commits should be signed with this key
- Key rotation will be announced via signed commits and updated in this document

## Reporting Security Issues

If you discover a security vulnerability in these scripts, please report it responsibly:

### For Script-Related Issues
- **AWS Credentials**: Ensure scripts never log or expose AWS credentials
- **File Permissions**: Review output file permissions (currently set to 666 in file-checker.sh)
- **Input Validation**: Check for potential command injection in CSV input files

### Contact
Please report security issues privately to: jimc1682000@gmail.com

Include:
- Description of the vulnerability
- Steps to reproduce
- Potential impact assessment
- Suggested mitigation (if any)

## Security Best Practices

### When Using These Scripts

1. **AWS Credentials**: 
   - Use AWS profiles with minimal required permissions
   - Never hardcode credentials in scripts
   - Regularly rotate access keys

2. **Input Validation**:
   - Validate CSV input files before processing
   - Use `--dryrun` options for testing

3. **File Permissions**:
   - Review output file permissions
   - Store sensitive outputs in secure locations

4. **Network Security**:
   - Use HTTPS for S3 operations
   - Monitor AWS CloudTrail for unexpected activity

### Script-Specific Considerations

- **change-name.sh**: Always test with `--dryrun` before bulk operations
- **file-checker.sh**: Output files contain bucket inventory - secure appropriately
- **gzip-logs.sh**: Ensure compressed archives don't contain sensitive information

## Supported Versions

| Script | Status | Security Support |
|--------|--------|-----------------|
| change-name.sh | ✅ Active | Security updates provided |
| file-checker.sh | ✅ Active | Security updates provided |
| gzip-logs.sh | ✅ Active | Security updates provided |

Security updates will be provided for the current version of all scripts in this repository.