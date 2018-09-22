Script.Load("lua/shine/extensions/provingground/linkedQueue/Node.lua")
Script.Load("lua/shine/extensions/provingground/linkedQueue/linkedQueue.lua")
Script.Load("lua/getSharedNode.lua")

function GetMarineQueue() 

        for index, queue in ientitylist(Shared.GetEntitiesWithClassname("linkedQueue")) do
              if queue.sett == 1 then 
                 return queue
              end
        end
        
return nil
end

function GetAlienQueue() 
        for index, queue in ientitylist(Shared.GetEntitiesWithClassname("linkedQueue")) do
              if queue.sett == 2 then 
                 return queue
              end
        end
    return nil
end
