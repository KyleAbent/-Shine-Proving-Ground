local Plugin = Plugin
local Shine = Shine
local VoteMenu = Shine.VoteMenu


function Plugin:Initialise()
self.Enabled = true
return true
end

Shine.VoteMenu:AddPage( "Spec Voice", function( self )
		self:AddTopButton( "Back", function()
			self:SetPage( "Proving Ground" )
		end )
end )

Shine.VoteMenu:AddPage( "Proving Ground", function( self )
		self:AddTopButton( "Back", function()
			self:SetPage( "Main" )
end )

	self:AddSideButton( "Contact Admin", function()
			self:SetPage( "Main" )
			self:SetIsVisible( false )
			Client.ShowWebpage( "https://steamcommunity.com/profiles/76561198165616756/" )
		end )
		
		self:AddSideButton( "Discord", function()
			self:SetPage( "Main" )
			self:SetIsVisible( false )
			Client.ShowWebpage( "https://discordapp.com/invite/qBKdVZQ" )
		end )
		
end )


	Shine.VoteMenu:EditPage( "Main", function( self )
		self:AddSideButton( "Proving Ground", function()
			self:SetPage( "Proving Ground" )
		end )

	end )	

