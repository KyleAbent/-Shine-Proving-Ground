--Kyle Abent  
--Todo: Aassert a certain amount of nodes is not exceeded by count just incase an exploit doesnt delete nodes correctly.
Script.Load("lua/shine/extensions/provingground/commands.lua")


local Plugin = Plugin
local Shine = Shine




function Plugin:Initialise()
	self.Enabled = true
	self:CreateCommands() 
	return true
end







