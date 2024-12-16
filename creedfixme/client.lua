local cooldownTime = 300000 
local lastUsedTime = 0      

RegisterCommand('fixmepls', function()
    local currentTime = GetGameTimer()
    if currentTime - lastUsedTime < cooldownTime then
        local remainingTime = math.ceil((cooldownTime - (currentTime - lastUsedTime)) / 1000)
        exports.ox_lib:notify({
            title = '🔧 Fix Me Pls',
            description = ('⏳ You must wait %d seconds before using this again.'):format(remainingTime),
            type = 'error'
        })
        print("DEBUG: Cooldown active -> Remaining time:", remainingTime, "seconds.")
        return
    end

    local playerPed = PlayerPedId()
    local playerId = GetPlayerServerId(PlayerId())
    local playerName = GetPlayerName(PlayerId())

    if not playerPed or playerPed == 0 then
        exports.ox_lib:notify({
            title = '🔧 Fix Me Pls',
            description = '❌ Failed to identify your player character!',
            type = 'error'
        })
        print("DEBUG: Invalid player ped.")
        return
    end


    local result = exports.ox_lib:alertDialog({
        header = '🚨 Fix Me Pls Confirmation 🚨',
        content = [[
⚠️ **Warning!**  

Are you sure you want to use **FixMePls**?  
This command is used to **fix your player state**.  

🛑 *Misusing this command can and will result in staff action!*
        ]],
        centered = true,
        cancel = true,
        labels = { cancel = '❌ No, Cancel', confirm = '✅ Yes, Fix Me 🚀' }
    })

    if result == 'confirm' then
        print("DEBUG: Confirmation received -> Delaying teleport")

        exports.ox_lib:notify({
            title = '🔧 Fix Me Pls',
            description = '⏳ You will be fixed soon. Please wait...',
            type = 'info'
        })

        Wait(5000) 
        print("DEBUG: 5-Second wait over -> Teleporting player")

        local paletoCoords = vector4(-51.9628, 6528.6963, 31.4908, 225.8389)

        DoScreenFadeOut(500)
        Wait(1000)

        SetEntityCoords(playerPed, paletoCoords.x, paletoCoords.y, paletoCoords.z, false, false, false, true)
        SetEntityHeading(playerPed, paletoCoords.w)

        Wait(500)
        DoScreenFadeIn(500)

        lastUsedTime = GetGameTimer()

        exports.ox_lib:notify({
            title = '✅ Fix Me Pls',
            description = '🎉 You have been successfully teleported to **Paleto**!',
            type = 'success'
        })


        TriggerServerEvent('fixmepls:logToDiscord', playerName, playerId)

        print("DEBUG: Player successfully teleported! Log event triggered.")
    else
        print("DEBUG: Action cancelled by user.")
        exports.ox_lib:notify({
            title = '❌ Fix Me Pls',
            description = '🚫 Action cancelled!',
            type = 'error'
        })
    end
end, false)



















