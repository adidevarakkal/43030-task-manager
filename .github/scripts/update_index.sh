#!/bin/bash
set -e

TASKS_FILE="$1"   # output of todo.py
TESTS_FILE="$2"   # output of todo-test.py
HTML_FILE="index.html"

# Data extraction
TODO_TASKS=$(awk '/^ToDo Tasks:/{flag=1; next} /^Done Tasks:/{flag=0} flag' "$TASKS_FILE")
DONE_TASKS=$(awk '/^Done Tasks:/{flag=1; next} flag' "$TASKS_FILE")
TEST_RESULTS=$(cat "$TESTS_FILE")

# Replace the content of <pre id="..."> in the HTML file
update_pre() {
  local id="$1" content="$2" file="$3"
  ID="$id" CONTENT="$content" perl -0pi -e \
    's{(<pre id="\Q$ENV{ID}\E">).*?(</pre>)}{$1$ENV{CONTENT}$2}s' "$file"
}

update_pre "todo-tasks" "$TODO_TASKS" "$HTML_FILE"
update_pre "done-tasks" "$DONE_TASKS" "$HTML_FILE"
update_pre "test-results" "$TEST_RESULTS" "$HTML_FILE"

# Git integration
git config --global user.name "github-actions"
git config --global user.email "github-actions@users.noreply.github.com"
git config --global --add safe.directory /app

git add "$HTML_FILE"
git commit -m "Update index.html with tasks and test results (${GITHUB_USER:-unknown})" || echo "No changes to commit"

if [ -n "$GITHUB_TOKEN" ] && [ -n "$GITHUB_REPOSITORY" ]; then
  git config --local --unset-all http.https://github.com/.extraheader || true
  git remote set-url origin "https://x-access-token:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}"
  git push origin HEAD:main
else
  echo "No GITHUB_TOKEN set, skipping push (local run)."
fi
