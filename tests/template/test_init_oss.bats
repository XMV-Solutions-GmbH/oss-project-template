#!/usr/bin/env bats
# SPDX-License-Identifier: MIT OR Apache-2.0
# =============================================================================
# Tests for init-project.sh - OSS Mode
# =============================================================================

load 'helpers'

setup() {
    setup_test_repo
}

teardown() {
    teardown_test_repo
}

@test "OSS mode: init script runs successfully" {
    run run_init_script oss
    [ "$status" -eq 0 ]
}

@test "OSS mode: LICENSE files are kept" {
    run_init_script oss
    assert_file_exists "LICENSE"
    assert_file_exists "LICENSE-MIT"
    assert_file_exists "LICENSE-APACHE"
}

@test "OSS mode: CODE_OF_CONDUCT.md is kept" {
    run_init_script oss
    assert_file_exists "CODE_OF_CONDUCT.md"
}

@test "OSS mode: ISSUE_TEMPLATE directory is kept" {
    run_init_script oss
    assert_dir_exists ".github/ISSUE_TEMPLATE"
}

@test "OSS mode: templates directory is removed" {
    run_init_script oss
    assert_dir_not_exists "templates"
}

@test "OSS mode: init-project.sh is removed" {
    run_init_script oss
    assert_file_not_exists ".github/gh-scripts/init-project.sh"
}

@test "OSS mode: init-project.prompt.md is removed" {
    run_init_script oss
    assert_file_not_exists ".github/prompts/init-project.prompt.md"
}

@test "OSS mode: PROJECT_MODE is set to OSS in copilot-instructions" {
    run_init_script oss
    assert_file_contains ".github/copilot-instructions.md" "PROJECT_MODE: OSS"
}

@test "OSS mode: SPDX headers remain MIT OR Apache-2.0" {
    run_init_script oss
    assert_file_contains "README.md" "SPDX-License-Identifier: MIT OR Apache-2.0"
}

@test "OSS mode: README init hint is removed" {
    run_init_script oss
    assert_file_not_contains "README.md" "INIT_HINT_START"
    assert_file_not_contains "README.md" "INIT_HINT_END"
}

@test "OSS mode: tests/template directory is removed" {
    run_init_script oss
    assert_dir_not_exists "tests/template"
}
