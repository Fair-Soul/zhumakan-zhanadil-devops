#!/bin/bash
# Simple checks of the project. Used in the Jenkins "Test" stage,
# but can also be run by hand: ./scripts/test_project.sh

cd "$(dirname "$0")/.." || exit 1

PASSED=0
FAILED=0

check() {
    # $1 = description, the rest = command to run
    local description="$1"
    shift
    if "$@" > /dev/null 2>&1; then
        echo "[PASS] $description"
        PASSED=$((PASSED + 1))
    else
        echo "[FAIL] $description"
        FAILED=$((FAILED + 1))
    fi
}

echo "Running project checks..."

for dir in app scripts config; do
    check "directory $dir/ exists" test -d "$dir"
done

for file in Zhumakan_Zhanadil_info.txt config/app.conf app/app.py \
            scripts/Zhumakan_Zhanadil_system.sh Dockerfile docker-compose.yml \
            Jenkinsfile .gitignore; do
    check "file $file exists" test -f "$file"
done

check "info file contains Student ID" grep -q "Student ID: 38093" Zhumakan_Zhanadil_info.txt

for instruction in FROM WORKDIR COPY RUN EXPOSE CMD; do
    check "Dockerfile uses $instruction" grep -q "^$instruction " Dockerfile
done

for pattern in '*.log' 'backup/' '.env'; do
    check ".gitignore ignores $pattern" grep -qxF "$pattern" .gitignore
done

check "system script has no syntax errors" bash -n scripts/Zhumakan_Zhanadil_system.sh
check "system script finds the info file" \
    bash -c "bash scripts/Zhumakan_Zhanadil_system.sh | grep -q 'Student information file exists.'"

echo "----------------------------------------"
echo "Passed: $PASSED, Failed: $FAILED"

if [ "$FAILED" -ne 0 ]; then
    echo "Some checks failed"
    exit 1
fi
echo "All checks passed"
