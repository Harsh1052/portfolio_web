#!/bin/bash

# Flutter Web Production Build Script
# Optimized for deployment with CanvasKit renderer

set -e  # Exit on error

echo "🚀 Starting Flutter Web Production Build..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Clean previous build
echo -e "${BLUE}🧹 Cleaning previous build...${NC}"
fvm flutter clean
rm -rf build/web

# Get dependencies
echo -e "${BLUE}📦 Getting dependencies...${NC}"
fvm flutter pub get

# Analyze code
echo -e "${BLUE}🔍 Analyzing code...${NC}"
fvm flutter analyze

# Run tests (optional - comment out if no tests)
# echo -e "${BLUE}🧪 Running tests...${NC}"
# flutter test

# Build for web with optimizations
echo -e "${BLUE}🏗️  Building for production...${NC}"
fvm flutter build web \
  --release \
  --pwa-strategy offline-first \
  --no-tree-shake-icons \
  --dart-define=FLUTTER_WEB_USE_SKIA=true \
  --source-maps \
  --no-wasm-dry-run

# Optimize build (optional post-processing)
echo -e "${BLUE}⚡ Optimizing build...${NC}"

# Create .nojekyll for GitHub Pages (prevents Jekyll processing)
touch build/web/.nojekyll

# Create CNAME file for custom domain (uncomment and modify if needed)
# echo "yourdomain.com" > build/web/CNAME

# Display build size
echo -e "${BLUE}📊 Build Statistics:${NC}"
du -sh build/web

echo ""
echo -e "${GREEN}✅ Build completed successfully!${NC}"
echo -e "${YELLOW}📁 Build output: build/web/${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
