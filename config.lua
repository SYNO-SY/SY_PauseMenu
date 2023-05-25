Config = {}
Config.Locale = GetConvar('esx:locale', 'en')
Config.Inventory = 'ox' --this is for to prevent the pausemenu opening  when Inventory is closing (if Inventory is open).

-- ████████╗██╗  ██╗███████╗███╗   ███╗███████╗
-- ╚══██╔══╝██║  ██║██╔════╝████╗ ████║██╔════╝
--    ██║   ███████║█████╗  ██╔████╔██║█████╗  
--    ██║   ██╔══██║██╔══╝  ██║╚██╔╝██║██╔══╝  
--    ██║   ██║  ██║███████╗██║ ╚═╝ ██║███████╗
--    ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝╚══════╝

Config.Theme = 'grey' -- purple,red,green,blue,grey

-- ██████╗ ██╗███████╗ ██████╗ ██████╗ ██████╗ ██████╗ 
-- ██╔══██╗██║██╔════╝██╔════╝██╔═══██╗██╔══██╗██╔══██╗
-- ██║  ██║██║███████╗██║     ██║   ██║██████╔╝██║  ██║
-- ██║  ██║██║╚════██║██║     ██║   ██║██╔══██╗██║  ██║
-- ██████╔╝██║███████║╚██████╗╚██████╔╝██║  ██║██████╔╝
-- ╚═════╝ ╚═╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚═════╝                                                 

Config.BotToken = 'OTEyOTk5MDYzMTM2NDAzNTE2.GzLbkl.R13kltOMgMRboO9dS6R4ou1vI1y7OtVDr7Hjy0' -- How to create a bot token https://www.youtube.com/watch?v=-m-Z7Wav-fM
Config.WebHook = 'https://discord.com/api/webhooks/1109891957100126258/23BE7lTeavJSligdzB9Yp4bWCPL-F3JslBmLaCfUnYB0tUGb_6W4AMWnZZgtZq4s_wvr' -- Report system webhook
Config.webhookName = 'SY_Pausemenu' -- Name of the WebHook
Config.webhookLogo = 'https://cdn.discordapp.com/attachments/954263572874137671/984808162857222164/discord.png' -- Avatar of the WebHook
Config.EnableDiscordImages = true -- if false will display default images
Config.DefaultMaleImage = 'https://imgur.com/UqJmo5d.png'
Config.DefaultFemaleImage = 'https://imgur.com/Tovcqdp.png'

-- ███╗   ██╗ ██████╗ ████████╗██╗███████╗██╗ ██████╗ █████╗ ████████╗██╗ ██████╗ ███╗   ██╗
-- ████╗  ██║██╔═══██╗╚══██╔══╝██║██╔════╝██║██╔════╝██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║
-- ██╔██╗ ██║██║   ██║   ██║   ██║█████╗  ██║██║     ███████║   ██║   ██║██║   ██║██╔██╗ ██║
-- ██║╚██╗██║██║   ██║   ██║   ██║██╔══╝  ██║██║     ██╔══██║   ██║   ██║██║   ██║██║╚██╗██║
-- ██║ ╚████║╚██████╔╝   ██║   ██║██║     ██║╚██████╗██║  ██║   ██║   ██║╚██████╔╝██║ ╚████║
-- ╚═╝  ╚═══╝ ╚═════╝    ╚═╝   ╚═╝╚═╝     ╚═╝ ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝

Config.Notification = "ESX" -- ESX,okok,custom.
sendNotification = function(text, msgtype, IsServer, src, time)
    if IsServer then
        if Config.Notification == "ESX" then
            TriggerClientEvent('esx:showNotification', source, text, msgtype, time)
        elseif Config.Notification == "okok" then
            TriggerClientEvent('okokNotify:Alert', source, "Repairshop", text, time, msgtype)
        elseif Config.Notification == "custom" then
            TriggerClientEvent('SY_Notify:Alert', source, "Repairshop", text, time, msgtype)
        end
    else
        if Config.Notification == "ESX" then
            ESX.ShowNotification(text, time, msgtype)
        elseif Config.Notification == "okok" then
            exports['okokNotify']:Alert("Repairshop", text, 5000, msgtype)
        elseif Config.Notification == "custom" then
            exports['SY_Notify']:Alert("Repairshop", text, 5000, msgtype)
        end
    end
end

-- ██████╗  █████╗ ████████╗ ██████╗██╗  ██╗███╗   ██╗ ██████╗ ████████╗███████╗
-- ██╔══██╗██╔══██╗╚══██╔══╝██╔════╝██║  ██║████╗  ██║██╔═══██╗╚══██╔══╝██╔════╝
-- ██████╔╝███████║   ██║   ██║     ███████║██╔██╗ ██║██║   ██║   ██║   █████╗  
-- ██╔═══╝ ██╔══██║   ██║   ██║     ██╔══██║██║╚██╗██║██║   ██║   ██║   ██╔══╝  
-- ██║     ██║  ██║   ██║   ╚██████╗██║  ██║██║ ╚████║╚██████╔╝   ██║   ███████╗
-- ╚═╝     ╚═╝  ╚═╝   ╚═╝    ╚═════╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝    ╚═╝   ╚══════╝

Config.PatchNotes = {
    date = '30.10.2023',
    updates = {'Lorem ipsum dolor sit amet consectetur adipisicing elit. Fuga, repudiandae minima.',
               'Lorem ipsum dolor sit amet consectetur adipisicing elit. Fuga, repudiandae minima.',
               'Lorem ipsum dolor sit amet consectetur adipisicing elit. Fuga, repudiandae minima.',
               'Lorem ipsum dolor sit amet consectetur adipisicing elit. Fuga, repudiandae minima.',
               'Lorem ipsum dolor sit amet consectetur adipisicing elit. Fuga, repudiandae minima.',
               'Lorem ipsum dolor sit amet consectetur adipisicing elit. Fuga, repudiandae minima.',
               'Lorem ipsum dolor sit amet consectetur adipisicing elit. Fuga, repudiandae minima.',
               'Lorem ipsum dolor sit amet consectetur adipisicing elit. Fuga, repudiandae minima.',
               'Lorem ipsum dolor sit amet consectetur adipisicing elit. Fuga, repudiandae minima.',
               'Lorem ipsum dolor sit amet consectetur adipisicing elit. Fuga, repudiandae minima.',
               'Lorem ipsum dolor sit amet consectetur adipisicing elit. Fuga, repudiandae minima.',
               'Lorem ipsum dolor sit amet consectetur adipisicing elit. Fuga, repudiandae minima.'}
}
