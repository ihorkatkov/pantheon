.PHONY: init setup-repo open worktree list update clean help

PANTHEON_ROOT := $(shell cd "$$(dirname "$(lastword $(MAKEFILE_LIST))")" && pwd)
WORKTREES_DIR := $(PANTHEON_ROOT)/worktrees

help: ## Show available commands
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

init: ## Clone your product repo into worktrees/main/
	@if [ -d "$(WORKTREES_DIR)/main" ]; then \
		echo "worktrees/main/ already exists"; \
	else \
		echo "Enter your product repo URL (SSH or HTTPS):"; \
		read -r REPO_URL; \
		git clone "$$REPO_URL" "$(WORKTREES_DIR)/main"; \
		echo "✓ Cloned into worktrees/main/"; \
		echo "Run 'make setup-repo' to generate project-specific AGENTS.md"; \
	fi

setup-repo: ## Generate project-specific AGENTS.md by inspecting your repo
	@cd "$(WORKTREES_DIR)/main" && \
		OPENCODE_CONFIG_DIR="$(PANTHEON_ROOT)/.opencode" \
		opencode run "/setup-repo"

open: ## Open OpenCode session (usage: make open [wt=worktree-name])
	@$(PANTHEON_ROOT)/pt $(or $(wt),main)

worktree: ## Create a new worktree (usage: make worktree name=<name> [branch=<branch>])
	@$(PANTHEON_ROOT)/pt --new $(name) $(or $(branch),$(name))

list: ## List available worktrees
	@$(PANTHEON_ROOT)/pt --list

update: ## Check for Pantheon updates and merge intelligently
	@echo "Checking for Pantheon updates..."
	@git remote get-url pantheon-upstream >/dev/null 2>&1 || \
		git remote add pantheon-upstream https://github.com/ihorkatkov/pantheon.git
	@git fetch pantheon-upstream main
	@LOCAL_VERSION=$$(cat .pantheon-version 2>/dev/null || echo "0.0.0"); \
	REMOTE_VERSION=$$(git show pantheon-upstream/main:.pantheon-version 2>/dev/null || echo "0.0.0"); \
	if [ "$$LOCAL_VERSION" = "$$REMOTE_VERSION" ]; then \
		echo "✓ Already up to date (v$$LOCAL_VERSION)"; \
	else \
		echo "Update available: v$$LOCAL_VERSION → v$$REMOTE_VERSION"; \
		echo "Launching AI-assisted merge..."; \
		cd "$(WORKTREES_DIR)/main" && \
			OPENCODE_CONFIG_DIR="$(PANTHEON_ROOT)/.opencode" \
			opencode run "/update"; \
	fi

clean: ## Remove a worktree (usage: make clean name=<name>)
	@$(PANTHEON_ROOT)/pt --remove $(name)

.DEFAULT_GOAL := help
