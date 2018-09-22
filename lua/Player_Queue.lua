--Because I would rather not add a for loop of everyone in queue checking for one player in queue when i can just add these options
local networkVars = 

{ 
  queueTeam = "integer"
}

local origC = Player.OnCreate
function Player:OnCreate()
    origC(self)
    self.queueTeam = 0
end
local origR = Player.Reset
function Player:Reset()
    origR(self)
    self.queueTeam = 0
end

function Player:setMarineQueue()
   self.queueTeam = 1
end

function Player:setAlienQueue()
 self.queueTeam = 2
end

function Player:setNoQueue(player)
 self.queueTeam = 0
end

function Player:getIsMarineQueue()
  return self.queueTeam == 1
end

function Player:getIsAlienQueue()
return self.queueTeam == 2
end

function Player:getQueue()
return self.queueTeam
end


Shared.LinkClassToMap("Player", Player.kMapName, networkVars)