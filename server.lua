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
	
	for k, v in pairs(bans) do 
		if k == identifier then 
			deferrals.defer()
			reject("You are banned from this server. Visit Discord.gg/m9Ngbmd for help.")
			CancelEvent()
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
	TriggerClientEvent("redem_roleplay:NotifyLeft", target, "New Message", message, "menu_textures", "menu_icon_alert", 8000)
end)

RegisterServerEvent("KickPlayer")
AddEventHandler("KickPlayer", function(target)
	DropPlayer(target, "You have been kicked by a moderator. Visit Discord.gg/m9Ngbmd for help.")
	TriggerClientEvent("redem_roleplay:NotifyLeft", source, "Success", "Player has been kicked.", "menu_textures", "menu_icon_tick", 8000)
end)

RegisterServerEvent("BanPlayer")
AddEventHandler("BanPlayer", function(target, banner)
	local identifier = GetSteamIdentifier(target)
	Ban(target, tostring(identifier), banner)
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

function Ban(target, identifier, banner)
	local bans = GetBans()
	
	bans[identifier] = {
		banner = banner,
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