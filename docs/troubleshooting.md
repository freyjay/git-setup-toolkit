# Troubleshooting Guide

Common issues and solutions for Francis's development setup utilities.

## 🚨 **Common Issues**

### **1. SSH Connection Failures**

#### **Symptoms**
```
⚠️  No SSH keys loaded
💡 Run: ssh-add ~/.ssh/id_rsa_personal
⚠️  GitHub connection test failed or timed out
```

#### **Solutions**
```bash
# Load SSH keys
ssh-add ~/.ssh/id_rsa_personal

# Verify key is loaded
ssh-add -l

# Test GitHub connection
ssh -T git@github-personal
# Should see: "Hi freyjay! You've successfully authenticated..."
```

#### **Why This Happens**
- SSH agent not running
- Keys not loaded in current session
- Network connectivity issues
- GitHub server issues

#### **Prevention**
Add to your shell profile (`.zshrc` or `.bash_profile`):
```bash
# Auto-load SSH keys on shell start
ssh-add -q ~/.ssh/id_rsa_personal 2>/dev/null
```

---

### **2. Permission Denied When Pushing**

#### **Symptoms**
```
git push -u origin master
Permission denied (publickey).
fatal: Could not read from remote repository.
```

#### **Root Causes & Solutions**

**A. SSH Keys Not Loaded**
```bash
# Check loaded keys
ssh-add -l

# If no keys shown, load them
ssh-add ~/.ssh/id_rsa_personal
```

**B. Wrong Remote URL Format**
```bash
# Check current remote
git remote -v

# Should be SSH format, not HTTPS
# ✅ Correct: git@github-personal:freyjay/project.git
# ❌ Wrong:   https://github.com/freyjay/project.git

# Fix if needed
git remote set-url origin git@github-personal:freyjay/project.git
```

**C. Repository Not Created on GitHub**
```bash
# Go to https://github.com/freyjay
# Click "New repository"
# Use exact same name as local project
# Don't initialize with README (you have local files)
```

---

### **3. Script Hangs or Times Out**

#### **Symptoms**
Script stops responding during SSH connectivity test.

#### **Immediate Solution**
```bash
# Kill the hanging script
Ctrl+C

# Use manual setup as fallback
mkdir my-project && cd my-project
git init
git config user.name "freyjay"
git config user.email "francisrey@example.com"
git remote add origin git@github-personal:freyjay/my-project.git
```

#### **Why This Happens**
- Network connectivity issues
- SSH configuration problems
- GitHub server not responding

#### **Long-term Fix**
The v2.0 script handles this with timeouts, but if issues persist:
```bash
# Check SSH configuration
cat ~/.ssh/config

# Verify hosts file
ping github.com

# Test basic connectivity
curl -I https://github.com
```

---

### **4. Git Account Configuration Issues**

#### **Symptoms**
```bash
git config user.name
# Returns wrong name or empty

git config user.email  
# Returns wrong email or empty
```

#### **Solution**
```bash
# Re-run the setup script - it fixes configuration
./francis-dev-setup/setup-project-v2.sh existing-project

# Or fix manually
git config user.name "freyjay"
git config user.email "francisrey@example.com"
```

#### **Verification**
```bash
# Check configuration
git config user.name    # Should be: freyjay
git config user.email   # Should be: francisrey@example.com
git remote -v           # Should be: git@github-personal:freyjay/project.git
```

---

### **5. Allowed Repositories Permission Errors**

#### **Symptoms**  
```
🔍 Pre-commit validation...
❌ COMMIT BLOCKED: Repository 'project-name' is not configured for account 'freyjay'
```

#### **Solution**
The script usually handles this automatically, but if it fails:

```bash
# Check current allowed repositories
grep freyjay /Users/francisrey/Developer/.git-accounts

# Manual fix - edit the file
nano /Users/francisrey/Developer/.git-accounts

# Add your project name to the freyjay line:
# freyjay|francisrey|francisrey@example.com|~/.ssh/id_rsa_personal|...,your-project-name
```

#### **Prevention**
Always use the setup script - it automatically manages allowed repositories.

---

## 🔧 **Diagnostic Commands**

### **System Health Check**
```bash
# Check SSH setup
ssh-add -l
ssh -T git@github-personal

# Check git configuration  
git config user.name
git config user.email
git config --list | grep user

# Check project setup
git status
git remote -v

# Check allowed repositories  
grep freyjay /Users/francisrey/Developer/.git-accounts
```

### **Network Connectivity Test**
```bash
# Basic connectivity
ping github.com

# HTTPS access
curl -I https://github.com/freyjay

# SSH access
ssh -T git@github-personal

# DNS resolution
nslookup github.com
```

### **File System Check**
```bash
# Verify directory structure
ls -la /Users/francisrey/Developer/

# Check git accounts file
cat /Users/francisrey/Developer/.git-accounts

# Verify SSH keys exist
ls -la ~/.ssh/
```

---

## 🎯 **Script-Specific Issues**

### **"Command not found" Errors**

#### **Issue**: `./setup-project-v2.sh: command not found`
```bash
# Make script executable
chmod +x /Users/francisrey/Developer/francis-dev-setup/setup-project-v2.sh

# Or run with bash explicitly
bash /Users/francisrey/Developer/francis-dev-setup/setup-project-v2.sh project-name
```

#### **Issue**: `git: command not found`
```bash
# Install Xcode Command Line Tools
xcode-select --install

# Or install git via Homebrew
brew install git
```

### **Color Output Issues**
If you see escape codes instead of colors:
```bash
# Run script with TERM variable
TERM=xterm-256color ./setup-project-v2.sh project-name

# Or disable colors by editing script (replace color variables with empty strings)
```

---

## 🚨 **Emergency Recovery**

### **Complete System Reset**
If everything is broken:

```bash
# 1. Verify SSH keys exist
ls -la ~/.ssh/id_rsa_personal*

# 2. Re-add SSH keys
ssh-add ~/.ssh/id_rsa_personal

# 3. Test basic GitHub access
ssh -T git@github-personal

# 4. Fix git global config if needed
git config --global user.name "freyjay"  
git config --global user.email "francisrey@example.com"

# 5. Manual project setup
mkdir emergency-project && cd emergency-project
git init  
git config user.name "freyjay"
git config user.email "francisrey@example.com"
git remote add origin git@github-personal:freyjay/emergency-project.git
```

### **Backup Your Setup**
```bash
# Backup important configuration
cp ~/.ssh/config ~/.ssh/config.backup
cp /Users/francisrey/Developer/.git-accounts /Users/francisrey/Developer/.git-accounts.backup

# Document working setup
ssh-add -l > ~/ssh-keys-backup.txt
git config --list > ~/git-config-backup.txt
```

---

## 💡 **Prevention Best Practices**

### **Daily Workflow**
```bash
# Start of day - verify setup
ssh-add -l                    # Check SSH keys
ssh -T git@github-personal    # Test connectivity

# Use setup script for new projects instead of manual git commands
./francis-dev-setup/setup-project-v2.sh new-project
```

### **Before Important Work**
```bash
# Pre-flight check
git config user.name          # Verify identity
git remote -v                 # Check remote URLs
git status                    # Ensure clean state

# Test push capability
git push --dry-run origin master
```

### **Regular Maintenance**
```bash
# Weekly - verify SSH keys are still working
ssh -T git@github-personal

# Monthly - backup configuration
cp /Users/francisrey/Developer/.git-accounts ~/Backups/
```

---

## 📞 **Getting Help**

### **Self-Diagnosis Steps**
1. **Run diagnostic commands** (see section above)
2. **Check recent changes** - what did you do differently?
3. **Try manual setup** - bypass the script entirely
4. **Test with a simple project** - isolate the issue

### **When to Use Manual Setup**
If the script consistently fails, fall back to manual commands:
```bash
mkdir test-project && cd test-project
git init
git config user.name "freyjay"  
git config user.email "francisrey@example.com"
git remote add origin git@github-personal:freyjay/test-project.git
```

### **Information to Gather**
- Exact error messages
- Output of diagnostic commands
- What you were trying to do
- What changed recently in your setup

---

## 🎭 **Real-World Success Stories**

### **The Claude Code Command Fix Case**
**Problem**: SSH connection kept timing out during script execution  
**Solution**: Implemented hybrid approach - core setup completed, SSH validation failed gracefully  
**Outcome**: Could continue development immediately, fixed SSH later  

### **The Multi-Project Setup Marathon**  
**Problem**: Needed to create 5 projects quickly, automation app wasn't available  
**Solution**: Used setup script repeatedly, each took ~10 seconds  
**Outcome**: All projects created reliably, consistent configuration  

### **The Broken Remote Recovery**
**Problem**: Accidentally set HTTPS remotes instead of SSH  
**Solution**: Re-ran setup script on existing projects  
**Outcome**: All remotes corrected to proper SSH format automatically  

---

**🎯 Remember: The hybrid approach means you can always make progress, even when things go wrong!**