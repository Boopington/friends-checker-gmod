// Clientside
if not CLIENT then return end

function doFLScan()
	local temp = {}
	for k,v in pairs(player.GetAll()) do
		if v:GetFriendStatus() == "friend" then
			table.insert(temp, v:Nick())
		end
	end
	
	net.Start("sendFL")
	net.WriteTable(temp)
	net.SendToServer()
	
end
net.Receive( "sendFL", doFLScan )