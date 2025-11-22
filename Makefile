# Flutter Web Portfolio Deployment Makefile
# Simplifies common build and deployment tasks

.PHONY: help install dev build clean analyze test deploy-firebase deploy-netlify deploy-vercel deploy-github setup-firebase setup-netlify setup-vercel

# Colors for output
BLUE := \033[0;34m
GREEN := \033[0;32m
YELLOW := \033[1;33m
NC := \033[0m # No Color

help: ## Show this help message
	@echo "$(BLUE)Flutter Web Portfolio - Deployment Commands$(NC)"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "$(YELLOW)%-20s$(NC) %s\n", $$1, $$2}'

install: ## Install dependencies
	@echo "$(BLUE)📦 Installing dependencies...$(NC)"
	fvm flutter pub get

dev: ## Run development server
	@echo "$(BLUE)🚀 Starting development server...$(NC)"
	fvm flutter run -d chrome

build: ## Build for production
	@echo "$(BLUE)🏗️  Building for production...$(NC)"
	@chmod +x scripts/build.sh
	@./scripts/build.sh

clean: ## Clean build artifacts
	@echo "$(BLUE)🧹 Cleaning build artifacts...$(NC)"
	fvm flutter clean
	rm -rf build

analyze: ## Analyze code
	@echo "$(BLUE)🔍 Analyzing code...$(NC)"
	fvm flutter analyze

format: ## Format code
	@echo "$(BLUE)✨ Formatting code...$(NC)"
	fvm dart format .

test: ## Run tests
	@echo "$(BLUE)🧪 Running tests...$(NC)"
	fvm flutter test

# Firebase Deployment
setup-firebase: ## Set up Firebase Hosting
	@echo "$(BLUE)🔥 Setting up Firebase Hosting...$(NC)"
	@if ! command -v firebase &> /dev/null; then \
		echo "$(YELLOW)Installing Firebase CLI...$(NC)"; \
		npm install -g firebase-tools; \
	fi
	@echo "$(GREEN)✓ Firebase CLI installed$(NC)"
	@echo "$(YELLOW)Run 'firebase login' to authenticate$(NC)"
	@echo "$(YELLOW)Run 'firebase init hosting' to initialize project$(NC)"
	@echo "$(YELLOW)Update .firebaserc with your project ID$(NC)"

deploy-firebase: build ## Build and deploy to Firebase Hosting
	@echo "$(BLUE)🔥 Deploying to Firebase Hosting...$(NC)"
	@if ! command -v firebase &> /dev/null; then \
		echo "$(YELLOW)Firebase CLI not found. Run 'make setup-firebase' first$(NC)"; \
		exit 1; \
	fi
	firebase deploy --only hosting
	@echo "$(GREEN)✅ Deployed to Firebase!$(NC)"

# Netlify Deployment
setup-netlify: ## Set up Netlify CLI
	@echo "$(BLUE)🚀 Setting up Netlify CLI...$(NC)"
	@if ! command -v netlify &> /dev/null; then \
		echo "$(YELLOW)Installing Netlify CLI...$(NC)"; \
		npm install -g netlify-cli; \
	fi
	@echo "$(GREEN)✓ Netlify CLI installed$(NC)"
	@echo "$(YELLOW)Run 'netlify login' to authenticate$(NC)"
	@echo "$(YELLOW)Run 'netlify init' to initialize site$(NC)"

deploy-netlify: build ## Build and deploy to Netlify
	@echo "$(BLUE)🚀 Deploying to Netlify...$(NC)"
	@if ! command -v netlify &> /dev/null; then \
		echo "$(YELLOW)Netlify CLI not found. Run 'make setup-netlify' first$(NC)"; \
		exit 1; \
	fi
	netlify deploy --prod --dir=build/web
	@echo "$(GREEN)✅ Deployed to Netlify!$(NC)"

# Vercel Deployment
setup-vercel: ## Set up Vercel CLI
	@echo "$(BLUE)▲ Setting up Vercel CLI...$(NC)"
	@if ! command -v vercel &> /dev/null; then \
		echo "$(YELLOW)Installing Vercel CLI...$(NC)"; \
		npm install -g vercel; \
	fi
	@echo "$(GREEN)✓ Vercel CLI installed$(NC)"
	@echo "$(YELLOW)Run 'vercel login' to authenticate$(NC)"

deploy-vercel: build ## Build and deploy to Vercel
	@echo "$(BLUE)▲ Deploying to Vercel...$(NC)"
	@if ! command -v vercel &> /dev/null; then \
		echo "$(YELLOW)Vercel CLI not found. Run 'make setup-vercel' first$(NC)"; \
		exit 1; \
	fi
	vercel --prod
	@echo "$(GREEN)✅ Deployed to Vercel!$(NC)"

# GitHub Pages Deployment
deploy-github: build ## Build and deploy to GitHub Pages
	@echo "$(BLUE)📄 Deploying to GitHub Pages...$(NC)"
	@echo "$(YELLOW)Note: Automated deployment via GitHub Actions is recommended$(NC)"
	@echo "$(YELLOW)Enable GitHub Pages in repository settings$(NC)"
	@echo "$(YELLOW)Push to main/master branch to trigger automatic deployment$(NC)"

# Development helpers
watch: ## Watch for changes and rebuild
	@echo "$(BLUE)👀 Watching for changes...$(NC)"
	@while true; do \
		fvm flutter build web --release --web-renderer canvaskit; \
		inotifywait -qre close_write .; \
	done

serve: build ## Build and serve locally
	@echo "$(BLUE)🌐 Serving build locally on http://localhost:8000$(NC)"
	@cd build/web && python3 -m http.server 8000

# Multi-platform deployment
deploy-all: ## Deploy to all platforms (Firebase, Netlify, Vercel)
	@echo "$(BLUE)🚀 Deploying to all platforms...$(NC)"
	@make deploy-firebase
	@make deploy-netlify
	@make deploy-vercel
	@echo "$(GREEN)✅ Deployed to all platforms!$(NC)"

# Quick start
quick-start: install build ## Install dependencies and build
	@echo "$(GREEN)✅ Ready to deploy! Use one of:$(NC)"
	@echo "  • make deploy-firebase"
	@echo "  • make deploy-netlify"
	@echo "  • make deploy-vercel"
	@echo "  • make deploy-github"
