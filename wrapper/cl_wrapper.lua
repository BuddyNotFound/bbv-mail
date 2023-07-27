
  
Wrapper = {
    blip = {},
    cam = {},
    zone = {},
    cars = {},
    object = {}
}

function Wrapper:CreateObject(id,prop,coords,network,misson) -- Create object / prop
    RequestModel(prop)
    while not HasModelLoaded(prop) do
      Wait(0)
    end
    Wrapper.object[id] = CreateObject(GetHashKey(prop), coords , network or false,misson or false)
    PlaceObjectOnGroundProperly(Wrapper.object[id])
    SetEntityHeading(Wrapper.object[id], coords.w)
    FreezeEntityPosition(Wrapper.object[id], true)
    SetEntityAsMissionEntity(Wrapper.object[id], true, true)
end

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    TriggerEvent('Wrapper:Reset')
end)
  

RegisterNetEvent('Wrapper:Reset',function()
    for k,v in pairs(Wrapper.object) do 
        DeleteObject(v)
    end
    for k,v in pairs(Wrapper.blip) do
        RemoveBlip(v)
    end
end)

function Wrapper:DeleteObject(id)
    DeleteObject(Wrapper.object[id])
end

function Wrapper:LoadModel(model) -- Load Model
    local modelHash = model
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
      Wait(0)
    end
end
local sleep = 2000

function Wrapper:Target(id,label,pos,event,type) -- QBTarget target create
    if Config.Settings.Target == "QB" then 
        local sizex = 1
        local sizey = 1
        exports["qb-target"]:AddBoxZone(id, pos, sizex, sizey, {
            name = id,
            heading = '90.0',
            minZ = pos - 5,
            maxZ = pos + 5
        }, {
            options = {
                {
                    type = "client",
                    event = event,
                    icon = "fas fa-button",
                    label = label,
                }
            },
            distance = 1.5
        })
    end
    if Config.Settings.Target == "OX" then
        Wrapper.zone[id] = exports["ox_target"]:addBoxZone({ -- -1183.28, -884.06, 13.75
        coords = vec3(pos.x,pos.y,pos.z - 1),
        size = vec3(1, 1, 1),
        rotation = 45,
        debug = false,
        options = {
            {
                name = id,
                event = event,
                icon = 'fa-solid fa-cube',
                label = label,
            },
        }
    })
    end
    if Config.Settings.Target == "BT" then 
        local _id = id
        exports['bt-target']:AddBoxZone(_id, vector3(pos.x,pos.y,pos.z), 0.4, 0.6, {
            name=_id,
            heading=91,
            minZ = pos.z - 1,
            maxZ = pos.z + 1
            }, {
                options = {
                    {
                        type = "client",
                        event = event,
                        icon = 'fa-solid fa-cube',
                        label = label,
                    },
                },
                distance = 1.5
            })
    end
    if Config.Settings.Target == "ST" then 
        TriggerEvent('Wrapper:St:Target',pos,event)
    end
end

function Wrapper:TargetRemove(sendid) -- Remove QBTarget target
    if Config.Settings.Target == "QB" then 
        exports["qb-target"]:RemoveZone(sendid)
    end 
    if Config.Settings.Target == "OX" then 
        exports['ox_target']:removeZone(Wrapper.zone[sendid])
    end
    if Config.Settings.Target == "BT" then 
        exports['bt-taget']:RemoveZone(sendid)
    end
    return
end

function Wrapper:Blip(id,label,pos,sprite,color,scale) -- Create Normal Blip on Map
    Wrapper.blip[id] = AddBlipForCoord(pos.x, pos.y, pos.z)
    SetBlipSprite (Wrapper.blip[id], sprite)
    SetBlipDisplay(Wrapper.blip[id], 4)
    SetBlipScale  (Wrapper.blip[id], scale)
    SetBlipAsShortRange(Wrapper.blip[id], true)
    SetBlipColour(Wrapper.blip[id], color)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(label)
    EndTextCommandSetBlipName(Wrapper.blip[id])
    return
end

function Wrapper:RemoveBlip(id)
    RemoveBlip(Wrapper.blip[id])
end

function Wrapper:Stash(id,label,weight,slots) -- Create and Open a stash in qb-inventory
    if Config.Settings.Inventory == 'QB' then 
    TriggerEvent("inventory:client:SetCurrentStash", label)
    TriggerServerEvent("inventory:server:OpenInventory", "stash", label, {
        maxweight = weight,
        slots = slots,
    })
    end
    if Config.Settings.Inventory == "OX" then 
        TriggerServerEvent('Wrapper:Inventory:Stash:Ox',id,label,weight,slots)
        Wait(500)
        TriggerServerEvent('Wrapper:Inventory:Stash:Ox:Open',id)
    end
    if Config.Settings.Inventory == "QS" then 
        TriggerServerEvent('Wrapper:Inventory:Stash:QS',label)
        Wait(500)
        local other = {}
        other.maxweight = 10000 -- Custom weight statsh.
        other.slots = 50 -- Custom slots spaces.
        TriggerServerEvent("inventory:server:OpenInventory", "stash", label, other)
        TriggerEvent("inventory:client:SetCurrentStash", label)
    end
end

function Wrapper:Notify(txt,tp,time) -- QBCore notify
    if Config.Settings.Framework == "QB" then 
    QBCore.Functions.Notify(txt, tp, time)
    end
    if Config.Settings.Framework == "ESX" then 
        ESX.ShowNotification(txt)
    end
end

function Wrapper:Bill(playerId, amount) -- QBCore bill player, YOU (your job) Bills => Player and amount (player,amount)
    TriggerServerEvent('Wrapper:Bill',playerId, amount)
end

function Wrapper:AddItem(item,amount) -- AddItem to me (Like give item) very unsafe use only in dev build.
    if Config.Settings.ReturnItem then 
        TriggerServerEvent('Wrapper2:AddItem',item,amount)
    end
end

function Wrapper:RemoveItem(item,amount)
    if Config.Settings.ReturnItem then 
        TriggerServerEvent('Wrapper2:RemoveItem', item, amount)
    end
end

function Wrapper:AddMoney(type,amount) -- AddItem to me (Like give item) very unsafe use only in dev build.
    TriggerServerEvent('Wrapper:AddMoney',type,amount)
end

function Wrapper:Craft(txt,time) -- Not Done
    QBCore.Functions.Progressbar("pickup_sla", txt, time, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "mp_common",
        anim = "givetake1_a",
        flags = 8,
    }, {}, {}, function() -- Done

    end, function()
        QBCore.Functions.Notify("Cancelled..", "error")
    end)
end

function Wrapper:Cam(id,trans) -- Create and render a camera :)
    Wrapper.cam[id] = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    RenderScriptCams(true, 1, trans or 1500,  true,  true)
    self.processCamera(Wrapper.cam[id])
end

function Wrapper:CamDestory(id,trans) -- KILL THE CAMERA !!!!
    activated = false
    RenderScriptCams(false, 1, trans or 1500,  true,  true)
    DestroyCam(Wrapper.cam[id], false)
end

function Wrapper:processCamera(id) -- process the camera :)
    local rotx, roty, rotz = table.unpack(GetEntityRotation(PlayerPedId()))
	local camX, camY, camZ = table.unpack(GetGameplayCamCoord())
	local camRX, camRY, camRZ = GetGameplayCamRelativePitch(), 0.0, GetGameplayCamRelativeHeading()
	local camF = GetGameplayCamFov()
	local camRZ = (rotz+camRZ)
	
	SetCamCoord(Wrapper.cam[id], camX, camY, camZ)
	SetCamRot(Wrapper.cam[id], camRX, camRY, camRZ)
	SetCamFov(Wrapper.cam[id], camF - 120) 
end

function Wrapper:Log(webhook,txt) -- Log all of your abusive staff
    TriggerServerEvent('Wrapper:Log',webhook,txt)
end

function Wrapper:Tp(_coords,fancy,ped) -- Teleport to coords, very fancy, very pretty
    local ped = _ped or PlayerPedId()
    local coords = _coords
    if coords == nil then 
        QBCore.Functions.Notify("Wrapper: Нямаш coords бай хуй", 'error', 2500)
        return
    end
    if fancy then 
        DoScreenFadeOut(1000)
        Wait(1000)
        DoScreenFadeIn(1000)
    end
    SetEntityCoords(ped,coords)
end

function Wrapper:AlertPolice()
-- // insert custom police alert command here

end

function Wrapper:SpawnVehicle(id,model,pos,heading)
    self:LoadModel(model)
    self.cars[id] = CreateVehicle(model, pos.x, pos.y, pos.z, pos.w, true)
    local netid = NetworkGetNetworkIdFromEntity(self.cars[id])
    SetVehicleHasBeenOwnedByPlayer(self.cars[id], true)
    SetNetworkIdCanMigrate(netid, true)
    SetVehicleNeedsToBeHotwired(self.cars[id], false)
    SetVehRadioStation(self.cars[id], 'OFF')
    SetModelAsNoLongerNeeded(model)
    TriggerEvent('qb-vehiclekeys:client:GiveKeys',GetVehicleNumberPlateTextIndex(self.cars[id]))
    return self.cars[id]
end

function Wrapper:DeleteVehicle(id)
    DeleteVehicle(self.cars[id])
end

function Wrapper:Warp(warp,seat)
    local ped = PlayerPedId()
    TaskWarpPedIntoVehicle(ped, self.cars[warp], seat)
end

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    for k,v in pairs(Wrapper.cars) do 
        DeleteVehicle(v)
    end
end)

function Wrapper:QBPlate(id)
    local plate = QBCore.Functions.GetPlate(self.cars[id])
    return plate
end

function Wrapper:QBPlateST(id)
    local plate = QBCore.Functions.GetPlate(id)
    return plate
end

function Wrapper:Prompt(msg) --Msg is part of the Text String at B
	SetNotificationTextEntry('STRING')
	AddTextComponentString(msg) -- B
	DrawNotification(true, false) -- Look on that website for what these mean, I forget. I think one is about flashing or not
end


-- THIS SCRIPT ONLY

function Wrapper:Target2(id,label,label2,pos,event,event2,type) -- QBTarget target create
    if Config.Settings.Target == "QB" then 
        local sizex = 1
        local sizey = 1
        exports["qb-target"]:AddBoxZone(id, pos, sizex, sizey, {
            name = id,
            heading = '90.0',
            minZ = pos - 5,
            maxZ = pos + 5
        }, {
            options = {
                {
                    type = "client",
                    event = event,
                    icon = "fas fa-button",
                    label = label,
                },
                {
                    type = "client",
                    event = event2,
                    icon = "fas fa-button",
                    label = label2,
                }
            },
            distance = 1.5
        })
    end
    if Config.Settings.Target == "OX" then 
        Wrapper.zone[id] = exports["ox_target"]:addBoxZone({ -- -1183.28, -884.06, 13.75
        coords = vec3(pos.x,pos.y,pos.z - 1),
        size = vec3(1, 1, 1),
        rotation = 45,
        debug = false,
        options = {
            {
                name = id,
                event = event,
                icon = 'fa-solid fa-cube',
                label = label,
            },
            {
                name = 'asda',
                event = event2,
                icon = 'fa-solid fa-cube',
                label = label2,
            },
        }
    })
    end
    if Config.Settings.Target == "BT" then 
        local _id = id
        exports['bt-target']:AddBoxZone(_id, vector3(pos.x,pos.y,pos.z), 0.4, 0.6, {
            name=_id,
            heading=91,
            minZ = pos.z - 1,
            maxZ = pos.z + 1
            }, {
                options = {
                    {
                        type = "client",
                        event = event,
                        icon = 'fa-solid fa-cube',
                        label = label,
                    },
                    {
                        type = "client",
                        event = event2,
                        icon = "fas fa-button",
                        label = label2,
                    }
                },
                distance = 1.5
            })
    end
end

RegisterNetEvent('Wrapper:St:Target',function(pos,event)
    while true do
        Wait(sleep)
        local pdist = GetEntityCoords(PlayerPedId())
        local ft = vec3(pos.x,pos.y,pos.z - 1)
        local dist = #(pdist - ft)
        if dist < 3 then 
            sleep = 0
            Wrapper:DrawText(ft.x,ft.y,ft.z,0.4,'[E] OPEN')
            if IsControlPressed(0,38) then 
                TriggerEvent(event)
            end
        else
            sleep = 2000
        end
    end
end)

function Wrapper:DrawText(x, y, z, scl_factor, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov * scl_factor
    if onScreen then
        SetTextScale(0.0, scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end