The usage example below is from [redemrp_inventory](https://github.com/RedEM-RP/redemrp_inventory/).

```
RegisterCommand('giveitem', function(source, args)
    local _source = source
    TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
		if user ~= nil then
			if user.getGroup() == 'superadmin' then
		
				local identifier = user.getIdentifier()
				local charid = user.getSessionVar("charid")
				
				for i,k in pairs(invTable) do
					if k.id == identifier and k.charid == charid then
						local item = args[1]
						local amount = args[2]
						local test = 1
						TriggerEvent("item:add", _source, {item, amount, test}, identifier , charid)
						TriggerEvent("Log", _source, "Item", "User successfully gave themself x" .. amount .. " " .. item .. ".") -- Log example
						TriggerClientEvent('gui:ReloadMenu', _source)
						break
					end
				end
			else 
				TriggerClientEvent("redem_roleplay:NotifyLeft", _source, "Error", "Insufficient permissions. This action has been logged.", "menu_textures", "menu_icon_alert", 8000)
				TriggerEvent("Log", _source, "Item", "User attempted to give themself x" .. args[2] .. " " .. args[1] .. ".") -- Log example
			end			
		end
    end)
end)
```
