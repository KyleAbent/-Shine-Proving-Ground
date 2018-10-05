--Well I didn't realize there's already pre-written code enhanced for spectator such as my desire with director
--But of course the only way this happened is by going in the order I did :P
local orig = FollowMoveMixin.__initmixin
function FollowMoveMixin:__initmixin()
  orig(self)
  self.intervals = 9
end

function FollowMoveMixin:setIntervals(num)
self.intervals = num
end

function FollowMoveMixin:getFME()
return self.followMoveEnabled 
end
/*
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
*/

 function FollowMoveMixin:ChangeTarget(self, reverse)

    local targets = self:GetTargetsToFollow()
    local numberOfTargets = table.icount(targets)
    local currentTargetIndex = table.find(targets, Shared.GetEntity(self.followedTargetId))
    local nextTargetIndex = currentTargetIndex
    
    if nextTargetIndex and reverse then
        nextTargetIndex = ((nextTargetIndex - 2) % numberOfTargets) + 1
    elseif nextTargetIndex then
        nextTargetIndex = (nextTargetIndex % numberOfTargets) + 1
    else
        nextTargetIndex = 1
    end
    
    if nextTargetIndex <= numberOfTargets then
    
        local cameraDistance = 6 --GetCDistance( Shared.GetEntity( targets[nextTargetIndex]:GetId() ) ) --5 -- getCDistance(target)
        
        if self.GetFollowMoveCameraDistance then
            cameraDistance = self:GetFollowMoveCameraDistance()
        end
        
        self.followedTargetId = targets[nextTargetIndex]:GetId()
        self:SetDesiredCamera(0.0, { move = true}, targets[nextTargetIndex]:GetOrigin(), nil, cameraDistance)
        
    end
    
end
function FollowMoveMixin:UpdateTarget(self, input)

    assert(Server)
    
    if self.imposedTargetId ~= Entity.invalidId then
    
        if self:GetIsValidTarget(Shared.GetEntity(self.imposedTargetId)) then
            return
        else
            self.imposedTargetId = Entity.invalidId
        end
        
    end
    
   -- local primaryAttack = bit.band(input.commands, Move.PrimaryAttack) ~= 0
  --  local secondaryAttack = bit.band(input.commands, Move.SecondaryAttack) ~= 0
    local isTargetValid = self:GetIsValidTarget(Shared.GetEntity(self.followedTargetId))
   -- local changeTargetAction = primaryAttack or secondaryAttack
    
    -- Require another click to change target.
    -- NOT. That would be lame, yo. Let me watch a movie and commentate over it on demand.
    local changeTarget = not isTargetValid--(not self.changeTargetAction and changeTargetAction) or not isTargetValid
          changeTarget = changeTarget or ( not self.timeLast or self.timeLast + self.intervals < Shared.GetTime() ) --Lets not stay forever
          
    self.changeTargetAction = changeTargetAction
    
    if changeTarget then--and secondaryAttack then
        self:ChangeTarget(self, true) 
        self.timeLast = Shared.GetTime()
    elseif changeTarget then --?? 
        self:ChangeTarget(self, false)
    end
    
end
function FollowMoveMixin:UpdateView(self, input)

  --  local viewAngles = self:ConvertToViewAngles(input.pitch, input.yaw, 0)
    local targetId = self.imposedTargetId ~= Entity.invalidId and self.imposedTargetId or self.followedTargetId
    local targetEntity = Shared.GetEntity(targetId)
    local isTargetValid = self:GetIsValidTarget(targetEntity)
    
      if targetEntity ~= nil then
             local dir = GetNormalizedVector(targetEntity:GetOrigin() - self:GetOrigin())
             local angles = Angles(GetPitchFromVector(dir), GetYawFromVector(dir), 0)
             self:SetOffsetAngles(angles)
     end
           
    if isTargetValid then
        self:SetOrigin(targetEntity:GetOrigin())
    end
    
    --self:SetViewAngles(viewAngles)
   -- self:SetOffsetAngles(viewAngles) --spectator_director
    
end

function FollowMoveMixin:UpdateMove(input)

    if not self.followMoveEnabled then
        return
    end
    
    if Server then
        self:UpdateTarget(self, input)
    end
    self:UpdateView(self, input)
    
end