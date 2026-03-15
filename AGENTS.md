# AGENTS.md

> **This is a placeholder.** Run `/setup-repo` (or `make setup-repo`) to generate a project-specific version.

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

## Project Setup

> **⚠️ Replace this section** by running `/setup-repo` or `make setup-repo`.
> The command will inspect your repository and generate project-specific content below.

### Repository Structure
<!-- /setup-repo will fill this -->

### Build/Lint/Test Commands
<!-- /setup-repo will fill this -->

### Code Style Guidelines
<!-- /setup-repo will fill this -->

### Testing
<!-- /setup-repo will fill this -->

### Git Conventions
<!-- /setup-repo will fill this -->

### Architecture Quick Reference
<!-- /setup-repo will fill this -->

### Critical Rules
1. Ask for clarification rather than making assumptions
2. Make smallest reasonable changes
3. All changes need tests
