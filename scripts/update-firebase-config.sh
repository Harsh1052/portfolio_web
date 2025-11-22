#!/bin/bash

# Update Firebase configuration with project ID
# Usage: ./update-firebase-config.sh <project-id>

if [ -z "$1" ]; then
    echo "Usage: ./update-firebase-config.sh <project-id>"
    echo "Example: ./update-firebase-config.sh portfolio-web-harsh"
    exit 1
fi

PROJECT_ID="$1"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}Updating Firebase configuration...${NC}"
echo ""

# Update .firebaserc
echo -e "${YELLOW}1. Updating .firebaserc${NC}"
cat > .firebaserc << EOF
{
  "projects": {
    "default": "$PROJECT_ID"
  }
}
EOF
echo -e "${GREEN}✓ .firebaserc updated${NC}"

# Update GitHub Actions workflow
echo -e "${YELLOW}2. Updating GitHub Actions workflow${NC}"
if [ -f ".github/workflows/firebase-deploy.yml" ]; then
    # For macOS, use sed -i '' instead of sed -i
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s/projectId: .*/projectId: $PROJECT_ID/" .github/workflows/firebase-deploy.yml
    else
        sed -i "s/projectId: .*/projectId: $PROJECT_ID/" .github/workflows/firebase-deploy.yml
    fi
    echo -e "${GREEN}✓ GitHub Actions workflow updated${NC}"
fi

# Set Firebase project
echo -e "${YELLOW}3. Setting Firebase project${NC}"
firebase use "$PROJECT_ID" 2>/dev/null && echo -e "${GREEN}✓ Firebase project set${NC}" || {
    firebase use --add "$PROJECT_ID" && echo -e "${GREEN}✓ Firebase project added and set${NC}"
}

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   Firebase Configuration Updated! ✅               ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Project ID:${NC} $PROJECT_ID"
echo -e "${YELLOW}Your site URLs:${NC}"
echo "  • https://$PROJECT_ID.web.app"
echo "  • https://$PROJECT_ID.firebaseapp.com"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Build: make build"
echo "2. Deploy: make deploy-firebase"
echo ""
