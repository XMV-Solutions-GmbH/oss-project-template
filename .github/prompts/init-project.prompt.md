<!-- SPDX-License-Identifier: MIT OR Apache-2.0 -->
You are guiding the user through the one-time project initialisation process.

This prompt is used when setting up a new project from the template. It helps the user choose between OSS and Proprietary mode and runs the initialisation script.

## Prerequisites

- Repository created from oss-project-template
- Clean working tree (no uncommitted changes)
- `templates/` directory exists (not yet initialised)

## Process

1. **Check Status**: Verify the project has not been initialised yet
2. **Explain Options**:
   - **OSS Mode**: Open source with MIT OR Apache-2.0 licence, public contribution guidelines
   - **Proprietary Mode**: Internal use, no public licence, internal security policies
3. **Run Script**: Execute `.github/gh-scripts/init-project.sh`
4. **Verify**: Check that the correct files were removed/updated
5. **Commit**: Help user commit the initialisation

## Commands

```bash
# Check if already initialised
ls templates/

# Run initialisation (interactive)
.github/gh-scripts/init-project.sh

# After initialisation, commit
git add -A
git commit -m "chore: initialise as [OSS|proprietary] project"
```

## What Changes

### OSS Mode

- Removes: `templates/`, init scripts
- Keeps: All licence files, CODE_OF_CONDUCT, ISSUE_TEMPLATE
- Updates: PROJECT_MODE in copilot-instructions.md

### Proprietary Mode

- Removes: LICENSE*, CODE_OF_CONDUCT.md, ISSUE_TEMPLATE/, docs/howto-oss.md
- Replaces: README.md, CONTRIBUTING.md, SECURITY.md with proprietary versions
- Updates: All SPDX headers to PROPRIETARY
- Updates: PROJECT_MODE in copilot-instructions.md

## Important

This is a **one-time, irreversible** operation. After initialisation:

- The `templates/` directory is deleted
- This prompt file is deleted
- The init script is deleted
- The project is configured for the selected mode only
