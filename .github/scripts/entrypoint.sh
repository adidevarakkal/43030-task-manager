#!/bin/bash
set -e
set -o pipefail

SCRIPTS=/app/.github/scripts

echo "Running task manager..."
python3 "$SCRIPTS/todo.py" | tee /tmp/tasks.txt

echo "Running unit tests..."
python3 "$SCRIPTS/todo-test.py" | tee /tmp/tests.txt

echo "Updating index.html..."
bash "$SCRIPTS/update_index.sh" /tmp/tasks.txt /tmp/tests.txt

echo "Pipeline scripts finished."
