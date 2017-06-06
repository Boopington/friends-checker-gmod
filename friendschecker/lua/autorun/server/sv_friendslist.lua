// Serverside
if not SERVER then return end

util.AddNetworkString( "sendFL" )
util.AddNetworkString( "recFL" )

local waiting = {}
local remtbl = {}

function getCaller( ply )
	for _,v in pairs(waiting) do
		if v[2] == ply then
			return v[1]
		end
	end
	return false
end

function registerFLReq( caller, victim )
	table.insert(waiting, { caller, victim, RealTime() } )
	net.Start("sendFL")
	net.Send(victim)
end

local function serverRecFL(len, ply)
	local friends = net:ReadTable()
	local caller = getCaller(ply)
	
	for k,v in pairs(waiting) do
		if v[2] == ply then
			if IsValid(v[1]) then
				if friends[1] == nil then
					evolve:Notify(v[1], evolve.colors.blue, ply:Nick(), evolve.colors.white, " has no friends playing on the server")
				else
					evolve:Notify(v[1], evolve.colors.blue, ply:Nick(), evolve.colors.white, " has these friends playing")
					for k,i in pairs(friends) do
						evolve:Notify(v[1], evolve.colors.white, ">", evolve.colors.blue, i)
					end
				end
			end
			v[2] = nil
			table.insert(remtbl, k)
		end
	end
	
	for k,v in pairs(remtbl) do
		table.remove(waiting, v)
	end
end
net.Receive( "sendFL", serverRecFL )

local function ssValid( ply )
	for _,v in pairs(waiting) do
		if v[2] == ply then
			return true
		end
	end
	return false
end

local function callerValid( ply )
	for _,v in pairs(waiting) do
		if v[1] == ply then
			return true
		end
	end
	return false
end

local function getCaller( ply )
	for _,v in pairs(waiting) do
		if v[2] == ply then
			return v[1]
		end
	end
	return false
end

hook.Add("PlayerDisconnected", "checkwaitingFL", function( ply )
	for k,v in pairs(waiting) do
		if v[2] == ply then
			table.insert(remtbl, k)
			if IsValid(v[1]) then
				evolve:Notify(v[1], evolve.colors.red, ply:Nick().." has disconnected, friendsListGet interrupted.")
			end
		end
	end
end)

local function timercheck()
	for k,v in pairs(waiting) do
		if (RealTime() - v[3] ) > 7 then
			if IsValid(v[1]) and IsValid(v[2]) then
				evolve:Notify(v[1], evolve.colors.red, v[2]:Nick().." timed out sending friend data.")
			end
			table.insert(remtbl, k)
		end
	end
	
	for k,v in pairs(remtbl) do
		table.remove(waiting, v)
	end
	
	remtbl = {}
end
timer.Create("checkFL", 5, 0, timercheck )