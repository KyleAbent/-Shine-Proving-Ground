local Shine = Shine

local Plugin = Plugin

function Plugin:Initialise()
self.Enabled = true
return true
end

	 Shine.VoteMenu:AddPage( "Intervals", function( self )
		self:AddSideButton( "8 Seconds", function()
		      Shared.ConsoleCommand( "sh_director_intervals 8" )
		end )
		self:AddSideButton( "12 Seconds", function()
		      Shared.ConsoleCommand( "sh_director_intervals 12" )
		end )
		self:AddSideButton( "16 Seconds", function()
		      Shared.ConsoleCommand( "sh_director_intervals 16" )
		end )
		self:AddSideButton( "20 Seconds", function()
		      Shared.ConsoleCommand( "sh_director_intervals 20" )
		end )
		self:AddSideButton( "24 Seconds", function()
		      Shared.ConsoleCommand( "sh_director_intervals 24" )
		end )
		self:AddTopButton( "Back", function()
			self:SetPage( "Spectator" )
		end )
	end )
		

	Shine.VoteMenu:AddPage( "Spectator", function( self )
		self:AddTopButton( "Back", function()
			self:SetPage( "Proving Grounds" )
		end )
		self:AddSideButton( "Intervals", function()
			self:SetPage( "Intervals" )
		end )
	end )

	Shine.VoteMenu:EditPage( "Spectator", function( self )
		self:AddSideButton( "Toggle Director", function()
		--	Shared.ConsoleCommand( "sh_specvoice 1" )
		    --local player = Client.GetLocalPlayer()
		   -- player:setNoQueue(player)
		      Shared.ConsoleCommand( "sh_direct" )
			--self:SetPage( "Main" )
			--self:SetIsVisible( false )
		end )
		
		
	end )
		

