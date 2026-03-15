---
description: Inspect your product repository and generate a project-specific AGENTS.md
---

# /setup-repo

You are setting up a Pantheon workspace for a new project. Your job is to inspect the product repository in the current worktree and generate a comprehensive AGENTS.md that gives all AI agents the context they need.

## What You Do

1. **Discover the ecosystem** — identify languages, frameworks, build tools, test runners
2. **Map the structure** — directories, entry points, key files
3. **Extract conventions** — code style, naming, imports, error handling patterns
4. **Generate AGENTS.md** — write a complete project context file

## Inspection Strategy

### Step 1: Identify the Stack
Read configuration files to determine the tech stack:
- `package.json`, `deno.json`, `Cargo.toml`, `go.mod`, `pyproject.toml`, `setup.py`, `requirements.txt`, `Gemfile`, `pom.xml`, `build.gradle`, etc.
- TypeScript configuration: `tsconfig.json`, `tsconfig.*.json`
- Framework indicators (Next.js, Rails, Django, FastAPI, Spring, etc.)
- Test runner and test patterns
- CI/CD configuration (.github/workflows/, .gitlab-ci.yml, .circleci/, etc.)

### Step 2: Map the Structure
- List top-level directories and their purposes
- Identify entry points (main files, route files, server files)
- Find configuration files
- Locate test directories and test file patterns

### Step 3: Extract Conventions
- Read existing README.md, CONTRIBUTING.md, or style guides
- Analyze 3-5 source files for patterns (imports, naming, structure)
- Check linter/formatter configs (`.eslintrc`, `.eslintrc.json`, `.prettierrc`, `tsconfig.json`, `rustfmt.toml`, `pyproject.toml` tool sections, etc.)
- Look at existing tests for testing patterns and frameworks
- Check git history for commit message conventions

### Step 4: Write AGENTS.md
Write the file at the WORKSPACE ROOT (two levels up from the worktree, or check where the current AGENTS.md placeholder is). Use this structure:

```
# AGENTS.md

Instructions for AI agents working in this repository.

## Agent Pantheon

[Copy the agent tables from the existing placeholder AGENTS.md — keep them as-is]

## Repository Structure

[Describe the directory layout discovered in Step 2]
[Use a tree diagram]

## Build/Lint/Test Commands

### Validation
[The primary validation command — what agents should run before committing]

### Testing
[Test commands with examples: run all, run single file, run with filter]

### Linting & Formatting
[Lint, format, type-check commands]

### Development
[Dev server commands if applicable]

## Code Style Guidelines

### Formatting
[Discovered formatting rules — tabs vs spaces, semicolons, quotes, line width]

### Imports
[Import patterns discovered from source files — with examples]

### Naming Conventions
[File naming, variable naming, type naming patterns]

### Error Handling
[Error handling patterns observed in the codebase]

## Testing

[Test framework, test file naming, example test structure from real tests]

## Git Conventions

### Branch Naming
[Discovered from git history or CONTRIBUTING.md — or suggest a sensible default]

### Commit Messages
[Discovered patterns — conventional commits, etc.]

## Architecture Quick Reference

### Key Files
[Important entry points and their purposes]

### Package/Module Structure
[How the codebase is organized]

## Critical Rules

1. Ask for clarification rather than making assumptions
2. Make smallest reasonable changes — don't refactor unrelated code
3. Never implement mock modes — use real data/APIs
4. Test output must be pristine — no unexpected logs or errors
5. All changes need tests
[Add any project-specific rules discovered]
```

### Step 5: Verify
- Ensure all referenced commands actually exist in package.json/deno.json/Makefile/etc.
- Check that file paths in AGENTS.md actually exist
- Confirm the structure description matches reality

## Important Notes

- Be thorough — agents need actionable information, not vague descriptions
- Include REAL command examples with actual flags and options
- Reference REAL file paths from the repository
- If something is unclear, note it as "TBD — verify with team"
- The generated AGENTS.md replaces the placeholder at the workspace root
- Do NOT modify any agent definitions in .opencode/agents/
- Do NOT modify any files in the product repository itself
