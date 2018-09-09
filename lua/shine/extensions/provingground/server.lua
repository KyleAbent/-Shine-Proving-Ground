local Plugin = Plugin
local Shine = Shine


local SpecVoiceSettings = {}

function Plugin:Notify( Player, Message, Format, ... )
	Shine:NotifyDualColour( Player, 255, 223, 94, "[Spectator]", 255, 255, 255, Message, Format, ... )
end

function Plugin:ImitateTeamChat( ReceivingPlayer, SendingPlayer, Team, Message )
	if (Team == 0) then
		Shine:NotifyDualColour( ReceivingPlayer, 255, 255, 255, "(Team) " .. SendingPlayer .. ":", 255, 255, 255, Message, false )
	elseif (Team == 1) then
		Shine:NotifyDualColour( ReceivingPlayer, 81, 194, 243, "(Team) " .. SendingPlayer .. ":", 255, 255, 255, Message, false )
	elseif (Team == 2) then
		Shine:NotifyDualColour( ReceivingPlayer, 255, 192, 46, "(Team) " .. SendingPlayer .. ":", 255, 192, 46, Message, false )
	end	
end

function Plugin:CreateCommands()
	local function SpecVoice( Client, Team )
		
		local TeamString = "invalid"

		if (Team == 1) then
			TeamString = "only to Marines"
		elseif (Team == 2) then
			TeamString = "only to Aliens"
		elseif (Team == 3) then
			TeamString = "only to other spectators"
		elseif (Team == 4) then
			TeamString = "to everyone"
		end

		if (TeamString == "invalid") then
			Plugin:Notify(Client, "Invalid option %s. Valid options are: 1, 2, 3, 4", true, Team)
		else
			SpecVoiceSettings[Client:GetUserId()] = Team
			Plugin:Notify(Client, "Now listening %s when you spectate", true, TeamString)
		end

	end
	local SpecVoiceCommand = self:BindCommand( "sh_specvoice", { "specvoice" }, SpecVoice, true )
	SpecVoiceCommand:AddParam{ Type = "number", Min = 0, Max = 4, Round = true, Optional = false, Default = 4 }
	SpecVoiceCommand:Help( "Sets spectator voice mode." )

end

function Plugin:Initialise()
	self.Enabled = true

	self:CreateCommands()

	return true
end

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

function Plugin:CanPlayerHearPlayer( Gamerules, Listener, Speaker )
	local ListenerTeam = Listener:GetTeamNumber()
	local SpeakerTeam = Speaker:GetTeamNumber()
	
	if (ListenerTeam == SpeakerTeam) then return true end
	if (ListenerTeam ~= 3) and (ListenerTeam ~= SpeakerTeam) then return false end

	local DefaultTeamToHear

	--if Plugin.Config.SpecsCanHearAllVoiceComms then
		DefaultTeamToHear = 4
	--else
		--DefaultTeamToHear = 3
	--end

	local ListenerClient = Server.GetOwner( Listener )
	local TeamToHear = SpecVoiceSettings[ListenerClient:GetUserId()] or DefaultTeamToHear
	
	local result = (TeamToHear == 4) or (TeamToHear == SpeakerTeam)
	return result
end
function Plugin:PostJoinTeam( Gamerules, Player, OldTeam, NewTeam, Force, ShineForce )
	
	-- player joined spectators
	if NewTeam == 3 then

		--if (Plugin.Config.SendMessageOnJoinSpec) then
			Plugin:Notify( Client, "%s", true, Plugin.Config.JoinSpecMessage )
		--end

		return
	end
end

--EnforceTeamSize plugin
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
    
    

    --Sum of playing ppl
   -- local TotalCount = AlienCount + MarineCount

    --Check if the sum is above MaxPlayers
   -- if TotalCount > 24 then
        --Inform player (change rgb code to whatever you like)
     --   Shine:NotifyDualColour( player, 0, 255, 0, "EnforcedTeamsize", 255, 255, 255, "Please Spectate until the round ends." )
     --   return false
  --  end
end



