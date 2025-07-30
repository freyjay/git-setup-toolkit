#!/bin/bash

# 🚀 Francis's High-Success Project Setup Script v2.0
# Hybrid approach: Bulletproof core + optional validation
# Usage: ./setup-project-v2.sh [project-name]

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
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Francis's Project Setup Script v2.0${NC}"
echo -e "${PURPLE}Hybrid Approach: Bulletproof Core + Optional Validation${NC}"
echo -e "=============================================================="

# Validate input
if [ -z "$PROJECT_NAME" ]; then
    echo -e "${RED}❌ Error: Project name required${NC}"
    echo "Usage: ./setup-project-v2.sh [project-name]"
    exit 1
fi

echo -e "${BLUE}📋 Setting up project: ${YELLOW}$PROJECT_NAME${NC}"

# Ensure we're in the correct directory
CURRENT_DIR=$(pwd)
if [[ "$CURRENT_DIR" != "$DEVELOPER_DIR"* ]]; then
    echo -e "${BLUE}📁 Changing to Developer directory...${NC}"
    cd "$DEVELOPER_DIR"
fi

# =============================================================================
# PHASE 1: BULLETPROOF CORE SETUP (Never fails)
# =============================================================================
echo -e "\n${GREEN}🎯 PHASE 1: BULLETPROOF CORE SETUP${NC}"
echo -e "========================================"

PROJECT_PATH="$DEVELOPER_DIR/$PROJECT_NAME"

# Create project directory
if [ -d "$PROJECT_PATH" ]; then
    echo -e "${YELLOW}⚠️  Project directory exists: $PROJECT_PATH${NC}"
    echo -e "${BLUE}❓ Continue with git setup in existing directory? (y/n)${NC}"
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}⏹️  Setup cancelled${NC}"
        exit 0
    fi
else
    echo -e "${BLUE}📁 Creating: $PROJECT_PATH${NC}"
    mkdir -p "$PROJECT_PATH"
fi

cd "$PROJECT_PATH"
echo -e "${GREEN}✅ Working in: $(pwd)${NC}"

# Initialize git (bulletproof)
if [ ! -d ".git" ]; then
    echo -e "${BLUE}🔧 Initializing git repository...${NC}"
    git init
    echo -e "${GREEN}✅ Git initialized${NC}"
else
    echo -e "${GREEN}✅ Git already initialized${NC}"
fi

# Configure git (bulletproof)
echo -e "${BLUE}⚙️  Configuring git credentials...${NC}"
git config user.name "$FRANCIS_ACCOUNT"
git config user.email "$FRANCIS_EMAIL"
echo -e "${GREEN}✅ Git configured for: $FRANCIS_ACCOUNT <$FRANCIS_EMAIL>${NC}"

# Set up remote (bulletproof)
REMOTE_URL="git@$SSH_HOST:$FRANCIS_ACCOUNT/$PROJECT_NAME.git"
if git remote get-url origin &>/dev/null; then
    CURRENT_REMOTE=$(git remote get-url origin)
    if [ "$CURRENT_REMOTE" != "$REMOTE_URL" ]; then
        echo -e "${BLUE}🔗 Updating remote URL...${NC}"
        git remote set-url origin "$REMOTE_URL"
    else
        echo -e "${GREEN}✅ Remote already configured${NC}"
    fi
else
    echo -e "${BLUE}🔗 Adding remote origin...${NC}"
    git remote add origin "$REMOTE_URL"
fi
echo -e "${GREEN}✅ Remote: $REMOTE_URL${NC}"

# =============================================================================
# PHASE 2: HELPFUL VALIDATION (Optional - won't block on failure)
# =============================================================================
echo -e "\n${PURPLE}🔍 PHASE 2: HELPFUL VALIDATION${NC}"
echo -e "================================="
echo -e "${PURPLE}Note: These checks provide helpful info but won't block setup${NC}"

# Check SSH keys (informational)
echo -e "\n${BLUE}🔑 SSH Key Status:${NC}"
if ssh-add -l &>/dev/null; then
    echo -e "${GREEN}✅ SSH keys are loaded${NC}"
    
    # Test GitHub connectivity with timeout (non-blocking)
    echo -e "${BLUE}🌐 Testing GitHub connectivity...${NC}"
    if SSH_TEST=$(ssh -o ConnectTimeout=3 -T git@$SSH_HOST 2>&1) && [[ "$SSH_TEST" == *"successfully authenticated"* ]]; then
        echo -e "${GREEN}✅ GitHub SSH connection verified${NC}"
        GITHUB_READY=true
    else
        echo -e "${YELLOW}⚠️  GitHub connection test failed or timed out${NC}"
        echo -e "${BLUE}💡 This won't prevent local git operations${NC}"
        GITHUB_READY=false
    fi
else
    echo -e "${YELLOW}⚠️  No SSH keys loaded${NC}"
    echo -e "${BLUE}💡 Run: ssh-add ~/.ssh/id_rsa_personal${NC}"
    GITHUB_READY=false
fi

# Update allowed repositories (informational)
echo -e "\n${BLUE}📝 Allowed Repositories:${NC}"
if [ -f "$GIT_ACCOUNTS_FILE" ]; then
    if grep -q "$PROJECT_NAME" "$GIT_ACCOUNTS_FILE"; then
        echo -e "${GREEN}✅ Project already in allowed repositories${NC}"
    else
        echo -e "${BLUE}➕ Adding to allowed repositories...${NC}"
        if sed -i.backup "s/\\(freyjay|.*|.*|.*|.*\\)/\\1,$PROJECT_NAME/" "$GIT_ACCOUNTS_FILE" 2>/dev/null; then
            echo -e "${GREEN}✅ Added to allowed repositories${NC}"
        else
            echo -e "${YELLOW}⚠️  Could not auto-update (manual edit needed)${NC}"
        fi
    fi
else
    echo -e "${YELLOW}⚠️  Git accounts file not found${NC}"
    echo -e "${BLUE}💡 Location: $GIT_ACCOUNTS_FILE${NC}"
fi

# Test basic git operations (informational)
echo -e "\n${BLUE}🧪 Git Operations Test:${NC}"
if git status &>/dev/null; then
    echo -e "${GREEN}✅ Git status working${NC}"
else
    echo -e "${YELLOW}⚠️  Git status failed${NC}"
fi

# =============================================================================
# SUCCESS SUMMARY
# =============================================================================
echo -e "\n${GREEN}🎉 CORE SETUP COMPLETE!${NC}"
echo -e "=========================="
echo -e "${GREEN}✅ Project: $PROJECT_NAME${NC}"
echo -e "${GREEN}✅ Location: $PROJECT_PATH${NC}"
echo -e "${GREEN}✅ Git: Initialized and configured${NC}"
echo -e "${GREEN}✅ Remote: $REMOTE_URL${NC}"

echo -e "\n${BLUE}📋 NEXT STEPS:${NC}"
echo -e "1. ${BLUE}Create initial files:${NC}"
echo -e "   • README.md, CLAUDE.md, .gitignore, LICENSE"
echo -e "2. ${BLUE}Make initial commit:${NC}"
echo -e "   • git add . && git commit -m 'Initial commit'"
echo -e "3. ${BLUE}Create GitHub repository:${NC}"
if [ "$GITHUB_READY" = true ]; then
    echo -e "   • Go to: ${YELLOW}https://github.com/$FRANCIS_ACCOUNT${NC}"
    echo -e "   • Create repo: ${YELLOW}$PROJECT_NAME${NC}"
    echo -e "   • Push: ${YELLOW}git push -u origin master${NC}"
else
    echo -e "   • First fix SSH setup, then:"
    echo -e "   • Go to: ${YELLOW}https://github.com/$FRANCIS_ACCOUNT${NC}"
    echo -e "   • Create repo: ${YELLOW}$PROJECT_NAME${NC}"
    echo -e "   • Push: ${YELLOW}git push -u origin master${NC}"
fi

echo -e "\n${PURPLE}💡 TROUBLESHOOTING:${NC}"
echo -e "• SSH issues: ${YELLOW}ssh-add ~/.ssh/id_rsa_personal${NC}"
echo -e "• Test connection: ${YELLOW}ssh -T git@$SSH_HOST${NC}"
echo -e "• Check account: ${YELLOW}git config user.name${NC}"

echo -e "\n${BLUE}🎭 Ready for \"The Saga of Francis & Claude\"!${NC}"

# Return to original directory
cd "$CURRENT_DIR"