#!/bin/bash

# Firebase Project Setup Script
# Creates and initializes Firebase project for portfolio

set -e

# Colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Firebase Project Setup for Portfolio Web        ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════╝${NC}"
echo ""

# Check if Firebase CLI is installed
if ! command -v firebase &> /dev/null; then
    echo -e "${RED}Firebase CLI is not installed!${NC}"
    echo -e "${YELLOW}Install it with: npm install -g firebase-tools${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Firebase CLI is installed${NC}"
echo ""

# Option to create new project
echo -e "${YELLOW}Do you want to create a new Firebase project?${NC}"
echo "1) Yes, create new project"
echo "2) No, I already created one"
echo ""
read -p "Enter choice (1 or 2): " create_choice

if [ "$create_choice" == "1" ]; then
    echo ""
    echo -e "${BLUE}Creating new Firebase project...${NC}"
    read -p "Enter project ID (e.g., portfolio-web-harsh): " project_id

    echo -e "${YELLOW}Creating project: $project_id${NC}"
    firebase projects:create "$project_id" || {
        echo -e "${RED}Failed to create project. It might already exist.${NC}"
        read -p "Enter your Firebase Project ID: " project_id
    }
else
    echo ""
    read -p "Enter your Firebase Project ID: " project_id
fi

echo ""
echo -e "${BLUE}Setting up Firebase Hosting...${NC}"

# Update .firebaserc with project ID
echo -e "${YELLOW}Updating .firebaserc...${NC}"
cat > .firebaserc << EOF
{
  "projects": {
    "default": "$project_id"
  }
}
EOF

echo -e "${GREEN}✓ Updated .firebaserc${NC}"

# firebase.json is already created, just verify it
if [ ! -f "firebase.json" ]; then
    echo -e "${RED}firebase.json not found! Creating...${NC}"
    cat > firebase.json << 'EOF'
{
  "hosting": {
    "public": "build/web",
    "ignore": [
      "firebase.json",
      "**/.*",
      "**/node_modules/**"
    ],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ],
    "headers": [
      {
        "source": "**/*.@(jpg|jpeg|gif|png|svg|webp|ico)",
        "headers": [
          {
            "key": "Cache-Control",
            "value": "max-age=31536000"
          }
        ]
      },
      {
        "source": "**/*.@(js|css|woff|woff2|ttf|otf)",
        "headers": [
          {
            "key": "Cache-Control",
            "value": "max-age=31536000"
          }
        ]
      }
    ],
    "cleanUrls": true,
    "trailingSlash": false
  }
}
EOF
fi

echo -e "${GREEN}✓ firebase.json verified${NC}"

# Update GitHub Actions workflow
echo -e "${YELLOW}Updating GitHub Actions workflow...${NC}"
if [ -f ".github/workflows/firebase-deploy.yml" ]; then
    sed -i.bak "s/projectId: .*/projectId: $project_id/" .github/workflows/firebase-deploy.yml
    rm -f .github/workflows/firebase-deploy.yml.bak
    echo -e "${GREEN}✓ Updated GitHub Actions workflow${NC}"
fi

# Test Firebase setup
echo ""
echo -e "${BLUE}Testing Firebase setup...${NC}"
firebase use --add "$project_id" 2>/dev/null || firebase use "$project_id"

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   Firebase Setup Complete! ✅                      ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Your Firebase project:${NC} $project_id"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Build your app:"
echo "   ${BLUE}make build${NC}"
echo ""
echo "2. Deploy to Firebase:"
echo "   ${BLUE}make deploy-firebase${NC}"
echo "   or"
echo "   ${BLUE}firebase deploy --only hosting${NC}"
echo ""
echo "3. Your site will be live at:"
echo "   ${GREEN}https://$project_id.web.app${NC}"
echo "   ${GREEN}https://$project_id.firebaseapp.com${NC}"
echo ""
echo -e "${YELLOW}Optional: Set up GitHub Actions auto-deploy${NC}"
echo "1. Generate service account key in Firebase Console"
echo "2. Add as FIREBASE_SERVICE_ACCOUNT secret in GitHub"
echo "3. Push to main branch - auto-deploys!"
echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
