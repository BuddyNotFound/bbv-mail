RegisterNetEvent('bbv-mail:receive:s',function(loc,pass)
    local src = source 
    local location = loc
    local password = pass
    local _id = Wrapper:Identifiers(src)
    local id = string.gsub(_id.steam,'steam:','bbv-') or 'NO STEAM FOUND'
    if Config.Settings.Inventory == "OX" then 
        TriggerClientEvent('ox_inventory:openInventory', src, 'stash', location..id..password)
    end
    if Config.Settings.Inventory == "QB" then 
       TriggerClientEvent('bbv-mail:qb:stash:receive',src,location..id..password)
    end
end)

RegisterNetEvent('bbv-mail:charge',function(a,b,c,d)
    -- REMOVED FOR BETTER FRAMEWORK SUPPORT, Is anyone wants he can enable it himself

    -- local src = source 
    -- local Player = QBCore.Functions.GetPlayer(src)
    -- local cash = Player.PlayerData.money.cash
    -- if cash > Config.Settings.SendPrice then 
    --     Player.Functions.RemoveMoney('cash', Config.Settings.SendPrice) 
        TriggerClientEvent('bbv-mail:charge:c',src,a,b,c,d)
    -- else
    --     TriggerClientEvent('QBCore:Notify', src, 'You dont have enough cash on you.', 'error', 3500)
    -- end
end)

RegisterNetEvent('bbv-loadnumber:s',function()
    local src = source
    local _id = Wrapper:Identifiers(src)
    local id = string.gsub(_id.steam,'steam:','bbv-') or 'NO STEAM FOUND'

    TriggerClientEvent('bbv-loadnumber:c',src,id)
end)