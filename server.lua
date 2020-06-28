RegisterServerEvent("CheckGroup")
AddEventHandler("CheckGroup", function()
	local _source = source
	TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
		if user ~= nil then
			user.getGroup()
			if user.getGroup() == "moderator" or user.getGroup() == "admin" or user.getGroup() == "superadmin" then
				TriggerClientEvent("OpenMenu", source)
			end
		end
	end)
end)

AddEventHandler("playerConnecting", function(name, reject, deferrals)
	local bans = GetBans()
	local _source = source
	local identifier = GetSteamIdentifier(_source)
	local networkid = GetNetworkIdentifier(_source)

	for user, ban in pairs(bans) do 
		for k, v in pairs(ban) do
			if v == identifier or v == networkid then
				deferrals.defer()	
				reject("You are banned from this server. Visit Discord.gg/m9Ngbmd for help.")
				print("^8A banned user (" .. user .. ") attempted to connect from " .. networkid .. " using " .. identifier .. ".^7")
				CancelEvent()
			end
		end
	end
end)

RegisterServerEvent("Announce")
AddEventHandler("Announce", function(message)
	TriggerClientEvent("redem_roleplay:NotifyLeft", -1, "Announcement", message, "menu_textures", "menu_icon_alert", 8000)
end)

RegisterServerEvent("Bring")
AddEventHandler("Bring", function(target, x, y, z)
	TriggerClientEvent("Bring", target, x, y, z)
end)

RegisterServerEvent("Message")
AddEventHandler("Message", function(target, message)
	TriggerClientEvent("redem_roleplay:NotifyLeft", target, "Private Message", message, "menu_textures", "menu_icon_alert", 8000)
end)

RegisterServerEvent("KickPlayer")
AddEventHandler("KickPlayer", function(target)
	DropPlayer(target, "You have been kicked by a moderator. Visit Discord.gg/m9Ngbmd for help.")
	TriggerClientEvent("redem_roleplay:NotifyLeft", source, "Success", "Player has been kicked.", "menu_textures", "menu_icon_tick", 8000)
end)

RegisterServerEvent("BanPlayer")
AddEventHandler("BanPlayer", function(target, username, banner)
	local identifier = GetSteamIdentifier(target)
	local networkid = GetNetworkIdentifier(target)
	Ban(target, tostring(username), tostring(identifier), tostring(networkid), banner)
end)

function GetBans()
	local bans = {}
	
	local file = LoadResourceFile(GetCurrentResourceName(), "bans.json")
	
	if file ~= "" then
		bans = json.decode(file)
	else 
		bans = {}
	end
	
	return bans
end

function Ban(target, username, identifier, networkid, banner)
	local bans = GetBans()
	
	print(target, username, identifier, networkid, banner)
	
	bans[username] = {
		steamid = identifier,
		ip = networkid,
		banner = banner,
		reason = "No reason specified.",
	}
	
	SaveResourceFile(GetCurrentResourceName(), "bans.json", json.encode(bans), -1)
	
	DropPlayer(target, "You are banned from this server. Visit Discord.gg/m9Ngbmd for help.")
end

function GetSteamIdentifier(source)
	local identifier = GetPlayerIdentifiers(source)[1] or false

	if (identifier == false or identifier:sub(1,5) ~= "steam") then
		return false
	end

	return identifier
end

function GetNetworkIdentifier(source)
	local identifier = GetPlayerIdentifiers(source)[2] or false

	if (identifier == false or identifier:sub(1,2) ~= "ip") then
		return false
	end

	return identifier
end

--[[ Auto ban if new ip or steamid is detected (for future release)
if ban['ip'] ~= networkid then
print("This user is connecting with a new IP.")
else
print("This user is connecting with the same credidentials.")
end
]]
