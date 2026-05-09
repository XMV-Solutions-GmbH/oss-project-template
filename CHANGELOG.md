<!-- SPDX-License-Identifier: MIT OR Apache-2.0 -->
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

Tracked in [GitHub Issues](https://github.com/XMV-Solutions-GmbH/oss-project-template/issues).

## [v0.2.0] — 2026-05-09

A hardening pass driven by lessons learned from the first two projects bootstrapped from this template (`sharepoint-mcp`, `outlook-mcp`). Everything in this release is application- and framework-independent — the template stays language- and domain-neutral.

### Added

- **`ENGINEERING_PRINCIPLES.md`** — the 434-line project-agnostic engineering baseline (language rule, status workflow, three test layers with harness as the AI-development gate, source-control rules, CI vigilance, doc-mirrors-repo, source-of-truth, PR discipline). Both sister projects carried an identical copy; promoting it to a first-class template artefact.
- **`CLAUDE.md`** — per-project overlay skeleton: tech stack placeholder, project-specific overrides table, licence/SPDX guidance, GitHub-Projects-as-tracker pointer.
- **`docs/proposals/`** — RFC layout: a `README.md` explaining when to use it (and when *not* to), and a `_template.md` with the canonical sections (Status, Context, Decision, Alternatives considered, Consequences, Implementation notes). Naming convention `YYYY-MM-DD-short-slug.md`. Lifecycle: Draft → Accepted → Implemented; or Superseded / Withdrawn — never rewritten in place.
- **`scripts/`** — directory placeholder with a `README.md` documenting the convention from § 8 of the engineering principles (shebang + SPDX, `set -euo pipefail`, idempotent, self-documenting, `--help` summary, exit codes).
- **`.github/workflows/HARNESS_JOB.md`** — copy-paste-ready harness job snippet for downstream projects, with the canonical "skip silently when secret is missing" guard so PRs from forks aren't blocked.

### Changed

- **GitHub Issues + GitHub Projects is now the canonical tracker** for every XMV OSS project, from day one. The older "markdown TODO/ISSUES files in `docs/`" pattern is retired. `ENGINEERING_PRINCIPLES.md` § 2 rewritten; § 7 and § 10 references updated; `.github/copilot-instructions.md` and `docs/testconcept.md` updated to file issues + close via PR; `docs/app-concept.md` structure tree drops `todo.md`.
- **README skeleton** in `.github/copilot-instructions.md` now includes the three sections that paid back in both sister projects: a one-sentence pitch as a blockquote (under 200 characters, has to stand alone on package registries), a "What is this for?" section (concrete user situation before features), and a use-case dialogue example (memorable headline workflow).
- **`.github/workflows/ci.yml`** — header comment block documenting the three-job shape (lint / test / harness) and what to swap in for language-specific bits. The bats-test job for the template's own tests is unchanged.
- **`.github/workflows/release.yml`** — header comment documenting the OIDC Trusted Publisher pattern (PyPI flavour, generalises to crates.io / npm).

### Removed

- **`docs/todo.md`** — retired in favour of GitHub Issues + Projects.

[Unreleased]: https://github.com/XMV-Solutions-GmbH/oss-project-template/compare/v0.2.0...HEAD
[v0.2.0]: https://github.com/XMV-Solutions-GmbH/oss-project-template/releases/tag/v0.2.0
