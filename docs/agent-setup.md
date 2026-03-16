# Setup Guide for AI Agents

> This document is written **for AI agents**. If a user says "set up Pantheon for my project" and points you here, follow these steps end-to-end. No other context is needed.

---

## Key Facts (Read First)

- **Pantheon is a workspace shell.** It wraps a product repo — it does NOT live inside one.
- **Product code lives in `worktrees/main/`** — a git worktree of the user's product repo.
- **`.opencode/`** contains all 23 agent definitions. Edit these files to customize agent behavior.
- **`AGENTS.md` at the workspace root** teaches all 23 agents your project's stack, commands, and conventions.
- **OpenCode traverses up** from `worktrees/main/` and loads `AGENTS.md` at the workspace root automatically.
- **`pt`** is a thin shell script that sets `OPENCODE_CONFIG_DIR` and calls `opencode`. It is the primary entrypoint.

---

## Prerequisites Check

```bash
git --version       # Recovery: https://git-scm.com/
gh --version        # Recovery: https://cli.github.com/ or use Path B below
make --version      # Recovery: xcode-select --install (macOS) / sudo apt install make (Linux)
opencode --version  # Recovery: https://opencode.ai/docs/install
ssh -T git@github.com  # Recovery: gh auth login OR add SSH key at github.com/settings/keys
```

Determine from the user:
- **Product repo URL** — e.g. `git@github.com:org/my-product.git`
- **Workspace name** — defaults to `<product-repo-name>-workspace`
- **Workspace location** — defaults to `~/Projects/<workspace-name>/`

---

## Step 1: Create Workspace from Template

**Path A — GitHub CLI (preferred):**
```bash
gh repo create <workspace-name> --template ihorkatkov/pantheon --private --clone
cd <workspace-name>
```

**Path B — Direct clone:**
```bash
git clone https://github.com/ihorkatkov/pantheon.git <workspace-name>
cd <workspace-name>
rm -rf .git && git init && git add -A
git commit -m "chore: initialize workspace from pantheon template"
```

**Verify:**
```bash
ls Makefile pt .opencode/   # must show all three
```

---

## Step 2: Clone Product Repo

```bash
make init REPO=<user's-product-repo-url>
```

**Verify:**
```bash
ls worktrees/main/.git   # must exist
```

---

## Step 3: Generate Project-Specific AGENTS.md

```bash
make setup-repo
```

**Verify:**
```bash
wc -l AGENTS.md                        # must be > 80 lines
grep "This is a placeholder" AGENTS.md  # must return nothing
```

**If verification fails — generate AGENTS.md yourself:**

1. Read config files: `package.json`, `Cargo.toml`, `go.mod`, `mix.exs`, `pyproject.toml`, `.github/workflows/`
2. Read 3–5 source files for import patterns and naming conventions
3. Read 3–5 test files for test framework and patterns
4. Run `git log --oneline -20` in `worktrees/main/` for commit patterns
5. Write `AGENTS.md` following the template in `.opencode/commands/setup-repo.md`

Required sections: Agent Pantheon, Repository Structure, Build/Lint/Test Commands, Code Style Guidelines, Naming Conventions, Error Handling, Testing, Git Conventions, Architecture Quick Reference, Critical Rules.

Do NOT skip any section. Do NOT leave placeholders.

---

## Step 4: Configure OpenCode (Machine Config)

`~/.config/opencode/opencode.json` — never committed, personal only:

```json
{
  "provider": {
    "anthropic": {
      "apiKey": "sk-ant-..."
    }
  }
}
```

---

## Step 5: (Optional) Post-Worktree Hook

```bash
mkdir -p hooks
# Choose template for user's ecosystem and write to hooks/post-worktree-create
chmod +x hooks/post-worktree-create
```

Templates: [configuration.md → Post-Worktree Hook](configuration.md#post-worktree-hook)

---

## Step 6: Verify

```bash
make help          # all make targets visible
./pt --help        # CLI functional
./pt --list        # shows: main (main) [default]
grep -c "" AGENTS.md  # must be > 80
```

---

## Step 7: Open a Session

```bash
./pt
# OpenCode starts in worktrees/main/ with all 23 agents
# Press Tab to switch to Prometheus (planning) or Vulkanus (implementation)
```

---

## Complete Example (Node.js / acme/webapp)

```bash
gh repo create acme-workspace --template ihorkatkov/pantheon --private --clone
cd acme-workspace
make init REPO=git@github.com:acme/webapp.git
make setup-repo
mkdir -p hooks
cat > hooks/post-worktree-create << 'EOF'
#!/bin/bash
cd "$1" && npm install && cp ../main/.env .env 2>/dev/null || true
EOF
chmod +x hooks/post-worktree-create
./pt
```

---

## Troubleshooting

| Symptom | Cause | Fix |
|---------|-------|-----|
| `opencode: command not found` | Not installed | https://opencode.ai/docs/install |
| `make: command not found` | Not on PATH | `xcode-select --install` / `sudo apt install make` |
| `Permission denied: ./pt` | Not executable | `chmod +x pt setup-worktree` |
| `worktrees/main/ already exists` | Step 2 already done | Skip to Step 3 |
| `AGENTS.md` still has placeholder | `/setup-repo` failed | Generate manually (see Step 3 fallback) |
| Agents unaware of project | AGENTS.md stale | `make setup-repo` |
| Wrong agents loading | `OPENCODE_CONFIG_DIR` not set | Always use `./pt`, not `opencode` directly |
| `ssh: Could not resolve github.com` | No SSH config | `gh auth login` or add SSH key |
