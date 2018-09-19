
if Server then

local origU = TeamJoin.OnUpdate

  function TeamJoin:OnUpdate()
  
     origU(self)
        if self.teamNumber == 1 and not self.teamIsFull and self.playerCount < 12 and GetMarineQueue() ~= nil then
           --Print("Not null marineteam")
           if not GetMarineQueue():isEmpty() then
               GetMarineQueue():dequeue()
           end
        elseif self.teamNumber == 2 and not self.teamIsFull and self.playerCount < 12 and GetAlienQueue() ~= nil then
           --Print("Not null alienteam")
           if not GetAlienQueue():isEmpty() then
               GetAlienQueue():dequeue()
           end
        end
  end


end