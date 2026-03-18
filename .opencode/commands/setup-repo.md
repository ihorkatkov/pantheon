---
description: Inspect your product repository and fill the Project Configuration section of AGENTS.md
---

# /setup-repo

**Your job: inspect the product repository and fill the Project Configuration section of AGENTS.md.**

The AGENTS.md file already exists at the workspace root (`$PANTHEON_ROOT/AGENTS.md` or `../../AGENTS.md`). It has agent tables at the top (DO NOT TOUCH) and a Project Configuration section marked by HTML comments. You replace ONLY the content between `<!-- PROJECT_CONFIG_START -->` and `<!-- PROJECT_CONFIG_END -->`.

## Hard Rules

- **Do NOT** run any install, build, or test commands (`npm install`, `mix deps.get`, `pip install`, `cargo build`, etc.)
- **Do NOT** modify any files in the product repository
- **Do NOT** modify any content above `<!-- PROJECT_CONFIG_START -->`
- **Do NOT** remove the `<!-- PROJECT_CONFIG_START -->` or `<!-- PROJECT_CONFIG_END -->` markers
- You READ the repo, then UPDATE one section of one file. Nothing else.

## Step 1: Inspect the Repo

Read configuration files to identify the stack (do NOT execute anything):

- `package.json`, `deno.json`, `tsconfig.json` → Node.js / Deno / TypeScript
- `Cargo.toml` → Rust
- `go.mod` → Go
- `pyproject.toml`, `setup.py`, `requirements.txt` → Python
- `mix.exs` → Elixir
- `Gemfile` → Ruby
- `pom.xml`, `build.gradle` → Java
- `Makefile`, `Justfile` → Build system
- `.github/workflows/`, `.gitlab-ci.yml`, `.circleci/` → CI/CD

Then read:
- 3-5 source files for import/naming patterns
- 3-5 test files for test framework and patterns
- Formatter/linter configs
- `git log --oneline -20` for commit conventions

## Step 2: Write the Project Configuration

Read the existing `$PANTHEON_ROOT/AGENTS.md` (or `../../AGENTS.md`). Find the `<!-- PROJECT_CONFIG_START -->` marker. Replace everything from that marker through `<!-- PROJECT_CONFIG_END -->` with:

```
<!-- PROJECT_CONFIG_START -->
## Project Configuration

### Validation
\`\`\`bash
[THE primary command to run before committing — e.g., mix precommit, npm run lint && npm test, cargo clippy && cargo test]
\`\`\`

Agents MUST run this before committing any changes.

### Testing
\`\`\`bash
# Run all tests
[command]

# Run a single test file
[command path/to/test]

# Run a specific test
[command with filter/line number]
\`\`\`

- **Framework**: [name]
- **Test file naming**: [pattern]
- **Test helpers/setup**: [what's available]

### Linting & Formatting
\`\`\`bash
# Format code
[command]

# Check formatting
[command]

# Lint / compile check
[command]
\`\`\`

### Development
\`\`\`bash
# Start dev server
[command]

# Database setup/migration
[command]

# Install dependencies
[command]
\`\`\`

### Repository Structure
\`\`\`
[directory tree with one-line descriptions]
\`\`\`

### Code Style
- **Formatting**: [tabs/spaces, width, key rules]
- **Imports**: [patterns with examples from the repo]
- **Naming**: [files, modules, functions, variables]
- **Error handling**: [patterns observed]

### Git Conventions
- **Branches**: [pattern]
- **Commits**: [pattern from git log]

### Critical Rules
1. Ask for clarification rather than making assumptions
2. Make smallest reasonable changes — don't refactor unrelated code
3. All changes need tests
[ADD: 3-10 project-specific rules discovered from the codebase]
<!-- PROJECT_CONFIG_END -->
```

**IMPORTANT**: Fill every section with REAL commands and patterns from the repo. No placeholders, no "TBD", no "[fill this]".

## Step 3: Verify

After writing:
1. Read back AGENTS.md and confirm the agent tables above the marker are unchanged
2. Confirm the Project Configuration section has all subsections filled
3. Confirm the markers `<!-- PROJECT_CONFIG_START -->` and `<!-- PROJECT_CONFIG_END -->` are present
4. Report: "AGENTS.md updated with [stack] configuration"
