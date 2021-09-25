import unittest
from collections import defaultdict

from dijkstra import dijkstra


class TestDijkstra(unittest.TestCase):
    def test_example_one(self):

        graph = defaultdict(dict)
        graph["start"]["a"] = 6
        graph["start"]["b"] = 2
        graph["a"]["fin"] = 1
        graph["b"]["a"] = 3
        graph["b"]["fin"] = 5
        graph["fin"] = {}

        self.assertEqual(dijkstra(graph, "start", "fin"), ("start", "b", "a", "fin"))

    def test_example_two(self):

        graph = defaultdict(dict)
        graph["start"]["a"] = 5
        graph["start"]["b"] = 2
        graph["a"]["c"] = 4
        graph["a"]["d"] = 2
        graph["b"]["a"] = 8
        graph["b"]["d"] = 7
        graph["c"]["d"] = 6
        graph["c"]["fin"] = 3
        graph["d"]["fin"] = 1
        graph["fin"] = {}

        self.assertEqual(dijkstra(graph, "start", "fin"), ("start", "a", "d", "fin"))

    def test_example_three(self):

        graph = defaultdict(dict)
        graph["fin"] = {}
        graph["start"]["a"] = 10
        graph["a"]["b"] = 20
        graph["b"]["c"] = 1
        graph["b"]["fin"] = 30
        graph["c"]["a"] = 1

        self.assertEqual(dijkstra(graph, "start", "fin"), ("start", "a", "b", "fin"))


if __name__ == "__main__":
    unittest.main()
