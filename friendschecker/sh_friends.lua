local PLUGIN = {}
PLUGIN.Title = "Friends"
PLUGIN.Description = "Check to see who a player is friends with."
PLUGIN.Author = "Mahaugher/Pedobear"
PLUGIN.ChatCommand = "friends"
PLUGIN.Usage = "<nick>"
PLUGIN.Privileges = { "friends" }


function PLUGIN:Call( ply, args )
	if ( ply:EV_HasPrivilege( "friends" ) ) then
		if ( args[1] ) then
			local players = evolve:FindPlayer( args, ply, nil, true )
			
			if ( #players > 0 ) then
				registerFLReq(ply, players[1])
				//evolve:Notify( ply, evolve.colors.white, "Requesting friend information for "..players[1]:Nick() )
				//ply:SendLua("gui.OpenURL( 'http://steamcommunity.com/profiles/".. players[1]:SteamID64() .."/friends' )")
			else
				evolve:Notify( ply, evolve.colors.red, "No matching players found!" )
			end
		else
			evolve:Notify( ply, evolve.colors.red, "You need to specify a nickname." )
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

evolve:RegisterPlugin( PLUGIN )