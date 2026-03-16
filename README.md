# Pantheon

**AI-powered development workspace with 23 specialized agents.**

Treat AI agents like code — version them, review them, improve them together.

---

## What Is Pantheon?

Pantheon is a **workspace shell** for AI-assisted development. It provides a pantheon of 23 specialized AI agents with distinct roles, a worktree-based workflow for parallel development, and shared configuration that keeps every team member working identically.

The actual product code lives in `worktrees/` — Pantheon wraps it with tooling, agents, and commands. There is no build step, no config generation, and no framework lock-in. It is just files.

**Key idea**: Treat AI agents like code — version them, review them, improve them together.

---

## Why?

### The Problem

AI-assisted development is powerful but inconsistent:
- Agent behavior varies between team members
- Prompts drift with no history
- Improvements stay siloed — one person's gains don't help others

### The Solution

**Treat AI agents like code**: version them, review them, improve them together.

- **Reproducible**: Every team member uses identical agent definitions
- **Measurable**: Track what changed when behavior improves or regresses
- **Collective**: When someone improves an agent, everyone benefits

This transforms AI assistance from "magic black box" to "engineered tool with known behavior."

---

## The Agent Pantheon

### Why Mythology Names?

Agent names aren't just flavor — they are **behavioral anchors**. Each mythological figure provides:

- A memorable identity that is harder to confuse than "agent-1", "agent-2"
- Built-in behavioral expectations from the mythology
- Clear anti-patterns (what the agent should NOT do)

When Vulkanus thinks "tests are molds, implementation fills them," it naturally follows TDD. When Mnemosyne thinks "preserve, don't invent," it refuses to suggest improvements. The mythology isn't decorative — it's operational guidance.

| Agent | Mythological Figure | Why It Fits |
|-------|---------------------|-------------|
| **Zeus** | King of the Olympian gods | Orchestrates the pantheon — classifies intent, delegates to the right specialist, never implements directly |
| **Prometheus** | Titan of forethought who gave fire to humanity | Brings structured plans (fire) that enable building — forethought prevents afterthought (rework) |
| **Vulkanus** | God of the forge (Hephaestus) | Master craftsman who forges artifacts others rely on — tests are molds, implementation fills them |
| **Mnemosyne** | Titaness of memory, mother of the Muses | Preserves institutional knowledge — you drink from her pool to remember, not re-discover |
| **Oracle** | Pythia of Delphi | Consulted for consequential technical decisions — one clear recommendation, not riddles |
| **Argus** | Argus Panoptes, the hundred-eyed giant | All-seeing adversarial reviewer — every finding must be proved by a failing test |

### All 23 Agents

**Primary Agents**

| Agent | Role | When to Use |
|-------|------|-------------|
| **zeus** (default) | Master Orchestrator | Routes work, delegates to specialists, tracks in-progress tasks |
| **prometheus** | Strategic Planner | Complex planning, requirements gathering, multi-phase work |
| **vulkanus** | TDD Implementer | Code changes, bug fixes, feature implementation |
| **mnemosyne** | System Cartographer | Research, documentation, "where/how does X work?" |
| **oracle** | Architecture Advisor | Hard debugging, design decisions, trade-off analysis |
| **argus** | Adversarial Reviewer | Pre-landing quality gate, dispatches hunter agents |
| **librarian** | External Researcher | Library docs, framework best practices, external APIs |
| **frontend-engineer** | UI/UX Implementer | Visual components, styling, frontend architecture |
| **document-writer** | Technical Writer | README files, API docs, user guides |
| **translator** | Translation Specialist | i18n, localization, content translation |

**Utility Agents** (for targeted queries)

| Agent | Role | When to Use |
|-------|------|-------------|
| **explore** | Contextual Grep | "Where is X?", "Find the code that does Z" |
| **codebase-locator** | File/Feature Finder | Locate files, directories, components for a feature |
| **codebase-analyzer** | Implementation Analyzer | Understand how specific components work |
| **codebase-pattern-finder** | Pattern Matcher | Find similar implementations and usage examples |
| **thoughts-locator** | Research Finder | Discover relevant documents in thoughts/ directory |
| **thoughts-analyzer** | Research Analyst | Deep dive on research topics from thoughts/ |

**Hunter Agents** (dispatched by Argus only)

| Agent | Role | How It Works |
|-------|------|--------------|
| **hunter-silent-failure** | Error Swallowing Detector | Writes failing tests proving swallowed errors exist |
| **hunter-type-design** | Type Invariant Checker | Writes failing tests proving invalid states are constructable |
| **hunter-security** | Security Vulnerability Finder | Writes failing tests that actually exploit the vulnerability |
| **hunter-code-review** | Convention Enforcer | Reads AGENTS.md; writes tests for violations and logic bugs |
| **hunter-simplifier** | Code Simplifier | Edits production code, runs test suite as equivalence proof |
| **hunter-comments** | Comment Auditor | Advisory only — emits Static Warnings for false/stale comments |
| **hunter-test-coverage** | Coverage Gap Filler | Writes passing tests for critical untested behaviors |

> **Note**: Zeus orchestration is experimental. Most users should press **Tab** to switch directly to **Prometheus** (planning) or **Vulkanus** (implementation).

---

## Quick Start

**You'll be up and running in under 5 minutes.**

### Prerequisites

- [Git](https://git-scm.com/) installed and authenticated to GitHub
- [OpenCode](https://opencode.ai/docs/install) installed

```bash
opencode --version   # verify it works
```

### Step 1: Create Your Workspace

On GitHub, click **"Use this template"** to create your own copy, then clone it:

```bash
gh repo create my-workspace --template ihorkatkov/pantheon --private
git clone git@github.com:your-org/your-workspace.git
cd your-workspace
```

### Step 2: Adopt Your Product Repo

```bash
make adopt REPO=git@github.com:org/my-product.git
```

This clones your repo into `worktrees/main/` and generates a project-specific `AGENTS.md` — the key file that teaches all 23 agents how your project works (build commands, test patterns, conventions, architecture).

Or step-by-step if you prefer:

```bash
make init REPO=git@github.com:org/my-product.git
make setup-repo
```

### Step 3: Start Working

```bash
pt              # Open OpenCode in main/ (interactive)
pt --new my-feature   # Create a feature branch worktree
# or
make open       # Same as pt
```

OpenCode starts with Zeus as the default agent. Press **Tab** to switch to Prometheus (planning) or Vulkanus (implementation).

### Step 4: (Recommended) Add Shell Alias

Add to `~/.zshrc` or `~/.bashrc`:

```bash
alias pt='/path/to/your-workspace/pt'
```

Reload: `source ~/.zshrc`

Now run `pt` from anywhere.

---

## Setup Guide for AI Agents

> This section is written FOR AI agents. If a user says "set up Pantheon for my project" and points you here, follow these steps end-to-end. No other context is needed.

---

### Key Facts (Read First)

- **Pantheon is a workspace shell.** It wraps a product repo — it does NOT live inside one.
- **Product code lives in `worktrees/main/`** — a git worktree of the user's product repo.
- **`.opencode/`** contains all 23 agent definitions. Edit these files to customize agent behavior.
- **`AGENTS.md` at the workspace root** is the project context file. It teaches all 23 agents your project's stack, commands, and conventions.
- **OpenCode traverses up** from `worktrees/main/` and loads `AGENTS.md` at the workspace root automatically.
- **`pt`** is a thin shell script that sets `OPENCODE_CONFIG_DIR` and calls `opencode`. It is the primary entrypoint.
- All `make` targets are convenience wrappers — the scripts (`pt`, `setup-worktree`) work standalone.

---

### Prerequisites Check

Verify each before proceeding. If a prerequisite is missing, follow the recovery note.

```bash
# 1. Git
git --version
# Recovery: install from https://git-scm.com/

# 2. GitHub CLI (needed for Path A workspace creation)
gh --version
# Recovery: install from https://cli.github.com/ or use Path B below

# 3. Make
make --version
# Recovery (macOS):  xcode-select --install
# Recovery (Linux):  sudo apt install make  OR  sudo yum install make

# 4. OpenCode
opencode --version
# Recovery: install from https://opencode.ai/docs/install

# 5. Git authentication to GitHub
ssh -T git@github.com
# OR
gh auth status
# Recovery: gh auth login  OR  add SSH key at github.com/settings/keys
```

Determine from the user:
- **Product repo URL** — e.g. `git@github.com:org/my-product.git`. Ask if not provided.
- **Workspace name** — defaults to `<product-repo-name>-workspace` if not specified.
- **Workspace location** — defaults to `~/Projects/<workspace-name>/`.

---

### Step 1: Create Workspace from Template

Two paths. Use Path A if `gh` is available; fall back to Path B otherwise.

#### Path A — GitHub Template (Preferred)

```bash
gh repo create <workspace-name> --template ihorkatkov/pantheon --private --clone
cd <workspace-name>
```

#### Path B — Direct Clone

```bash
git clone https://github.com/ihorkatkov/pantheon.git <workspace-name>
cd <workspace-name>
# Re-initialize git so the workspace is its own repo (not a fork of pantheon)
rm -rf .git
git init
git add -A
git commit -m "chore: initialize workspace from pantheon template"
# Push to a new remote if the user wants version control on the workspace:
# gh repo create <workspace-name> --private --source=. --push
```

**Verification — workspace is valid:**
```bash
ls Makefile pt .opencode/
# Must show all three. If any are missing, the clone/template failed.
```

---

### Step 2: Clone Product Repo

```bash
make init REPO=<user's-product-repo-url>
```

**What this does:** Clones the product repo into `worktrees/main/`.

**Verification:**
```bash
ls worktrees/main/.git
# Must exist. If worktrees/main/ is empty or missing, re-run make init.
```

If `worktrees/main/` already exists (workspace was previously initialized), skip this step.

---

### Step 3: Generate Project-Specific AGENTS.md

```bash
make setup-repo
```

**What this does:** Launches OpenCode non-interactively, runs `/setup-repo`, which inspects the product repo and writes a comprehensive `AGENTS.md` at the workspace root.

**Verification:**
```bash
wc -l AGENTS.md
# Must be more than 80 lines.
grep "This is a placeholder" AGENTS.md
# Must return nothing. If it still contains the placeholder text, the command failed.
```

**If verification fails — you ARE the agent that should write AGENTS.md:**

`make setup-repo` calls `opencode run "/setup-repo"` which opens a new AI session. If you are the agent running this setup (and cannot launch a subprocess), you must generate `AGENTS.md` yourself:

1. Read the product repo's config files: `package.json`, `Cargo.toml`, `go.mod`, `mix.exs`, `pyproject.toml`, `Gemfile`, `Makefile`, `deno.json`, `.github/workflows/`
2. Read 3–5 source files for import patterns and naming conventions
3. Read 3–5 test files for test framework and naming patterns
4. Run `git log --oneline -20` in `worktrees/main/` for commit message patterns
5. Write `AGENTS.md` at the workspace root following the template in `.opencode/commands/setup-repo.md`

Required sections: Agent Pantheon, Repository Structure, Build/Lint/Test Commands, Code Style Guidelines, Naming Conventions, Error Handling, Testing, Git Conventions, Architecture Quick Reference, Critical Rules.

Do NOT skip any section. Do NOT leave placeholders. Confirm the file is over 80 lines after writing.

---

### Step 4: Configure OpenCode (Machine Config)

OpenCode reads personal settings (API keys, MCP servers) from the machine config. This file is **never committed** — it is personal.

Location: `~/.config/opencode/opencode.json`

Check if it exists:
```bash
cat ~/.config/opencode/opencode.json
```

If it does not exist or has no API key, create it:

```json
{
  "provider": {
    "anthropic": {
      "apiKey": "sk-ant-..."
    }
  }
}
```

Supported provider keys: `anthropic`, `openai`, `google`, `groq`. At least one is required.

**Optional MCP servers** (add only if the user requests them):
```json
{
  "provider": {
    "anthropic": { "apiKey": "sk-ant-..." }
  },
  "mcp": {
    "linear": {
      "type": "local",
      "command": "npx",
      "args": ["-y", "@linear/mcp-server"],
      "env": { "LINEAR_API_KEY": "lin_api_..." }
    }
  }
}
```

---

### Step 5: (Optional) Project-Specific Customizations

#### Post-Worktree Hook

When `pt --new` creates a feature worktree, it automatically runs `hooks/post-worktree-create` if the file is executable. Use this to install dependencies or run setup in each new worktree.

```bash
mkdir -p hooks
```

Choose the template for the user's ecosystem:

**Node.js / npm:**
```bash
#!/bin/bash
WORKTREE_PATH="$1"
cd "$WORKTREE_PATH"
npm install
cp ../main/.env .env 2>/dev/null || true
```

**Node.js / pnpm:**
```bash
#!/bin/bash
WORKTREE_PATH="$1"
cd "$WORKTREE_PATH"
pnpm install
```

**Elixir / Phoenix:**
```bash
#!/bin/bash
WORKTREE_PATH="$1"
cd "$WORKTREE_PATH"
mix deps.get
mix ecto.setup
```

**Python:**
```bash
#!/bin/bash
WORKTREE_PATH="$1"
cd "$WORKTREE_PATH"
pip install -e .
```

**Rust:**
```bash
#!/bin/bash
WORKTREE_PATH="$1"
cd "$WORKTREE_PATH"
cargo build
```

**Go:**
```bash
#!/bin/bash
WORKTREE_PATH="$1"
cd "$WORKTREE_PATH"
go mod download
```

After writing the hook, make it executable:
```bash
chmod +x hooks/post-worktree-create
```

#### Project-Level OpenCode Settings

Add project-level MCP servers, model overrides, or keybindings to `.opencode/opencode.jsonc`. This file is tracked in git and shared with the whole team.

#### Custom Agents or Commands

- Add agent files to `.opencode/agents/<name>.md`
- Add slash commands to `.opencode/commands/<name>.md`

Changes take effect immediately — no restart needed.

---

### Step 6: Verify Everything Works

```bash
# All Make targets visible
make help

# pt CLI functional
./pt --help

# Worktrees list shows main
./pt --list
# Expected output: "main (main or master branch) [default]"

# AGENTS.md is not a placeholder
grep -c "" AGENTS.md
# Must be > 80
```

If OpenCode is available interactively, open a session:
```bash
./pt
# OpenCode should start in worktrees/main/
# Zeus is the default agent. Press Tab to switch agents.
```

---

### Step 7: (Optional) Create a Feature Worktree

Demonstrate that feature isolation works:
```bash
# Create a new isolated worktree on a new branch
./pt --new my-feature

# Open it
./pt my-feature

# When done, remove it
./pt --remove my-feature
```

Each worktree is a full checkout with isolated git state. Multiple sessions can run in parallel (one terminal per worktree).

---

### Complete Example

Full transcript: setting up Pantheon for a hypothetical Node.js product repo called `acme/webapp`.

```bash
# 0. Prerequisites confirmed: git, gh, make, opencode all installed

# 1. Create workspace from template
gh repo create acme-workspace --template ihorkatkov/pantheon --private --clone
cd acme-workspace

# Verify
ls Makefile pt .opencode/   # ✓

# 2. Clone product repo
make init REPO=git@github.com:acme/webapp.git
# Output: "✓ Cloned into worktrees/main/"

# Verify
ls worktrees/main/.git   # ✓

# 3. Generate AGENTS.md
make setup-repo
# OpenCode runs /setup-repo non-interactively
# Output: "✓ AGENTS.md updated successfully."

# Verify
wc -l AGENTS.md      # e.g., 143
grep "This is a placeholder" AGENTS.md   # (no output = good)

# 4. Machine config (already exists from prior use — skip if already configured)
cat ~/.config/opencode/opencode.json   # has anthropic key

# 5. Add post-worktree hook for Node.js
mkdir -p hooks
cat > hooks/post-worktree-create << 'EOF'
#!/bin/bash
WORKTREE_PATH="$1"
cd "$WORKTREE_PATH"
npm install
cp ../main/.env .env 2>/dev/null || true
EOF
chmod +x hooks/post-worktree-create

# 6. Verify everything
make help         # lists init, adopt, setup-repo, open, worktree, list, update, clean
./pt --help       # shows full CLI usage
./pt --list       # shows: main (main) [default]

# 7. Open a session
./pt
# OpenCode opens in worktrees/main/ with all 23 agents available
# Press Tab → switch to Prometheus to plan, Vulkanus to implement
```

Setup is complete.

---

### Troubleshooting for Agents

| Symptom | Cause | Fix |
|---------|-------|-----|
| `opencode: command not found` | OpenCode not installed | Direct user to https://opencode.ai/docs/install |
| `make: command not found` | Make not on PATH | macOS: `xcode-select --install` · Linux: `sudo apt install make` |
| `gh: command not found` | GitHub CLI not installed | Use Path B (direct clone) in Step 1 |
| `Permission denied: ./pt` | Script not executable | `chmod +x pt setup-worktree` |
| `worktrees/main/ already exists` | Step 2 already done | Skip Step 2 — proceed to Step 3 |
| `AGENTS.md still contains "This is a placeholder"` | `/setup-repo` sub-process failed | Generate `AGENTS.md` manually (see Step 3 fallback) |
| Agents unaware of project conventions | AGENTS.md is stale or placeholder | Run `make setup-repo` or generate manually |
| `Error: Worktree 'main' not found` after Step 2 | `make init` failed silently | Re-run with explicit REPO: `make init REPO=<url>` and check for git clone errors |
| OpenCode loads wrong agents | `OPENCODE_CONFIG_DIR` not set | Always use `./pt` — it sets the env var. If running `opencode` directly: `export OPENCODE_CONFIG_DIR="$(pwd)/.opencode"` |
| `ssh: Could not resolve hostname github.com` | No network or SSH not configured | Run `gh auth login` or add SSH key at github.com/settings/keys |

---

## Daily Use

### Start a New Feature Worktree

```bash
# Create worktree for a ticket
pt --new my-feature my/feature-branch

# Open it
pt my-feature
```

Or with make:

```bash
make worktree name=my-feature branch=my/feature-branch
make open wt=my-feature
```

### Work on an Existing Worktree

```bash
# Interactive session
pt my-feature

# One-off prompt (non-interactive)
pt my-feature -p "explain the auth flow"

# Prompt on main
pt -p "what tests are failing?"
```

### Run Parallel Sessions

Each worktree is fully isolated. Run multiple OpenCode sessions simultaneously:

```bash
# Terminal 1: main branch
pt

# Terminal 2: feature branch
pt my-feature

# Terminal 3: another feature
pt my-other-feature
```

All sessions share the same agents but have isolated git state.

### Clean Up

```bash
# Remove a worktree (asks for confirmation)
pt --remove my-feature

# Force remove without confirmation
pt --remove my-feature --force

# Prune stale references
pt --prune

# Via make
make clean name=my-feature
```

### List Worktrees

```bash
pt --list
# or
make list
```

---

## Workspace Layout

```
your-workspace/
├── .opencode/                  # Shared agent configuration (checked into git)
│   ├── agents/                 # 23 agent definition files (*.md)
│   ├── commands/               # Slash commands (/create-plan, /implement-plan, etc.)
│   ├── skills/                 # Specialized skills (perplexity-search, translate)
│   └── opencode.jsonc          # Project-level OpenCode settings
│
├── pt                          # CLI wrapper script — the main entrypoint
├── setup-worktree              # Hook script run after worktree creation
├── Makefile                    # Convenience targets (init, setup-repo, open, etc.)
│
├── worktrees/                  # Product repo checkouts (gitignored)
│   ├── main/                   # Main branch — your product repo
│   └── my-feature/             # Feature branch worktrees
│
├── thoughts/                   # Research docs and task plans (tracked in git)
│   ├── research/               # Mnemosyne's research output
│   └── tasks/                  # Prometheus's planning output
│
├── AGENTS.md                   # AI agent instructions (generated by /setup-repo)
├── .pantheon-version           # Version tracking for updates
└── docs/                       # Extended documentation
    ├── agents.md               # Detailed agent documentation
    └── CHEATSHEET.md           # Quick reference card
```

---

## How It Works

### Configuration Layers

| Layer | Location | What It Contains | Shared? |
|-------|----------|------------------|---------|
| **Machine** | `~/.config/opencode/opencode.json` | API keys, MCP servers, themes | No — personal only |
| **Workspace** | `.opencode/` | Agents, commands, skills, project settings | **Yes** — tracked in git |
| **Project** | `AGENTS.md` (workspace root) | Build commands, conventions, architecture | **Yes** — tracked in git |
| **Product** | `worktrees/main/CLAUDE.md` (optional) | Additional product-specific notes | Yes — in your product repo |

### When You Run `pt main`

1. `OPENCODE_CONFIG_DIR` is set to `your-workspace/.opencode/`
2. OpenCode starts in `your-workspace/worktrees/main/` directory
3. Machine config loaded from `~/.config/opencode/`
4. Workspace agents/commands loaded from `.opencode/`
5. OpenCode traverses **up** from `worktrees/main/` and finds `AGENTS.md` at the workspace root — providing project-specific context to all agents

### Machine Configuration

Create `~/.config/opencode/opencode.json` for your personal settings:

```json
{
  "provider": {
    "anthropic": {
      "apiKey": "your-anthropic-key"
    }
  }
}
```

> **Note**: This file contains secrets — never commit it.

---

## How AGENTS.md Works

OpenCode traverses **up** from the working directory, collecting all `AGENTS.md` and `CLAUDE.md` files it finds. In a Pantheon workspace:

```
pantheon-workspace/
├── AGENTS.md                  ← Found by traversing UP (workspace context)
└── worktrees/
    └── main/
        ├── CLAUDE.md          ← Found in cwd (product context, if exists)
        └── (your product code)
```

This means:

- **Workspace `AGENTS.md`** (at root) provides agent system context and project conventions — your build commands, test patterns, code style, architecture overview
- **Product `CLAUDE.md`** (in worktree, if your product repo has one) provides additional product-specific context
- Both are loaded and available to all agents in the session

The `make adopt` command (or `make setup-repo`) generates the workspace `AGENTS.md` by inspecting your product repo. This is the **most important step** of adoption — it teaches all 23 agents how your specific project works.

---

## Customization

### Edit Existing Agents

All agents are plain Markdown files in `.opencode/agents/`. Edit them directly:

```bash
# Fine-tune Vulkanus's TDD behavior
$EDITOR .opencode/agents/vulkanus.md

# Add project-specific conventions to Mnemosyne
$EDITOR .opencode/agents/mnemosyne.md
```

Changes take effect immediately — no restart needed. Commit the edit and every team member gets the improvement.

### Add a New Agent

Create a new file in `.opencode/agents/`:

```markdown
---
description: Brief description of what this agent does.
mode: subagent
model: anthropic/claude-sonnet-4-6
---

# MyAgent

You are MyAgent...
```

The `description` field is shown in the agent picker. The `mode` field controls availability (`all`, `subagent`).

### Add New Commands

Create a file in `.opencode/commands/`:

```markdown
---
description: What this slash command does.
---

# /my-command

Instructions for the AI when this command is invoked...
```

Now `/my-command` is available in all sessions.

### Add New Skills

Create a directory in `.opencode/skills/`:

```
.opencode/skills/my-skill/
└── SKILL.md
```

### Post-Worktree Hooks

When `pt --new` creates a worktree, it runs `hooks/post-worktree-create` if it exists. Use this for project-specific setup:

```bash
# Copy the example hook to get started
cp hooks/post-worktree-create.example hooks/post-worktree-create
chmod +x hooks/post-worktree-create
```

Example for an Elixir/Phoenix project:

```bash
#!/bin/bash
WORKTREE_PATH="$1"
cd "$WORKTREE_PATH"
mix deps.get
mix ecto.setup
```

Example for a Node.js project:

```bash
#!/bin/bash
WORKTREE_PATH="$1"
cd "$WORKTREE_PATH"
npm install
cp ../main/.env .env
```

Example to symlink `thoughts/` into the worktree (so research docs stay in the workspace, not the product repo):

```bash
#!/bin/bash
WORKTREE_PATH="$1"
PANTHEON_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ln -sf "$PANTHEON_ROOT/thoughts" "$WORKTREE_PATH/thoughts"
```

> **Note**: The legacy `setup-worktree` script at the repo root still works for backwards compatibility.

---

## Updating

Pantheon is versioned. When upstream improvements are available:

```bash
make update
```

This:
1. Adds `pantheon-upstream` remote pointing to `github.com/ihorkatkov/pantheon`
2. Fetches the latest version
3. If a new version is available, launches OpenCode with `/update`
4. The AI merges upstream changes intelligently — preserving your customizations, applying structural improvements

Your custom agents, commands, and `AGENTS.md` are never overwritten.

---

## Agent Quick Reference

**Primary Agents** — press Tab in OpenCode to switch

| Agent | When to Use |
|-------|-------------|
| **zeus** | Default. Routes work, orchestrates multi-step tasks |
| **prometheus** | "Plan how to implement X" — generates structured plan files |
| **vulkanus** | "Implement X" — TDD-driven code changes |
| **mnemosyne** | "Where is X?", "How does Y work?", "Research Z" |
| **oracle** | "Should I use A or B?", "Debug this hard problem" |
| **argus** | "Review this before I ship" — adversarial quality gate |
| **librarian** | "How does library X work?", "Find official docs for Y" |
| **frontend-engineer** | "Build this UI component", "Make this look great" |
| **document-writer** | "Write docs for X", "Create a README for Y" |
| **translator** | "Translate this to French", "Localize these UI strings" |

**Utility Agents** — invoked by primary agents, or directly with @name

| Agent | When to Use |
|-------|-------------|
| **@explore** | Quick: "Where is auth implemented?" |
| **@codebase-locator** | Find all files related to a feature |
| **@codebase-analyzer** | Trace data flow, understand HOW code works |
| **@codebase-pattern-finder** | Find examples to copy — "how is X done here?" |
| **@thoughts-locator** | Find prior research docs in `thoughts/` |
| **@thoughts-analyzer** | Distill key insights from research docs |

**Hunter Agents** — dispatched by Argus automatically

| Agent | Catches |
|-------|---------|
| **hunter-silent-failure** | Swallowed errors, empty catch blocks, optional chaining hiding failures |
| **hunter-type-design** | Invalid states constructable at runtime, missing schema validation |
| **hunter-security** | Auth bypasses, tenant isolation leaks, IDOR vulnerabilities |
| **hunter-code-review** | AGENTS.md violations, logic bugs, naming violations |
| **hunter-simplifier** | Unnecessary complexity — refactors and verifies with test suite |
| **hunter-comments** | Factually wrong, stale, or temporal comments (advisory) |
| **hunter-test-coverage** | Critical untested paths: error handling, edge cases, business logic |

---

## Commands

Available as slash commands in any OpenCode session:

| Command | Description |
|---------|-------------|
| `/create-plan` | Interactively create an implementation plan with codebase research. Saves to `thoughts/tasks/`. |
| `/implement-plan` | Execute an approved plan file from `thoughts/tasks/`, following TDD gates. |
| `/update-plan` | Iterate on an existing plan file based on feedback. |
| `/research-codebase` | Invoke Mnemosyne behavior to document what exists in the codebase. |
| `/setup-repo` | Inspect your product repo and generate a project-specific AGENTS.md. |
| `/update` | Intelligently merge upstream Pantheon updates while preserving your customizations. |

---

## Skills

Skills are specialized instruction modules that agents load on demand:

| Skill | Description |
|-------|-------------|
| `perplexity-search` | Real-time web research via the Perplexity API. Used for current events, library docs, competitive analysis. |
| `translate` | Context-aware translation preserving formatting, code blocks, and technical terms. |

---

## Migrating from Existing Setup

If your product repo already has `.opencode/` with customized agents:

### The Pantheon Model

| Layer | Where | What |
|-------|-------|------|
| **Agent behavior** | Workspace `.opencode/agents/` | Generic roles (TDD, research, planning) |
| **Project context** | Workspace `AGENTS.md` | Your stack, commands, conventions |
| **Product context** | Worktree `CLAUDE.md` (optional) | Additional product-specific notes |

### Migration Steps

1. **Run `make adopt REPO=...`** (or `make setup-repo`) — generates `AGENTS.md` from your product repo
2. **Review the generated `AGENTS.md`** — add any conventions that were baked into custom agents
3. **Remove `.opencode/` from your product repo** — the workspace provides agents for all team members
4. **Move project-specific commands** to `AGENTS.md` sections (validation commands, test patterns, etc.)

### What Goes Where

| Content | Where It Belongs |
|---------|-----------------|
| `mix precommit`, `npm test`, `cargo build` | `AGENTS.md` → Build/Test Commands |
| Import patterns, naming conventions | `AGENTS.md` → Code Style |
| Test file naming, test framework patterns | `AGENTS.md` → Testing |
| Language-specific patterns (Elixir, Rust, Python) | `AGENTS.md` → Code Style |
| TDD workflow, delegation rules | Agent files (already generic) |
| Research protocols, planning templates | Agent files (already generic) |

---

## FAQ / Troubleshooting

### "Agents not found" / wrong agents loading

The `pt` wrapper sets `OPENCODE_CONFIG_DIR` automatically. If running OpenCode directly:

```bash
export OPENCODE_CONFIG_DIR="/path/to/your-workspace/.opencode"
opencode
```

Verify the env var is set:
```bash
echo $OPENCODE_CONFIG_DIR  # should show your workspace path
```

### "Worktree not found"

```bash
pt --list   # shows all available worktrees
```

If `worktrees/main/` doesn't exist, run `make init` first.

### "pt: command not found" after adding alias

```bash
source ~/.zshrc     # reload shell config
# or start a new terminal
```

### "Worktree creation fails"

Ensure you have access to the product repository and can clone it. The `setup-worktree` script runs automatically after worktree creation — check that script for project-specific setup steps.

### MCP servers not connecting

Check your machine config:
```bash
cat ~/.config/opencode/opencode.json | jq '.mcp'
```

MCP servers are optional but require valid API keys and configured commands if enabled.

### Wrong AGENTS.md loaded

OpenCode traverses up from the worktree directory to find `AGENTS.md`. The workspace `AGENTS.md` at the repo root is what gets loaded — not one inside the worktree itself.

If agents seem unaware of your project conventions, confirm `AGENTS.md` exists at the workspace root:

```bash
ls AGENTS.md       # should exist at workspace root
make setup-repo    # regenerate if missing or stale
```

Verify you opened the correct worktree:
```bash
pt --list   # shows all available worktrees
```

### Where Do Research Docs Go?

Agents create research documents in `thoughts/` relative to their working directory. Since agents run inside the worktree (`worktrees/main/`), `thoughts/` is created inside the product repo by default.

To keep research docs in the workspace instead (tracked in your workspace git, not your product repo), add a symlink in your post-worktree-create hook:

```bash
# hooks/post-worktree-create
PANTHEON_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ln -sf "$PANTHEON_ROOT/thoughts" "$1/thoughts"
```

Or simply accept that `thoughts/` lives in the product repo — most projects gitignore it by default.

### Common Issues Checklist

- [ ] `opencode --version` works
- [ ] `pt --list` shows worktrees
- [ ] `~/.config/opencode/opencode.json` exists with a valid API key
- [ ] `worktrees/main/` exists and has a `.git` file or directory
- [ ] `AGENTS.md` has been generated (`make setup-repo` was run)

---

## Contributing

Pantheon improves through use. If you improve an agent prompt, fix a workflow, or add a useful command:

1. Fork the repository
2. Make your changes in `.opencode/agents/`, `.opencode/commands/`, or `docs/`
3. Open a pull request with a description of the behavioral change

Agent changes should include: what behavior changed, why it's better, and ideally a before/after example of agent output.

---

## License

MIT — see [LICENSE](LICENSE).

Copyright 2025 ihorkatkov.
