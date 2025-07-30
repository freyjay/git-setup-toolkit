#!/bin/bash

# 🚀 Francis's Project Setup Script
# High-success project initialization for multi-git environment
# Usage: ./setup-project.sh [project-name]

set -e  # Exit on any error

PROJECT_NAME="$1"
DEVELOPER_DIR="/Users/francisrey/Developer"
GIT_ACCOUNTS_FILE="$DEVELOPER_DIR/.git-accounts"
FRANCIS_ACCOUNT="freyjay"
FRANCIS_EMAIL="francisrey@example.com"
SSH_HOST="github-personal"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Francis's Project Setup Script${NC}"
echo -e "=================================================="

# Validate input
if [ -z "$PROJECT_NAME" ]; then
    echo -e "${RED}❌ Error: Project name required${NC}"
    echo "Usage: ./setup-project.sh [project-name]"
    exit 1
fi

echo -e "${BLUE}📋 Setting up project: ${YELLOW}$PROJECT_NAME${NC}"

# Phase 1: Environment Validation
echo -e "\n${BLUE}Phase 1: Environment Validation${NC}"
echo "-----------------------------------"

# Check if we're in the correct directory
CURRENT_DIR=$(pwd)
if [[ "$CURRENT_DIR" != "$DEVELOPER_DIR"* ]]; then
    echo -e "${YELLOW}⚠️  Warning: Not in Developer directory${NC}"
    echo "Current: $CURRENT_DIR"
    echo "Expected: $DEVELOPER_DIR"
    echo -e "${BLUE}💡 Changing to Developer directory...${NC}"
    cd "$DEVELOPER_DIR"
fi

# Check SSH agent and keys
echo -e "${BLUE}🔑 Checking SSH setup...${NC}"
if ! ssh-add -l &>/dev/null; then
    echo -e "${YELLOW}⚠️  SSH agent not running or no keys loaded${NC}"
    echo -e "${BLUE}🔧 Attempting to load SSH keys...${NC}"
    ssh-add ~/.ssh/id_rsa_personal 2>/dev/null || {
        echo -e "${RED}❌ Failed to load SSH key${NC}"
        echo -e "${BLUE}💡 Please run: ssh-add ~/.ssh/id_rsa_personal${NC}"
        exit 1
    }
fi

# Test GitHub connectivity
echo -e "${BLUE}🌐 Testing GitHub connectivity...${NC}"
SSH_TEST=$(ssh -o ConnectTimeout=5 -T git@$SSH_HOST 2>&1)
if [[ "$SSH_TEST" == *"successfully authenticated"* ]]; then
    echo -e "${GREEN}✅ GitHub SSH connection successful${NC}"
else
    echo -e "${RED}❌ GitHub SSH connection failed${NC}"
    echo -e "${BLUE}💡 Please check your SSH key setup${NC}"
    echo -e "${BLUE}Debug: $SSH_TEST${NC}"
    exit 1
fi

# Phase 2: Project Directory Setup
echo -e "\n${BLUE}Phase 2: Project Directory Setup${NC}"
echo "--------------------------------------"

PROJECT_PATH="$DEVELOPER_DIR/$PROJECT_NAME"

if [ -d "$PROJECT_PATH" ]; then
    echo -e "${YELLOW}⚠️  Project directory already exists: $PROJECT_PATH${NC}"
    echo -e "${BLUE}❓ Do you want to initialize git in existing directory? (y/n)${NC}"
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}⏹️  Setup cancelled${NC}"
        exit 0
    fi
else
    echo -e "${BLUE}📁 Creating project directory: $PROJECT_PATH${NC}"
    mkdir -p "$PROJECT_PATH"
fi

cd "$PROJECT_PATH"
echo -e "${GREEN}✅ Working in: $(pwd)${NC}"

# Phase 3: Git Account Configuration
echo -e "\n${BLUE}Phase 3: Git Account Configuration${NC}"
echo "---------------------------------------"

# Add project to allowed repositories if not already present
if [ -f "$GIT_ACCOUNTS_FILE" ]; then
    echo -e "${BLUE}📝 Checking allowed repositories...${NC}"
    if ! grep -q "$PROJECT_NAME" "$GIT_ACCOUNTS_FILE"; then
        echo -e "${BLUE}➕ Adding $PROJECT_NAME to allowed repositories...${NC}"
        # Add project to the freyjay account line
        sed -i.backup "s/\\(freyjay|.*|.*|.*|.*\\)/\\1,$PROJECT_NAME/" "$GIT_ACCOUNTS_FILE"
        echo -e "${GREEN}✅ Project added to allowed repositories${NC}"
    else
        echo -e "${GREEN}✅ Project already in allowed repositories${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  Git accounts file not found: $GIT_ACCOUNTS_FILE${NC}"
    echo -e "${BLUE}💡 Creating basic git accounts configuration...${NC}"
    cat > "$GIT_ACCOUNTS_FILE" << EOF
# Git Account Configuration
# Format: account_name|username|email|ssh_key_path|default_repos
freyjay|francisrey|francisrey@example.com|~/.ssh/id_rsa_personal|$PROJECT_NAME
EOF
fi

# Initialize git if not already initialized
if [ ! -d ".git" ]; then
    echo -e "${BLUE}🔧 Initializing git repository...${NC}"
    git init
else
    echo -e "${GREEN}✅ Git repository already initialized${NC}"
fi

# Configure git for this project
echo -e "${BLUE}⚙️  Configuring git settings...${NC}"
git config user.name "$FRANCIS_ACCOUNT"
git config user.email "$FRANCIS_EMAIL"

echo -e "${GREEN}✅ Git configured:${NC}"
echo -e "   Name: $(git config user.name)"
echo -e "   Email: $(git config user.email)"

# Phase 4: Remote Setup
echo -e "\n${BLUE}Phase 4: Remote Setup${NC}"
echo "---------------------------"

REMOTE_URL="git@$SSH_HOST:$FRANCIS_ACCOUNT/$PROJECT_NAME.git"

# Check if remote already exists
if git remote get-url origin &>/dev/null; then
    CURRENT_REMOTE=$(git remote get-url origin)
    echo -e "${BLUE}🔗 Current remote: $CURRENT_REMOTE${NC}"
    
    if [ "$CURRENT_REMOTE" != "$REMOTE_URL" ]; then
        echo -e "${YELLOW}⚠️  Remote URL mismatch${NC}"
        echo -e "${BLUE}🔧 Updating remote URL...${NC}"
        git remote set-url origin "$REMOTE_URL"
    fi
else
    echo -e "${BLUE}🔗 Adding remote origin...${NC}"
    git remote add origin "$REMOTE_URL"
fi

echo -e "${GREEN}✅ Remote configured: $REMOTE_URL${NC}"

# Phase 5: Final Validation
echo -e "\n${BLUE}Phase 5: Final Validation${NC}"
echo "-------------------------------"

# Test git status
echo -e "${BLUE}📊 Testing git status...${NC}"
git status &>/dev/null && echo -e "${GREEN}✅ Git status working${NC}" || {
    echo -e "${RED}❌ Git status failed${NC}"
    exit 1
}

# Verify remote connectivity (without pushing)
echo -e "${BLUE}🔍 Verifying remote connectivity...${NC}"
git ls-remote origin &>/dev/null && {
    echo -e "${GREEN}✅ Remote repository accessible${NC}"
} || {
    echo -e "${YELLOW}⚠️  Remote repository not found (this is normal for new repos)${NC}"
    echo -e "${BLUE}💡 Remember to create the repository on GitHub:${NC}"
    echo -e "   https://github.com/$FRANCIS_ACCOUNT"
}

# Success Summary
echo -e "\n${GREEN}🎉 PROJECT SETUP COMPLETE!${NC}"
echo -e "================================"
echo -e "${GREEN}✅ Project: $PROJECT_NAME${NC}"
echo -e "${GREEN}✅ Location: $PROJECT_PATH${NC}"
echo -e "${GREEN}✅ Git Account: $FRANCIS_ACCOUNT${NC}"
echo -e "${GREEN}✅ Remote: $REMOTE_URL${NC}"
echo -e "${GREEN}✅ SSH: Validated${NC}"
echo -e "${GREEN}✅ Allowed Repos: Updated${NC}"

echo -e "\n${BLUE}📋 Next Steps:${NC}"
echo -e "1. Create initial files (README.md, etc.)"
echo -e "2. Make initial commit"
echo -e "3. Create repository on GitHub: ${YELLOW}https://github.com/$FRANCIS_ACCOUNT${NC}"
echo -e "4. Push with: ${YELLOW}git push -u origin master${NC}"

echo -e "\n${BLUE}🎭 Ready for: \"The Saga of Francis & Claude\"!${NC}"