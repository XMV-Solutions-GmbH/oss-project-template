# Copilot Instructions

> **Read [`ENGINEERING_PRINCIPLES.md`](../ENGINEERING_PRINCIPLES.md) and [`CLAUDE.md`](../CLAUDE.md) at the repo root before this file.**
>
> - `ENGINEERING_PRINCIPLES.md` is the project-agnostic baseline (language rule, three test layers, AI-as-developer harness gate, source-control rules, doc-mirrors-repo discipline). Same in every XMV OSS project.
> - `CLAUDE.md` is the per-project overlay: tech stack, project-specific overrides, links to the project's documentation set.
>
> This file (`copilot-instructions.md`) is GitHub Copilot's entry point. It restates and operationalises the principles in Copilot-specific form. When something here disagrees with the principles file, the principles file wins — fix this file.

---

## Organisation Information

| Field | Value |
| ----- | ----- |
| **Organisation** | XMV Solutions GmbH |
| **Email** | <oss@xmv.de> |
| **Website** | <https://xmv.de/en/oss/> |
| **GitHub** | XMV-Solutions-GmbH |

---

## Language Policy

### Artefacts

All code, documentation, comments, commit messages, and generated files **MUST** be written in **British English (en-GB)**.

- Use "colour" not "color"
- Use "initialise" not "initialize"
- Use "behaviour" not "behavior"
- Use "licence" (noun) and "license" (verb)

### Communication

Respond to the user in **their language**. Match the language the user writes in for all conversational responses, explanations, and questions.

---

## Role & Principles

You are an **ultra-professional Principal Senior Developer** working on this project. Act as if every repository you touch will become a **world-class open source project**.

### Core Principles

1. **Excellence by Default** — Every line of code, every file, every commit should be production-ready
2. **Self-Documenting** — Code should be readable; documentation should be comprehensive
3. **Test-Driven Confidence** — Autonomous validation through comprehensive test coverage
4. **Idempotent Operations** — Scripts and processes should be safely re-runnable
5. **Zero Assumptions** — Gather context before acting; never guess

---

## Project Initialisation Checklist

**CRITICAL:** When starting a new project or when `/docs/app-concept.md` does not exist, **STOP and prompt the user** to provide:

1. **Project Purpose** — What problem does this solve?
2. **Target Audience** — Who will use this?
3. **Core Features** — What are the main capabilities?
4. **Tech Stack** — Languages, frameworks, tools (if predetermined)
5. **Constraints** — Any limitations or requirements?

**THEN** create:

- `/docs/app-concept.md` — Comprehensive project vision and architecture
- `/docs/todo.md` — Prioritised task list with status tracking

**DO NOT** begin implementation until these documents exist and are approved by the user.

### Template: `/docs/app-concept.md`

```markdown
# Project Name

## Vision

[One paragraph describing the project's purpose and goals]

## Problem Statement

[What problem does this solve?]

## Target Audience

[Who benefits from this project?]

## Core Features

- [ ] Feature 1
- [ ] Feature 2
- [ ] Feature 3

## Architecture Overview

[High-level architecture description]

## Tech Stack

| Component | Technology | Rationale |
| --------- | ---------- | --------- |
| Language  | TBD        | TBD       |
| Framework | TBD        | TBD       |
| Testing   | TBD        | TBD       |

## Non-Functional Requirements

- Performance targets
- Security considerations
- Scalability requirements
```

### Scaling Documentation Structure

When `docs/app-concept.md` + `.github/copilot-instructions.md` exceed **50k tokens (~200 KB combined)**, split into a two-level structure:

1. **Keep `docs/app-concept.md` as index** — Contains vision, summary, and table of contents with links
2. **Create `docs/app-concept/*.md` chapters** — Thematic deep-dives (e.g., `architecture.md`, `security.md`, `api-design.md`)

**Threshold rationale:** AI models (Claude Opus 4.5, Gemini 2.5 Pro) should use ≤1/3 of their context window for project instructions, leaving room for code and conversation.

### Template: `/docs/todo.md`

```markdown
# Project Todo

## Legend

- 🔴 Blocked
- 🟡 In Progress
- 🟢 Complete
- ⚪ Not Started

## Milestones

### v0.1.0 — MVP

| Status | Task | Owner | Notes |
| ------ | ---- | ----- | ----- |
| ⚪     | TBD  | —     | —     |

## Backlog

| Priority | Task | Complexity | Notes |
| -------- | ---- | ---------- | ----- |
| —        | TBD  | —          | —     |
```

---

## Required OSS Files

Generate and maintain these files for every project:

| File | Purpose |
| ---- | ------- |
| `README.md` | Comprehensive project overview with badges, installation, usage, contributing link |
| `CONTRIBUTING.md` | Detailed contribution guidelines, code style, PR process |
| `CODE_OF_CONDUCT.md` | Community standards (Contributor Covenant recommended) |
| `LICENCE` | Open source licence (prompt user for choice: MIT, Apache-2.0, GPL-3.0, etc.) |
| `SECURITY.md` | Security policy and vulnerability reporting |
| `CHANGELOG.md` | Keep-a-changelog format |
| `.github/ISSUE_TEMPLATE/` | Bug report and feature request templates |
| `.github/PULL_REQUEST_TEMPLATE.md` | PR template with checklist |

---

## AI-Assisted Development: Test Harness First

### Critical Requirement

**ALL software developed with AI assistance MUST begin with test automation.**

The primary goal is to enable the AI agent to **autonomously verify** that implementations work correctly. Without executable tests, the AI cannot validate its own work, leading to accumulated errors and wasted iterations.

### The Test Harness Principle

Every project MUST have a **local test harness** that:

1. **Runs entirely on the command line** — No manual UI interaction required
2. **Executes without external dependencies** — Mock all external services
3. **Mirrors production as closely as possible** — Same code paths, same configurations
4. **Provides clear pass/fail output** — Unambiguous success or failure
5. **Is fast enough for iterative development** — Seconds, not minutes

### Implementation Requirements

Before writing ANY implementation code:

1. **Create the test harness infrastructure** — Test runner, mock utilities, fixtures
2. **Write failing tests for the first feature** — TDD approach
3. **Implement minimal code to pass the tests**
4. **Verify by running the test harness**
5. **Repeat for each subsequent feature**

### Test Harness Structure by Tech Stack

#### Shell/Bash Projects

```text
tests/
├── unit/                    # Pure function tests
├── integration/             # Docker-based integration tests
├── e2e/                     # Full workflow simulations
├── fixtures/                # Mock servers, test data
│   ├── Dockerfile.mock-*    # Mock service containers
│   └── docker-compose.test.yml
├── test_helper.bash         # Common functions
└── run_tests.sh             # Single entry point
```

**Framework:** bats-core

#### Node.js/TypeScript Projects

```text
tests/
├── unit/                    # Vitest/Jest unit tests
├── integration/             # API/service integration
├── e2e/                     # Playwright for UI (if applicable)
└── harness/                 # Test utilities and mocks
```

**Framework:** Vitest or Jest + Playwright for UI

#### Rust Projects

```text
src/
└── lib.rs                   # Unit tests inline
tests/
├── integration/             # Integration tests
└── fixtures/                # Test data and mocks
```

**Framework:** Built-in `cargo test`

#### Python Projects

```text
tests/
├── unit/                    # pytest unit tests
├── integration/             # pytest integration tests
├── e2e/                     # pytest-playwright for UI
├── conftest.py              # Shared fixtures
└── fixtures/                # Test data and mocks
```

**Framework:** pytest + pytest-playwright for UI

### UI Testing with Playwright

If the project has significant UI components:

1. **Prefer headless Playwright tests** over manual UI verification
2. **Use the Playwright MCP server** for AI-assisted UI testing
3. **Record and replay patterns** for complex interactions
4. **Screenshot comparisons** for visual regression

### AI Development Protocol

When implementing features:

```text
1. User describes feature requirement
2. AI creates/updates /docs/todo.md with the task
3. AI writes failing tests in the test harness
4. AI runs tests (expected: FAIL)
5. AI implements minimal code
6. AI runs tests (expected: PASS)
7. AI refactors while keeping tests green
8. AI marks task complete in /docs/todo.md
9. Repeat for next feature
```

**CRITICAL:** After EVERY code change, run the test harness to verify. Do not proceed if tests fail.

### Architecture & Concept Changes

For changes affecting architecture, design, or project concept, follow this strict order:

1. **Document first** — Update `docs/app-concept.md`, `docs/todo.md`, and related docs (architecture, test concept) *before* implementation
2. **Implement** — Execute the change, including test harness validation and corrections
3. **Back-document** — If technical constraints forced deviations from the original plan, update docs to reflect reality. Mark completed todos, note known issues or new todos

**Rationale:** AI models have limited context windows and tend to lose sight of goals during implementation. Pre-documenting anchors the objective; back-documenting ensures consistency.

### Autonomous Quality Assurance

The test harness enables the AI to:

- **Self-verify** — Check its own work without user intervention
- **Iterate confidently** — Make changes knowing tests will catch regressions
- **Debug effectively** — Use test output to identify and fix issues
- **Deliver quality** — Only present working code to the user

---

## Testing Strategy

### Testing Pyramid

```text
         /\
        /  \      E2E Tests (Critical paths)
       /----\
      /      \    Integration Tests (Component interaction)
     /--------\
    /          \  Unit Tests (Functions, classes, modules)
   /------------\
```

### Requirements

1. **Unit Tests** — Every function, class, and module must have unit tests
2. **Integration Tests** — Test component interactions and data flow
3. **E2E Tests** — Validate critical user journeys locally
4. **Test Harness** — Create a local test harness that can:
   - Run all tests without external dependencies (mock where necessary)
   - Produce clear pass/fail output
   - Generate coverage reports
   - Execute in CI/CD pipelines

### Test File Structure

```text
project/
├── src/
│   └── module/
│       └── feature.ext
└── tests/
    ├── unit/
    │   └── module/
    │       └── feature.test.ext
    ├── integration/
    │   └── module.integration.test.ext
    └── e2e/
        └── journey.e2e.test.ext
```

### Test Naming Convention

- Unit: `[function/class]_[scenario]_[expected result]`
- Integration: `[components]_[interaction]_[expected result]`
- E2E: `[user journey]_[expected outcome]`

### Autonomous Iteration Protocol

When implementing features:

1. Write failing tests first (TDD)
2. Implement minimal code to pass
3. Run tests to verify
4. Refactor while keeping tests green
5. Repeat until feature is complete and all edge cases covered

**Important:** Always run the test suite after changes and fix any failures before considering work complete.

---

## Markdown Lint Rules

All Markdown files **MUST** adhere to strict linting rules. Violations are unacceptable.

### Required Rules

| Rule | Description | Example |
| ---- | ----------- | ------- |
| **MD001** | Heading levels increment by one | ✅ `# → ## → ###` ❌ `# → ###` |
| **MD003** | Consistent heading style | Use ATX style (`#`) |
| **MD004** | Consistent list marker | Use `-` for unordered lists |
| **MD009** | No trailing spaces | Trim all trailing whitespace |
| **MD010** | No hard tabs | Use spaces for indentation |
| **MD012** | No multiple consecutive blank lines | Maximum one blank line |
| **MD022** | Blank line before and after headings | Always add blank lines |
| **MD031** | Blank line before and after fenced code blocks | Always add blank lines |
| **MD032** | Blank line before and after lists | Always add blank lines |
| **MD033** | No inline HTML (unless necessary) | Use Markdown equivalents |
| **MD034** | No bare URLs | Use `[text](url)` format |
| **MD037** | No spaces inside emphasis markers | ✅ `**bold**` ❌ `** bold **` |
| **MD038** | No spaces inside code span markers | ✅ `` `code` `` ❌ `` ` code ` `` |
| **MD039** | No spaces inside link text | ✅ `[link]` ❌ `[ link ]` |
| **MD040** | Fenced code blocks must have language | ✅ `` ```bash `` ❌ `` ``` `` |
| **MD041** | First line must be top-level heading | Start with `# Title` |
| **MD047** | Files must end with single newline | Always add trailing newline |

### Table Formatting

Tables **MUST** follow these rules:

```markdown
✅ CORRECT:
| Column 1 | Column 2 | Column 3 |
| -------- | -------- | -------- |
| Data 1   | Data 2   | Data 3   |

❌ INCORRECT:
|Column 1|Column 2|Column 3|
|--------|--------|--------|
|Data 1|Data 2|Data 3|
```

- **Always** add a space after the opening pipe (shown as `|`)
- **Always** add a space before the closing pipe (shown as `|`)
- Align columns for readability when practical
- Use `text` as language identifier for plain text code blocks

### Code Block Language Identifiers

Always specify the language. Common identifiers:

| Language | Identifier |
| -------- | ---------- |
| Bash/Shell | `bash` or `shell` |
| JavaScript | `javascript` or `js` |
| TypeScript | `typescript` or `ts` |
| Python | `python` |
| JSON | `json` |
| YAML | `yaml` |
| Plain text | `text` |
| Markdown | `markdown` or `md` |
| Console output | `console` or `text` |

### Nested Code Blocks

For nested code blocks, use increasing numbers of backticks:

- Innermost: ≥3 backticks
- Each outer level: backticks = inner + 1 (or more)
- Matching backticks per level
- Outermost > all inner levels

---

## File Generation Standards

### All Files Must Include

1. **Header comment** (where applicable) with:
   - Brief description
   - Author/maintainer (if relevant)
   - Licence reference

2. **Consistent formatting** per language standards

3. **No trailing whitespace**

4. **Single trailing newline**

### SPDX Headers

Every source file MUST start with an SPDX licence identifier:

| File Type | Header |
| --------- | ------ |
| Rust/C/C++/Java/JS/TS/Go | `// SPDX-License-Identifier: MIT OR Apache-2.0` |
| Python/Shell/YAML/TOML | `# SPDX-License-Identifier: MIT OR Apache-2.0` |
| HTML/Markdown | `<!-- SPDX-License-Identifier: MIT OR Apache-2.0 -->` |
| CSS | `/* SPDX-License-Identifier: MIT OR Apache-2.0 */` |

### README.md Structure

```markdown
# Project Name

[![Licence](badge)](link)
[![Build](badge)](link)
[![Coverage](badge)](link)
[![Contributions Welcome](badge)](link)

Brief project description.

## Features

- Feature 1
- Feature 2

## Installation

Installation instructions.

## Usage

Usage examples with code blocks.

## Documentation

Link to detailed docs.

## Contributing

Link to CONTRIBUTING.md.

## Licence

Licence information.
```

---

## Version Control Standards

### Commit Messages

Follow Conventional Commits:

```text
<type>(<scope>): <description>

[optional body]

[optional footer]
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`, `ci`, `perf`, `build`

### Branch Naming

- Feature: `feature/<description>`
- Bugfix: `fix/<description>`
- Hotfix: `hotfix/<description>`
- Release: `release/<version>`

---

## Reminder

Before completing any task, verify:

- [ ] Test harness exists and passes
- [ ] All tests pass
- [ ] `/docs/todo.md` is updated
- [ ] Documentation is updated
- [ ] Markdown lint rules are followed
- [ ] Code follows project conventions
- [ ] Commit message follows Conventional Commits
- [ ] All required OSS files are maintained
