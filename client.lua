local location = nil
local player = nil
local spectating = false
local visible = true
local invincible = false

Citizen.CreateThread(function() 
	while true do 
		Citizen.Wait(1)
		
		if IsControlJustPressed(0, 0x4AF4D473) then -- Delete key
			TriggerServerEvent("CheckGroup")
		end
		
		if spectating then 
			if IsControlJustPressed(0, 0x156F7119) then -- Backspace
				CancelCamera()
			end
		end
	end
end)

RegisterNetEvent("OpenMenu")
AddEventHandler("OpenMenu", function()
    WarMenu.OpenMenu('AtomicMenu')
end)

Citizen.CreateThread(function()
    WarMenu.CreateMenu('AtomicMenu', "Atomic")
    WarMenu.SetSubTitle('AtomicMenu', ' ')
    WarMenu.SetMenuX('AtomicMenu', 0.04)
    WarMenu.SetMenuMaxOptionCountOnScreen('AtomicMenu', 15)
	
	WarMenu.CreateSubMenu('PlayerMenu', 'AtomicMenu', ' ')
	WarMenu.CreateSubMenu('OptionsMenu', 'AtomicMenu', ' ')

    while true do
        Citizen.Wait(0)

        if WarMenu.IsMenuOpened('AtomicMenu') then
			local players = GetPlayers()
			
			for k, v in ipairs(players) do 
				if WarMenu.MenuButton(GetPlayerName(v), "PlayerMenu") then
					player = v
				end
			end
			
			if WarMenu.MenuButton("Options", "OptionsMenu") then end
		
            WarMenu.Display()
        end
		
		if WarMenu.IsMenuOpened('PlayerMenu') then
			if WarMenu.Button('Goto Player', "") then 
				Teleport()
			end
			
			if WarMenu.Button('Bring Player', "") then 
				Bring()
			end
			
			if WarMenu.Button('Spectate Player', "") then 
				Spectate()
			end
			
			if WarMenu.Button('Message Player', "") then 
				Message()
			end
			
			if WarMenu.Button('Kick player', "") then 
				TriggerServerEvent("KickPlayer", GetPlayerServerId(player))
				TriggerEvent("redem_roleplay:NotifyLeft", "Success", "Player has been kicked.", "menu_textures", "menu_icon_tick", 8000)
			end
			
			if WarMenu.Button('Ban Player', "") then
				TriggerServerEvent("BanPlayer", GetPlayerServerId(player), GetPlayerName(player), GetPlayerName(GetPlayerPed(-1)))
				TriggerEvent("redem_roleplay:NotifyLeft", "Success", "Player has been banned.", "menu_textures", "menu_icon_tick", 8000)
			end
			
			WarMenu.Display()
		end
		
		if WarMenu.IsMenuOpened('OptionsMenu') then
			if WarMenu.Button('Toggle Visibility', "") then 
				if visible then 
					SetEntityVisible(PlayerPedId(), false)
					visible = false
				else 
					SetEntityVisible(PlayerPedId(), true)
					visible = true
				end
			end
			
			if WarMenu.Button('Return to location', "") then 
				Return()
			end
			
			if WarMenu.Button('Send Announcement', "") then 
				Announce()
			end
			
			WarMenu.Display()
		end
    end
end)

function Spectate()
	camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
	AttachCamToEntity(camera, GetPlayerPed(player), 0.0, -3.0, 1.0, false)
    SetCamActive(camera, true)
    RenderScriptCams(true, true, 1, true, true)
	SetEntityVisible(PlayerPedId(), false)
	SetEntityInvincible(PlayerPedId(), true)
	spectating = true
end

function CancelCamera()
    RenderScriptCams(true, false, 1, true, true)
    DestroyCam(camera, true)
    DestroyAllCams()
	SetEntityVisible(PlayerPedId(), true)
	SetEntityInvincible(PlayerPedId(), false)
	spectating = false
end

function Teleport()
	local player = GetPlayerPed(player)
	local coords = GetEntityCoords(player)
	lastlocation = GetEntityCoords(PlayerPedId())
	SetEntityCoords(PlayerPedId(), coords)
end

function Message()
	AddTextEntry("FMMC_KEY_TIP8", "Message:")
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 175)

    while (UpdateOnscreenKeyboard() == 0) do
        Wait(0);
    end
	
    while (UpdateOnscreenKeyboard() == 2) do
        Wait(0);
        break
    end
	
    if (GetOnscreenKeyboardResult()) then
		TriggerServerEvent("Message", GetPlayerServerId(player), GetOnscreenKeyboardResult())
		TriggerEvent("redem_roleplay:NotifyLeft", "Success", "Message sent.", "menu_textures", "menu_icon_tick", 8000)
    end
end

function Announce()
	AddTextEntry("FMMC_KEY_TIP8", "Announcement:")
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 175)

    while (UpdateOnscreenKeyboard() == 0) do
        Wait(0);
    end
	
    while (UpdateOnscreenKeyboard() == 2) do
        Wait(0);
        break
    end
	
    if (GetOnscreenKeyboardResult()) then
		TriggerServerEvent("Announce", GetOnscreenKeyboardResult())
    end
end

function Bring()
	local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
	TriggerServerEvent("Bring", GetPlayerServerId(player), x, y, z)
end

RegisterNetEvent("Bring")
AddEventHandler("Bring", function(x, y, z)
	SetEntityCoords(PlayerPedId(), x, y, z, false, false, false, false)
end)

function Return()
	SetEntityCoords(PlayerPedId(), lastlocation)
end

function GetPlayers()
    local players = {}

    for i = 0, 31 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end

    return players
end
