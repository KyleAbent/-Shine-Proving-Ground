--Kyle Abent
--Aditional camera angles that come as an option to enhance the spectator experience
--It's impossible to see everything with a manual camera. This helps to see things that may go missing otherwise


local networkVars = 

{
  isDirecting = "private boolean", 
  voiceChannel = "integer",  --Specvoice plugin modified
} 

local origC = Spectator.OnCreate
function Spectator:OnCreate()
    origC(self)
    self.isDirecting = false
    self.voiceChannel = 4  --Specvoice plugin modified
end

function Player:setVoiceChannel(channel)
 self.voiceChannel = channel  --Specvoice plugin modified
end

function Player:getVoiceChannel()
 return self.voiceChannel   --Specvoice plugin modified
end


Shared.LinkClassToMap("Spectator", Spectator.kMapName, networkVars)

