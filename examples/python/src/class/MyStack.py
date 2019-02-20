class MyStack:
    def __init__(self, size):
        self.maxSize = size
        self.items = []
    
    def push(self, data):
        if self.items.__len__ < self.maxSize
            self.items.append(data)

    def pop(self):
        return self.items.pop()
    
    def peek(self):
        if self.items:
            return self.items[-1]
    
    def isEmpty(self):
        return self.items == []

    def isFull(self):
        return (self.items.__len__() == (self.maxSize - 1))

if __name__ == '__main__':
    s = MyStack(5)
    s.push(10)
    s.push(20)
    s.push(30)
    s.push(40)
    s.push(50)

    while (s.isEmpty() == False):
        print(s.pop())
        print(' ')

    print ('end')