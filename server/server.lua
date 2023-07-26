RegisterNetEvent('bbv-mail:receive:s',function(loc,pass)
    local src = source 
    local location = loc
    local password = pass
    local Player = QBCore.Functions.GetPlayer(source)
    local citizenid = Player.PlayerData.citizenid
    if Config.Settings.Inventory == "OX" then 
        TriggerClientEvent('ox_inventory:openInventory', src, 'stash', location..citizenid..password)
    end
    if Config.Settings.Inventory == "QB" then 
       TriggerClientEvent('bbv-mail:qb:stash:receive',src,location..citizenid..password)
    end
end)

RegisterNetEvent('bbv-mail:charge',function(a,b,c,d)
    local src = source 
    local Player = QBCore.Functions.GetPlayer(src)
    local cash = Player.PlayerData.money.cash
    if cash > Config.Settings.SendPrice then 
        Player.Functions.RemoveMoney('cash', Config.Settings.SendPrice) 
        TriggerClientEvent('bbv-mail:charge:c',src,a,b,c,d)
    else
        TriggerClientEvent('QBCore:Notify', src, 'You dont have enough cash on you.', 'error', 3500)
    end
end)