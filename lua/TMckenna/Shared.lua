

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
