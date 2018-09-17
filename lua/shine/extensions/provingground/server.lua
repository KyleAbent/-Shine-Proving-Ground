--Kyle 'Avoca' Abent writing and using this plugin. Using EnforcedTeamSizes, SpecSlots, TeamQueue. Remixed to fit into Neck Snapper's Proving Ground server.

local Plugin = Plugin
local Shine = Shine

function Plugin:Initialise()--Yes I know this can be written to use one que, one place in que, and not three queues, and not three places in queues. 
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


Shine.Hook.SetupClassHook( "Gamerules", "GetCanJoinPlayingTeam", "unBlockForQueue", "Replace" ) --Replace to remove portion


--Gamerules unblock the spectator from joining RR if team full so we can use queue
function Plugin:unBlockForQueue(player)  --Unblock portion for res slot later?
   --Print("hm?")
  /*
    if player:GetIsSpectator() then

        local numClients = Server.GetNumClientsTotal()
        local numSpecs = Server.GetNumSpectators()

        local numPlayer = numClients - numSpecs
        local maxPlayers = Server.GetMaxPlayers()
        local numRes = Server.GetReservedSlotLimit()

        --check for empty player slots excluding reserved slots
        if numPlayer >= maxPlayers then
            Server.SendNetworkMessage(player, "JoinError", BuildJoinErrorMessage(3), true)
            return false
        end

        --check for empty player slots including reserved slots
        local userId = player:GetSteamId()
        local hasReservedSlot = GetHasReservedSlotAccess(userId)
        if numPlayer >= (maxPlayers - numRes) and not hasReservedSlot then
            Server.SendNetworkMessage(player, "JoinError", BuildJoinErrorMessage(3), true)
            return false
        end
    end
     */
    return true
end

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


 function Plugin:findNextPriority(num) --if teamsize <12
   -- Print("findNextPriority")
    local lowestPriority = 999
    local toChange
    local Gamerules = GetGamerules()
    local index
------------------------------------------------------------------------------------------------------------------------------
        if num == 1 then
                   for i = 1, #self.marineQueue do
                      local currentPriority = self.marineQueue[i]
                      --Print("currentPriority is %s", currentPriority)
                      if currentPriority.steamID ~= -1 and currentPriority.priority < lowestPriority  then
                         lowestPriority = currentPriority.priority
                         toChange = currentPriority
                         index = currentPriority.priority
                      end
                   end
        if lowestPriority == 999 then return end
        Shared.ConsoleCommand(string.format("sh_queueteam %s 1", self.marineQueue[index].steamID )) 
        Shine:NotifyDualColour( self.marineQueue[index].plyr, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "You've been removed from the Marine Team Queue" )
        marinePlaceInQueue = marinePlaceInQueue - 1 --Lets not do this because I would have to adjust every other as well.
        self.marineQueue[index] = { steamID = -1, 9999 }
        self:lowerAllMarineQueue()
------------------------------------------------------------------------------------------------------------------------------
        elseif num== 2 then
                   for i = 1, #self.alienQueue do
                      local currentPriority = self.alienQueue[i]
                       --Print("currentPriority is %s", currentPriority)
                      if currentPriority.steamID ~= -1 and currentPriority.priority  < lowestPriority   then
                         lowestPriority = currentPriority.priority
                         toChange = currentPriority
                         index = currentPriority.priority
                      end
                   end
        if lowestPriority == 999 then return end      
        Shared.ConsoleCommand(string.format("sh_queueteam %s 2", self.alienQueue[index].steamID ))
        Shine:NotifyDualColour( self.alienQueue[index].plyr, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "You've been removed from the Alien Team Queue" )
        alienPlaceInQueue = alienPlaceInQueue - 1 --Lets not do this because I would have to adjust every other as well. 
        self.alienQueue[index] = { steamID = -1, 9999 }  
         self:lowerAllAlienQueue()
------------------------------------------------------------------------------------------------------------------------------
        elseif num == 3 then
                   for i = 1, #self.spectQueue do
                      local currentPriority = self.spectQueue[i]
                       --Print("currentPriority is %s", currentPriority)
                      if currentPriority.steamID ~= -1 and currentPriority.priority  < lowestPriority then
                         lowestPriority = currentPriority.priority
                         toChange = currentPriority
                         index = currentPriority.priority
                      end
                   end
        if lowestPriority == 999 then return end               
        Shared.ConsoleCommand(string.format("sh_queueteam %s 3", self.spectQueue[index].steamID ))
        Shine:NotifyDualColour( self.spectQueue[index].plyr, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "You've been removed from the Spectator Team Queue" )
        spectPlaceInQueue = spectPlaceInQueue - 1 --Lets not do this because I would have to adjust every other as well.
        self.spectQueue[index] = { steamID = -1, 9999 }
       self:lowerAllSpectQueue()
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
 --Yuck I hate for loops well atleast 3 queue is less to search than 1 queue
function Plugin:getIsInMarineQueue(player, disconnected)  --Maybe not. Yes I know 3x.
                   for i = 1, #self.marineQueue do
                      local currentPriority = self.marineQueue[i]
                      if currentPriority.steamID ~= -1 and currentPriority.plyr  == player:GetClient() then
                         if disconnected then self.marineQueue[i] = { steamID = -1, 9999 } end
                         return true
                      end
                   end
                   return false
end
function Plugin:getIsInAlienQueue(player, disconnected) --Yes I know 3x.
                   for i = 1, #self.alienQueue do
                      local currentPriority = self.alienQueue[i]
                      if currentPriority.steamID ~= -1 and currentPriority.plyr  == player:GetClient() then
                         if disconnected then self.alienQueue[i] = { steamID = -1, 9999 } end
                         return true
                      end
                   end
                   return false
end
function Plugin:getisInSpectatorQueue(player, disconnected) --Yes I know 3x.
                   for i = 1, #self.spectQueue do
                      local currentPriority = self.spectQueue[i]
                      if currentPriority.steamID ~= -1 and currentPriority.plyr  == player:GetClient() then
                         if disconnected then self.spectQueue[i] = { steamID = -1, 9999 } end
                         return true
                      end
                   end
                  return false
end

function Plugin:lowerAllMarineQueue()
                   for i = 1, #self.marineQueue do
                      local currentPriority = self.marineQueue[i]
                      if currentPriority.steamID ~= -1 and currentPriority.plyr  ~= 999 then
                          currentPriority.priority = Clamp(currentPriority.priority -1, 1, 998)
                          Shine:NotifyDualColour( currentPriority.plyr, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "Your new priority is " .. currentPriority.priority  )
                      end
                   end
end

function Plugin:lowerAllAlienQueue()
                   for i = 1, #self.alienQueue do
                      local currentPriority = self.alienQueue[i]
                      if currentPriority.steamID ~= -1 and  currentPriority.plyr  ~= 999 then
                          currentPriority.priority = Clamp(currentPriority.priority -1, 1, 998)
                          Shine:NotifyDualColour( currentPriority.plyr, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "Your new priority is " .. currentPriority.priority  )
                      end
                   end
end

function Plugin:lowerAllSpectQueue()
                   for i = 1, #self.spectQueue do
                      local currentPriority = self.spectQueue[i]
                      if currentPriority.steamID ~= -1 and currentPriority.plyr  ~= 999 then
                          currentPriority.priority = Clamp(currentPriority.priority -1, 1, 998)
                          Shine:NotifyDualColour( currentPriority.plyr, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "Your new priority is " .. currentPriority.priority  )
                      end
                   end
end
--EnforceTeamSize plugin, Remixed to add Queue.
function Plugin:JoinTeam(gamerules, player, newteam, force, ShineForce)
    if ShineForce or newteam == kSpectatorIndex or newteam == kTeamReadyRoom then return end
     local Client = player:GetClient()
    --self:checkAndClearQueue(player, newteam)
    
    local AlienCount = gamerules:GetTeam2():GetNumPlayers()
    local MarineCount = gamerules:GetTeam1():GetNumPlayers()
    local SpectCount = gamerules:GetSpectatorTeam():GetNumPlayers()
    
    if MarineCount < 12 then
    self:findNextPriority(1)
    end
     
    if AlienCount < 12 then
    self:findNextPriority(2)
    end
      
    if SpectCount < 6 then
    self:findNextPriority(3)
    end
 
    if newteam == 2 then

       if AlienCount >= 12 then --Yes i know 3x
          if not self:getIsInAlienQueue(player) and not self:getIsInMarineQueue(player, false) and not self:getisInSpectatorQueue(player) then --here is where one teamQueue would be better than 3 lol.
          Shine:NotifyDualColour( player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "Alien Team Capped at 12 players" )
          Shine:NotifyDualColour( player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "You've entered the Alien Team Queue at number " .. alienPlaceInQueue) ---Great, what pos in queueue are we?
          self:RemoveFromOtherQueue(player, newteam)
          self.alienQueue[ alienPlaceInQueue ] = { steamID = Client:GetUserId(), priority = alienPlaceInQueue, plyr = player:GetClient() }
          alienPlaceInQueue = alienPlaceInQueue + 1
          else
          Shine:NotifyDualColour( player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "You've already entered a team queue" )
          end
          return false
      end
------------------------------------------------------------------------------------------------------------------------------
    elseif newteam == 1 then

        if MarineCount >=12 then --Yes i know 3x
          if not self:getIsInAlienQueue(player) and not self:getIsInMarineQueue(player, false) and not self:getisInSpectatorQueue(player) then --here is where one teamQueue would be better than 3 lol.
          Shine:NotifyDualColour( player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "Marine Team Capped at 12 players" )
          Shine:NotifyDualColour( player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "You've entered the Marine Team Queue at number " .. marinePlaceInQueue ) ---Great, what pos in queueue are we?
          self:RemoveFromOtherQueue(player, newteam)
          self.marineQueue[ marinePlaceInQueue ] = { steamID = Client:GetUserId(), priority = marinePlaceInQueue, plyr = player:GetClient() }
          marinePlaceInQueue = marinePlaceInQueue + 1
          else
          Shine:NotifyDualColour( player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "You've already entered a team queue" )
          end
          return false
       end
------------------------------------------------------------------------------------------------------------------------------
    elseif newteam == 3 then

         if SpectCount >=6 then --Yes i know 3x
          if not self:getIsInAlienQueue(player) and not self:getIsInMarineQueue(player, false) and not self:getisInSpectatorQueue(player) then --here is where one teamQueue would be better than 3 lol.
          Shine:NotifyDualColour( player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "Spectator Team Capped at 12 players" )
          Shine:NotifyDualColour( player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "You've entered the Spectator Team Queue at number " ..  spectPlaceInQueue ) ---Great, what pos in queueue are we?
          self:RemoveFromOtherQueue(player, newteam)
          self.spectQueue[ spectPlaceInQueue ] = { steamID = Client:GetUserId(), priority = spectPlaceInQueue, plyr = player:GetClient() }
          spectPlaceInQueue = spectPlaceInQueue + 1
          else
          Shine:NotifyDualColour( player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "You've already entered a team queue" )
          end
          return false
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
      local gamerules = GetGamerules()
    local AlienCount = gamerules:GetTeam2():GetNumPlayers()
    local MarineCount = gamerules:GetTeam1():GetNumPlayers()
    local SpectCount = gamerules:GetSpectatorTeam():GetNumPlayers()
    
    if controlling:GetTeam() == 1 and MarineCount < 12 then --Is playercount 12 as the player leaving or does him leaving lower it to 11?
    self:findNextPriority(1)
    end
     
    if  controlling:GetTeam() == 2 and AlienCount < 12 then --Is playercount 12 as the player leaving or does him leaving lower it to 11?
    self:findNextPriority(2)
    end
      
    if controlling:GetTeam() == 3 and SpectCount < 6 then
    self:findNextPriority(3)
    end
     
      if controlling:GetTeam() == 0 then
            if getIsInMarineQueue(controlling, true) then
               self:lowerAllMarineQueue()   --not on 9.16.18 3 but will be later
            elseif getIsInAlienQueue(controlling, true) then
               self:lowerAllAlienQueue()     --not on 9.16.18 3 but will be later
            elseif getisInSpectatorQueue(controlling, true) then
               self:lowerAllSpectatorQueue()   --not on 9.16.18 3 but will be later
            end
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


