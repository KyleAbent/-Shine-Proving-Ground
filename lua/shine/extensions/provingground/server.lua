Script.Load("lua/shine/extensions/provingground/linkedQueue/Node.lua")
Script.Load("lua/shine/extensions/provingground/linkedQueue/linkedQueue.lua")
Script.Load("lua/shine/extensions/provingground/linkedQueue/doActivity.lua")

local Plugin = Plugin
local Shine = Shine

function Plugin:CreateCommands()

local function QueueTeam( Client, Targets, Team )
		local Gamerules = GetGamerules()
		if not Gamerules then return end

		local TargetCount = #Targets
		if TargetCount == 0 then return end

		for i = 1, TargetCount do
			local Player = Targets[ i ]:GetControllingPlayer()

			if Player then 
                if Player:GetTeamNumber() == 0 then
                Shine:NotifyDualColour( Player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "Congratulations! You're the priority in the *blank* Team Queue!" )
				Gamerules:JoinTeam( Player, Team, nil, true )
				else
                Shine:NotifyDualColour( Player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "Doh! You've joined a team queue then joined a team. You would have been chosen if in RR!" )
                end
			end
		end

		self:SendTranslatedMessage( Client, "ChangeTeam", {
			TargetCount = TargetCount,
			Team = Team
		} )
	end
	local ChangeTeamCommand = self:BindCommand( "sh_queueteam", "queueteam" , QueueTeam )
	ChangeTeamCommand:AddParam{ Type = "clients" }
	ChangeTeamCommand:AddParam{ Type = "team", Error = "Please specify a team to move to." }
ChangeTeamCommand:Help( "Sets the given player(s) onto the given team." )

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
        local marineQueue = Server.CreateEntity(linkedQueue.kMapName)
              marineQueue.sett = 1
        local alienQueue = Server.CreateEntity(linkedQueue.kMapName)
              alienQueue.sett = 2
end






function Plugin:JoinTeam(gamerules, player, newteam, force, ShineForce)
   -- if ShineForce or newteam == kSpectatorIndex or newteam == kTeamReadyRoom then return end

    local AlienCount = gamerules:GetTeam2():GetNumPlayers()
    local MarineCount = gamerules:GetTeam1():GetNumPlayers()
    
    /*
    if AlienCount < 12 and AlienCount<MarineCount then
               local aq = GetAlienQueue()
               if aq ~= nil then
                 aq:dequeue()
               end
    elseif MarineCount < 12 and AlienCount>MarineCount then
               local mq = GetMarineQueue()
               if mq ~= nil then
                 mq:dequeue()
               end
    end
    */
    
    if newteam == 2 and ( AlienCount >= 12 or AlienCount > MarineCount ) then
        Shine:NotifyDualColour( player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "Alien Team Full" )
        local aq = GetAlienQueue() --if ~= null then
        local node = Server.CreateEntity(queueNode.kMapName) 
          --    node:Node( ToString(player:GetClient():GetUserId()) , nil, nil, aq.size+1)
              node:Node( ToString(player:GetId()) , nil, nil, aq.size+1)
              Shine:NotifyDualColour( player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "You've entered the Alien Queue at priority # " .. aq.size+1 )
              aq:enqueue(node:GetId())   
              aq:print()
    return false
    elseif newteam == 1 and  ( MarineCount >= 12 or AlienCount < MarineCount  ) then
        Shine:NotifyDualColour( player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "Marine Team Full" )
        local mq = GetMarineQueue() --if ~= null then
        local node = Server.CreateEntity(queueNode.kMapName) 
            --  node:Node( ToString(player:GetClient():GetUserId()) , nil, nil, mq.size+1)
              node:Node( ToString(player:GetId()) , nil, nil, mq.size+1)
              Shine:NotifyDualColour( player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "You've entered the Marine Queue at priority # " .. mq.size+1 )
              mq:enqueue(node:GetId())   
              mq:print()
    return false
    end
    
    


end



