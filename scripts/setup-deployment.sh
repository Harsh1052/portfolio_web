#!/bin/bash

# Deployment Setup Script
# Helps you set up deployment for your preferred platform

set -e

# Colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Flutter Web Portfolio - Deployment Setup        ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════╝${NC}"
echo ""

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install Firebase CLI
setup_firebase() {
    echo -e "${BLUE}Setting up Firebase Hosting...${NC}"

    if ! command_exists firebase; then
        echo -e "${YELLOW}Installing Firebase CLI...${NC}"
        npm install -g firebase-tools
    else
        echo -e "${GREEN}✓ Firebase CLI already installed${NC}"
    fi

    echo ""
    echo -e "${YELLOW}Next steps:${NC}"
    echo "1. Run: firebase login"
    echo "2. Run: firebase init hosting"
    echo "3. Select 'build/web' as public directory"
    echo "4. Select 'Yes' for single-page app"
    echo "5. Update .firebaserc with your project ID"
    echo "6. Run: make deploy-firebase"
    echo ""
}

# Function to install Netlify CLI
setup_netlify() {
    echo -e "${BLUE}Setting up Netlify...${NC}"

    if ! command_exists netlify; then
        echo -e "${YELLOW}Installing Netlify CLI...${NC}"
        npm install -g netlify-cli
    else
        echo -e "${GREEN}✓ Netlify CLI already installed${NC}"
    fi

    echo ""
    echo -e "${YELLOW}Next steps:${NC}"
    echo "1. Run: netlify login"
    echo "2. Run: netlify init"
    echo "3. Run: make deploy-netlify"
    echo ""
    echo -e "${YELLOW}Or use drag-and-drop:${NC}"
    echo "1. Run: make build"
    echo "2. Go to: https://app.netlify.com/drop"
    echo "3. Drag build/web folder"
    echo ""
}

# Function to install Vercel CLI
setup_vercel() {
    echo -e "${BLUE}Setting up Vercel...${NC}"

    if ! command_exists vercel; then
        echo -e "${YELLOW}Installing Vercel CLI...${NC}"
        npm install -g vercel
    else
        echo -e "${GREEN}✓ Vercel CLI already installed${NC}"
    fi

    echo ""
    echo -e "${YELLOW}Next steps:${NC}"
    echo "1. Run: vercel login"
    echo "2. Run: make deploy-vercel"
    echo ""
}

# Function to setup GitHub Pages
setup_github() {
    echo -e "${BLUE}Setting up GitHub Pages...${NC}"
    echo ""
    echo -e "${YELLOW}Steps to enable GitHub Pages:${NC}"
    echo "1. Go to your repository on GitHub"
    echo "2. Navigate to Settings > Pages"
    echo "3. Under 'Source', select 'GitHub Actions'"
    echo "4. Push your code to main/master branch"
    echo "5. GitHub Actions will automatically build and deploy"
    echo ""
    echo -e "${GREEN}Your site will be live at:${NC}"
    echo "https://yourusername.github.io/repository-name/"
    echo ""
}

# Main menu
echo "Select your deployment platform:"
echo ""
echo "1) Firebase Hosting"
echo "2) Netlify"
echo "3) Vercel"
echo "4) GitHub Pages"
echo "5) All platforms"
echo "6) Exit"
echo ""

read -p "Enter your choice (1-6): " choice

case $choice in
    1)
        setup_firebase
        ;;
    2)
        setup_netlify
        ;;
    3)
        setup_vercel
        ;;
    4)
        setup_github
        ;;
    5)
        setup_firebase
        setup_netlify
        setup_vercel
        setup_github
        ;;
    6)
        echo -e "${GREEN}Goodbye!${NC}"
        exit 0
        ;;
    *)
        echo -e "${RED}Invalid choice${NC}"
        exit 1
        ;;
esac

echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
echo -e "${GREEN}Setup complete!${NC}"
echo ""
echo -e "${YELLOW}Useful commands:${NC}"
echo "  make help              - Show all available commands"
echo "  make build             - Build for production"
echo "  make deploy-firebase   - Deploy to Firebase"
echo "  make deploy-netlify    - Deploy to Netlify"
echo "  make deploy-vercel     - Deploy to Vercel"
echo ""
echo -e "${YELLOW}For detailed documentation, see:${NC}"
echo "  DEPLOYMENT.md"
echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
