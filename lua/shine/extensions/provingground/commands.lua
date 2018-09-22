function Plugin:CreateCommands()

local function LeaveQueue(Client)
   local Player = Client:GetControllingPlayer()
   Player:setNoQueue(Player)
end


	local LeaveTeamQueueCommand = self:BindCommand( "sh_leavequeue", "leavequeue" , LeaveQueue, true )
    LeaveTeamQueueCommand:Help( "leave team queue" )
    
local function TeamCap(Client, Number)
  self.Config.kTeamCapSize = Number
  Shine:NotifyDualColour( nil, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "Team Cap Size has been changed to " .. Number )
end


	local TeamCapCommand = self:BindCommand( "sh_teamcap", "teamcap" , TeamCap )
	TeamCapCommand:AddParam{ Type = "number" }
    TeamCapCommand:Help( "Sets team cap size" )
    
local function TeamQueue(Client, Boolean)
  self.Config.kTeamQueueEnabled = Boolean
     if Boolean == true then
       Shine:NotifyDualColour( nil, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "Team Queue has been set to  true " )
     else
       Shine:NotifyDualColour( nil, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "Team Queue has been set to  false " )
     end

end


	local TeamQueueCommand = self:BindCommand( "sh_teamqueue", "teamqueue" , TeamQueue )
	TeamQueueCommand:AddParam{ Type = "boolean" }
    TeamQueueCommand:Help( "Enables or disables team queue" )
    
local function ChangeName(Client, Targets, String)
       for i = 1, #Targets do
       local Player = Targets[ i ]:GetControllingPlayer()
             Player:SetName(String)
        --self:NotifySand( Client, "%s has a total of %s Sand", true, Player:GetName(), self:GetPlayerSandInfo(Player:GetClient()))
        end
end
	local ChangeNameCommand = self:BindCommand( "sh_changename", "changename" , ChangeName )
	ChangeNameCommand:AddParam{ Type = "clients" }
	ChangeNameCommand:AddParam{ Type = "string" }
    ChangeNameCommand:Help( "Sets an individual player name" )
    


     --Specvoice plugin modified
	local function SpecVoice( Client, Team )
		
		local TeamString = "invalid"
        local Player = Client:GetControllingPlayer()
              if not Player:GetTeamNumber() == 3 then 
                Shine:NotifyDualColour( nil, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "You must be a spectator " )
              return 
              end
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
		   Shine:NotifyDualColour( nil, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "Invalid option"..Team.." Valid options are: 1, 2, 3, 4" )
		else
		   Shine:NotifyDualColour( nil, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "Now listening to "..TeamString.." while on spectator team " )
			Player:setVoiceChannel(Team)
		end

	end
	local SpecVoiceCommand = self:BindCommand( "sh_specvoice", { "specvoice" }, SpecVoice, true )
	SpecVoiceCommand:AddParam{ Type = "number", Min = 0, Max = 4, Round = true, Optional = false, Default = 4 }
    SpecVoiceCommand:Help( "Sets spectator voice mode." )


end