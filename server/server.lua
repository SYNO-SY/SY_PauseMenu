ESX = exports["es_extended"]:getSharedObject()
local Avatars = {}
local FormattedToken = "Bot " .. Config.BotToken



function DiscordRequest(method, endpoint, jsondata)
    local data = nil
    PerformHttpRequest("https://discordapp.com/api/" .. endpoint, function(errorCode, resultData, resultHeaders)
        data = { data = resultData, code = errorCode, headers = resultHeaders }
    end, method, #jsondata > 0 and json.encode(jsondata) or "",
        { ["Content-Type"] = "application/json", ["Authorization"] = FormattedToken })

    while data == nil do
        Citizen.Wait(0)
    end

    return data
end

ESX.RegisterServerCallback('SY_Pausemenu:GetPlayerAvatar', function(source, cb, gender)
    if Config.EnableDiscordImages then
        cb(GetDiscordAvatar(source, gender))
    else
        if gender == 'm' then
            cb(Config.MaleDefaultImage)
        else
            cb(Config.FemaleDefaultImage)
        end
    end
end)

ESX.RegisterServerCallback('SY_Pausemenu:GetAllPlayer', function(source, cb)
    local xPlayers = ESX.GetExtendedPlayers()
    local total_players = #xPlayers
    local player_ping = GetPlayerPing(source)
    tab ={total_players,player_ping}
    if total_players then
        cb(tab)
    end
end)

ESX.RegisterServerCallback('SY_Pausemenu:GetPlayerMoney', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    cb(xPlayer.getAccounts())
end)

function GetDiscordAvatar(user, gender)
    local discordId = nil
    local imgURL = nil;
    for _, id in ipairs(GetPlayerIdentifiers(user)) do
        if string.match(id, "discord:") then
            discordId = string.gsub(id, "discord:", "")
            break
        end
    end
    if discordId then
        if Avatars[discordId] == nil then
            local endpoint = ("users/%s"):format(discordId)
            local member = DiscordRequest("GET", endpoint, {})

            if member.code == 200 then
                local data = json.decode(member.data)
                if data ~= nil and data.avatar ~= nil then
                    if (data.avatar:sub(1, 1) and data.avatar:sub(2, 2) == "_") then
                        imgURL = "https://media.discordapp.net/avatars/" .. discordId .. "/" .. data.avatar .. ".gif";
                    else
                        imgURL = "https://media.discordapp.net/avatars/" .. discordId .. "/" .. data.avatar .. ".png"
                    end
                end
            else
                print("SY_Pausemenu:: Please make sure Config.BotToken is correct")
                if gender == 'm' then
                    imgURL = Config.MaleDefaultImage
                else
                    imgURL = Config.FemaleDefaultImage
                end
            end
            Avatars[discordId] = imgURL;
        else
            imgURL = Avatars[discordId];
        end
    else
        print("SY_Pausemenu:: Discord ID was not found : " .. GetPlayerName(user))
        if gender == 'm' then
            imgURL = Config.MaleDefaultImage
        else
            imgURL = Config.FemaleDefaultImage
        end
    end
    return imgURL;
end

RegisterServerEvent('boii-pausemenu:DropPlayer')
AddEventHandler('boii-pausemenu:DropPlayer', function()
    DropPlayer(source, 'You disconnected from the server.')
end)


RegisterServerEvent('SY_Pausemenu:ooc')
AddEventHandler('SY_Pausemenu:ooc', function(data)
        local xPlayer = ESX.GetPlayerFromId(source)
		local message = data
		local time = os.date(Config.DateFormat)
		playerName = xPlayer.getName()
		TriggerClientEvent('chat:ooc', -1, source, playerName, message, time)
        TriggerClientEvent('SY_Pausemenu:SendOoc',-1, playerName, message)
end)


Config = {}

function SendWebHook(webHook , title, color, message)
    local embedMsg = {}
    timestamp = os.date("%c")
    embedMsg = {
        {
            ["color"] = color,
            ["title"] = title,
            ["description"] =  ""..message.."",
            ["footer"] ={
                ["text"] = timestamp.." (Server Time).",
            },
        }
    }
    PerformHttpRequest(webHook,function(err, text, headers)end, 'POST', json.encode({username = Config.webhookName, avatar_url= Config.webhookLogo ,embeds = embedMsg}), { ['Content-Type']= 'application/json' })
end



RegisterServerEvent('SY_PauseMenu:sendWebHook')
AddEventHandler('SY_PauseMenu:sendWebHook', function(data)
    title = data.subjectText
    message = data.reportText
    if Config.WebHook == '' then
        print('^7[^1INFO^7]: No default WebHook URL detected. Please configure the script correctly.')
    else 
        webHook = Config.WebHook
        title = title
        color = 655104
        message = message
        SendWebHook(webHook , title, color, message)
    end
end)