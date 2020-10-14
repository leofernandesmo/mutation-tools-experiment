package br.edu.ifal.mutationexperiment.mystack;

//JUnit4
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import org.junit.Test;


public class MyStackTest  {

  private MyStack stack = new MyStack(5);
    
  @Test  
  public void shouldInsertAndRemoveWithoutProblem() throws Exception {    
    stack.push(100);
    assertEquals(100, stack.pop());
    stack.push(200);
    stack.push(100);
    stack.push(50);
    assertEquals(50, stack.pop());
  }

  @Test  
  public void shouldReturnValueWithoutDelete() throws Exception {
    stack.push(100);
    assertEquals(100, stack.peek());
    assertFalse(stack.isEmpty());
  }

  @Test  
  public void shouldSayStackIsFull() throws Exception {
    stack.push(100);
    stack.push(200);
    stack.push(300);
    stack.push(400);
    stack.push(500);
    assertTrue(stack.isFull());
  }
}