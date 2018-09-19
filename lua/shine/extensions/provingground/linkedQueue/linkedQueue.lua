--Kyle Abent -- Data Structures -- linked Queue (Java to Lua) -- better perf, less time

  class 'linkedQueue' (Entity)
  linkedQueue.kMapName = "linkedqueue"


   local networkVars = 
{
    front = "private entityid",
    back = "private entityid",
}

function linkedQueue:OnCreate() 
     self.front = Entity.invalidI 
     self.back = Entity.invalidI 
end

function linkedQueue:GetIsMapEntity()
return true
end
  function linkedQueue:enqueue(newEntry)
   
      print("~~~~~~~~~~~~~~~~~~~~~~~~" )
      print("LinkedQueue myQueue enqueue()" )
      print("~~~~~~~~~~~~~~~~~~~~~~~~" )    
      if (self:isEmpty()) then
         self.back = newEntry
         self.front = newEntry
         return
      end

     local current = self.back
            //System.out.println("Back priority is " + current.getPriority() )
           // System.out.println("newEntry priority is " + newEntry.getPriority() )
            
                    //While loop continuing until priority implementation is complete.
      local hasPrioritized = false
      while(not hasPrioritized) do
                  //Easy entrant, first try without checking other index positions
         if (newEntry:getPriority() < current:getPriority() ) then
            newEntry:setNextNode(self.back) //pointer to what was prev
            self.back:setPrevNode(newEntry) //back set to new item
            self.back = newEntry            //backpointer to new item
            self.back:setPrevNode(Entity.invalidI)    //previous of new back is Entity.invalidI. Definition of back.
            hasPrioritized = true
                 // System.out.println("test 1")
         end
                   //Tougher implementation, nested loop, moving between from left to right if valid position, moving index pos for priority check
         while(current ~= front and current:getNextNode():getPriority() < newEntry:getPriority() )  do
            current = current:getNextNode() //could error?
              // System.out.println("test 2")
        end
                  //From left to right if priority fits into this place then adjust accordingly
         if (newEntry:getPriority() > current:getPriority() ) then
                   //   System.out.println("current is " + current.getData())
                         //Special Rules for non front and front.
            if(current ~= self.front) then
               current:getNextNode():setPrevNode(newEntry)
               newEntry:setNextNode(current:getNextNode())
         -- end
            else
               front = newEntry
               front:setNextNode(Entity.invalidI)
            end
            currentLsetNextNode(newEntry)          
            newEntryLsetPrevNode(current)
            hasPrioritized = true
               //  System.out.println("test 3")
        end
                  
         if (current ~= front) then
            current = current:getNextNode() //could error?
         
         else
            hasPrioritized = true//although false. No other areas to check. Hm.
        end
      
      end
   
   end
      //deleteFront   // deletes an integer from the front of the dequeue, assuming dequeue is not empty
  /** Removes and returns the entry at the front of this queue.
      @return  The object at the front of the queue. 
      @throws  EmptyQueueException if the queue is empty before the operation. */
  function linkedQueue:dequeue()
      print("~~~~~~~~~~~~~~~~~~~~~~~~" )
      print("LinkedQueue myQueue dequeue()" )
      print("~~~~~~~~~~~~~~~~~~~~~~~~" )
      if(self:isEmpty()) then
         return false --"queue is empty, cannot deque"
       end  
       //else}
      local tempNode
      tempNode = self.front
      self.front = front:getPrevNode()
        
      if (self.front == Entity.invalidI) then
         self.back = Entity.invalidI
      else
         self.front:setNextNode(Entity.invalidI)
       end
      return tempNode
  end
 
  //insertFront   // inserts a new integer at the front of the dequeue
  function linkedQueue:insertFront(newEntry)
      print("~~~~~~~~~~~~~~~~~~~~~~~~" )
      print("LinkedQueue myQueue insertFront()" )
      print("~~~~~~~~~~~~~~~~~~~~~~~~" )
      
      if (self:isEmpty()) then
      
         self.back = newEntry
         self.front = newEntry
         return
      end
      local current = self.front
         //   System.out.println("Back priority is " + current.getPriority() )
          //  System.out.println("newEntry priority is " + newEntry.getPriority() )
            
                    //While loop continuing until priority implementation is complete.
      local hasPrioritized = false
      while(not hasPrioritized) do
                  //Easy entrant, first try without checking other index positions
         if (newEntry:getPriority() > current:getPriority() ) then
            newEntry:setPrevNode(front) //pointer to what was prev
            self.front:setNextNode(newEntry) //back set to new item
            self.front = newEntry            //backpointer to new item
            front:setNextNode(Entity.invalidI)    //previous of new back is Entity.invalidI. Definition of back.
            hasPrioritized = true
                //   System.out.println("111 current is " + current.getData() + " priority is " + current.getNextNode().getPriority() + " new entry priority is " +  newEntry.getPriority())
               //   System.out.println("test 1")
        end
                   //Tougher implementation, nested loop, moving between from left to right if valid position, moving index pos for priority check
         while(current ~= self.back and current:getPrevNode():getPriority() > newEntry:getPriority() )  do
            current = current:getPrevNode() //could error?
             //  System.out.println("222 current is " + current.getData() + " priority is " + current.getNextNode().getPriority() + " new entry priority is " +  newEntry.getPriority())
         end
                  //From left to right if priority fits into this place then adjust accordingly
         if (newEntry:getPriority() <current:getPriority() ) then
                   //   System.out.println("current is " + current.getData())
                         //Special Rules for non front and front.
            if(current ~= self.back) then
               current:getPrevNode():setNextNode(newEntry)
               newEntry:setPrevNode(current:getPrevNode())
            else
               self.back = newEntry
               self.back:setNextNode(Entity.invalidI)
            end
            current:setPrevNode(newEntry)          
            newEntry:setNextNode(current)
            hasPrioritized = true
               //  System.out.println("test 3")
       end
                  
         if (current ~= self.back) then
            current = current:getPrevNode() //could error?
         else
            hasPrioritized = true//although false. No other areas to check. Hm.
        end
      
      end
   
          
  end
  //deleteBack    // deletes an integer from the back of the dequeue, assuming dequeue is not empty
   function linkedQueue:deleteBack()
      print("~~~~~~~~~~~~~~~~~~~~~~~~" )
      print("LinkedQueue myQueue deleteBack()" )
      print("~~~~~~~~~~~~~~~~~~~~~~~~" )
      if(self:isEmpty()) then
         return false
       end
      
      local tempNode = back
      self.back = self:getNextNode()
                 
      if (self.back == Entity.invalidI) then
         self.front = Entity.invalidI
      else
         self.back:setPrevNode(Entity.invalidI)
      end
      return tempNode
   end

   function linkedQueue:isEmpty()
     
      if(front == Entity.invalidI) then
      
         return true
      end
      return false
   end

   function linkedQueue:clear()
      print("LinkedQueue myQueue clear()" )
      print("~~~~~~~~~~~~~~~~~~~~~~~~" )
      self.front = Entity.invalidI
      self.back = Entity.invalidI
  end

  //print         // print the contents of the dequeue (one int per line) 
   function linkedQueue:print()
      print("~~~~~~~~~~~~~~~~~~~~~~~~" )
      print("LinkedQueue myQueue print()" )
      print("~~~~~~~~~~~~~~~~~~~~~~~~" )
   
      local current = Shared.GetEntity(self.front)    // start at beginning of list
      print("***Front***" )      
      while(current ~= Entity.invalidI )  do    // until end of list,
      
      
         print(  string.format("%s , %s",  current:getData(), current:getPriority() ))
      
         current = current:getPrevNode()  // move to next link
      
      end
      print("***Back***" )
   
   end
   
        Shared.LinkClassToMap("linkedQueue", linkedQueue.kMapName, networkVars)
     
    
