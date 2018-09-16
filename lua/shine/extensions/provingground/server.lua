--Kyle 'Avoca' Abent writing and using this plugin. Using EnforcedTeamSizes, SpecSlots, TeamQueue. Remixed to fit into Neck Snapper's Proving Ground server.

local Plugin = Plugin
local Shine = Shine

function Plugin:Initialise()
	self.Enabled = true
	self:CreateCommands()
	self.marineQueue = {}
	self.alienQueue = {}
	self.spectQueue = {}
	return true
end


local marinePlaceInQueue = 1
local alienPlaceInQueue = 1
local spectPlaceInQueue = 1

function Plugin:Notify( Player, Message, Format, ... )
	Shine:NotifyDualColour( Player, 255, 223, 94, "[Proving Ground]", 255, 255, 255, Message, Format, ... )
end



function Plugin:CreateCommands()


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

/*
function Plugin:checkAndClearQueue(player, newteam)

       --If player is on alien queue and joins marine team? then ? clear alien queue? visa versa. Bleh.
     if self.alienQueue[ player:GetClient() ] and self.alienQueue[ player:GetClient() ] ~= 9999 then
         if newteam == 1 or newteam == 2 then
         Shine:NotifyDualColour( player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "You've been removed from the Alien Team Queue" )
         self.alienQueue[alienPlaceInQueue ] = {  steamID = -1} 
         alienPlaceInQueue = alienPlaceInQueue - 1
         end
     end

     if self.marineQueue[ player:GetClient() ] and self.marineQueue[ player:GetClient() ] ~= 9999  then
         if newteam == 1 or newteam == 2 then
         Shine:NotifyDualColour( player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "You've been removed from the Marine Team Queue" )
         self.marineQueue[ marinePlaceInQueue ] ={  steamID = -1 } 
          marinePlaceInQueue = marinePlaceInQueue - 1
         end
     end
     
     if self.spectQueue[ player:GetClient() ] and self.spectQueue[ player:GetClient() ] ~= 9999  then
       --  if newteam == 3 then
         Shine:NotifyDualColour( player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "You've been removed from the Spectator Team Queue" )
         self.spectQueue[ spectPlaceInQueue ] = { steamID = -1 } 
         spectPlaceInQueue = spectPlaceInQueue - 1
         --end
     end
     
end
*/
 function Plugin:findNextPriority(num) --if teamsize <12
    Print("findNextPriority")
    local lowestPriority = 999
    local toChange
    local Gamerules = GetGamerules()
    local index
------------------------------------------------------------------------------------------------------------------------------
        if num == 1 then
                   for i = 1, #self.marineQueue do
                      local currentPriority = self.marineQueue[i]
                      Print("currentPriority is %s", currentPriority)
                      if currentPriority.steamID ~= -1 and currentPriority.priority < lowestPriority then
                         lowestPriority = currentPriority
                         toChange = currentPriority
                         index = currentPriority.priority
                      end
                   end
        if lowestPriority == 999 then return end
        Shared.ConsoleCommand(string.format("sh_setteam %s 1", self.marineQueue[index].steamID )) 
        Shine:NotifyDualColour( self.marineQueue[index].plyr, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "Congratulations! You're the priority in the Marine Team Queue!" )
        Shine:NotifyDualColour( self.marineQueue[index].plyr, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "You've been removed from the Marine Team Queue" )
        marinePlaceInQueue = marinePlaceInQueue - 1 
        self.marineQueue[index] = { steamID = -1, 9999 }
------------------------------------------------------------------------------------------------------------------------------
        elseif num== 2 then
                   for i = 1, #self.alienQueue do
                      local currentPriority = self.alienQueue[i]
                       Print("currentPriority is %s", currentPriority)
                      if currentPriority.steamID ~= -1 and currentPriority.priority  < lowestPriority then
                         lowestPriority = currentPriority
                         toChange = currentPriority
                         index = currentPriority.priority
                      end
                   end
        if lowestPriority == 999 then return end      
        Shared.ConsoleCommand(string.format("sh_setteam %s 2", self.alienQueue[index].steamID ))
        Shine:NotifyDualColour( self.alienQueue[index].plyr, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "Congratulations! You're the priority in the Alien Team Queue!" )
        Shine:NotifyDualColour( self.alienQueue[index].plyr, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "You've been removed from the Alien Team Queue" )
        alienPlaceInQueue = alienPlaceInQueue - 1
        self.alienQueue[index] = { steamID = -1, 9999 }  
------------------------------------------------------------------------------------------------------------------------------
        elseif num == 3 then
                   for i = 1, #self.spectQueue do
                      local currentPriority = self.spectQueue[i]
                       Print("currentPriority is %s", currentPriority)
                      if currentPriority.steamID ~= -1 and currentPriority.priority  < lowestPriority then
                         lowestPriority = currentPriority
                         toChange = currentPriority
                         index = currentPriority.priority
                      end
                   end
        if lowestPriority == 999 then return end               
        Shared.ConsoleCommand(string.format("sh_setteam %s 3", self.spectQueue[index].steamID ))
        Shine:NotifyDualColour( self.spectQueue[index].plyr, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "Congratulations! You're the priority in the Spectate Team Queue!" )
        Shine:NotifyDualColour( self.spectQueue[index].plyr, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "You've been removed from the Spectator Team Queue" )
        spectPlaceInQueue = spectPlaceInQueue - 1
        self.spectQueue[index] = { steamID = -1, 9999 }
        end
        
    --lower everyones priority down 1?
     
end

function Plugin:RemoveFromOtherQueue(player, newteam)
    --Damn do I really gotta loop each and check steamid. Bleh.
    if newteam == 1 then
    elseif newteam == 2 then
    elseif newteam == 3 then
    end
    

end
--EnforceTeamSize plugin, Remixed to add Queue.
function Plugin:JoinTeam(gamerules, player, newteam, force, ShineForce)
    if ShineForce or newteam == kSpectatorIndex or newteam == kTeamReadyRoom then return end
     local Client = player:GetClient()
    --self:checkAndClearQueue(player, newteam)
    self:findNextPriority(1)
    self:findNextPriority(2)
    self:findNextPriority(3)
 
    if newteam == 2 then
    local AlienCount = gamerules:GetTeam2():GetNumPlayers()
       if AlienCount >= 12 then
        Shine:NotifyDualColour( player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "Alien Team Capped at 12 players" )
        Shine:NotifyDualColour( player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "You've entered the Alien Team Queue at number " .. alienPlaceInQueue) ---Great, what pos in queueue are we?
        self:RemoveFromOtherQueue(player, newteam)
        self.alienQueue[ alienPlaceInQueue ] = { steamID = Client:GetUserId(), priority = alienPlaceInQueue, plyr = player }
        alienPlaceInQueue = alienPlaceInQueue + 1
      return false
      --else self:findNextPriority(newteam)
      end
------------------------------------------------------------------------------------------------------------------------------
    elseif newteam == 1 then
    local MarineCount = gamerules:GetTeam1():GetNumPlayers()
        if MarineCount >=12 then
        Shine:NotifyDualColour( player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "Marine Team Capped at 12 players" )
        Shine:NotifyDualColour( player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "You've entered the Marine Team Queue at number " .. marinePlaceInQueue ) ---Great, what pos in queueue are we?
        self:RemoveFromOtherQueue(player, newteam)
        self.marineQueue[ marinePlaceInQueue ] = { steamID = Client:GetUserId(), priority = marinePlaceInQueue, plyr = player }
        marinePlaceInQueue = marinePlaceInQueue + 1
        return false
       -- else self:findNextPriority(newteam)
        end
------------------------------------------------------------------------------------------------------------------------------
    elseif newteam == 3 then
    local SpectCount = gamerules:GetTeam3():GetNumPlayers()
         if SpectCount >=6 then
        Shine:NotifyDualColour( player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "Spectator Team Capped at 12 players" )
        Shine:NotifyDualColour( player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "You've entered the Spectator Team Queue at number " ..  spectPlaceInQueue ) ---Great, what pos in queueue are we?
        self:RemoveFromOtherQueue(player, newteam)
        self.spectQueue[ spectPlaceInQueue ] = { steamID = Client:GetUserId(), priority = spectPlaceInQueue, plyr = player }
        spectPlaceInQueue = spectPlaceInQueue + 1
        return false
      -- else self:findNextPriority(newteam)
        end
        ------------------------------------------------------------------------------------------------------------------------------
    elseif newteam == 0 then
       --  self:findNextPriority(1)
      --   self:findNextPriority(2)
       --  self:findNextPriority(3)
    end
    
    --If teamsize less than full and queue is waiting then find next eligable priority
    
end


function Plugin:ClientDisconnect(Client)
    local controlling = Client:GetControllingPlayer()
    if controlling:GetTeam() == 1 then
            if self.marineQueue[ Client ]  then
            marinePlaceInQueue = marinePlaceInQueue - 1
            end
            self:findNextPriority(1)
------------------------------------------------------------------------------------------------------------------------------
    elseif controlling:GetTeam() == 2 then
            if self.alienQueue[ Client ]  then
            alienPlaceInQueue = alienPlaceInQueue - 1
            end
            self:findNextPriority(2)
------------------------------------------------------------------------------------------------------------------------------
    elseif controlling:GetTeam() == 3 then
            if self.spectQueue[ Client ]  then
            spectPlaceInQueue = spectPlaceInQueue - 1
            end
            self:findNextPriority(3)
------------------------------------------------------------------------------------------------------------------------------
    end
end


