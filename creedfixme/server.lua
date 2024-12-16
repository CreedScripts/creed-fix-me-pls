local webhookURL = "REPLACE_WITH_YOUR_DISCORD_HOOK"


local function sendToDiscord(playerName, playerId, discordID)

    local utcTime = os.time()
    local aestTime = os.date("!%Y-%m-%d %I:%M:%S %p", utcTime + (10 * 3600)) 

    local embed = {
        {
            ["title"] = "**🚨 FixMePls Command Used 🚨**",
            ["color"] = 3447003, 
            ["fields"] = {
                {
                    ["name"] = "**🔹 Player Name:**",
                    ["value"] = playerName,
                    ["inline"] = true
                },
                {
                    ["name"] = "**🔹 Server ID:**",
                    ["value"] = playerId,
                    ["inline"] = true
                },
                {
                    ["name"] = "**🔹 Discord ID:**",
                    ["value"] = discordID ~= "N/A" and ("<@" .. discordID .. ">") or "Not Linked",
                    ["inline"] = false
                }
            },
            ["footer"] = {
                ["text"] = "FixMePls Logs • " .. aestTime .. " AEST",
                ["icon_url"] = "https://media.discordapp.net/attachments/1252960975276085360/1318142515760595016/creed_scripts.png?ex=67613f61&is=675fede1&hm=03be6b835bdb751b801d11d4c9f2125d0d63abcfbff29d062e3ae3c4743dac71&=&format=webp&quality=lossless" -- Example icon
            }
        }
    }

    PerformHttpRequest(webhookURL, function(err, text, headers)
        if err ~= 200 then
            print("DEBUG: Webhook failed with error:", err)
        end
    end, 'POST', json.encode({
        username = "FixMePls Logs",
        embeds = embed,
        avatar_url = "https://media.discordapp.net/attachments/1252960975276085360/1318142515760595016/creed_scripts.png?ex=67613f61&is=675fede1&hm=03be6b835bdb751b801d11d4c9f2125d0d63abcfbff29d062e3ae3c4743dac71&=&format=webp&quality=lossless" -- Bot avatar
    }), { ['Content-Type'] = 'application/json' })
end


local function getDiscordID(source)
    local discordID = "N/A"
    for _, id in ipairs(GetPlayerIdentifiers(source)) do
        if string.sub(id, 1, 8) == "discord:" then
            discordID = string.sub(id, 9) 
            break
        end
    end
    return discordID
end


RegisterServerEvent('fixmepls:logToDiscord')
AddEventHandler('fixmepls:logToDiscord', function(playerName, playerId)
    local source = source 
    local discordID = getDiscordID(source)


    sendToDiscord(playerName, playerId, discordID)
    print(("DEBUG: Log sent to Discord for player: %s | Server ID: %d | Discord ID: %s"):format(playerName, playerId, discordID))
end)





