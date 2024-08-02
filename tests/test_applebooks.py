# noqa: INP001

import os
import sys
import unittest
from queue import Queue
from threading import Event

test_dir = os.path.dirname(os.path.abspath(__file__))
sys.path = [test_dir, *sys.path]

from calibre_plugins.applebooks_covers import AppleBooksCovers

from calibre.utils.logging import default_log


class TestAppleBooksCovers(unittest.TestCase):
    def setUp(self):
        self.plugin = AppleBooksCovers(None)
        self.plugin.log = default_log
        self.queue = Queue()

    def test_isbn_lookup(self):
        self.plugin.download_cover(
            default_log,
            self.queue,
            Event(),
            title="The Fifth Witness",
            authors=("Michael Connelly",),
            identifiers={"isbn": "9780316069359"},
        )
        self.assertEqual(self.queue.qsize(), 1)

    def test_search(self):
        self.plugin.download_cover(
            default_log,
            self.queue,
            Event(),
            title="A Game of Thrones",
            authors=("George R. R. Martin",),
        )
        self.assertEqual(self.queue.qsize(), 5)


if __name__ == "__main__":
    unittest.main(module="test_applebooks", verbosity=2)
