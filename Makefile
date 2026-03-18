.PHONY: init setup-repo adopt open worktree list update clean help

PANTHEON_ROOT := $(shell cd "$$(dirname "$(lastword $(MAKEFILE_LIST))")" && pwd)
WORKTREES_DIR := $(PANTHEON_ROOT)/worktrees

help: ## Show available commands
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

init: ## Clone product repo (usage: make init REPO=git@github.com:org/repo.git)
	@if [ -d "$(WORKTREES_DIR)/main" ]; then \
		echo "worktrees/main/ already exists"; \
	elif [ -n "$(REPO)" ]; then \
		git clone "$(REPO)" "$(WORKTREES_DIR)/main"; \
		echo "✓ Cloned into worktrees/main/"; \
		echo "Run 'make setup-repo' to generate project-specific AGENTS.md"; \
	else \
		echo "Usage: make init REPO=git@github.com:org/repo.git"; \
		exit 1; \
	fi

setup-repo: ## Generate project-specific AGENTS.md by inspecting your repo
	@if [ ! -d "$(WORKTREES_DIR)/main" ]; then \
		echo "Error: worktrees/main/ does not exist. Run 'make init REPO=...' first."; \
		exit 1; \
	fi
	@BEFORE=$$(md5 -q "$(PANTHEON_ROOT)/AGENTS.md" 2>/dev/null || md5sum "$(PANTHEON_ROOT)/AGENTS.md" 2>/dev/null | cut -d' ' -f1 || echo "none"); \
	cd "$(WORKTREES_DIR)/main" && \
		OPENCODE_CONFIG_DIR="$(PANTHEON_ROOT)/.opencode" \
		PANTHEON_ROOT="$(PANTHEON_ROOT)" \
		opencode run --command setup-repo --agent document-writer; \
	AFTER=$$(md5 -q "$(PANTHEON_ROOT)/AGENTS.md" 2>/dev/null || md5sum "$(PANTHEON_ROOT)/AGENTS.md" 2>/dev/null | cut -d' ' -f1 || echo "none"); \
	if [ "$$BEFORE" = "$$AFTER" ]; then \
		echo ""; \
		echo "⚠️  WARNING: AGENTS.md was not modified by /setup-repo."; \
		echo "   The file at $(PANTHEON_ROOT)/AGENTS.md may still be the placeholder."; \
		echo "   Try running: pt main -p \"/setup-repo\""; \
	else \
		echo ""; \
		echo "✓ AGENTS.md updated successfully."; \
	fi

adopt: ## One-command setup (usage: make adopt REPO=git@github.com:org/repo.git)
	@if [ -z "$(REPO)" ]; then \
		echo "Usage: make adopt REPO=git@github.com:org/repo.git"; \
		exit 1; \
	fi
	@echo "==> Step 1/2: Cloning product repo..."
	@$(MAKE) init REPO="$(REPO)"
	@echo ""
	@echo "==> Step 2/2: Generating project-specific AGENTS.md..."
	@$(MAKE) setup-repo
	@echo ""
	@echo "✓ Adoption complete. Run 'pt' or 'make open' to start working."

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
			PANTHEON_ROOT="$(PANTHEON_ROOT)" \
			opencode run --command update --agent document-writer; \
	fi

clean: ## Remove a worktree (usage: make clean name=<name>)
	@$(PANTHEON_ROOT)/pt --remove $(name)

.DEFAULT_GOAL := help
