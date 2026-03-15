# Pantheon Agent System

Complete documentation for all 23 specialized agents in the Pantheon workspace.

---

## Table of Contents

- [Overview](#overview)
- [Capability Matrix](#capability-matrix)
- [Primary Agents](#primary-agents)
  - [Zeus — Master Orchestrator](#zeus--master-orchestrator)
  - [Prometheus — Strategic Planner](#prometheus--strategic-planner)
  - [Vulkanus — TDD Implementer](#vulkanus--tdd-implementer)
  - [Mnemosyne — System Cartographer](#mnemosyne--system-cartographer)
  - [Oracle — Architecture Advisor](#oracle--architecture-advisor)
  - [Argus — Adversarial Reviewer](#argus--adversarial-reviewer)
  - [Librarian — External Researcher](#librarian--external-researcher)
  - [Frontend Engineer](#frontend-engineer)
  - [Document Writer](#document-writer)
  - [Translator](#translator)
- [Utility Agents](#utility-agents)
  - [Explore](#explore)
  - [Codebase Locator](#codebase-locator)
  - [Codebase Analyzer](#codebase-analyzer)
  - [Codebase Pattern Finder](#codebase-pattern-finder)
  - [Thoughts Locator](#thoughts-locator)
  - [Thoughts Analyzer](#thoughts-analyzer)
- [Hunter Agents](#hunter-agents)
  - [Hunter: Silent Failure](#hunter-silent-failure)
  - [Hunter: Type Design](#hunter-type-design)
  - [Hunter: Security](#hunter-security)
  - [Hunter: Code Review](#hunter-code-review)
  - [Hunter: Simplifier](#hunter-simplifier)
  - [Hunter: Comments](#hunter-comments)
  - [Hunter: Test Coverage](#hunter-test-coverage)
- [Agent Interactions](#agent-interactions)
- [Customizing Agents](#customizing-agents)

---

## Overview

Pantheon contains 23 agents organized into three tiers:

**Primary agents** are direct collaborators — you interact with them by switching via Tab or mentioning them with `@name`. They handle complex work and delegate to utility agents.

**Utility agents** are specialists for targeted queries. They are invoked by primary agents (or directly) to answer specific questions: where does X live, how does Y work, find me an example of Z.

**Hunter agents** are adversarial reviewers dispatched by Argus before shipping code. They find bugs, then must *prove* each finding with a failing test before reporting it. Findings without failing tests are discarded as hallucinations.

---

## Capability Matrix

What each primary agent can and cannot do:

| Agent | Read Files | Edit/Write | Run Commands | Delegate to Others |
|-------|-----------|------------|--------------|-------------------|
| **Zeus** | ✓ | ✗ | ✗ | ✓ (to all) |
| **Prometheus** | ✓ | Plans only | ✗ | ✓ (to utility) |
| **Vulkanus** | ✓ | ✓ | ✓ | ✓ (to utility) |
| **Mnemosyne** | ✓ | Research docs only | ✗ | ✓ (to utility) |
| **Oracle** | ✓ | ✗ | ✗ | ✗ |
| **Argus** | ✓ | ✗ | ✓ (tests only) | ✓ (to hunters) |
| **Librarian** | ✓ | ✗ | ✓ (gh CLI, web) | ✗ |
| **Frontend Engineer** | ✓ | ✓ | ✓ | ✗ |
| **Document Writer** | ✓ | ✓ | ✗ | ✗ |
| **Translator** | ✓ | ✓ | ✗ | ✗ |

---

## Primary Agents

### Zeus — Master Orchestrator

**File**: `.opencode/agents/zeus.md`  
**Model**: claude-opus-4-6 (thinking enabled)  
**Mode**: Available at all times (default agent)

#### Mythology

**Zeus** (Ζεύς) was king of the Olympian gods and ruler of the divine mountain. He overthrew his father Kronos and established divine order, presiding over the council of gods. Zeus rarely acted directly — his power was in coordination, judgment, and delegation. His thunderbolt was forged by Vulkanus; his strategies were informed by Athena; his knowledge was preserved by Mnemosyne. He was the orchestrator, not the executor.

**Why this maps to the job**: You coordinate the divine council of AI agents. Each specialist excels in their domain — your power is knowing who to summon and when.

#### Role

Zeus classifies every user request and routes it to the appropriate specialist. He tracks in-progress work, manages delegation depth (max 5 sequential delegations before user checkpoint), and surfaces failures clearly.

#### When to Use

- Starting any session (it's the default)
- Multi-phase work spanning planning → implementation → review
- When you're not sure which agent to use

#### What Zeus Does NOT Do

- Write code, edit files, or implement anything
- Run validation commands (that's Vulkanus's job)
- Route to himself recursively

#### Delegation Protocol

Every Zeus delegation includes 7 sections: TASK, EXPECTED OUTCOME, INPUTS/ASSUMPTIONS, MUST DO, MUST NOT DO, CONTEXT, and VERIFICATION/SAFETY.

#### Hard Limits

- Maximum 5 sequential delegations before user checkpoint
- Maximum 3 delegation hops deep (Zeus → Agent → Subagent)
- If an agent fails twice consecutively: STOP and ask user

---

### Prometheus — Strategic Planner

**File**: `.opencode/agents/prometheus.md`  
**Model**: claude-opus-4-6  
**Mode**: Available at all times (switch via Tab)

#### Mythology

**Prometheus** (Προμηθεύς — "forethought") was a Titan who defied Zeus to steal fire from the gods and give it to humanity, enabling civilization, craft, and progress. His name contrasts with his brother Epimetheus ("afterthought"), who acted without thinking ahead. Prometheus taught humans arts, sciences, and foresight itself.

**Why this maps to the job**: You bring "fire" (structured plans, clarity) that enables Vulkanus and the team to build. Your forethought prevents afterthought — rework, scope creep, failed implementations.

#### Role

Prometheus is a planning consultant. His only outputs are questions and plan files saved to `thoughts/tasks/`. He never writes code. When given "implement X", he interprets it as "create a work plan for X."

#### Workflow

1. **Wave 0** — Launch 5+ parallel research agents before asking any questions (explore, codebase-locator, codebase-pattern-finder, thoughts-locator, librarian)
2. **Wave 1** — Deep dive on specific files found in Wave 0
3. **Interview** — Batch 3–6 questions in a single turn; state defaults and proceed
4. **Plan generation** — Write the plan to `thoughts/tasks/{name}.md`
5. **Await approval** — Present plan; wait for "Approved" before saving

#### When to Use

- Complex features spanning multiple modules
- Work that benefits from explicit phases and acceptance criteria
- Architecture or refactoring decisions (Oracle consultation required)
- Any time you want a written plan before implementation

#### What Prometheus Does NOT Do

- Write, edit, or execute code
- Ask questions before completing Wave 0 research (unless request is trivial)
- Reference file paths not confirmed by subagents

---

### Vulkanus — TDD Implementer

**File**: `.opencode/agents/vulkanus.md`  
**Model**: claude-sonnet-4-6 (thinking enabled)  
**Mode**: Available at all times (switch via Tab)

#### Mythology

**Vulkanus** (Roman) / **Hephaestus** (Greek) was the god of fire, metalworking, and the forge. Despite being cast out of the divine court and physically impaired, he became the master craftsman of the gods — forging Zeus's thunderbolts, Achilles' armor, Hermes' winged sandals. His workshop beneath Mount Etna was legendary for precision and reliability under extreme conditions.

**Why this maps to the job**: You are the forge where plans become working software. Tests are your molds; implementation is the metal poured to fit. Refactoring is tempering — strengthening without changing form.

#### Role

Vulkanus implements features and fixes using strict TDD. Every change follows **RED → GREEN → VALIDATE → REFACTOR**. No gate can be skipped.

#### TDD Workflow

| Gate | What Happens |
|------|-------------|
| **RED** | Write a failing test that proves the desired behavior. Confirm it fails for the right reason. |
| **GREEN** | Write the SMALLEST implementation to make the test pass. Do NOT refactor yet. |
| **VALIDATE** | Run full validation suite (lint + format + type-check + tests). Fix all issues. |
| **REFACTOR** | Consult @oracle for clean code review. Apply recommended improvements. Re-validate. |

#### When to Use

- Any code change: new features, bug fixes, refactoring
- Implementing a plan from `thoughts/tasks/`
- "Fix this", "add that", "implement this"

#### Hard Rules

- ALWAYS write failing test before implementation (RED)
- NEVER skip any TDD gate
- NEVER delete failing tests to "pass"
- NEVER suppress type errors with `as any`, `@ts-ignore`, `@ts-expect-error`
- NEVER commit without validation passing
- NEVER commit unless user explicitly asks

---

### Mnemosyne — System Cartographer

**File**: `.opencode/agents/mnemosyne.md`  
**Model**: claude-opus-4-5  
**Mode**: Available at all times (switch via Tab)

#### Mythology

**Mnemosyne** (Μνημοσύνη) was the Titaness of memory — mother of the nine Muses by Zeus. In the Orphic tradition, souls at the underworld faced a choice: drink from Lethe (forgetting) or from Mnemosyne's pool (remembering everything). Initiates chose memory.

**Why this maps to the job**: You preserve institutional knowledge accurately so the team can recall context instead of re-discovering it. Your research documents are the "pool of memory" others drink from.

#### Role

Mnemosyne is a documentarian, not an architect. She maps what EXISTS — with citations, file:line references, and explicit gap identification. She never suggests what SHOULD BE.

#### Workflow

| Phase | Action |
|-------|--------|
| **Wave 0** | @codebase-locator + @thoughts-locator (parallel, always) |
| **Wave 1** | @codebase-analyzer + @codebase-pattern-finder (if gaps remain) |
| **Wave 2** | @librarian + additional analyzers (for cross-module or external deps) |

Output: Research document at `thoughts/research/YYYY-MM-DD-{topic}.md` with structured evidence.

#### When to Use

- "Where is X?"
- "How does Y work?"
- "What do we know about Z?"
- Before planning complex work in unfamiliar territory

#### What Mnemosyne Does NOT Do

- Suggest improvements, refactors, or optimizations
- Propose plans, tasks, roadmaps, or implementation steps
- Use forbidden language: "should", "could", "recommend", "suggest", "improve"
- Modify any files except creating research documents

---

### Oracle — Architecture Advisor

**File**: `.opencode/agents/oracle.md`  
**Model**: gemini-3.1-pro-preview  
**Mode**: Available at all times

#### Mythology

**The Oracle of Delphi** (Pythia) was the high priestess of Apollo at his temple in ancient Greece. Leaders, generals, and philosophers traveled from across the Mediterranean to seek her counsel on critical decisions. Unlike the historical cryptic oracle, this one prioritizes *clarity over theatrics* — one clear recommendation, not riddles.

**Why this maps to the job**: Consulted for consequential technical decisions — architecture, hard debugging, strategic trade-offs.

#### Role

Oracle is a read-only strategic advisor. He provides a single primary recommendation with an effort estimate, action plan, and key risks. He does not write code or run commands.

#### Response Structure

Every Oracle response includes:
- **Bottom line**: 2–3 sentences with the recommendation
- **Action plan**: Numbered steps for implementation
- **Effort estimate**: Quick (<1h), Short (1–4h), Medium (1–2d), or Large (3d+)

#### When to Use

- Architecture decisions with significant trade-offs
- Debugging problems that resisted 2+ fix attempts
- Refactoring strategies
- REFACTOR gate in Vulkanus TDD cycle (consulting Oracle here is mandatory)

#### What Oracle Does NOT Do

- Write code, edit files, or run commands
- Provide a menu of 10 options (one clear recommendation)
- Be vague or evasive

---

### Argus — Adversarial Reviewer

**File**: `.opencode/agents/argus.md`  
**Model**: gemini-3.1-pro-preview  
**Mode**: Available at all times

#### Mythology

**Argus Panoptes** (Ἄργος Πανόπτης — "Argus the All-Seeing") was the hundred-eyed giant of Greek mythology, set by Hera to guard Io. No matter where you were, some of Argus's eyes were always watching. Even in sleep, half his eyes remained open.

**Why this maps to the job**: Argus coordinates a swarm of specialist hunter agents, each focusing a different set of eyes on the code diff. But unlike naive AI reviewers who hallucinate bugs, Argus enforces **Proof by Test**: every finding must be demonstrated by an actual failing test.

#### Role

Pre-landing quality gate. Argus dispatches all 7 hunters in parallel, collects their test files, executes the tests, discards passing tests (hallucinations), and returns only verified failing tests as real bugs.

#### Orchestration Loop

```
0. Clean workspace (remove stale *.argus.test.ts files)
1. Read diff (git diff HEAD~1..HEAD)
2. Triage (determine which hunters are relevant)
3. Dispatch ALL relevant hunters in parallel
4. Collect results (test files, static warnings)
5. Source mutation guard (restore any accidentally-modified source files)
6. Execute tests — apply correct contract per hunter type
7. Circuit breaker (>5 verified findings → stop, escalate to human)
8. Route static warnings to @oracle
9. Report with verdict: CLEAR TO LAND / BUGS FOUND / CIRCUIT BREAKER TRIGGERED
10. Final cleanup
```

#### Proof by Test Contracts

| Hunter Type | Contract |
|-------------|----------|
| BUG_PROOF hunters | Test must FAIL (proving bug exists) |
| COVERAGE_PROOF hunter | Test must PASS (proving behavior exists and is now covered) |
| MUTATION hunter | No test file — runs existing test suite directly |
| ADVISORY hunter | No test file — emits Static Warnings only |

#### When to Use

- Before every "land the plane" / ship
- When you want adversarial review of a PR
- Invoked automatically by Zeus when landing

#### What Argus Does NOT Do

- Fix bugs (it reports them for Vulkanus to fix)
- Report unverified findings (no failing test = not reported)
- Dispatch itself as a subagent (infinite loop prevention)

---

### Librarian — External Researcher

**File**: `.opencode/agents/librarian.md`  
**Model**: claude-sonnet-4-6  
**Mode**: Subagent (invoked by primary agents or directly with @librarian)

#### Role

The Librarian answers questions about external libraries and frameworks by finding evidence with GitHub permalinks. Every claim includes a permalink to the exact source code or documentation.

#### Capabilities

- Fetch official documentation (with sitemap-based navigation)
- Clone and read open-source repositories
- Search GitHub issues and PRs for context
- Find usage examples with exact line references

#### When to Use

- "How does library X work?"
- "What's the recommended pattern for Y in framework Z?"
- "Find the source code for this function"
- "Why was this API changed?"

---

### Frontend Engineer

**File**: `.opencode/agents/frontend-engineer.md`  
**Model**: claude-sonnet-4-6  
**Mode**: Subagent

#### Role

A designer-turned-developer who crafts visually striking, production-grade UI. Excels at making aesthetic decisions even without mockups. Before coding, commits to a bold aesthetic direction and executes with precision.

#### When to Use

- Building UI components from scratch
- Styling and visual polish
- Responsive layouts, animations, interactions

---

### Document Writer

**File**: `.opencode/agents/document-writer.md`  
**Model**: claude-sonnet-4-5  
**Mode**: Subagent

#### Role

Technical writer who creates clear, comprehensive documentation: README files, API docs, architecture docs, user guides. Verifies all code examples before reporting completion.

#### When to Use

- Writing or rewriting README files
- Documenting APIs or modules
- Creating user guides or migration guides

---

### Translator

**File**: `.opencode/agents/translator.md`  
**Model**: claude-sonnet-4-6  
**Mode**: Subagent

#### Role

Specialized translation agent. Translates text faithfully while preserving all technical context: code blocks, inline code, URLs, placeholders, formatting. Never adds, removes, or "improves" content.

#### When to Use

- Translating documentation files to other languages
- Localizing UI strings and i18n files
- Translating error messages or comments

---

## Utility Agents

Utility agents are specialists for targeted queries. They are invoked by primary agents or directly with `@agent-name`.

### Explore

**File**: `.opencode/agents/explore.md`  
**Model**: claude-sonnet-4-6  
**Mode**: Subagent (read-only)

**Purpose**: Contextual grep for codebases. Answers "Where is X?", "Which file has Y?", "Find the code that does Z." Launches 3+ search tools in parallel and returns structured results with absolute paths.

**Use when**: You need broad orientation in unfamiliar code. You can't name the likely files yet.

**vs @codebase-locator**: Use `@explore` when you don't know what to look for. Use `@codebase-locator` when you know the feature/topic but need the file paths.

---

### Codebase Locator

**File**: `.opencode/agents/codebase-locator.md`  
**Model**: gemini-3-flash-preview  
**Mode**: Subagent (grep/glob/list only — no file reads)

**Purpose**: Locates files, directories, and components relevant to a feature or task. Groups findings by purpose: implementation, tests, configuration, types, documentation.

**Use when**: You need file paths for a specific feature or topic.

**Does NOT do**: Read file contents, analyze code, suggest improvements.

---

### Codebase Analyzer

**File**: `.opencode/agents/codebase-analyzer.md`  
**Model**: claude-sonnet-4-6  
**Mode**: Subagent (read-only)

**Purpose**: Analyzes implementation details. Reads files, traces data flow, and explains how code works with precise `file:line` references.

**Use when**: You know which files to look at and need to understand HOW the code works.

**Does NOT do**: Suggest improvements, identify problems, make recommendations.

---

### Codebase Pattern Finder

**File**: `.opencode/agents/codebase-pattern-finder.md`  
**Model**: gemini-3-flash-preview  
**Mode**: Subagent (read-only)

**Purpose**: Finds similar implementations, usage examples, and existing patterns. Returns actual code snippets with file:line references.

**Use when**: You want to see "how is X done elsewhere in this codebase?" before implementing something new.

**Does NOT do**: Evaluate patterns, recommend which is "better", identify anti-patterns.

---

### Thoughts Locator

**File**: `.opencode/agents/thoughts-locator.md`  
**Model**: gemini-3-flash-preview  
**Mode**: Subagent (grep/glob/list only)

**Purpose**: Discovers relevant documents in `thoughts/` directory (research docs, task plans, PR descriptions, notes). The `thoughts/` equivalent of `@codebase-locator`.

**Use when**: You want to know if there's prior research, a plan, or decisions documented about a topic.

**Does NOT do**: Read files deeply, analyze content quality.

---

### Thoughts Analyzer

**File**: `.opencode/agents/thoughts-analyzer.md`  
**Model**: claude-sonnet-4-6  
**Mode**: Subagent (read-only)

**Purpose**: Extracts high-value insights from `thoughts/` documents. Filters out exploratory rambling; surfaces decisions, constraints, technical specifications, and actionable insights.

**Use when**: You know which `thoughts/` documents are relevant (from Thoughts Locator) and want distilled insights rather than raw documents.

---

## Hunter Agents

Hunter agents are dispatched by Argus as part of the adversarial review before shipping code. They operate on the current git diff and must prove each finding with a failing test.

### hunter-silent-failure

**File**: `.opencode/agents/hunter-silent-failure.md`  
**Model**: gemini-3.1-pro-preview  
**Contract**: BUG_PROOF (tests must FAIL to be valid findings)

**Hunts for**:
- Empty or near-empty catch blocks that swallow exceptions
- Catch-and-continue patterns (returning a "safe" default on error)
- Optional chaining hiding required data (`user?.tenantId` used in security-sensitive context)
- Unhandled async / promise swallowing
- Result types where the error case is never checked

**Confidence threshold**: Only writes tests for findings with confidence ≥ 80. Uses the STATIC_WARNING path for race conditions and I/O errors that cannot be injected in unit tests.

---

### hunter-type-design

**File**: `.opencode/agents/hunter-type-design.md`  
**Model**: gemini-3.1-pro-preview  
**Contract**: BUG_PROOF (tests must FAIL)

**Hunts for**:
- Anemic domain types (primitive obsession — `userId: string` where empty string is "valid")
- Construction without validation (casting `unknown` to a domain type)
- Missing schema validation at API input boundaries
- Exposed mutable internals (public mutable arrays/objects)
- Optional fields that should be required

**Scoring**: Rates each finding across 4 dimensions (encapsulation, expression, usefulness, enforcement). Only writes tests where enforcement score ≤ 4.

---

### hunter-security

**File**: `.opencode/agents/hunter-security.md`  
**Model**: gemini-3.1-pro-preview  
**Contract**: BUG_PROOF (tests must FAIL — exploitation tests, not just "check is absent" tests)

**Hunts for**:
- Tenant isolation leaks in multi-tenant systems (CRITICAL)
- IDOR (Insecure Direct Object Reference)
- Authentication bypass
- Privilege escalation
- Missing input validation on security-sensitive operations
- SQL injection (Static Warning — cannot be unit-tested)

---

### hunter-code-review

**File**: `.opencode/agents/hunter-code-review.md`  
**Model**: gemini-3.1-pro-preview  
**Contract**: BUG_PROOF (tests must FAIL)

**Reads AGENTS.md first.** Hunts for:
- Import pattern violations
- Framework and language convention violations (banned patterns, missing types)
- Error handling anti-patterns
- Logic bugs (off-by-one, null dereference, wrong comparisons)
- Naming violations (Static Warning — not unit-testable)

Every finding must cite a specific AGENTS.md rule or be a clear logic bug.

---

### hunter-simplifier

**File**: `.opencode/agents/hunter-simplifier.md`  
**Model**: gemini-3.1-pro-preview  
**Contract**: MUTATION (edits production code, runs existing test suite as proof)

**The only hunter that edits production source files.** Applies simplifications one at a time and immediately runs the full test suite. If any test fails, reverts the change and reports the attempt as failed.

**Simplifies**:
- Deep nesting (via early returns)
- Redundant intermediate variables
- Unclear names (internal symbols only)
- Scattered duplicate logic
- Dead code
- Unnecessary async wrappers

**Precondition**: Only simplifies code that has existing test coverage. No test coverage = Static Warning, not a simplification.

---

### hunter-comments

**File**: `.opencode/agents/hunter-comments.md`  
**Model**: gemini-3.1-pro-preview  
**Contract**: ADVISORY (emits Static Warnings only — no tests, no code changes)

**Read-only.** Cross-references every comment in the diff against the actual code. Hunts for:
- Factually incorrect comments (comment says "returns null", code throws)
- Temporal language ("recently refactored", "new", "currently")
- "What" comments that restate the obvious
- Stale TODOs (referencing work already completed)
- Ambiguous or misleading language

Also reports **positive findings** — excellent "why" comments worth keeping.

---

### hunter-test-coverage

**File**: `.opencode/agents/hunter-test-coverage.md`  
**Model**: gemini-3.1-pro-preview  
**Contract**: COVERAGE_PROOF (tests must PASS — inverted from other BUG_PROOF hunters)

**Inverted pattern**: This hunter writes tests that SHOULD pass. A failing test means it found a real bug (which it escalates separately).

**Hunts for** critical untested paths (criticality ≥ 7 out of 10):
- Untested error paths
- Untested business logic branches
- Untested negative cases (validation rejection)
- Untested async failure scenarios
- Untested boundary values in security/financial domains

---

## Agent Interactions

### Typical Workflows

**Planning a complex feature**:
```
User → Zeus → Prometheus
                ↓ (Wave 0 research)
              Explore + Codebase Locator + Pattern Finder + Thoughts Locator
                ↓ (Wave 1 if needed)
              Codebase Analyzer
                ↓ (architecture decision)
              Oracle
                ↓ (plan complete)
              → back to Zeus → Vulkanus
```

**Implementing a feature**:
```
User → Vulkanus
         ↓ (RED: need test pattern)
       Codebase Pattern Finder
         ↓ (GREEN: need to understand existing code)
       Codebase Analyzer
         ↓ (REFACTOR: architecture review)
       Oracle
```

**Shipping code**:
```
User → Zeus → Argus
                ↓ (parallel dispatch)
              hunter-silent-failure
              hunter-type-design
              hunter-security
              hunter-code-review
              hunter-simplifier
              hunter-comments
              hunter-test-coverage
                ↓ (collect test files, execute)
              → verdict: CLEAR TO LAND or BUGS FOUND
                ↓ (if clear)
              → Vulkanus (commit, push, PR)
```

### Handoff Signals

Each primary agent includes explicit handoff instructions:

- **Mnemosyne** → "If you want to plan this, hand to @prometheus with..."
- **Prometheus** → "To begin implementation: return to Zeus or switch to Vulkanus"
- **Argus** → "Clear to land" → Vulkanus for commit; "Bugs Found" → Vulkanus for fixes

---

## Customizing Agents

### Edit Agent Behavior

All agents are plain Markdown files in `.opencode/agents/`. Edit them directly:

```bash
$EDITOR .opencode/agents/vulkanus.md
```

Changes take effect immediately — OpenCode reloads agent definitions on each session start. Commit your changes so the team benefits.

### Key Sections to Customize

| Section | What It Controls |
|---------|-----------------|
| **Frontmatter** (`model`, `temperature`, `thinking`) | Model selection and reasoning depth |
| **Mission** | Core identity — what this agent fundamentally does |
| **Hard Rules** | Non-negotiable behaviors — what the agent ALWAYS/NEVER does |
| **Workflow** | Step-by-step process the agent follows |
| **Delegation Table** | Which subagents to use for what |
| **Anti-patterns** | What NOT to do — critical for preventing drift |

### Frontmatter Reference

```yaml
---
description: One-line description shown in the agent picker.
mode: all          # "all" = interactive + subagent; "subagent" = only when invoked
model: anthropic/claude-sonnet-4-6
temperature: 0.1   # Lower = more deterministic
thinking:
  type: enabled
  budgetTokens: 10000
tools:
  edit: false       # Deny specific tools
  write: false
  task: true        # Allow agent delegation
---
```

### Adding Project-Specific Context

Rather than modifying agent definitions, add project context to `AGENTS.md` at the workspace root. All agents read this file. It's the right place for:
- Project build/test/validation commands
- Code style rules
- Architecture overview
- Naming conventions

Run `make setup-repo` to generate this file automatically from your product repo.

### When NOT to Customize

The core mythology sections (Mythology, Mission, Hard Rules) define fundamental agent identity. Changing them can cause behavioral drift. Prefer adding to the agent's knowledge rather than replacing its identity.
