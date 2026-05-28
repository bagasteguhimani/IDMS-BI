.PHONY: help dev up down db-shell migrate seed test-backend test-frontend lint

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-18s\033[0m %s\n", $$1, $$2}'

# ─── Local Dev ────────────────────────────────────────
dev: ## Start all services via Docker Compose
	docker compose up --build

up: ## Start services in background
	docker compose up -d

down: ## Stop all services
	docker compose down

db-shell: ## Open a psql shell into the running db container
	docker compose exec db psql -U idms_user -d idms

# ─── Backend ──────────────────────────────────────────
migrate: ## Run database migrations
	cd Backend && go run ./cmd/migrate

seed: ## Seed database with initial data
	cd Backend && go run ./cmd/seed

test-backend: ## Run backend tests
	cd Backend && go test ./...

lint-backend: ## Lint backend code
	cd Backend && golangci-lint run ./...

# ─── Frontend ─────────────────────────────────────────
install-frontend: ## Install frontend dependencies
	cd Frontend && npm install

test-frontend: ## Run frontend tests
	cd Frontend && npm test

lint-frontend: ## Lint frontend code
	cd Frontend && npm run lint

# ─── Misc ─────────────────────────────────────────────
env: ## Copy .env.example to .env if .env does not exist
	@test -f .env || (cp .env.example .env && echo ".env created from .env.example")
