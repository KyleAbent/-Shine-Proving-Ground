--Kyle Abent
--Aditional camera angles that come as an option to enhance the spectator experience
--It's impossible to see everything with a manual camera. This helps to see things that may go missing otherwise
--The reason why I'm having a child class of spectator is so I can easily update the camera angles without networkvar lag
-- This is non game altering in that gameplay is not effecting. The only way this is effecting gameplay is by improving
-- the spectator experience and grasping more calculations based on a changed view angle. You're more likely to get
-- a spectator to use chat to talk to the rest of the world.

local networkVars = 

{
  voiceChannel = "integer",  --Specvoice plugin modified
} 

local cCreate = Spectator.OnCreate
function Spectator:OnCreate()
    cCreate(self)
    self.voiceChannel = 4  --Specvoice plugin modified
    Print("%s %s", self:GetId(), self:getQueue() )
end

function Spectator:setVoiceChannel(channel)
 self.voiceChannel = channel  --Specvoice plugin modified
end

function Spectator:getVoiceChannel()
 return self.voiceChannel   --Specvoice plugin modified
end


Shared.LinkClassToMap("Spectator", Spectator.kMapName, networkVars)





class 'SpectateDirector' (Spectator)
SpectateDirector.kMapName = "Director"


local networkVars = 

{
  lockedId = "entityid", --for directing. I dont wanna mess with vanilla target. eh?
} 


function SpectateDirector:OnCreate()
    Spectator.OnCreate(self)
    self.lockedId = Entity.invalidI  --if directing then non null
   
end


function SpectateDirector:ChangeView(player)
  --shine
end
function SpectateDirector:SetLockOnTarget(userid)
   self.lockedId = userid
end

function SpectateDirector:OnUpdatePlayer(deltatime)
    if Server then
       if not  self.timeLastDirectUpdate or ( self.timeLastDirectUpdate + 8 < Shared.GetTime()  or  self.lockedId == 0  ) then
         self:ChangeView(self)
          self.timeLastDirectUpdate = Shared.GetTime()
        end
       self:LockAngles()
     end  
    
end

function SpectateDirector:LockAngles()//if cam then look for lock
  -- if self:GetSpectatorMode() == kSpectatorMode.FirstPerson then return end
  local OfLock = Shared.GetEntity( self.lockedId ) 
   if OfLock ~= nil then
            --if (OfLock.GetIsAlive and OfLock:GetIsAlive())  then
             local dir = GetNormalizedVector(OfLock:GetOrigin() - self:GetOrigin())
             local angles = Angles(GetPitchFromVector(dir), GetYawFromVector(dir), 0)
             self:SetOffsetAngles(angles)
           -- end
  end
end

function SpectateDirector:BreakChains()
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

function SpectateDirector:OverrideInput(input)
   Spectator.OverrideInput(self, input)
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





Shared.LinkClassToMap("SpectateDirector", SpectateDirector.kMapName, networkVars)

