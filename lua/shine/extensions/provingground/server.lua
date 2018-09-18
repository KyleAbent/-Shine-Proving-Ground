--Kyle 'Avoca' Abent writing and using this plugin. Using EnforcedTeamSizes, SpecSlots, TeamQueue. Remixed to fit into Neck Snapper's Proving Ground server.

local Plugin = Plugin
local Shine = Shine

function Plugin:Initialise()--Yes I know this can be written to use one que, one place in que, and not three queues, and not three places in queues. 
	self.Enabled = true
	self:CreateCommands()	
	self.teamQueue = {}
	return true
end


local marinePlaceInQueue = 1 --starts at +1
local alienPlaceInQueue = 1
local spectPlaceInQueue = 1
local globalQueueIndex = 1

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


 function Plugin:findNextPriority(teamNum) --if teamsize <12
   -- Print("findNextPriority")
   if #self.teamQueue == 0 then return end
    local lowestPriority = 999
    local toChange
    local Gamerules = GetGamerules()
    local index
------------------------------------------------------------------------------------------------------------------------------
                   for i = 1, #self.teamQueue do
                      local currentPriority = self.teamQueue[i]
                      --Print("currentPriority is %s", currentPriority)
                      if currentPriority.steamID ~= -1 and currentPriority.priority < lowestPriority  and currentPriority.team == teamNum then
                         lowestPriority = currentPriority.priority
                         toChange = currentPriority
                         index = i--currentPriority.priority
                      end
                      --adjust node in front and in back
                   end
        if lowestPriority == 999 then return end
        Shared.ConsoleCommand(string.format("sh_queueteam %s 1", self.teamQueue[index].steamID )) 
        Shine:NotifyDualColour( self.teamQueue[index].plyr, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "You've been removed from the Marine Team Queue" )
        self:RemoveFromOtherQueue(player, teamNum)
        --self:lowerAllMarineQueue()        
       
     
end

function Plugin:RemoveFromOtherQueue(player, teamnum)
  local found = false
                   for i = 1, #self.teamQueue do
                      local currentPriority = self.teamQueue[i]
                      if currentPriority.steamID ~= -1 and currentPriority.plyr  == player:GetClient() then
                         found = true
                         Shine:NotifyDualColour( player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "You've been removed from your previous Queue" )
                      end
                   end
                   
                   for i = 1, #self.teamQueue do
                      local nextPriority = self.teamQueue[i+1] --Adjust the chain nextNode (or prevNode) pointer
                      if nextPriority and i > globalQueueIndex  then
                         self.teamQueue[i] = nextPriority
                         self.teamQueue[i].priority = self.teamQueue[i].priority - 1
                         Shine:NotifyDualColour( self.marineQueue[i].plyr, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "Your new priority is " .. currentPriority.priority  )
                      end
                   end
    if found then
       if teamnum == 1 then
        marinePlaceInQueue = marinePlaceInQueue - 1 --hm?
       elseif teamnum == 2 then
        alienPlaceInQueue = alienPlaceInQueue - 1 --hm?
       elseif teamnum == 3 then
        spectPlaceInQueue = spectPlaceInQueue - 1 --hm?
       end
    globalQueueIndex = globalQueueIndex - 1 --hm?
    end

end
function Plugin:lowerQueueFromPosAboveToBelow()

     
                   for i = 1, #self.teamQueue do
                      local currentPriority = self.marineQueue[i]
                      if i > globalQueueIndex  then
                         if disconnected then self.marineQueue[i] = { steamID = -1, 9999 } end
                         return true
                      end
                   end

end
function Plugin:removeFromQueueIfFound(player)
  -- For each team priorty greater, reduce. 
   --Lower team specific index
   -- +1 = 1
   local found = false
                   for i = 1, #self.teamQueue do
                      local currentPriority = self.marineQueue[i]
                      if currentPriority.steamID ~= -1 and currentPriority.plyr  == player:GetClient() then
                         if disconnected then self.marineQueue[i] = { steamID = -1, 9999 } end
                         return true
                      end
                   end
                   
                   if found then self:lowerQueueFromPosAboveToBelow() end
                   return false
end
function Plugin:getIsInQueueAsTeamNum(player, disconnected, teamnum)  --Maybe not. Yes I know 3x.
                   for i = 1, #self.teamQueue do
                      local currentPriority = self.marineQueue[i]
                      if currentPriority.steamID ~= -1 and currentPriority.plyr  == player:GetClient() then
                         if disconnected then self.marineQueue[i] = { steamID = -1, 9999 } end
                         return true
                      end
                   end
                   return false
end

function Plugin:lowerAllInQueueForTeam(teamnum)
                   for i = 1, #self.teamQueue do
                      local currentPriority = self.marineQueue[i]
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
    
    if newteam == 1 and MarineCount < 12 and MarineCount < AlienCount then
    self:findNextPriority(1)
    end
     
    if newteam == 2 and AlienCount < 12 and AlienCount < MarineCount then
    self:findNextPriority(2)
    end
      
    if newteam == 3 and SpectCount < 6 then
    self:findNextPriority(3)
    end
 
    local isFull = false
    local indexToUse
    local stTeam = "Null"
   
    if newteam == 2 then  --if not full then....

       if AlienCount >= 12 or AlienCount > MarineCount then
          isFull = true
          stTeam = "Alien"
          indexToUse = alienPlaceInQueue
          alienPlaceInQueue = alienPlaceInQueue + 1
      end
------------------------------------------------------------------------------------------------------------------------------
    elseif newteam == 1 then
        if MarineCount >=12 or MarineCount > AlienCount then 
         isFull = true
         stTeam = "Marine"
         indexToUse = marinePlaceInQueue
         marinePlaceInQueue = marinePlaceInQueue + 1
       end
------------------------------------------------------------------------------------------------------------------------------
    elseif newteam == 3 then
         if SpectCount >=6 then 
         stTeam = "Spectate"
         isFull = true
         indexToUse = spectPlaceInQueue
         spectPlaceInQueue = spectPlaceInQueue + 1
        end
        ------------------------------------------------------------------------------------------------------------------------------
    elseif newteam == 0 then
       --  self:findNextPriority(1)
      --   self:findNextPriority(2)
       --  self:findNextPriority(3)
    end
    
    if isFull then
             
          self:RemoveFromOtherQueue(player, newteam)
          Shine:NotifyDualColour( player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, string.format("The %s team is full ",  stTeam ))
          Shine:NotifyDualColour( player, 0, 255, 0, "[Proving Ground]", 255, 255, 255,  string.format("You've entered the %s team queue at priority numer %s",  stTeam, indexToUse) )
          self.teamQueue[ globalQueueIndex ] = { steamID = Client:GetUserId(), priority = indexToUse, plyr = player:GetClient(), team = newteam }
          globalQueueIndex = globalQueueIndex + 1
        --  else

          --end
          return false
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
            if MarineQueue(controlling, true) then
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


