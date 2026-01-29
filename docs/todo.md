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
| 🟢     | Add AI Assistant Prompts (add-instruction.prompt.md) | AI    | Merged PR #8 |
| 🟢     | Project Init Switch (OSS/Proprietary) | AI    | Merged PR #9 |
| 🟡     | Template Test Harness with Coverage | AI    | Feature branch active |

### v0.1.0 — Project Init Switch Tasks

| Status | Task | Notes |
| ------ | ---- | ----- |
| 🟢     | Create `templates/proprietary/` structure | README, CONTRIBUTING, SECURITY templates |
| 🟢     | Create `init-project.sh` script | Main switch logic |
| 🟢     | Create `init-project.prompt.md` | AI-guided setup |
| 🟢     | Update README with setup hint | "Run init-project.sh first" |
| 🟢     | Mark copilot-instructions sections | Sections already separated |
| 🟡     | Test both modes | bats tests with kcov coverage |

### v0.1.0 — Template Test Harness Tasks

| Status | Task | Notes |
| ------ | ---- | ----- |
| ⚪     | Create `tests/template/` structure | bats tests for init-project.sh |
| ⚪     | Add kcov coverage to CI | Report to Coveralls |
| ⚪     | Update init-project.sh | Delete tests/template/ on init |
| ⚪     | Test locally and verify badge | Coverage visible in README |

## Backlog

| Priority | Task | Complexity | Notes |
| -------- | ---- | ---------- | ----- |
| —        | TBD  | —          | —     |
