
if Server then

local origU = TeamJoin.OnUpdate

  function TeamJoin:OnUpdate()
  
     origU(self)
        if self.teamNumber == 1 and not self.teamIsFull and self.playerCount < 12 and GetMarineQueue() ~= nil then
          -- Print("Not null marineteam")
           if not GetMarineQueue():isEmpty() then
            -- Print("Umm 1")
               GetMarineQueue():dequeue()
           end
        elseif self.teamNumber == 2 and not self.teamIsFull and self.playerCount < 12 and GetAlienQueue() ~= nil then
          -- Print("Not null alienteam")
           if not GetAlienQueue():isEmpty() then
           -- Print("Umm 2")
               GetAlienQueue():dequeue()
           end
        end
  end


end