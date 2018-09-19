--Kyle Abent -- Data Structures -- linked Queue (Java to Lua) -- better perf, less time
Script.Load("lua/shine/extensions/provingground/linkedQueue/Node.lua")
function Plugin:testQueue()
    
local node = Server.CreateEntity(queueNode.kMapName) 
local myQueue = Server.CreateEntity(linkedQueue.kMapName)


            node:Node("15", nil, nil, 10)
      myQueue:enqueue(node:GetId())   
      print(" enqueue 15, priority 10 ")


       node = Server.CreateEntity(queueNode.kMapName)
            node:Node("12", nil, nil, 6)
      myQueue:enqueue(node:GetId())      
      print(" enqueue 12, priotiy 6 ")
              
       node = Server.CreateEntity(queueNode.kMapName)
            node:Node("7", nil, nil, 4)
      myQueue:enqueue(node:GetId())      
      print(" enqueue 7, priority 4 ")
   
   
       node = Server.CreateEntity(queueNode.kMapName)
            node:Node("3", nil, nil, 2)
      myQueue:enqueue(node:GetId())      
      print(" enqueue 3, priority 3 ")
      
      //add to front 34 priority 5, should be 2nd to front

       node = Server.CreateEntity(queueNode.kMapName)
            node:Node("34", nil, nil, 5)
      myQueue:insertFront(node:GetId())      
      print(" insertFront 34, priority 5 ")
      print("");
      
       node = Server.CreateEntity(queueNode.kMapName)
            node:Node("93", nil, nil, 9)
      myQueue:insertFront(node:GetId())      
      print(" insertFront 93, priority 9 ")
      print("");
      
     //add to front 93 priority 3, should be 2nd to front
       node = Server.CreateEntity(queueNode.kMapName)
            node:Node("88", nil, nil, 8)
      myQueue:insertFront(node:GetId())      
      print(" insertFront 88, priority 8 ")
      print("");
      
      //add to back 12 priority 3, should be 2nd to last
       node = Server.CreateEntity(queueNode.kMapName)
            node:Node("96", nil, nil, 3)
      myQueue:enqueue(node:GetId())      
      print(" enqueue 96, priority 3 ")
       
       
       node = Server.CreateEntity(queueNode.kMapName)
            node:Node("42", nil, nil, 7)
      myQueue:enqueue(node:GetId())      
      print(" enqueue 42, priority 7 ")
      
       
       
      //myQueue:enqueue(new Node("99", null, null, 7));
      // print(" enqueue 99, priority 7 ");
      
          //Print 
      myQueue:print(); 
           //deleteFront
      print("");
      local dequeued = myQueue:dequeue()
            if dequeued then
             print( string.format("dequeue %s", Shared.GetEntity(dequeued):getData() ))
             end
           //Print 
      print("");
      myQueue:print(); 
            //deleteBack
      print("");
         dequeued = myQueue:deleteBack()
            if dequeued then
            print( string.format("deleteBack %s", Shared.GetEntity(dequeued):getData() ))
             end
          //Print 
      myQueue:print(); 
          //insertFront 5
      print("");
            node = Server.CreateEntity(queueNode.kMapName)
            node:Node("15", nil, nil,  10)
      myQueue:insertFront(node:GetId())   ;
      print(" insertFront 15, priority 10 ")
      print("");
        //Print 
      myQueue:print(); 
   
      
       // insertLast 3
           node = Server.CreateEntity(queueNode.kMapName)
            node:Node("3", nil, nil,  2)
      myQueue:insertFront(node:GetId())   ;
      print(" enqueue 3, priority 2 ")
      print("");
        //Print 
      myQueue:print(); 
      print("");
         //Clear
      myQueue:clear();
      print("Clearing and printing myQueue");
            //Print 
      print("");
      myQueue:print();
      
      
end


