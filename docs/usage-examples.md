# Usage Examples

Real-world scenarios for using Francis's development setup utilities.

## 🚀 **Scenario 1: Quick New Project**

### **Situation**
You need to create a new project quickly, and the automation app isn't available or convenient.

### **Solution**
```bash
cd /Users/francisrey/Developer
./francis-dev-setup/setup-project-v2.sh my-quick-project
```

### **Expected Output**
```
🚀 Francis's Project Setup Script v2.0
Hybrid Approach: Bulletproof Core + Optional Validation
==============================================================

🎯 PHASE 1: BULLETPROOF CORE SETUP
========================================
✅ Working in: /Users/francisrey/Developer/my-quick-project
✅ Git initialized
✅ Git configured for: freyjay <francisrey@example.com>
✅ Remote: git@github-personal:freyjay/my-quick-project.git

🔍 PHASE 2: HELPFUL VALIDATION
=================================
✅ SSH keys are loaded
✅ GitHub SSH connection verified
✅ Added to allowed repositories
✅ Git status working

🎉 CORE SETUP COMPLETE!
```

### **Next Steps**
1. Create initial files: `echo "# My Quick Project" > README.md`
2. Commit: `git add . && git commit -m "Initial commit"`
3. Create GitHub repo and push

---

## 🛠️ **Scenario 2: Fixing Broken Project Setup**

### **Situation**
You have a project with messed up git configuration or wrong remotes.

### **Solution**
```bash
# Re-run setup on existing directory - it will fix configuration
./francis-dev-setup/setup-project-v2.sh existing-broken-project
```

### **What It Fixes**
- ✅ Corrects git user.name and user.email
- ✅ Updates remote URL to proper SSH format
- ✅ Adds project to allowed repositories if missing
- ✅ Validates current setup status

---

## 🔧 **Scenario 3: SSH Issues - Graceful Degradation**

### **Situation**
Your SSH keys aren't loaded or GitHub is unreachable.

### **What Happens**
```
🎯 PHASE 1: BULLETPROOF CORE SETUP
========================================
✅ Git initialized
✅ Git configured for: freyjay <francisrey@example.com>
✅ Remote: git@github-personal:freyjay/my-project.git

🔍 PHASE 2: HELPFUL VALIDATION
=================================
⚠️  No SSH keys loaded
💡 Run: ssh-add ~/.ssh/id_rsa_personal
⚠️  GitHub connection test failed or timed out
💡 This won't prevent local git operations

🎉 CORE SETUP COMPLETE!
```

### **Key Benefit**
Project is still created and ready to use! SSH issues don't block setup.

### **How to Fix SSH Later**
```bash
# Load SSH keys
ssh-add ~/.ssh/id_rsa_personal

# Test connection
ssh -T git@github-personal

# Now you can push
git push -u origin master
```

---

## 📱 **Scenario 4: Integration with Existing Workflow**

### **Primary Workflow (Recommended)**
```bash
# Use the full automation system
open "/Applications/Project Setup.app"
# Creates project with templates, AI integration, etc.
```

### **Fallback Workflow (When Automation Isn't Available)**
```bash
# Use this script for basic but reliable setup
./francis-dev-setup/setup-project-v2.sh fallback-project

# Then manually add what you need:
# - Copy CLAUDE.md template
# - Add .gitignore for your tech stack
# - Create proper README.md
```

### **Recovery Workflow (Fix Broken Projects)**
```bash
# Re-run setup to fix configuration issues
./francis-dev-setup/setup-project-v2.sh existing-project
```

---

## 🎭 **Scenario 5: Learning from Real Development**

### **The Claude Code Command Fix Story**
During development of `claude-code-command-fix`, we needed reliable project setup:

```bash
# This is what we actually ran:
./setup-project-v2.sh claude-code-command-fix

# Output showed SSH timeout, but core setup succeeded:
# ✅ Git initialized and configured  
# ✅ Remote URL set properly
# ⚠️  GitHub connection test failed or timed out
# 💡 This won't prevent local git operations

# We could immediately start working:
cd claude-code-command-fix
echo "# Claude Code Command Fix" > README.md
git add . && git commit -m "Initial commit"

# Fixed SSH later and pushed successfully
```

### **Key Insight**
The hybrid approach let us keep working even with connectivity issues, demonstrating the value of bulletproof core operations.

---

## 💡 **Pro Tips**

### **Speed Up Repeated Use**
```bash
# Create an alias for frequent use
echo 'alias new-project="./francis-dev-setup/setup-project-v2.sh"' >> ~/.zshrc
source ~/.zshrc

# Now you can just run:
new-project awesome-idea
```

### **Batch Project Creation**
```bash
# Create multiple related projects
for project in frontend backend mobile; do
  ./francis-dev-setup/setup-project-v2.sh "myapp-$project"
done
```

### **Pre-flight Check**
```bash
# Verify your setup before starting
ssh-add -l                    # Check loaded keys
ssh -T git@github-personal    # Test GitHub connection
git config --global user.name # Verify git config
```

---

## 🚨 **Troubleshooting Real Scenarios**

### **"Permission Denied" When Pushing**
```bash
# Usually means SSH keys not loaded
ssh-add ~/.ssh/id_rsa_personal

# Or wrong remote URL format
git remote -v  # Check current remotes
git remote set-url origin git@github-personal:freyjay/project-name.git
```

### **"Repository not found" Error**
```bash
# You forgot to create the GitHub repository
# Go to: https://github.com/freyjay
# Create repo with same name as local project
# Then push normally
```

### **Script Hangs or Fails**
```bash
# Kill the script with Ctrl+C
# Check what's available:
which git     # Ensure git is installed
ssh-add -l    # Check SSH key status
pwd          # Ensure you're in the right directory

# Try running just the core operations manually:
mkdir my-project && cd my-project
git init
git config user.name "freyjay"
git config user.email "francisrey@example.com"
```

---

## 📈 **Success Patterns**

### **When Everything Works (80% of cases)**
- SSH keys are loaded
- Network connectivity is good  
- GitHub is accessible
- Result: Full automation with validation

### **When SSH Issues Occur (15% of cases)**
- Core setup completes successfully
- Validation warnings appear
- Clear guidance provided for fixes
- Result: Working project that can be pushed later

### **When Network Issues Occur (5% of cases)**
- Core setup still completes
- Local git operations work fine
- GitHub operations delayed until connectivity returns
- Result: Local development can continue immediately

---

**🎯 The hybrid approach ensures you can always make progress, regardless of external factors!**