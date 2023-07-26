Config = {}
Config.Debug = true

QBCore = exports['qb-core']:GetCoreObject()

Config.Settings = {
    Framework = 'QB', 
    Target = "OX", -- OX/QB/BT
    Inventory = 'OX', -- QB/OX
    Menu = 'OX', -- QB/OX
    SendPrice = 250,
    PostSize = 25000,
    PostSlots = 10,
}

Config.Posts = {
    LosSantos = {
        Name = 'LSantos',
        Prop = 'bzzz_prop_shop_locker',
        Pos = vector4(75.91, 119.34, 79.18 - 1, 160.0),
        Target = vector3(75.95, 119.31, 79.45 + 0.95),
    },
    PlaetoBay = {
        Name = 'Paleto',
        Prop = 'bzzz_prop_shop_locker',
        Pos = vector4(203.16, 6619.75, 31.58  - 1, 180.0),
        Target = vector3(203.03, 6619.71, 31.91 + 0.95),
    },
    SandyShores = {
        Name = 'Sandy',
        Prop = 'bzzz_prop_shop_locker',
        Pos = vector4(1768.42, 3651.07, 34.45  - 1, 30.0),
        Target = vector3(1768.42, 3651.07, 34.45 + 1.15),
    }
}