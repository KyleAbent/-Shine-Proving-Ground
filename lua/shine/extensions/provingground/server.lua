Script.Load("lua/shine/extensions/provingground/linkedQueue/Node.lua")
Script.Load("lua/shine/extensions/provingground/linkedQueue/linkedQueue.lua")
Script.Load("lua/shine/extensions/provingground/linkedQueue/doActivity.lua")

local Plugin = Plugin
local Shine = Shine

function Plugin:CreateCommands()



end

function Plugin:Initialise()
	self.Enabled = true
     self.data = nil
     self.nextNode = nil
     self.priority = nil
	self:CreateCommands()


	return true
end

function Plugin:MapPostLoad()
      	self:testQueue()
end








function Plugin:JoinTeam(gamerules, player, newteam, force, ShineForce)
    if ShineForce or newteam == kSpectatorIndex or newteam == kTeamReadyRoom then return end

    local AlienCount = gamerules:GetTeam2():GetNumPlayers()
    local MarineCount = gamerules:GetTeam1():GetNumPlayers()
    
 
    if newteam == 2 and AlienCount >= 12 then
        Shine:NotifyDualColour( player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "Alien Team Capped at 12 players" )
    return false
    elseif newteam == 1 and MarineCount >=12 then
        Shine:NotifyDualColour( player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "Marine Team Capped at 12 players" )
    return false
    end
    
    


end



