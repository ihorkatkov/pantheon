# Configuration

---

## Configuration Layers

| Layer | Location | What It Contains | Shared? |
|-------|----------|------------------|---------|
| **Machine** | `~/.config/opencode/opencode.json` | API keys, MCP servers, themes | No — personal only |
| **Workspace** | `.opencode/` | Agents, commands, skills, project settings | **Yes** — tracked in git |
| **Project** | `AGENTS.md` (workspace root) | Build commands, conventions, architecture | **Yes** — tracked in git |
| **Product** | `worktrees/main/CLAUDE.md` (optional) | Additional product-specific notes | Yes — in your product repo |

---

## Machine Configuration

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

Supported provider keys: `anthropic`, `openai`, `google`, `groq`. At least one is required.

> **Note**: This file contains secrets — never commit it.

### Optional MCP Servers

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

## How AGENTS.md Works

OpenCode traverses **up** from the working directory, collecting all `AGENTS.md` and `CLAUDE.md` files it finds:

```
pantheon-workspace/
├── AGENTS.md                  ← Found by traversing UP (workspace context)
└── worktrees/
    └── main/
        ├── CLAUDE.md          ← Found in cwd (product context, if exists)
        └── (your product code)
```

The `make adopt` command generates `AGENTS.md` by inspecting your product repo. This is the most important step — it teaches all 23 agents how your specific project works.

---

## Customization

### Edit Existing Agents

All agents are plain Markdown files in `.opencode/agents/`. Edit them directly:

```bash
$EDITOR .opencode/agents/vulkanus.md
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

### Add New Commands

Create a file in `.opencode/commands/`:

```markdown
---
description: What this slash command does.
---

# /my-command

Instructions for the AI when this command is invoked...
```

### Post-Worktree Hook

When `pt --new` creates a worktree, it runs `hooks/post-worktree-create` if it exists:

```bash
mkdir -p hooks
cp hooks/post-worktree-create.example hooks/post-worktree-create
chmod +x hooks/post-worktree-create
```

**Node.js:**
```bash
#!/bin/bash
cd "$1" && npm install && cp ../main/.env .env 2>/dev/null || true
```

**Elixir/Phoenix:**
```bash
#!/bin/bash
cd "$1" && mix deps.get && mix ecto.setup
```

**Symlink thoughts/ into worktree:**
```bash
#!/bin/bash
PANTHEON_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ln -sf "$PANTHEON_ROOT/thoughts" "$1/thoughts"
```

---

## Updating

```bash
make update
```

Merges upstream Pantheon improvements while preserving your customizations. Your agents, commands, and `AGENTS.md` are never overwritten.

---

## Troubleshooting

### Wrong agents loading

```bash
export OPENCODE_CONFIG_DIR="/path/to/your-workspace/.opencode"
opencode
```

### AGENTS.md not loading

```bash
ls AGENTS.md       # must exist at workspace root
make setup-repo    # regenerate if missing or stale
```

### MCP servers not connecting

```bash
cat ~/.config/opencode/opencode.json | jq '.mcp'
```

### Where research docs go

Agents write to `thoughts/` relative to their working directory (`worktrees/main/`). To keep them in the workspace:

```bash
# hooks/post-worktree-create
PANTHEON_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ln -sf "$PANTHEON_ROOT/thoughts" "$1/thoughts"
```
