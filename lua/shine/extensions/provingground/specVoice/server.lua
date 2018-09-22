local Plugin = Plugin
local Shine = Shine


--SpecVoice Plugin
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




