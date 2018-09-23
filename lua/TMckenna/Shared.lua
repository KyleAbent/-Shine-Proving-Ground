Script.Load("lua/shine/extensions/provingground/linkedQueue/Node.lua")
Script.Load("lua/shine/extensions/provingground/linkedQueue/linkedQueue.lua")
Script.Load("lua/getSharedNode.lua")

function SetTeamJoinMaxTeamSize(int) 

        for index, tj in ientitylist(Shared.GetEntitiesWithClassname("TeamJoin")) do
                 tj:setMaxTeamSize(int)
        end
        
end

function GetMarineTeamJoin()

        for index, tj in ientitylist(Shared.GetEntitiesWithClassname("TeamJoin")) do
              if tj.teamNumber == 1 then 
                 return tj
              end
        end
        
return nil
end
function GetAlienTeamJoin()

        for index, tj in ientitylist(Shared.GetEntitiesWithClassname("TeamJoin")) do
              if tj.teamNumber == 2 then 
                 return tj
              end
        end
        
return nil
end
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
