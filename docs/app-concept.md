# OSS Project Template

## Vision

A production-ready template for professional software projects with AI-assisted development support. The template serves both open source (OSS) and proprietary projects through a one-time initialisation switch.

## Problem Statement

Starting a new project requires significant boilerplate: licence files, contribution guidelines, CI/CD workflows, and AI instructions. Teams waste time recreating these structures. Additionally, the same professional standards should apply to both OSS and proprietary projects, but the artefacts differ.

## Target Audience

- Developers starting new OSS projects
- Teams building proprietary software with professional standards
- Organisations using AI-assisted development (GitHub Copilot, etc.)

## Core Features

- [x] Complete OSS project structure (README, CONTRIBUTING, LICENCE, etc.)
- [x] AI-assisted development guidelines (copilot-instructions.md)
- [x] GitHub automation scripts (branch protection, team assignment)
- [x] Reusable prompts for common workflows (PR creation, merging)
- [ ] **Project Init Switch** — One-time OSS/Proprietary mode selection

## Architecture Overview

### Project Init Switch (NEW)

```text
Template Applied → User runs init-project.sh → Selects Mode → Cleanup
                                                    │
                    ┌───────────────────────────────┴───────────────────────────────┐
                    │                                                               │
                    ▼                                                               ▼
               OSS Mode                                                    Proprietary Mode
         ┌─────────────────┐                                          ┌─────────────────┐
         │ Keep:           │                                          │ Delete:         │
         │ - LICENSE*      │                                          │ - LICENSE*      │
         │ - CODE_OF_COND. │                                          │ - CODE_OF_COND. │
         │ - ISSUE_TEMPL.  │                                          │ - ISSUE_TEMPL.  │
         │ Delete:         │                                          │ Replace:        │
         │ - templates/    │                                          │ - README        │
         │ - init-project  │                                          │ - CONTRIBUTING  │
         │   scripts       │                                          │ - SECURITY      │
         └─────────────────┘                                          │ - SPDX headers  │
                                                                      │ Delete:         │
                                                                      │ - templates/    │
                                                                      │ - init-project  │
                                                                      └─────────────────┘
```

### File Structure After Init

| File | OSS Mode | Proprietary Mode |
| ---- | -------- | ---------------- |
| `LICENSE`, `LICENSE-*` | ✅ Keep | ❌ Delete |
| `CODE_OF_CONDUCT.md` | ✅ Keep | ❌ Delete |
| `.github/ISSUE_TEMPLATE/` | ✅ Keep | ❌ Delete |
| `docs/howto-oss.md` | ✅ Keep | ❌ Delete |
| `README.md` | ✅ Keep (with badges) | 🔄 Replace (internal) |
| `CONTRIBUTING.md` | ✅ Keep (public) | 🔄 Replace (internal) |
| `SECURITY.md` | ✅ Keep (public) | 🔄 Replace (internal) |
| SPDX Headers | ✅ `MIT OR Apache-2.0` | 🔄 `PROPRIETARY` |
| `templates/` | ❌ Delete | ❌ Delete |
| `init-project.*` | ❌ Delete | ❌ Delete |

## Tech Stack

| Component | Technology | Rationale |
| --------- | ---------- | --------- |
| Scripts | Bash | Universal availability on dev machines |
| CI/CD | GitHub Actions | Native GitHub integration |
| Linting | markdownlint | Consistent documentation |
| AI | GitHub Copilot | Primary AI assistant target |

## Non-Functional Requirements

- **Idempotent scripts** — Safe to re-run without side effects
- **No external dependencies** — Works with standard Unix tools + gh CLI
- **Self-cleaning** — Init switch removes itself after execution

