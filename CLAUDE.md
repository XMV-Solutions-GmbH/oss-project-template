<!--
SPDX-License-Identifier: MIT OR Apache-2.0
SPDX-FileCopyrightText: 2026 XMV Solutions GmbH
SPDX-FileContributor: David Koller <david.koller@xmv.de>
-->

# Project conventions — `<PROJECT_NAME>`

> **Template note.** Replace the placeholders in this file once the new repo
> has its first PR or first published release. Keep this file short; the
> heavy lifting is in [`ENGINEERING_PRINCIPLES.md`](ENGINEERING_PRINCIPLES.md).

**Read [ENGINEERING_PRINCIPLES.md](ENGINEERING_PRINCIPLES.md) first.** It is the project-agnostic baseline (language rule, status workflow, AI-as-developer test-harness requirement, source-control rules, documentation baseline, source-of-truth and doc-mirrors-repo discipline, PR discipline). This file only adds notes specific to *this* repository.

The split is load-bearing:

- **`ENGINEERING_PRINCIPLES.md`** is the same in every XMV OSS project — copied verbatim from this template. When a principle improves in one project, back-port it to the others (see § 0 of the principles file).
- **`CLAUDE.md`** (this file) is where you record what makes *this* project specific: the tech stack, the test-environment requirements, the licence-header copyright holder, project-specific overrides of the baseline, and pointers to the per-project documentation set.

When the AI agent or a new contributor opens the repo for the first time, they read **this file first**; it tells them which principles apply (via the link above) and where to find everything else.

---

## What this repo is

<!-- One paragraph: what the project does, who for, why. Link to the full
     vision document under `docs/`. -->

`<PROJECT_NAME>` <one-sentence description>.

Full vision and scope in [`docs/app-concept.md`](docs/app-concept.md). Read it before changing anything that touches the public surface.

## Project-specific docs

| Doc | Purpose |
|---|---|
| [docs/app-concept.md](docs/app-concept.md) | Vision, MVP scope, public surface, open questions |
| [docs/testconcept.md](docs/testconcept.md) | Per-project instantiation of the three test layers (unit / integration / harness) |
| [docs/proposals/](docs/proposals/) | RFCs / spike notes / architectural decisions that are too big for a single issue |
| [README.md](README.md) | Quickstart for end users |
| [CONTRIBUTING.md](CONTRIBUTING.md) | Contribution flow |
| [SECURITY.md](SECURITY.md) | Vulnerability disclosure |
| [CHANGELOG.md](CHANGELOG.md) | Keep-a-changelog history |

## Project-specific tracking

**Authoritative tracker: GitHub Issues + GitHub Projects** at <https://github.com/`<ORG>`/`<REPO>`/issues>.

Per [`ENGINEERING_PRINCIPLES.md` § 2](ENGINEERING_PRINCIPLES.md), every XMV OSS project tracks planned work and resolved issues in its repo-bound GitHub Project from day one. Markdown todo files (`docs/todo.md`, `TODO.md`) are not used for new projects — only as a frozen historical artefact when migrating from older repos.

Recommended labels (adjust to fit the project):

- `type:feat` / `type:fix` / `type:chore` / `type:docs` / `type:test`
- `area:<component>` (one per major component)
- `priority:p0` / `p1` / `p2`
- `agent:claude` (or similar) when an AI agent is the executor

Issue body convention: **Context** · **Acceptance criteria** (checkbox list) · **Out of scope** · **Links**. Milestones map to releases (e.g. `v0.1.0 — MVP`, `v0.2.0`).

## Tech stack (in scope for this repo)

<!-- List the languages, frameworks, runtimes, package managers, lint/format
     tooling, test frameworks, deployment/distribution surface. Be specific. -->

- TBD

## Licence & attribution (this project)

Per [`ENGINEERING_PRINCIPLES.md` §§ 11–12](ENGINEERING_PRINCIPLES.md):

- **Licence**: dual-licensed **MIT OR Apache-2.0** — see [LICENSE-MIT](LICENSE-MIT), [LICENSE-APACHE](LICENSE-APACHE).
- **Copyright holder**: XMV Solutions GmbH.
- **SPDX licence identifier** for file headers: `MIT OR Apache-2.0`.

### Header to add to every new source file

For Python, Shell, YAML, TOML, and most languages with `#` line comments:

```text
# SPDX-License-Identifier: MIT OR Apache-2.0
# SPDX-FileCopyrightText: <year> XMV Solutions GmbH
# SPDX-FileContributor: <git user.name> <<git user.email>>
```

For languages with `//` line comments (Go, Rust, JS/TS, Java, …):

```text
// SPDX-License-Identifier: MIT OR Apache-2.0
// SPDX-FileCopyrightText: <year> XMV Solutions GmbH
// SPDX-FileContributor: <git user.name> <<git user.email>>
```

For HTML / Markdown:

```html
<!--
SPDX-License-Identifier: MIT OR Apache-2.0
SPDX-FileCopyrightText: <year> XMV Solutions GmbH
SPDX-FileContributor: <name> <<email>>
-->
```

Read `git config user.name` / `user.email` for the contributor line — that's the human author per German *Urheberrecht*. The line is never overwritten by later editors; new substantial contributors append additional `SPDX-FileContributor` lines.

### What NOT to do

- Never add `Co-Authored-By: Claude …` (or any AI tool) to commit messages.
- Never put AI tool names or versions into source comments.
- Never list an AI as a `SPDX-FileContributor`.

## Project-specific overrides of the engineering baseline

<!-- Document any deviations from ENGINEERING_PRINCIPLES.md here, with the
     paragraph reference and a one-line justification. Examples:

- **PR workflow already triggered (per § 13).** This package has external
  users via PyPI, so `main` is treated as deployable trunk: feature
  branches + PRs, branch protection, CI green required for merge.
- **Test environment (per § 5).** A dedicated <SaaS> tenant is used for
  harness tests; credentials live in GitHub Actions secrets and a
  developer-local `.env` (git-ignored).
- **Harness token renewal.** Monthly recurring chore: ... -->

- TBD
