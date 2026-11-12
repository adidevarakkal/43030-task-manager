import unittest
from io import StringIO

from todo import Task, TaskPool


class TestTaskPool(unittest.TestCase):
    def setUp(self):
        # Runs before each test
        self.pool = TaskPool()

    def test_add_task(self):
        task = Task("New task")
        self.pool.add_task(task)
        self.assertEqual(len(self.pool.tasks), 1)

    def test_get_open_tasks(self):
        self.pool.populate()
        open_tasks = self.pool.get_open_tasks()
        self.assertEqual(len(open_tasks), 3)
        self.assertTrue(all(task.status == "ToDo" for task in open_tasks))

    def test_get_done_tasks(self):
        self.pool.populate()
        done_tasks = self.pool.get_done_tasks()
        self.assertEqual(len(done_tasks), 3)
        self.assertTrue(all(task.status == "Done" for task in done_tasks))


if __name__ == "__main__":
    suite = unittest.TestLoader().loadTestsFromTestCase(TestTaskPool)
    stream = StringIO()
    result = unittest.TextTestRunner(stream=stream, verbosity=2).run(suite)

    # Print one clean line per test, e.g. "test_add_task ... ok"
    for line in stream.getvalue().splitlines():
        if line.startswith("test_") and " ... " in line:
            name = line.split(" ")[0]
            outcome = line.rsplit(" ... ", 1)[1]
            print(f"{name} ... {outcome}")

    raise SystemExit(0 if result.wasSuccessful() else 1)
