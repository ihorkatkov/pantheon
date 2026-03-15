# Pantheon Cheatsheet

Quick reference for everything you need day-to-day.

---

## `pt` CLI

```
pt [worktree] [options]
```

| Command | Description |
|---------|-------------|
| `pt` | Open OpenCode in `main/` (default) |
| `pt <worktree>` | Open OpenCode in specified worktree |
| `pt -p "message"` | Run a prompt non-interactively in `main/` |
| `pt <worktree> -p "msg"` | Run a prompt non-interactively in specified worktree |
| `pt --list` | List all available worktrees |
| `pt --new <name> [branch]` | Create new worktree and open OpenCode |
| `pt --remove <name>` | Remove a worktree (asks for confirmation) |
| `pt --remove <name> --force` | Remove without confirmation |
| `pt --prune` | Prune stale worktree references |
| `pt --help` | Show help |

**Aliases**: `-l` = `--list`, `-n` = `--new`, `-r` = `--remove`, `-p` = `--prompt`, `-h` = `--help`

**Shell alias** (add to `~/.zshrc`):
```bash
alias pt='/path/to/workspace/pt'
```

---

## `make` Targets

```bash
make help           # Show all targets with descriptions
```

| Target | Description |
|--------|-------------|
| `make init` | Clone your product repo into `worktrees/main/` |
| `make setup-repo` | Generate project-specific AGENTS.md by inspecting your repo |
| `make open` | Open OpenCode in `main/` |
| `make open wt=<name>` | Open OpenCode in a named worktree |
| `make worktree name=<name> branch=<branch>` | Create a new worktree |
| `make list` | List available worktrees |
| `make clean name=<name>` | Remove a worktree |
| `make update` | Check for Pantheon updates and merge intelligently |

---

## Slash Commands

Available as `/command` in any OpenCode session:

| Command | Description |
|---------|-------------|
| `/create-plan` | Interactively create an implementation plan. Researches codebase first, asks batched questions, saves plan to `thoughts/tasks/`. |
| `/implement-plan` | Execute an approved plan from `thoughts/tasks/`. Follows TDD gates (RED→GREEN→VALIDATE). Update checkboxes as phases complete. |
| `/update-plan` | Iterate on an existing plan. Provide path + feedback; agent researches and updates surgically. |
| `/research-codebase` | Invoke Mnemosyne to document what currently exists. Creates research doc in `thoughts/research/`. |
| `/setup-repo` | Inspect your product repo and generate a project-specific AGENTS.md at the workspace root. |
| `/update` | Merge upstream Pantheon improvements while preserving your customizations. |

---

## Agent Quick Reference

Switch agents with **Tab** in OpenCode, or invoke with `@agent-name`.

### Primary Agents (Tab to switch)

| Agent | One-line purpose | When to Use |
|-------|-----------------|-------------|
| **zeus** | Master orchestrator | Default. Routes work, delegates to specialists |
| **prometheus** | Strategic planner | "Plan how to implement X", complex multi-phase work |
| **vulkanus** | TDD implementer | "Build X", "Fix X", any code change |
| **mnemosyne** | System cartographer | "Where is X?", "How does Y work?", "Research Z" |
| **oracle** | Architecture advisor | "Should I use A or B?", hard debugging |
| **argus** | Adversarial reviewer | "Review this before I ship", quality gate |
| **librarian** | External researcher | "How does library X work?", official docs |
| **frontend-engineer** | UI/UX implementer | "Build this UI", visual components |
| **document-writer** | Technical writer | "Write docs for X", README, API docs |
| **translator** | Translation specialist | "Translate to French", i18n strings |

### Utility Agents (@name to invoke)

| Agent | One-line purpose |
|-------|-----------------|
| **@explore** | "Find where auth is implemented" — broad codebase search |
| **@codebase-locator** | Find all files for a feature (paths only, no analysis) |
| **@codebase-analyzer** | Understand HOW specific files/functions work (with line refs) |
| **@codebase-pattern-finder** | Find examples — "how is pagination done here?" |
| **@thoughts-locator** | Find research docs in `thoughts/` by topic |
| **@thoughts-analyzer** | Extract key decisions and constraints from `thoughts/` docs |

### Hunter Agents (dispatched by Argus)

| Agent | Catches |
|-------|---------|
| **hunter-silent-failure** | Swallowed errors, empty catches, `.?` hiding failures |
| **hunter-type-design** | Invalid states constructable at runtime |
| **hunter-security** | Auth bypasses, tenant leaks, IDOR |
| **hunter-code-review** | AGENTS.md violations, logic bugs |
| **hunter-simplifier** | Unnecessary complexity (applies refactors, proves with tests) |
| **hunter-comments** | Factually wrong, stale, or temporal comments |
| **hunter-test-coverage** | Critical untested paths (error handling, edge cases) |

---

## Common Workflows

### "I want to start a new feature"

```bash
# 1. Create a worktree for your ticket
pt --new my-feature my/branch-name

# 2. Open it
pt my-feature

# 3. Start planning (or implement directly for small changes)
# In OpenCode:
#   Tab → Prometheus: "Plan how to implement X"
#   or
#   Tab → Vulkanus: "Implement X"
```

### "I want to research the codebase"

```bash
pt            # or pt my-feature

# In OpenCode (any of these):
/research-codebase "where is the authentication flow?"
# or
# Tab → Mnemosyne: "Explain the billing system"
# or
# @mnemosyne "Where is invoice parsing?"
```

### "I want to plan a complex task"

```bash
pt

# In OpenCode:
/create-plan
# → Provide task description
# → Prometheus researches codebase in parallel
# → Answers your batched questions
# → Generates plan in thoughts/tasks/
# → You approve, then implement

# Or invoke Prometheus directly:
# Tab → Prometheus: "Plan adding webhook support"
```

### "I want to review code quality before shipping"

```bash
pt my-feature

# In OpenCode:
# Zeus: "let's land the plane"
# → Zeus invokes Argus
# → Argus dispatches all 7 hunters in parallel
# → Each finding proved by failing test
# → Report: CLEAR TO LAND or BUGS FOUND

# Or invoke Argus directly:
# @argus "Review the current changes"
```

### "I want to ship / land my changes"

```bash
pt my-feature

# In OpenCode:
# Zeus: "let's land the plane"
# or
# Vulkanus: "let's land the plane"

# This triggers:
# 1. Argus adversarial review
# 2. If clear: git commit → git push → gh pr create
# 3. PR description generated
```

### "I want to look up external library docs"

```bash
pt

# In OpenCode:
# @librarian "How does React Query handle background refetching?"
# @librarian "Show me the source for TanStack Router's loader API"
```

---

## Directory Quick Reference

```
workspace/
├── .opencode/agents/     # Edit agents here
├── .opencode/commands/   # Add slash commands here
├── .opencode/skills/     # Add skills here
├── worktrees/main/       # Your product repo (main branch)
├── worktrees/<name>/     # Feature worktrees
├── thoughts/research/    # Mnemosyne's research output
├── thoughts/tasks/       # Prometheus's plan files
├── AGENTS.md             # Project context for all agents (generated)
└── .pantheon-version     # Version tracking
```

---

## Key Files

| File | Purpose |
|------|---------|
| `AGENTS.md` | Project context: build commands, conventions, architecture. Read by every agent. Generated by `/setup-repo`. |
| `thoughts/tasks/*/plan.md` | Implementation plans from Prometheus |
| `thoughts/research/*.md` | Research documents from Mnemosyne |
| `.opencode/opencode.jsonc` | Workspace-level OpenCode config (default agent, MCP servers) |
| `~/.config/opencode/opencode.json` | Machine-level config (API keys) — never commit |

---

## TDD Gates (Vulkanus)

| Gate | What Happens | Done When |
|------|-------------|-----------|
| **RED** | Write a failing test | Test fails for the right reason |
| **GREEN** | Write minimal implementation | All tests pass |
| **VALIDATE** | Run full validation suite | lint + fmt + type-check + tests all pass |
| **REFACTOR** | Consult @oracle, apply improvements, re-validate | Code is clean, consistent, simple |

**Never skip a gate. Never delete tests to pass them.**

---

## Argus Verdict Reference

| Verdict | Meaning | Action |
|---------|---------|--------|
| `CLEAR TO LAND` | No verified bugs | Proceed to commit/push/PR |
| `BUGS FOUND` | ≤5 verified failing tests | Fix with Vulkanus, re-run Argus (once) |
| `CIRCUIT BREAKER TRIGGERED` | >5 verified bugs | STOP — human review required |
