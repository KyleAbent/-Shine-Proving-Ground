 --no loops required
  class 'queueNode' (Entity)
  queueNode.kMapName = "queuenode"

   local networkVars = 
{
    data = "string (256)",
    priority = 'integer',
    nextNode = "private entityid",
    prevNode = "private entityid",
}
function queueNode:OnCreate()
      Print("Node created") 
     self.data = nil
     self.priority = 0
     self.nextNode = Entity.invalidI 
     self.prevNode = Entity.invalidI 
end

 function queueNode:getData() 
      return self.data
      end

   function queueNode:getNextNode() 
      return nextNode;
   end

   function queueNode:getPriority() 
      return self.priority;
   end

   function queueNode:setPriority( priority) 
      self.priority = priority;
   end

   function queueNode:setData(data) 
      self.data = data;
   end

   function queueNode:setNextNode(nextNode) 
      self.nextNode = nextNode;
   end
   
   
    function queueNode:Node(data, next, prev, prior)

      self.data = data;
      self.nextNode = next;
      self.nextNode = prev;
      self.priority = prior;
    end

  function queueNode:getPrevNode() 
      return prevNode;
   end

   function queueNode:setPrevNode(prevNode) 
      self.prevNode = prevNode;
   end
   
function queueNode:GetIsMapEntity()
return true
end
   
Shared.LinkClassToMap("queueNode", queueNode.kMapName, networkVars)
