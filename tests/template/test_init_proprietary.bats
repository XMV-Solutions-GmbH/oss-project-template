#!/usr/bin/env bats
# SPDX-License-Identifier: MIT OR Apache-2.0
# =============================================================================
# Tests for init-project.sh - Proprietary Mode
# =============================================================================

load 'helpers'

setup() {
    setup_test_repo
}

teardown() {
    teardown_test_repo
}

@test "Proprietary mode: init script runs successfully" {
    run run_init_script proprietary
    [ "$status" -eq 0 ]
}

@test "Proprietary mode: LICENSE files are removed" {
    run_init_script proprietary
    assert_file_not_exists "LICENSE"
    assert_file_not_exists "LICENSE-MIT"
    assert_file_not_exists "LICENSE-APACHE"
}

@test "Proprietary mode: CODE_OF_CONDUCT.md is removed" {
    run_init_script proprietary
    assert_file_not_exists "CODE_OF_CONDUCT.md"
}

@test "Proprietary mode: ISSUE_TEMPLATE directory is removed" {
    run_init_script proprietary
    assert_dir_not_exists ".github/ISSUE_TEMPLATE"
}

@test "Proprietary mode: docs/howto-oss.md is removed" {
    run_init_script proprietary
    assert_file_not_exists "docs/howto-oss.md"
}

@test "Proprietary mode: templates directory is removed" {
    run_init_script proprietary
    assert_dir_not_exists "templates"
}

@test "Proprietary mode: init-project.sh is removed" {
    run_init_script proprietary
    assert_file_not_exists ".github/gh-scripts/init-project.sh"
}

@test "Proprietary mode: init-project.prompt.md is removed" {
    run_init_script proprietary
    assert_file_not_exists ".github/prompts/init-project.prompt.md"
}

@test "Proprietary mode: PROJECT_MODE is set to PROPRIETARY in copilot-instructions" {
    run_init_script proprietary
    assert_file_contains ".github/copilot-instructions.md" "PROJECT_MODE: PROPRIETARY"
}

@test "Proprietary mode: README.md is replaced with proprietary version" {
    run_init_script proprietary
    assert_file_contains "README.md" "CONFIDENTIAL"
    assert_file_contains "README.md" "Test Project"
}

@test "Proprietary mode: CONTRIBUTING.md is replaced with proprietary version" {
    run_init_script proprietary
    assert_file_contains "CONTRIBUTING.md" "Internal Guidelines"
}

@test "Proprietary mode: SECURITY.md is replaced with proprietary version" {
    run_init_script proprietary
    assert_file_contains "SECURITY.md" "Internal Document"
}

@test "Proprietary mode: SPDX headers are updated to PROPRIETARY" {
    run_init_script proprietary
    # Check a shell script for updated header
    if [[ -f "$REPO_ROOT/.github/gh-scripts/new-feature.sh" ]]; then
        assert_file_contains ".github/gh-scripts/new-feature.sh" "LicenseRef-Proprietary"
    fi
}

@test "Proprietary mode: tests/template directory is removed" {
    run_init_script proprietary
    assert_dir_not_exists "tests/template"
}
