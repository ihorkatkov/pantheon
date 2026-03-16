# Pantheon

![Pantheon](assets/banner.png)

23 AI agents. One workspace. Version-controlled like code.

Pantheon is a workspace shell for AI-assisted development. Agents are defined in files, reviewed in PRs, and shared across the team. Built on [OpenCode](https://opencode.ai).

> Treat agents like code — version them, review them, ship them.

---

## The Agent Pantheon

Agent names are **behavioral anchors** from Greek mythology — not decoration. When Vulkanus thinks "tests are molds," it follows TDD. When Mnemosyne thinks "preserve, don't invent," it refuses to suggest changes.

**Primary Agents**

| Agent | Role | Mythology |
|-------|------|-----------|
| **Zeus** | Master Orchestrator | King of Olympus — delegates, never implements directly |
| **Prometheus** | Strategic Planner | Titan of forethought — planning prevents rework |
| **Vulkanus** | TDD Implementer | God of the forge — tests are molds, code fills them |
| **Mnemosyne** | System Cartographer | Titaness of memory — preserves, never invents |
| **Oracle** | Architecture Advisor | Pythia of Delphi — one clear answer, not riddles |
| **Argus** | Adversarial Reviewer | Hundred-eyed giant — every finding proved by a failing test |
| **Librarian** | External Researcher | Library docs, framework best practices |
| **Frontend Engineer** | UI/UX Implementer | Visual components, styling, architecture |
| **Document Writer** | Technical Writer | README files, API docs, user guides |
| **Translator** | Translation Specialist | i18n, localization, content translation |

**Utility Agents** — targeted queries, invoked by primary agents or directly

| Agent | Role |
|-------|------|
| **Explore** | Contextual grep — "Where is X?" |
| **Codebase Locator** | Find files and directories for a feature |
| **Codebase Analyzer** | Understand how specific components work |
| **Codebase Pattern Finder** | Find similar implementations to model after |
| **Thoughts Locator** | Find prior research in `thoughts/` |
| **Thoughts Analyzer** | Distill insights from research docs |

**Hunter Agents** — dispatched by Argus for adversarial review

| Agent | Catches |
|-------|---------|
| **Silent Failure** | Swallowed errors, empty catches, optional chaining hiding failures |
| **Type Design** | Invalid states constructable at runtime, missing validation |
| **Security** | Auth bypasses, tenant isolation leaks, IDOR |
| **Code Review** | Convention violations, logic bugs, naming issues |
| **Simplifier** | Unnecessary complexity — refactors with test equivalence proof |
| **Comments** | Factually wrong or stale comments (advisory only) |
| **Test Coverage** | Critical untested paths: error handling, edge cases, business logic |

> Full agent docs with mythology: [docs/agents.md](docs/agents.md)

---

## Quick Start

```bash
# 1. Create workspace from template
gh repo create my-workspace --template ihorkatkov/pantheon --private --clone
cd my-workspace

# 2. Adopt your product repo (clones + generates AGENTS.md)
make adopt REPO=git@github.com:org/my-product.git

# 3. Start working
pt                    # Open AI session in main worktree
pt --new my-feature   # Create a feature branch worktree
```

`make adopt` clones your repo into `worktrees/main/` and generates a project-specific `AGENTS.md` — the file that teaches all 23 agents your stack, commands, and conventions.

Press **Tab** in OpenCode to switch between agents. Zeus is the default orchestrator.

---

## How It Works

```
your-workspace/
├── .opencode/agents/      ← 23 agent definitions (edit, commit, ship)
├── .opencode/commands/    ← Slash commands (/create-plan, /setup-repo, etc.)
├── .opencode/skills/      ← Skills (perplexity-search, translate)
├── AGENTS.md              ← Generated project context (your stack, commands, conventions)
├── pt                     ← CLI entrypoint (wraps OpenCode + worktree management)
├── Makefile               ← make adopt, make open, make update, etc.
├── worktrees/
│   ├── main/              ← Your product repo
│   └── my-feature/        ← Isolated branch worktree
└── thoughts/              ← Research docs and task plans
```

OpenCode traverses **up** from the worktree and finds `AGENTS.md` at the workspace root. Every agent reads the same project context automatically.

---

<details>
<summary><h2>🤖 Setup Guide for AI Agents</h2></summary>

> **For AI agents**: If a user points you at this repo and says "set up Pantheon for my project," follow these steps end-to-end.

### Key Facts

- **Pantheon is a workspace shell.** It wraps a product repo — it does NOT live inside one.
- **Product code lives in `worktrees/main/`** — a git worktree of the user's product repo.
- **`.opencode/`** contains all 23 agent definitions. Edit files directly to customize.
- **`AGENTS.md` at workspace root** teaches agents your project's stack, commands, and conventions.
- **OpenCode traverses up** from `worktrees/main/` and loads workspace root `AGENTS.md` automatically.
- **`pt`** is a thin shell wrapper that sets `OPENCODE_CONFIG_DIR` and calls `opencode`.

### Prerequisites

```bash
git --version       # https://git-scm.com/
gh --version        # https://cli.github.com/ (or use Path B below)
make --version      # macOS: xcode-select --install / Linux: sudo apt install make
opencode --version  # https://opencode.ai/docs/install
```

Determine from user: **product repo URL**, **workspace name** (default: `<repo>-workspace`), **location** (default: `~/Projects/`).

### Step 1: Create Workspace

**Path A — GitHub CLI (preferred):**

```bash
gh repo create <workspace-name> --template ihorkatkov/pantheon --private --clone
cd <workspace-name>
```

**Path B — Direct clone:**

```bash
git clone https://github.com/ihorkatkov/pantheon.git <workspace-name>
cd <workspace-name>
rm -rf .git && git init && git add -A && git commit -m "chore: init from pantheon"
```

**Verify:** `ls Makefile pt .opencode/` — must show all three.

### Step 2: Clone Product Repo

```bash
make init REPO=<product-repo-url>
```

**Verify:** `ls worktrees/main/.git` — must exist.

### Step 3: Generate AGENTS.md

```bash
make setup-repo
```

**Verify:**

```bash
wc -l AGENTS.md                        # must be > 80
grep "This is a placeholder" AGENTS.md  # must return nothing
```

**If verification fails** — you ARE the agent, generate it yourself:

1. Read config files in `worktrees/main/`: `package.json`, `Cargo.toml`, `go.mod`, `mix.exs`, `pyproject.toml`, `deno.json`, `Gemfile`, `Makefile`
2. Read 3–5 source files for import/naming patterns
3. Read 3–5 test files for test framework/patterns
4. Run `git log --oneline -20` in `worktrees/main/`
5. Write `AGENTS.md` at workspace root following the template in `.opencode/commands/setup-repo.md`

Required sections: Agent Pantheon, Repository Structure, Build/Lint/Test Commands, Code Style, Testing, Git Conventions, Architecture, Critical Rules. **Do NOT skip any. Do NOT leave placeholders.**

### Step 4: Machine Config

Check `~/.config/opencode/opencode.json` exists with at least one provider key:

```json
{
  "provider": {
    "anthropic": { "apiKey": "sk-ant-..." }
  }
}
```

If missing, ask user for their API key and create it. **Never commit this file.**

### Step 5: Post-Worktree Hook (Optional)

Create `hooks/post-worktree-create` for project-specific setup:

| Ecosystem | Hook Content |
|-----------|-------------|
| **Node.js** | `cd "$1" && npm install && cp ../main/.env .env 2>/dev/null \|\| true` |
| **Elixir** | `cd "$1" && mix deps.get && mix ecto.setup` |
| **Python** | `cd "$1" && pip install -e .` |
| **Rust** | `cd "$1" && cargo build` |
| **Go** | `cd "$1" && go mod download` |

```bash
chmod +x hooks/post-worktree-create
```

### Step 6: Verify

```bash
make help       # All targets visible
./pt --help     # CLI works
./pt --list     # Shows main worktree
```

### Step 7: Open Session

```bash
./pt
# OpenCode starts with Zeus. Press Tab to switch to Prometheus (plan) or Vulkanus (implement).
```

### Complete Example (Node.js)

```bash
gh repo create acme-workspace --template ihorkatkov/pantheon --private --clone
cd acme-workspace
make adopt REPO=git@github.com:acme/webapp.git
cat > hooks/post-worktree-create << 'EOF'
#!/bin/bash
cd "$1" && npm install && cp ../main/.env .env 2>/dev/null || true
EOF
chmod +x hooks/post-worktree-create
./pt
```

### Troubleshooting

| Symptom | Fix |
|---------|-----|
| `opencode: command not found` | Install from https://opencode.ai/docs/install |
| `make: command not found` | macOS: `xcode-select --install` · Linux: `sudo apt install make` |
| `Permission denied: ./pt` | `chmod +x pt setup-worktree` |
| AGENTS.md still placeholder | Generate manually (Step 3 fallback above) |
| Wrong agents loading | Use `./pt`, not `opencode` directly — pt sets `OPENCODE_CONFIG_DIR` |

</details>

---

## Links

[Agent Catalog](docs/agents.md) · [Configuration](docs/configuration.md) · [Cheatsheet](docs/CHEATSHEET.md) · [Contributing](CONTRIBUTING.md)

---

MIT © ihorkatkov
