# 43030 Task Manager CI/CD (Lecture 4 activities)

A small Python task manager with unit tests, containerised with Docker and run by GitHub Actions.

- `ci.yml` builds and runs the Docker image on every push to `main`. The container runs `todo.py` and `todo-test.py`, then `update_index.sh` writes the task lists and test results into `index.html` and commits it.
- `tracker.yml` runs when a pull request is merged and moves the linked issue to **Done** on the GitHub Projects board.

