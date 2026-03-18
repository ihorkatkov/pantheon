# AGENTS.md

Instructions for AI agents working in this repository.

## Agent Pantheon

This workspace uses a multi-agent system coordinated by **Zeus** (the master orchestrator):

### Primary Agents

| Agent | Role | When Used |
|-------|------|-----------|
| **Zeus** | Master Orchestrator | Default agent. Routes work to specialists |
| **Prometheus** | Strategic Planner | Complex planning, requirements gathering |
| **Vulkanus** | TDD Implementer | Code changes, bug fixes, validation |
| **Mnemosyne** | System Cartographer | Research, documentation |
| **Oracle** | Architecture Advisor | Hard debugging, design decisions |
| **Argus** | Adversarial Reviewer | Pre-landing quality gate |

### Utility Agents

| Agent | Role |
|-------|------|
| **Explore** | Contextual grep — "Where is X?" |
| **Codebase Locator** | Find files and directories |
| **Codebase Analyzer** | Understand how code works |
| **Codebase Pattern Finder** | Find similar implementations |
| **Librarian** | External library docs |
| **Frontend Engineer** | UI/UX implementation |
| **Document Writer** | Technical documentation |
| **Translator** | Translation and i18n |
| **Thoughts Locator** | Find research documents |
| **Thoughts Analyzer** | Analyze research insights |

### Hunter Agents (dispatched by Argus)

| Agent | Role |
|-------|------|
| **Hunter Silent Failure** | Finds swallowed errors |
| **Hunter Type Design** | Finds type invariant violations |
| **Hunter Security** | Finds security vulnerabilities |
| **Hunter Code Review** | Finds convention violations |
| **Hunter Simplifier** | Simplifies code with proof |
| **Hunter Comments** | Audits comment accuracy |
| **Hunter Test Coverage** | Fills test coverage gaps |

---

<!-- PROJECT_CONFIG_START -->
## Project Configuration

> ⚠️ **Not configured yet.** Run `make setup-repo` to detect your project's stack and fill this section.

### Validation
<!-- The primary command agents must run before committing -->

### Testing
<!-- How to run tests: all, single file, filtered -->

### Linting & Formatting
<!-- Lint, format, type-check commands -->

### Development
<!-- Dev server, database, asset commands -->

### Repository Structure
<!-- Directory layout with descriptions -->

### Code Style
<!-- Import patterns, naming, error handling conventions -->

### Git Conventions
<!-- Branch naming, commit message patterns -->

### Critical Rules
1. Ask for clarification rather than making assumptions
2. Make smallest reasonable changes — don't refactor unrelated code
3. All changes need tests
<!-- PROJECT_CONFIG_END -->
