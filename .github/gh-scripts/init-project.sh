#!/usr/bin/env bash
# SPDX-License-Identifier: MIT OR Apache-2.0
# =============================================================================
# init-project.sh - One-time project initialisation switch
# =============================================================================
#
# This script configures the project for either OSS or Proprietary mode.
# It MUST be run once after creating a new repository from this template.
#
# Usage:
#   .github/gh-scripts/init-project.sh
#
# The script will:
#   1. Ask for project mode (OSS or PROPRIETARY)
#   2. Collect project-specific information
#   3. Remove files not needed for the selected mode
#   4. Update remaining files with project information
#   5. Remove itself and the templates directory
#
# =============================================================================

set -euo pipefail

# -----------------------------------------------------------------------------
# Configuration
# -----------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
TEMPLATES_DIR="$REPO_ROOT/templates"

# Colours for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Colour

# -----------------------------------------------------------------------------
# Helper Functions
# -----------------------------------------------------------------------------

info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

success() {
    echo -e "${GREEN}✓${NC} $1"
}

warn() {
    echo -e "${YELLOW}⚠${NC} $1"
}

error() {
    echo -e "${RED}✗${NC} $1" >&2
}

prompt() {
    local var_name="$1"
    local prompt_text="$2"
    local default="${3:-}"
    
    if [[ -n "$default" ]]; then
        read -rp "$prompt_text [$default]: " value
        value="${value:-$default}"
    else
        read -rp "$prompt_text: " value
    fi
    
    eval "$var_name=\"\$value\""
}

confirm() {
    local prompt_text="$1"
    local response
    read -rp "$prompt_text (y/N): " response
    [[ "$response" =~ ^[Yy]$ ]]
}

# -----------------------------------------------------------------------------
# Validation
# -----------------------------------------------------------------------------

check_already_initialised() {
    if [[ ! -d "$TEMPLATES_DIR" ]]; then
        error "This project has already been initialised."
        error "The templates/ directory no longer exists."
        exit 1
    fi
}

check_clean_working_tree() {
    if ! git diff --quiet HEAD 2>/dev/null; then
        error "Working tree is not clean. Please commit or stash changes first."
        exit 1
    fi
}

# -----------------------------------------------------------------------------
# OSS Mode Functions
# -----------------------------------------------------------------------------

init_oss_mode() {
    info "Initialising OSS mode..."
    
    # Update PROJECT_MODE in copilot-instructions.md
    sed -i 's/PROJECT_MODE: OSS  # Options: OSS | PROPRIETARY/PROJECT_MODE: OSS/' \
        "$REPO_ROOT/.github/copilot-instructions.md"
    
    # Remove Proprietary Mode section from copilot-instructions.md
    sed -i '/^### Proprietary Mode/,/^---$/d' \
        "$REPO_ROOT/.github/copilot-instructions.md" 2>/dev/null || true
    
    # Remove proprietary templates
    rm -rf "$TEMPLATES_DIR"
    
    # Update README - remove init hint
    sed -i '/<!-- INIT_HINT_START -->/,/<!-- INIT_HINT_END -->/d' \
        "$REPO_ROOT/README.md" 2>/dev/null || true
    
    success "OSS mode initialised"
}

# -----------------------------------------------------------------------------
# Proprietary Mode Functions
# -----------------------------------------------------------------------------

init_proprietary_mode() {
    local org="$1"
    local project_name="$2"
    local project_desc="$3"
    local team_email="$4"
    local security_email="$5"
    local year
    year=$(date +%Y)
    
    info "Initialising Proprietary mode..."
    
    # Update PROJECT_MODE in copilot-instructions.md
    sed -i 's/PROJECT_MODE: OSS  # Options: OSS | PROPRIETARY/PROJECT_MODE: PROPRIETARY/' \
        "$REPO_ROOT/.github/copilot-instructions.md"
    
    # Remove OSS Mode section from copilot-instructions.md
    sed -i '/^### OSS Mode/,/^### Proprietary Mode/{ /^### Proprietary Mode/!d }' \
        "$REPO_ROOT/.github/copilot-instructions.md" 2>/dev/null || true
    
    # Delete OSS-specific files
    rm -f "$REPO_ROOT/LICENSE"
    rm -f "$REPO_ROOT/LICENSE-MIT"
    rm -f "$REPO_ROOT/LICENSE-APACHE"
    rm -f "$REPO_ROOT/CODE_OF_CONDUCT.md"
    rm -rf "$REPO_ROOT/.github/ISSUE_TEMPLATE"
    rm -f "$REPO_ROOT/docs/howto-oss.md"
    
    success "Removed OSS-specific files"
    
    # Process and install proprietary templates
    for tmpl in "$TEMPLATES_DIR/proprietary/"*.tmpl; do
        [[ -f "$tmpl" ]] || continue
        local filename
        filename=$(basename "$tmpl" .tmpl)
        local dest="$REPO_ROOT/$filename"
        
        sed -e "s/{{PROJECT_NAME}}/$project_name/g" \
            -e "s/{{PROJECT_DESCRIPTION}}/$project_desc/g" \
            -e "s/{{ORGANISATION}}/$org/g" \
            -e "s/{{TEAM_EMAIL}}/$team_email/g" \
            -e "s/{{SECURITY_EMAIL}}/$security_email/g" \
            -e "s/{{YEAR}}/$year/g" \
            -e "s|{{REPO_URL}}|https://github.com/$org/$(basename "$REPO_ROOT")|g" \
            -e "s/{{REPO_NAME}}/$(basename "$REPO_ROOT")/g" \
            -e "s/{{TEAM_NAME}}/$org Team/g" \
            -e "s/{{PREREQUISITES}}/See documentation/g" \
            -e "s/{{INSTALL_COMMAND}}/# See documentation/g" \
            -e "s/{{RUN_COMMAND}}/# See documentation/g" \
            -e "s/{{EDITOR}}/\$EDITOR/g" \
            -e "s/{{TEST_COMMAND}}/# See documentation/g" \
            -e "s/{{TEST_SPECIFIC_COMMAND}}/# See documentation/g" \
            "$tmpl" > "$dest"
        
        success "Created $filename"
    done
    
    # Update SPDX headers in all files
    update_spdx_headers "$org" "$year"
    
    # Remove templates directory
    rm -rf "$TEMPLATES_DIR"
    
    success "Proprietary mode initialised"
}

update_spdx_headers() {
    local org="$1"
    local year="$2"
    
    info "Updating SPDX headers..."
    
    # Find all files with SPDX headers and update them
    local files_updated=0
    
    while IFS= read -r -d '' file; do
        if grep -q "SPDX-License-Identifier: MIT OR Apache-2.0" "$file" 2>/dev/null; then
            # Determine comment style based on file extension
            local ext="${file##*.}"
            local new_header
            
            case "$ext" in
                sh|py|yaml|yml|toml|ini)
                    new_header="# SPDX-License-Identifier: LicenseRef-Proprietary\n# Copyright (c) $year $org. All rights reserved."
                    sed -i "s|# SPDX-License-Identifier: MIT OR Apache-2.0|# SPDX-License-Identifier: LicenseRef-Proprietary\n# Copyright (c) $year $org. All rights reserved.|" "$file"
                    ;;
                md|html)
                    sed -i "s|<!-- SPDX-License-Identifier: MIT OR Apache-2.0 -->|<!-- SPDX-License-Identifier: LicenseRef-Proprietary -->\n<!-- Copyright (c) $year $org. All rights reserved. -->|" "$file"
                    ;;
                js|ts|rs|go|java|c|cpp|h)
                    sed -i "s|// SPDX-License-Identifier: MIT OR Apache-2.0|// SPDX-License-Identifier: LicenseRef-Proprietary\n// Copyright (c) $year $org. All rights reserved.|" "$file"
                    ;;
            esac
            
            ((files_updated++)) || true
        fi
    done < <(find "$REPO_ROOT" -type f \( -name "*.md" -o -name "*.sh" -o -name "*.py" -o -name "*.yaml" -o -name "*.yml" -o -name "*.js" -o -name "*.ts" -o -name "*.toml" -o -name "*.ini" \) -print0 2>/dev/null)
    
    success "Updated $files_updated files with proprietary headers"
}

# -----------------------------------------------------------------------------
# Cleanup Functions
# -----------------------------------------------------------------------------

cleanup_init_files() {
    info "Cleaning up initialisation files..."
    
    # Remove this script
    rm -f "$SCRIPT_DIR/init-project.sh"
    
    # Remove the init prompt
    rm -f "$REPO_ROOT/.github/prompts/init-project.prompt.md"
    
    # Remove template tests (only needed for template repo itself)
    rm -rf "$REPO_ROOT/tests/template" 2>/dev/null || true
    
    # Remove init hint from README if still present
    sed -i '/<!-- INIT_HINT_START -->/,/<!-- INIT_HINT_END -->/d' \
        "$REPO_ROOT/README.md" 2>/dev/null || true
    
    success "Cleaned up initialisation files"
}

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------

main() {
    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║           Project Initialisation Switch                        ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    # Validate
    check_already_initialised
    check_clean_working_tree
    
    # Mode selection
    echo "Select project mode:"
    echo ""
    echo "  1) OSS        - Open Source Software (MIT OR Apache-2.0)"
    echo "  2) PROPRIETARY - Closed source, internal use"
    echo ""
    
    local mode_choice
    read -rp "Enter choice (1 or 2): " mode_choice
    
    case "$mode_choice" in
        1|oss|OSS)
            echo ""
            warn "This will configure the project for Open Source development."
            warn "The following will be REMOVED:"
            echo "  - templates/ directory"
            echo "  - Proprietary mode section from copilot-instructions.md"
            echo ""
            
            if confirm "Proceed with OSS initialisation?"; then
                init_oss_mode
                cleanup_init_files
                
                echo ""
                success "Project initialised for OSS mode!"
                echo ""
                info "Next steps:"
                echo "  1. Review and update README.md with your project details"
                echo "  2. Update repo.ini with your organisation/repo information"
                echo "  3. Run: git add -A && git commit -m 'chore: initialise as OSS project'"
                echo ""
            else
                info "Initialisation cancelled."
                exit 0
            fi
            ;;
        
        2|proprietary|PROPRIETARY)
            echo ""
            warn "This will configure the project for Proprietary development."
            warn "The following will be REMOVED:"
            echo "  - LICENSE, LICENSE-MIT, LICENSE-APACHE"
            echo "  - CODE_OF_CONDUCT.md"
            echo "  - .github/ISSUE_TEMPLATE/"
            echo "  - docs/howto-oss.md"
            echo "  - OSS mode section from copilot-instructions.md"
            echo ""
            warn "The following will be REPLACED:"
            echo "  - README.md"
            echo "  - CONTRIBUTING.md"
            echo "  - SECURITY.md"
            echo "  - All SPDX headers"
            echo ""
            
            if confirm "Proceed with Proprietary initialisation?"; then
                echo ""
                info "Please provide the following information:"
                echo ""
                
                local org project_name project_desc team_email security_email
                
                prompt org "Organisation name" "XMV Solutions GmbH"
                prompt project_name "Project name"
                prompt project_desc "Project description (one line)"
                prompt team_email "Team email" "dev@${org,,}.de"
                prompt security_email "Security contact email" "security@${org,,}.de"
                
                echo ""
                info "Configuration:"
                echo "  Organisation:    $org"
                echo "  Project:         $project_name"
                echo "  Description:     $project_desc"
                echo "  Team Email:      $team_email"
                echo "  Security Email:  $security_email"
                echo ""
                
                if confirm "Is this correct?"; then
                    init_proprietary_mode "$org" "$project_name" "$project_desc" "$team_email" "$security_email"
                    cleanup_init_files
                    
                    echo ""
                    success "Project initialised for Proprietary mode!"
                    echo ""
                    info "Next steps:"
                    echo "  1. Review generated README.md, CONTRIBUTING.md, SECURITY.md"
                    echo "  2. Update repo.ini with your organisation/repo information"
                    echo "  3. Run: git add -A && git commit -m 'chore: initialise as proprietary project'"
                    echo ""
                else
                    info "Initialisation cancelled."
                    exit 0
                fi
            else
                info "Initialisation cancelled."
                exit 0
            fi
            ;;
        
        *)
            error "Invalid choice. Please enter 1 or 2."
            exit 1
            ;;
    esac
}

main "$@"
