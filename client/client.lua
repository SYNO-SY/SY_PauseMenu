ESX = exports["es_extended"]:getSharedObject()
local pausemenu_opend = false
local PlayerData = {}


CreateThread(function()
    local playMinute, playHour = 0, 0
    while true do
        Wait(1000 * 60) -- every minute
        playMinute = playMinute + 1

        if playMinute == 60 then
            playMinute = 0
            playHour = playHour + 1
        end
        SendNUIMessage({
            action = 'Updateplaytime',
            playHour = playHour,
            playMinute = playMinute
        })
    end
end)

CreateThread(function()
    while true do
        Wait(1)
        SetPauseMenuActive(false)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
    PlayerData.firstName = ESX.PlayerData.firstName
    PlayerData.lastName = ESX.PlayerData.lastName
    PlayerData.job = ESX.PlayerData.job.label
    PlayerData.jobName = ESX.PlayerData.job.grade_label
    if ESX.PlayerData.sex == "m" then
        PlayerData.sex = "Male"
    else
        PlayerData.sex = "Female"
    end
end)

CreateThread(function ()
end)

AddEventHandler('esx_status:onTick', function(data)
    local values = {}
    local hunger, thirst
    for i = 1, #data do
        if data[i].name == 'thirst' then thirst = math.floor(data[i].percent) end
        if data[i].name == 'hunger' then hunger = math.floor(data[i].percent) end
    end

    local ped = PlayerPedId()

    values.healthBar = math.floor((GetEntityHealth(ped) - 100) / (GetEntityMaxHealth(ped) - 100) * 100)
    values.drinkBar = thirst
    values.foodBar = hunger
    SendNUIMessage({
        action = 'SetStatus',
        values = values
    })

end)

RegisterCommand("pausemenu", function()
    SendNui()
    if pausemenu_opend == true then
        pausemenu_opend = false
        return
    end
    if pausemenu_opend == false and (not IsPauseMenuActive()) then
        OpenPuaseMenu()
    end
end)


function SendNui()
    ESX.TriggerServerCallback('SY_Pausemenu:GetPlayerAvatar', function(cb)
        SendNUIMessage({
            action = 'Setprofile',
            pr_img = cb
        })
        SendNUIMessage({
            action = 'Setmugshot',
            mugshot_img = getpedmugshot()
        })
    end, 'male')
    ESX.TriggerServerCallback('SY_Pausemenu:GetAllPlayer', function(cb)
        SendNUIMessage({
            action = 'Setcount',
            player_count = cb[1],
            player_ping = cb[2]
        })
    end)
    ESX.TriggerServerCallback('SY_Pausemenu:GetPlayerMoney', function(cb)
        for k,v in pairs(cb) do
            if v.label == 'Bank' then
               player_bank = v.money
            end
            if v.label == 'Cash' then
                player_cash = v.money
             end
        end
        SendNUIMessage({
            action = 'SetPlayeraccounts',
            player_cash = player_cash,
            player_bank = player_bank
        })
    end, 0)

    SendNUIMessage({
        action = 'SetPlayerdetails',
        PlayerData = PlayerData
    })
end

RegisterKeyMapping("pausemenu", "Open PauseMenu", "keyboard", "Escape")

function OpenPuaseMenu()
    pausemenu_opend = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'openui'
    })
end

function ClosePuaseMenu()
    SendNUIMessage({
        action = 'closeui'
    })
    SetNuiFocus(false, false)
end

--[[NUI CALLBACK]]
--
RegisterNUICallback("close", function()
    pausemenu_opend = false
    ClosePuaseMenu()
end)

RegisterNUICallback("resume", function()
    pausemenu_opend = false
    ClosePuaseMenu()
end)
RegisterNUICallback("settings", function()
    pausemenu_opend = true
    ClosePuaseMenu()
    ActivateFrontendMenu(GetHashKey('FE_MENU_VERSION_LANDING_MENU'), 0, -1)
end)
RegisterNUICallback("keybind", function()
    pausemenu_opend = true
    ClosePuaseMenu()
    ActivateFrontendMenu(GetHashKey('FE_MENU_VERSION_LANDING_KEYMAPPING_MENU'), 0, -1)
end)
RegisterNUICallback("map", function()
    pausemenu_opend = true
    ClosePuaseMenu()
    ActivateFrontendMenu(GetHashKey('FE_MENU_VERSION_MP_PAUSE'), 0, -1)
end)
RegisterNUICallback('exit', function()
    pausemenu_opend = true
    ClosePuaseMenu()
    TriggerServerEvent('SY_PasueMenu:DropPlayer')
end)
RegisterNUICallback('Report', function(data)
   TriggerServerEvent("SY_PauseMenu:sendWebHook", data)
end)

--[[END OF NUI CALLBACK]]
--

--[[MUG-SHOT]]
requests = {}

function GenerateId()
    local id = ""
    for i = 1, 15 do
        id = id .. (math.random(1, 2) == 1 and string.char(math.random(97, 122)) or tostring(math.random(0, 9)))
    end
    return id
end

function ClearHeadshots()
    for i = 1, 32 do
        if IsPedheadshotValid(i) then
            UnregisterPedheadshot(i)
        end
    end
end

function GetHeadshot(ped)
    ClearHeadshots()
    if not ped then ped = PlayerPedId() end
    if DoesEntityExist(ped) then
        local handle, timer = RegisterPedheadshot(ped), GetGameTimer() + 5000
        while not IsPedheadshotReady(handle) or not IsPedheadshotValid(handle) do
            Wait(50)
            if GetGameTimer() >= timer then
                return { success = false, error = "Could not load ped headshot." }
            end
        end

        local txd = GetPedheadshotTxdString(handle)
        local url = string.format("https://nui-img/%s/%s", txd, txd)
        return { success = true, url = url, txd = txd, handle = handle }
    end
end

function getpedmugshot()
    if not ped then ped = PlayerPedId() end
    local headshot = GetHeadshot(ped)
    if headshot.success then
        mugshotimg = headshot.url
        return mugshotimg
    else
        return nil
    end
end

function GetBase64(ped)
    if not ped then ped = PlayerPedId() end
    local headshot = GetHeadshot(ped)
    if headshot.success then
        local requestId = GenerateId()
        requests[requestId] = nil
        SendNUIMessage({
            type = "convert_base64",
            img = headshot.url,
            handle = headshot.handle,
            id = requestId
        })

        local timer = GetGameTimer() + 5000
        while not requests[requestId] do
            Wait(250)
            if GetGameTimer() >= timer then
                return { success = false, error = "Waiting for base64 conversion timed out." }
            end
        end
        return { success = true, base64 = requests[requestId] }
    else
        return headshot
    end
end

RegisterNUICallback("base64", function(data, cb)
    if data.handle then
        UnregisterPedheadshot(data.handle)
    end
    if data.id then
        requests[data.id] = data.base64
        Wait(1500)
        requests[data.id] = nil
    end

    cb({ ok = true })
end)

--[[MUG-SHOT]]


--[[ooc]]

RegisterNUICallback("ooc", function (data)
    TriggerServerEvent('SY_Pausemenu:ooc',data.oocText)
end)

RegisterNetEvent('SY_Pausemenu:SendOoc')
AddEventHandler('SY_Pausemenu:SendOoc', function(name, message)
    SendNUIMessage({
        action = 'Setooc',
        oocText = message,
        oocName = name
    })
end)