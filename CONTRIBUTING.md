# Contributing

Pantheon improves through use. If you improve an agent prompt, fix a workflow, or add a useful command — open a PR.

---

## What to Contribute

**Agent improvements** — edit files in `.opencode/agents/`

The highest-value contributions. Include:
- What behavior changed
- Why it's better
- Before/after example of agent output (paste a real session if possible)

**New commands** — add files to `.opencode/commands/`

Slash commands that capture reusable workflows. Include a description and example invocation in the PR.

**Documentation** — edit files in `docs/`

Fix inaccuracies, add examples, improve clarity. No friction here.

**Bug fixes** — `pt`, `setup-worktree`, `Makefile`

Shell scripts and make targets. Include the reproduction case.

---

## Process

```bash
# 1. Fork and clone
gh repo fork ihorkatkov/pantheon --clone
cd pantheon

# 2. Make your changes
$EDITOR .opencode/agents/vulkanus.md

# 3. Test it
./pt --list   # verify CLI works

# 4. Open a PR
gh pr create --title "agent(vulkanus): ..." --body "..."
```

---

## Agent PR Format

```
agent(vulkanus): tighten TDD gate — reject implementation without failing test

Before: Vulkanus would sometimes write implementation first when the task description
        was clear enough. This caused test coverage gaps.

After:  Now explicitly checks for a failing test before writing any production code.
        Added anti-pattern: "never write production code without a red test."

Tested on: Neno invoice parser (Elixir), 3 feature branches.
```

---

## What Not to Change

- `AGENTS.md` — this is auto-generated per project, not shared
- `worktrees/` — gitignored, local only
- `~/.config/opencode/opencode.json` — personal machine config, never committed

---

MIT © ihorkatkov
