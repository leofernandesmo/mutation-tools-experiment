#include <iostream>       // std::cout
#include <stack>          // std::stack
#include <vector>         // std::vector
#include <deque>          // std::deque
#include <stdio.h>

class MyStack
{
private:
    int maxSize = -1;
    int top = -1;
    long stackArray[0];
public:
    MyStack(int s);

    void push(long j)
    {
        stackArray[++top] = j;
    }

    long pop() 
    {
      return stackArray[top--];
    }
    
    long peek() {
      return stackArray[top];
    }
    
    bool isEmpty() {
      return (top == -1);
    }
    
    bool isFull() {
      return (top == maxSize);
    }

};

MyStack::MyStack(int s)
{
    maxSize = s;
    stackArray[maxSize];
    top = -1;
}

int main() 
{
      MyStack theStack(5); 
      theStack.push(10);
      theStack.push(20);
      theStack.push(30);
      theStack.push(40);
      theStack.push(50);
      
      printf ("Print stack values:\n");

      while (!theStack.isEmpty()) {
         long value = theStack.pop();
         printf ("%ld\n", value);
         printf ("------\n");
      }
      printf ("End.\n");

      return 0;
}