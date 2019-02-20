import unittest
from MyStack import MyStack

class MyStackTest(unittest.TestCase):
    def setUp(self):
        self.stack = MyStack(5)

    def test_shouldInsertAndRemoveWithoutProblem(self):
        self.stack.push(100)
        self.assertEquals(self.stack.pop(), 100)
        self.stack.push(200)
        self.stack.push(100)
        self.stack.push(50)
        self.assertEquals(self.stack.pop(), 100)