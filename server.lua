AyseCore = exports["Ayse_Core"]:GetCoreObject()

local jailedPlayers = {}

function GetPlayerIdentifierFromType(type, source)
    local identifierCount = GetNumPlayerIdentifiers(source)
    for count = 0, identifierCount do
        local identifier = GetPlayerIdentifier(source, count)
        if identifier and string.find(identifier, type) then
            return identifier
        end
    end
    return nil
end

function sendToDiscord(name, message, color)
    local embed = {
        {
            title = name,
            description = message,
            footer = {
                icon_url = "https://i.imgur.com/FJzMEKv.png",
                text = "AyseFramework Jailing"
            },
            color = color
        }
    }
    PerformHttpRequest(server_config.discordWebhook, function(err, text, headers) end, 'POST', json.encode({username = "ND Jailing", embeds = embed}), {["Content-Type"] = "application/json"})
end

RegisterNetEvent("Ayse_Jailing:jailPlayer")
AddEventHandler("Ayse_Jailing:jailPlayer", function(id, time, fine, reason)
    local player = source
    local players = AyseCore.Functions.GetPlayers()
    local dept = players[player].job
    for _, department in pairs(config.accessDepartments) do
        if department == dept then
            jailedPlayers[GetPlayerIdentifierFromType("license", id)] = time
            AyseCore.Functions.DeductMoney(fine, id, "bank")
            TriggerClientEvent("Ayse_Jailing:jailPlayer", id, time)
            sendToDiscord("Jail Logs", "**" .. GetPlayerName(player) .. "** Jailed **" .. GetPlayerName(id) .. "** for **" .. time .. " seconds** with the reason: **" .. reason .. "**.", 1595381)
            TriggerClientEvent('chat:addMessage', -1, {
                color = { 255, 0, 0},
                multiline = true,
                args = {"[Judge]", GetPlayerName(id) .. " was charaged with " .. reason .. " and will be spending " .. time .. " months in jail."}
            })
            break
        end
    end
end)

RegisterNetEvent("Ayse_Jailing:updateJailing")
AddEventHandler("Ayse_Jailing:updateJailing", function(time)
    local player = source
    if time == 0 then
        jailedPlayers[GetPlayerIdentifierFromType("license", player)] = nil
    else
        jailedPlayers[GetPlayerIdentifierFromType("license", player)] = time
    end
end)

RegisterNetEvent("Ayse_Jailing:getPlayers")
AddEventHandler("Ayse_Jailing:getPlayers", function()
    local players = {}
    for _, id in pairs(GetPlayers()) do
        players[id] = "(" .. id .. ") " .. GetPlayerName(id)
    end
    TriggerClientEvent("Ayse_Jailing:returnPlayers", source, players)
end)

RegisterNetEvent("Ayse_Jailing:getJailTime")
AddEventHandler("Ayse_Jailing:getJailTime", function()
    local player = source
    local time = jailedPlayers[GetPlayerIdentifierFromType("license", player)]
    if time then
        TriggerClientEvent("Ayse_Jailing:jailPlayer", player, time)
    end
end)