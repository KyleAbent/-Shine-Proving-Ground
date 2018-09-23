function Plugin:CreateCommands()

local function JoinQueue(Client, Number)
   local Player = Client:GetControllingPlayer()
   if Player:GetTeamNumber() ~= 3 then
     Shine:NotifyDualColour( Player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "This is intended for spectator who doesn't want to step out of line when switching from RR to SPECT" )
     return
   end
     
   if Number == 1 then
     if   GetGamerules():GetTeam1():GetNumPlayers() >= self.Config.kTeamCapSize then
     self:HandleMarineQueue(Player)
     else
     Shine:NotifyDualColour( Player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "Team Size must be current limit which is " .. self.Config.kTeamCapSize  )
     end
   elseif Number == 2 then
     if   GetGamerules():GetTeam2():GetNumPlayers() >= self.Config.kTeamCapSize then
     self:HandleAlienQueue(Player)
     else
     Shine:NotifyDualColour( Player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "Team Size must be current limit which is " .. self.Config.kTeamCapSize  )
     end
   end
   
end


	local JoinQueueQueueCommand = self:BindCommand( "sh_joinqueue", "joinqueue" , JoinQueue, true )
		JoinQueueQueueCommand:AddParam{ Type = "number" }
    JoinQueueQueueCommand:Help( "leave team queue" )
    
    
local function LeaveQueue(Client)
   local Player = Client:GetControllingPlayer()
   Player:setNoQueue(Player)
end


	local LeaveTeamQueueCommand = self:BindCommand( "sh_leavequeue", "leavequeue" , LeaveQueue, true )

    
local function TeamCap(Client, Number)--Assert Number <= 12
  self.Config.kTeamCapSize = Number
  Shine:NotifyDualColour( nil, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "Team Cap Size has been changed to " .. Number )
  Shine:NotifyDualColour( nil, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "If Team Queue is enabled then it will apply to team queue size requirement (Default 12)" )
  --SetTeamJoinMaxTeamSize(Number)
  GetMarineTeamJoin():setMaxTeamSize(Number)
  GetAlienTeamJoin():setMaxTeamSize(Number)
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
                Shine:NotifyDualColour( Player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "You must be a spectator " )
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
		   Shine:NotifyDualColour( Player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "Invalid option"..Team.." Valid options are: 1, 2, 3, 4" )
		else
		   Shine:NotifyDualColour( Player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "Now listening to "..TeamString.." while on spectator team " )
			Player:setVoiceChannel(Team)
		end

	end
	local SpecVoiceCommand = self:BindCommand( "sh_specvoice", { "specvoice" }, SpecVoice, true )
	SpecVoiceCommand:AddParam{ Type = "number", Min = 0, Max = 4, Round = true, Optional = false, Default = 4 }
    SpecVoiceCommand:Help( "Sets spectator voice mode." )


end