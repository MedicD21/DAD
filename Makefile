.PHONY: help install dev test lint format clean docker-build docker-up docker-down

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-20s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

install: ## Install backend dependencies
	cd backend && npm install

dev: ## Start development server
	cd backend && npm run dev

test: ## Run tests
	cd backend && npm test

test-watch: ## Run tests in watch mode
	cd backend && npm run test:watch

test-coverage: ## Run tests with coverage
	cd backend && npm run test:coverage

lint: ## Run linter
	cd backend && npm run lint

lint-fix: ## Fix linting issues
	cd backend && npm run lint:fix

format: ## Format code with Prettier
	cd backend && npm run format

format-check: ## Check code formatting
	cd backend && npm run format:check

clean: ## Clean node_modules and cache
	rm -rf backend/node_modules
	rm -rf backend/coverage
	rm -rf backend/.nyc_output

docker-build: ## Build Docker image
	docker-compose build

docker-up: ## Start Docker containers
	docker-compose up -d

docker-down: ## Stop Docker containers
	docker-compose down

docker-logs: ## View Docker logs
	docker-compose logs -f

docker-clean: ## Remove Docker containers and images
	docker-compose down -v --rmi all

setup: install ## Initial project setup
	@echo "Setting up the project..."
	@cd backend && cp .env.example .env
	@echo "Setup complete! Edit backend/.env with your configuration."

check: lint format-check test ## Run all checks (lint, format, test)

ci: install lint format-check test ## Run CI pipeline locally

deploy-build: ## Build production Docker image
	docker build -t dead-app-detector:latest .

all: clean install lint test ## Clean, install, lint, and test
