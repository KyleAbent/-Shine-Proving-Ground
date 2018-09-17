--Kyle 'Avoca' Abent writing and using this plugin. Using EnforcedTeamSizes, SpecSlots, TeamQueue. Remixed to fit into Neck Snapper's Proving Ground server.

local Plugin = Plugin
local Shine = Shine

function Plugin:Initialise()--Yes I know this can be written to use one que, one place in que, and not three queues, and not three places in queues. 
	self.Enabled = true
	self:CreateCommands()
	return true
end


function Plugin:Notify( Player, Message, Format, ... )
	Shine:NotifyDualColour( Player, 255, 223, 94, "[Proving Ground]", 255, 255, 255, Message, Format, ... )
end

function Plugin:CreateCommands()


end


 
--EnforceTeamSize plugin
function Plugin:JoinTeam(gamerules, player, newteam, force, ShineForce)
    if ShineForce or newteam == kSpectatorIndex or newteam == kTeamReadyRoom then return end
     local Client = player:GetClient()
    local AlienCount = gamerules:GetTeam2():GetNumPlayers()
    local MarineCount = gamerules:GetTeam1():GetNumPlayers()
    local SpectCount = gamerules:GetSpectatorTeam():GetNumPlayers()
 
    if newteam == 2 then

       if AlienCount >= 12 then --Yes i know 3x
          Shine:NotifyDualColour( player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "Alien Team Capped at 12 players" )
          return false
      end
------------------------------------------------------------------------------------------------------------------------------
    elseif newteam == 1 then

        if MarineCount >=12 then --Yes i know 3x
          Shine:NotifyDualColour( player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "Marine Team Capped at 12 players" )
           return false
       end
------------------------------------------------------------------------------------------------------------------------------
    elseif newteam == 3 then

         if SpectCount >=6 then --Yes i know 3x
          Shine:NotifyDualColour( player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "Spectator Team Capped at 6 players" )
          return false
        end
        ------------------------------------------------------------------------------------------------------------------------------
    elseif newteam == 0 then

    end
    

    
end




--SpecSlots Plugin
function Plugin:PlayerSay( Client, MessageTable )
	local Player = Client and Client:GetControllingPlayer()
	local PlayerName = Player and Player:GetName()
	local Team = Player:GetTeamNumber()
	local TeamOnly = MessageTable.teamOnly

	if (Player and TeamOnly) then
		local ChatMessage = StringTrim(MessageTable.message)

		local Spectators = GetEntitiesForTeam( "Player", kSpectatorIndex )

		for i = 1, #Spectators do
			local Ply = Spectators[ i ]

			if Ply then
				Plugin:ImitateTeamChat(Ply, PlayerName, Team, ChatMessage)
			end
		end
	end
end


--SpecSlots Plugin
function Plugin:ImitateTeamChat( ReceivingPlayer, SendingPlayer, Team, Message )
	if (Team == 0) then
		Shine:NotifyDualColour( ReceivingPlayer, 255, 255, 255, "(Team) " .. SendingPlayer .. ":", 255, 255, 255, Message, false )
	elseif (Team == 1) then
		Shine:NotifyDualColour( ReceivingPlayer, 81, 194, 243, "(Team) " .. SendingPlayer .. ":", 255, 255, 255, Message, false )
	elseif (Team == 2) then
		Shine:NotifyDualColour( ReceivingPlayer, 255, 192, 46, "(Team) " .. SendingPlayer .. ":", 255, 192, 46, Message, false )
	end	
end


