--Kyle Abent
--Aditional camera angles that come as an option to enhance the spectator experience
-- choppyness is from not using onupdateplayer

local networkVars = 

{
  voiceChannel = "integer",  --Specvoice plugin modified
  isDirecting = "boolean",
  lockedId = "entityid", --for directing. I dont wanna mess with vanilla target. eh?
  --if directing then non null
} 

local cCreate = Spectator.OnCreate
function Spectator:OnCreate()
    cCreate(self)
    self.voiceChannel = 4  --Specvoice plugin modified
    self.isDirecting = false
     self.lockedId = Entity.invalidI 
    --Print("%s %s", self:GetId(), self:getQueue() )
end

function Spectator:setVoiceChannel(channel)
 self.voiceChannel = channel  --Specvoice plugin modified
end

function Spectator:getVoiceChannel()
 return self.voiceChannel   --Specvoice plugin modified
end

function Spectator:ChangeView(player)
  --shine
end
function Spectator:SetLockOnTarget(userid)
   self.lockedId = userid
end

function Spectator:OnUpdatePlayer(deltatime)
    if Server then
    if self.isDirecting then
       if not  self.timeLastDirectUpdate or ( self.timeLastDirectUpdate + 8 < Shared.GetTime()  or  self.lockedId == 0  ) then
         self:ChangeView(self)
          self.timeLastDirectUpdate = Shared.GetTime()
        end
       self:LockAngles()
     end  
    end
end

function Spectator:LockAngles()//if cam then look for lock
  -- if self:GetSpectatorMode() == kSpectatorMode.FirstPerson then return end
  local OfLock = Shared.GetEntity( self.lockedId ) 
   if OfLock ~= nil then
            --if (OfLock.GetIsAlive and OfLock:GetIsAlive())  then
             local dir = GetNormalizedVector(OfLock:GetOrigin() - self:GetOrigin())
             local angles = Angles(GetPitchFromVector(dir), GetYawFromVector(dir), 0)
             self:SetOffsetAngles(angles)
           -- end
  else
       self:ChangeView(self)
  end
end

function Spectator:BreakChains()
  self.lockedId = Entity.invalidI 
end

local function GetCDistance(target)
local dist = 5
 if target:isa("CommandStructure") then
 dist = 8
 elseif target:isa("Contamination") then
  dist = 3
  elseif target:isa("Marine") then
  dist = 4 
  elseif target:isa("Whip") then
  dist = 5
  elseif target:isa("Shift") then
  dist = 5
  end
  return dist
  
end

local origo = Spectator.OverrideInput
function Spectator:OverrideInput(input)
   origo (self, input)
    if not self.isDirecting then return input end
          if  self:GetSpectatorMode() ~= kSpectatorMode.FirstPerson and self.lockedId ~= Entity.invalidI then
            local target = Shared.GetEntity( self.lockedId ) 
              if target  then
                 --self:LockAngles(target)
                 if  HasMixin(target, "Construct")  or target:isa("Contamination") then input.move.x = input.move.x + 0.15 end
                 local distance = self:GetDistance(target)
                 if distance >= GetCDistance(target) then
                    //  Print("Distance %s lastzoom %s", distance, self.lastzoom) //debug my ass
                      input.move.z = input.move.z + 0.5
                      local ymove = 0
                      local myY = self:GetOrigin().y
                      local urY = target:GetOrigin().y 
                      local difference =  urY - myY
                            if difference == 0 then
                                ymove = difference
                            elseif difference <= -1 then
                               ymove = -1
                            elseif difference >= 1 then
                               ymove = 1
                            end
                       input.move.y = input.move.y + (ymove) 
                   elseif distance <= 1.8 then
                   input.move.z = input.move.z - 1
                     // Print(" new distance is %s, new lastzoom is %s", distance, self.lastzoom)
                 end
              end
          
          end
    
    return input
    
end





Shared.LinkClassToMap("Spectator", Spectator.kMapName, networkVars)

