--Kyle Abent
Script.Load("lua/shine/extensions/provingground/commands.lua")
Script.Load("lua/shine/extensions/provingground/linkedQueue/Node.lua")
Script.Load("lua/shine/extensions/provingground/linkedQueue/linkedQueue.lua")
Script.Load("lua/shine/extensions/provingground/linkedQueue/doActivity.lua")

local Plugin = Plugin
local Shine = Shine

Plugin.HasConfig = true
Plugin.ConfigName = "ProvingGround.json"
Plugin.DefaultConfig  = { kTeamCapSize = 12, kTeamQueueEnabled = false }


function Plugin:Initialise()
	self.Enabled = true
	self:CreateCommands()
	return true
end

function Plugin:MapPostLoad()
        local marineQueue = Server.CreateEntity(linkedQueue.kMapName)
              marineQueue.sett = 1
        local alienQueue = Server.CreateEntity(linkedQueue.kMapName)
              alienQueue.sett = 2
end

function Plugin:HandleAlienQueue(player)
        Shine:NotifyDualColour( player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "Alien Team Full" )
        if player:getIsMarineQueue() then
              player:setNoQueue()
              Shine:NotifyDualColour( player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "You've been removed from the Marine Team Queue" )
        end
        if not player:getIsAlienQueue() then
        local aq = GetAlienQueue() --if ~= null then
        local node = Server.CreateEntity(queueNode.kMapName) 
          --    node:Node( ToString(player:GetClient():GetUserId()) , nil, nil, aq.size+1)
              node:Node( ToString(player:GetId()) , nil, nil, aq.size+1)
              Shine:NotifyDualColour( player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "You've entered the Alien Queue at priority # " .. aq.size+1 )
              aq:enqueue(node:GetId())   
              aq:print()
              player:setAlienQueue()
        else
              Shine:NotifyDualColour( player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "You've already entered the Alien Team Queue" )
        end
end

function Plugin:HandleMarineQueue(player)
        Shine:NotifyDualColour( player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "Marine Team Full" )
        if player:getIsAlienQueue() then
              player:setNoQueue()
              Shine:NotifyDualColour( player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "You've been removed from the Alien Team Queue" )
        end
        if not player:getIsMarineQueue() then
        local mq = GetMarineQueue() --if ~= null then
        local node = Server.CreateEntity(queueNode.kMapName) 
            --  node:Node( ToString(player:GetClient():GetUserId()) , nil, nil, mq.size+1)
              node:Node( ToString(player:GetId()) , nil, nil, mq.size+1)
              Shine:NotifyDualColour( player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "You've entered the Marine Queue at priority # " .. mq.size+1 )
              mq:enqueue(node:GetId())   
              mq:print()
              player:setMarineQueue()
        else
              Shine:NotifyDualColour( player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "You've already entered the Marine Team Queue" )
        end
end
function Plugin:JoinTeam(gamerules, player, newteam, force, ShineForce)
   -- if ShineForce or newteam == kSpectatorIndex or newteam == kTeamReadyRoom then return end

    local AlienCount = gamerules:GetTeam2():GetNumPlayers()
    local MarineCount = gamerules:GetTeam1():GetNumPlayers()
    
    if newteam == 2 then 
                if self.Config.kTeamQueueEnabled and ( AlienCount >= self.Config.kTeamCapSize   or AlienCount > MarineCount ) then
                   self:HandleAlienQueue(player)
                    return false
                else
                   player:setNoQueue()
                end
    elseif newteam == 1 then
                  if self.Config.kTeamQueueEnabled and ( MarineCount >= self.Config.kTeamCapSize   or AlienCount < MarineCount  ) then
                    self:HandleMarineQueue(player)
                    return false
                  else
                     player:setNoQueue()
                  end
    end
end


Shine.Hook.SetupClassHook( "Player", "setNoQueue", "displayNo", "PassivePre" )

function Plugin:displayNo(player) --local teamstring = , notify once at end, changing string with ifelse
   if player:getIsMarineQueue() then
   Shine:NotifyDualColour( player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "You've been removed from Marine Team Queue" )
   elseif player:getIsAlienQueue() then
   Shine:NotifyDualColour( player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "You've been removed from Alien Team Queue" )
   else
   Shine:NotifyDualColour( player, 0, 255, 0, "[Proving Ground]", 255, 255, 255, "You're not currently on a Team Queue" )
   end
end

                                                                     --Post so done after default
Shine.Hook.SetupClassHook( Gamerules, "GetCanPlayerHearPlayer", "OnlyForSpect", "PassivePost" )
 --Specvoice plugin modified
function Plugin:OnlyForSpect( Gamerules, Listener, Speaker )
	local ListenerTeam = Listener:GetTeamNumber()
	local SpeakerTeam = Speaker:GetTeamNumber()
	local TeamToHear = Listener:getVoiceChannel()
	return (TeamToHear == SpeakerTeam and ListenerTeam == 3)or (ListenerTeam == 3 and TeamToHear == 4)
end

