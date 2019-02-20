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

    def test_shouldReturnValueWithoutDelete(self):
        self.stack.push(100)
        self.assertEquals(self.stack.peek(), 100)
        self.assertFalse(self.stack.isEmpty())

    def test_shouldSayStackIsFull(self):
        self.stack.push(100)
        self.stack.push(200)
        self.stack.push(300)
        self.stack.push(400)
        self.stack.push(500)
        self.assertTrue(self.stack.isFull())