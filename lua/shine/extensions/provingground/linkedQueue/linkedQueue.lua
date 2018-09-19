--Kyle Abent -- Data Structures -- linked Queue (Java to Lua) -- better perf, less time

  class 'linkedQueue' (Entity)
  linkedQueue.kMapName = "linkedqueue"


   local networkVars = 
{
    front = "private entityid",
    back = "private entityid",
}

function linkedQueue:OnCreate() 
       if Server then
     self.front = Entity.invalidI 
     self.back = Entity.invalidI 
     end
end

function linkedQueue:GetIsMapEntity()
return true
end
  function linkedQueue:enqueue(newEntry)
   --   print("newEntry is " + newEntry )
    --  newEntry = Shared.GetEntity(newEntry)
   --   print("newEntry is " + newEntry )
      print("~~~~~~~~~~~~~~~~~~~~~~~~" )
      print("LinkedQueue myQueue enqueue()" )
      print("~~~~~~~~~~~~~~~~~~~~~~~~" )    
      if self:isEmpty() then
         self.back = newEntry
         self.front = newEntry
         print("Empty" )
         return
      else
      print(   string.format("Back  is %s", Shared.GetEntity(self.back) )  )
      print(  string.format("Front  is %s",  Shared.GetEntity(self.front) ) )
      end
      
     local current = Shared.GetEntity(self.back)
            --print("Back priority is " + current:getPriority() )
           -- print("newEntry priority is " + newEntry:getPriority() )
            
                    //While loop continuing until priority implementation is complete.

      local hasPrioritized = false
      while(not hasPrioritized) do
                  //Easy entrant, first try without checking other index positions
         if (Shared.GetEntity(newEntry):getPriority() < current:getPriority() ) then
            Shared.GetEntity(newEntry):setNextNode(self.back) //pointer to what was prev
            Shared.GetEntity(self.back):setPrevNode(newEntry) //back set to new item
            self.back = newEntry            //backpointer to new item
            Shared.GetEntity(self.back):setPrevNode(Entity.invalidI)    //previous of new back is Entity.invalidI. Definition of back.
            hasPrioritized = true
                  print("test 1")
         end
                   //Tougher implementation, nested loop, moving between from left to right if valid position, moving index pos for priority check
         while(current ~= Shared.GetEntity(self.front) and Shared.GetEntity(current:getNextNode()):getPriority() < Shared.GetEntity(newEntry):getPriority() )  do
            current = Shared.GetEntity(current:getNextNode()) //could error?
               print("test 2")
        end
                  //From left to right if priority fits into this place then adjust accordingly
         if (Shared.GetEntity(newEntry):getPriority() > current:getPriority() ) then
                 --     print("current is " + current:getData())
                         //Special Rules for non front and front.
            if(current ~= Shared.GetEntity(self.front)) then
               Shared.GetEntity(current:getNextNode()):setPrevNode(newEntry)
               Shared.GetEntity(newEntry):setNextNode(current:getNextNode())
         -- end
            else
               self.front = newEntry
               Shared.GetEntity(self.front):setNextNode(Entity.invalidI)
            end
            current:setNextNode(newEntry)          
            Shared.GetEntity(newEntry):setPrevNode(current)
            hasPrioritized = true
                 print("test 3")
        end
                  
         if (current ~= self.front) then
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
      local tempNode = self.front
      self.front = Shared.GetEntity(self.front):getPrevNode()
        
      if (self.front == Entity.invalidI) then
         self.back = Entity.invalidI
      else
         Shared.GetEntity(self.front):setNextNode(Entity.invalidI)
       end
      return tempNode
  end
 
  //insertFront   // inserts a new integer at the front of the dequeue
  function linkedQueue:insertFront(newEntry) --I've been advised to breakoff this into seperate functions
      print("~~~~~~~~~~~~~~~~~~~~~~~~" )
      print("LinkedQueue myQueue insertFront()" )
      print("~~~~~~~~~~~~~~~~~~~~~~~~" )
      
      if (self:isEmpty()) then
         self.back = newEntry
         self.front = newEntry
       --  Print("is Empty")
         return
      end
      local current = Shared.GetEntity(self.front)
          --  print("Back priority is " + current.getPriority() )
           -- print("newEntry priority is " + newEntry.getPriority() )
            
                    //While loop continuing until priority implementation is complete.
      local hasPrioritized = false
      while(not hasPrioritized) do
                  //Easy entrant, first try without checking other index positions
         if (Shared.GetEntity(newEntry):getPriority() > current:getPriority() ) then
            Shared.GetEntity(newEntry):setPrevNode(self.front) //pointer to what was prev
            Shared.GetEntity(self.front):setNextNode(newEntry) //back set to new item
            self.front = newEntry            //backpointer to new item
            Shared.GetEntity(self.front):setNextNode(Entity.invalidI)    //previous of new back is Entity.invalidI. Definition of back.
            hasPrioritized = true
              --  print("111 current is " + current:getData() + " priority is " + Shared.GetEntity(current:getNextNode()).getPriority() + " new entry priority is " +  Shared.GetEntity(newEntry):getPriority())
              -- print("test 1")
        end
                   //Tougher implementation, nested loop, moving between from left to right if valid position, moving index pos for priority check
         while(current ~= Shared.GetEntity(self.back) and Shared.GetEntity(current:getPrevNode()):getPriority() > Shared.GetEntity(newEntry):getPriority() )  do
            current = Shared.GetEntity(current:getPrevNode()) //could error?
             --  print("222 current is " + current:getData() + " priority is " + current:getNextNode():getPriority() + " new entry priority is " +  newEntry.getPriority())
         end
                  //From left to right if priority fits into this place then adjust accordingly
         if (Shared.GetEntity(newEntry):getPriority() <current:getPriority() ) then
                  --  print("current is " + current:getData())
                         //Special Rules for non front and front.
            if(current ~= Shared.GetEntity(self.back)) then
               Shared.GetEntity(current:getPrevNode()):setNextNode(newEntry)
               Shared.GetEntity(newEntry):setPrevNode(current:getPrevNode())
            else
               self.back = newEntry
               Shared.GetEntity(self.back):setNextNode(Entity.invalidI)
            end
            current:setPrevNode(newEntry)          
            Shared.GetEntity(newEntry):setNextNode(current)
            hasPrioritized = true
                 print("test 3")
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
      local tempNode = self.back
      self.back =  Shared.GetEntity(tempNode):getNextNode()
      if (self.back == Entity.invalidI) then
         self.front = Entity.invalidI
      else
          Shared.GetEntity(self.back):setPrevNode(Entity.invalidI)
      end
      return tempNode
   end

   function linkedQueue:isEmpty()     
      if Shared.GetEntity(self.front) == nil then
       --  Print("Is Empty")
         return true
      end
       --Print("Is not Empty")
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
         current = Shared.GetEntity(current:getPrevNode())  // move to next link
      end
      print("***Back***" )
   end
        
Shared.LinkClassToMap("linkedQueue", linkedQueue.kMapName, networkVars)