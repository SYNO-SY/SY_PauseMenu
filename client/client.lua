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

CreateThread(function()
    while true do
        Wait(100)
        SendNUIMessage({
            action = 'SetPlayerdetails',
            PlayerData = PlayerData
        })
        ESX.TriggerServerCallback('SY_Pausemenu:GetAllPlayer', function(cb)
            SendNUIMessage({
                action = 'Setcount',
                player_count = cb[1],
                player_ping = cb[2]
            })
        end)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    Wait(1000)
    ESX.PlayerData = xPlayer
    PlayerData.firstName = ESX.PlayerData.firstName
    PlayerData.lastName = ESX.PlayerData.lastName
    PlayerData.job = ESX.PlayerData.job.label
    PlayerData.jobName = ESX.PlayerData.job.grade_label
    local accounts = ESX.PlayerData.accounts
    for _, data in pairs(accounts) do
        if data.name == 'bank' then
            PlayerData.bank = data.money
        elseif data.name == 'money' then
            PlayerData.cash = data.money
        end
    end
    if ESX.PlayerData.sex == "m" then
        PlayerData.sex = "Male"
    else
        PlayerData.sex = "Female"
    end
    local patchnotes
    for _, v in ipairs(Config.PatchNotes.updates) do
        patchnotes = v
        SendNUIMessage({
            action = 'SetPatchnotes',
            PatchnoteDate = Config.PatchNotes.date,
            Patchnotes = patchnotes
        })
    end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
    PlayerData.job = ESX.PlayerData.job.label
    PlayerData.jobName = ESX.PlayerData.job.grade_label
end)

AddEventHandler('esx_status:onTick', function(data)
    local values = {}
    local hunger, thirst
    for i = 1, #data do
        if data[i].name == 'thirst' then
            thirst = math.floor(data[i].percent)
        end
        if data[i].name == 'hunger' then
            hunger = math.floor(data[i].percent)
        end
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
    if Config.Inventory == 'ox' then
        local isInventoryBusy = LocalPlayer.state.invOpen
        if isInventoryBusy then
            pausemenu_opend = true
        else
            pausemenu_opend = false
        end
    end
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
        local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId())
        local img_url = string.format("https://nui-img/%s/%s", mugshotStr, mugshotStr)
        SendNUIMessage({
            action = 'Setprofile',
            pr_img = cb
        })
        SendNUIMessage({
            action = 'Setmugshot',
            mugshot_img = img_url
        })
    end, 'male')
end

RegisterKeyMapping("pausemenu", "Open PauseMenu", "keyboard", "Escape")

function OpenPuaseMenu()
    pausemenu_opend = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'openui',
        theme = Config.Theme
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
    pausemenu_opend = false
    ClosePuaseMenu()
    sendNotification("Report has been submited succesfully", "success", false, nil, 5000)
    TriggerServerEvent("SY_PauseMenu:sendWebHook", data)
end)

--[[END OF NUI CALLBACK]]

--[[ooc]]

RegisterNUICallback("ooc", function(data)
    TriggerServerEvent('SY_Pausemenu:ooc', data.oocText)
end)

RegisterNetEvent('SY_Pausemenu:SendOoc')
AddEventHandler('SY_Pausemenu:SendOoc', function(name, message)
    SendNUIMessage({
        action = 'Setooc',
        oocText = message,
        oocName = name
    })
end)
