#!/usr/bin/env bash
# SPDX-License-Identifier: MIT OR Apache-2.0
# =============================================================================
# Test Helper Functions for Template Tests
# =============================================================================

# Create a temporary copy of the repository for testing
setup_test_repo() {
    TEST_DIR=$(mktemp -d)
    export TEST_DIR
    
    # Copy repository to temp dir (excluding .git to avoid issues)
    rsync -a --exclude='.git' "$BATS_TEST_DIRNAME/../../.." "$TEST_DIR/repo/"
    
    # Initialise a fresh git repo for the test
    cd "$TEST_DIR/repo" || exit 1
    git init -q
    git config user.email "test@example.com"
    git config user.name "Test User"
    git add -A
    git commit -q -m "Initial commit"
    
    export REPO_ROOT="$TEST_DIR/repo"
}

# Clean up temporary directory
teardown_test_repo() {
    if [[ -n "$TEST_DIR" && -d "$TEST_DIR" ]]; then
        rm -rf "$TEST_DIR"
    fi
}

# Run init-project.sh with simulated input
run_init_script() {
    local mode="$1"
    local input=""
    
    case "$mode" in
        oss|OSS|1)
            input="1\ny\n"
            ;;
        proprietary|PROPRIETARY|2)
            # Mode, confirm, org, project name, description, team email, security email, confirm
            input="2\ny\nTest Org\nTest Project\nA test project\ndev@test.org\nsecurity@test.org\ny\n"
            ;;
        *)
            echo "Unknown mode: $mode" >&2
            return 1
            ;;
    esac
    
    cd "$REPO_ROOT" || exit 1
    echo -e "$input" | bash .github/gh-scripts/init-project.sh 2>&1
}

# Assert file exists
assert_file_exists() {
    local file="$1"
    if [[ ! -f "$REPO_ROOT/$file" ]]; then
        echo "Expected file to exist: $file" >&2
        return 1
    fi
}

# Assert file does not exist
assert_file_not_exists() {
    local file="$1"
    if [[ -f "$REPO_ROOT/$file" ]]; then
        echo "Expected file to NOT exist: $file" >&2
        return 1
    fi
}

# Assert directory exists
assert_dir_exists() {
    local dir="$1"
    if [[ ! -d "$REPO_ROOT/$dir" ]]; then
        echo "Expected directory to exist: $dir" >&2
        return 1
    fi
}

# Assert directory does not exist
assert_dir_not_exists() {
    local dir="$1"
    if [[ -d "$REPO_ROOT/$dir" ]]; then
        echo "Expected directory to NOT exist: $dir" >&2
        return 1
    fi
}

# Assert file contains string
assert_file_contains() {
    local file="$1"
    local pattern="$2"
    if ! grep -q "$pattern" "$REPO_ROOT/$file" 2>/dev/null; then
        echo "Expected '$pattern' in $file" >&2
        return 1
    fi
}

# Assert file does not contain string
assert_file_not_contains() {
    local file="$1"
    local pattern="$2"
    if grep -q "$pattern" "$REPO_ROOT/$file" 2>/dev/null; then
        echo "Did not expect '$pattern' in $file" >&2
        return 1
    fi
}
