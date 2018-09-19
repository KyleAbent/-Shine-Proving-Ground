--Kyle Abent -- Data Structures -- linked Queue (Java to Lua) -- better perf, less time
  class 'queueNode' (Entity)
  queueNode.kMapName = "queuenode"

   local networkVars = 
{
    data = "private string (256)", --steamid?
    priority = "private integer",
    nextNode = "private entityid",
    prevNode = "private entityid",
}
function queueNode:OnCreate()
     Print("Node created") 
     self.data = 'hm'
     self.priority = 0
     self.nextNode = Entity.invalidI 
     self.prevNode = Entity.invalidI 
end

 function queueNode:getData() 
      return self.data
      end

   function queueNode:getNextNode() 
      return self.nextNode
   end
  function queueNode:getPrevNode() 
      return self.prevNode
   end
   function queueNode:getPriority() 
      return self.priority
   end

   function queueNode:setPriority( priority) 
      self.priority = priority
   end

   function queueNode:setData(data) 
      self.data = data
   end

   function queueNode:setNextNode(nextNode) 
      self.nextNode = nextNode
   end
   
    function queueNode:Node(data, next, prev, prior)

      self.data = data
      self.nextNode = next
      self.nextNode = prev
      self.priority = prior
    end



   function queueNode:setPrevNode(prevNode) 
      self.prevNode = prevNode
   end
   
function queueNode:GetIsMapEntity()
return true
end
   
Shared.LinkClassToMap("queueNode", queueNode.kMapName, networkVars)
