local resourcename = GetCurrentResourceName()

CreateThread(function()
    Wait(1000)
    for k,v in pairs(Config.Posts) do
        Wrapper:CreateObject(resourcename..k,v.Prop,v.Pos,false,true)
        Wrapper:Target(resourcename..k,'Open',v.Target,'bbv-mail:open'..v.Name)
        Wrapper:Blip(resourcename..k,'Postal',v.Pos,525,5,0.6)
        RegisterNetEvent('bbv-mail:open'..v.Name,function()
          local currpos = v.Name
          if Config.Settings.Menu == "OX" then 
              exports['ox_lib']:registerContext({
                  id = 'mail-menu',
                  title = 'Postal',
                  menu = 'mail-menu',
                  options = {
                    {
                      title = 'Send Mail',
                      description = 'Price : ' ..Config.Settings.SendPrice.. '$',
                      event = 'bbv-mail:send',
                    },
                    {
                      title = 'Receive Mail',
                      description = 'Price : FREE',
                      event = 'bbv-mail:receive',
                      args = {
                        location = currpos,
                      }
                    }
                  }
                })
               exports['ox_lib']:showContext('mail-menu')
          end
          if Config.Settings.Menu == "QB" then 
            exports['qb-menu']:openMenu({
              {
                  header = "Postal",
                  isMenuHeader = true,  
              },
              {
                header = 'Send Mail',
                txt = 'Price : ' ..Config.Settings.SendPrice.. '$',
                params = {
                  event = 'bbv-mail:send',
                }
              },
              {
                header = 'Receive Mail',
                txt = 'Price : FREE',
                params = {
                  event = 'bbv-mail:receive',
                  args = {
                    location = currpos
                 }
                }
              },
          })
          end
        end)
    end
end)

RegisterNetEvent('bbv-mail:receive',function(data)
    local location = data.location 
    if Config.Settings.Menu == "OX" then 
      local input = exports['ox_lib']:inputDialog('Postal Menu', {'Password'})
 
      if not input then return end
      TriggerServerEvent('bbv-mail:receive:s',location,input[1])
    end
    if Config.Settings.Menu == "QB" then 
    local dialog = exports['qb-input']:ShowInput({
        header = "Postal",
        submitText = "Receive Mail",
        inputs = {
            {
                text = "Secret Code",
                name = "code", 
                type = "password",
                isRequired = true, 
            },
        },
    })
    TriggerServerEvent('bbv-mail:receive:s',location,dialog.code)
    end
end)


RegisterNetEvent('bbv-mail:send',function()
    if Config.Settings.Menu == "OX" then 
        exports['ox_lib']:registerContext({
            id = 'mail-menu',
            title = 'Location',
            description = 'Select a location where you want to send the package to',
            menu = 'mail-menu',
            options = {
              {
                title = 'Los Santos',
                event = 'bbv-mail:send:open',
                args = {
                    location = 'LSantos'
                 }
              },
              {
                title = 'Paleto Bay',
                event = 'bbv-mail:send:open',
                args = {
                    location = 'Paleto'
                  }
              },
              {
                title = 'Sandy Shores',
                event = 'bbv-mail:send:open',
                args = {
                    location = 'Sandy'
                  }
              }
            }
          })
         exports['ox_lib']:showContext('mail-menu')
    end
    if Config.Settings.Menu == "QB" then 
      exports['qb-menu']:openMenu({
        {
            header = "Location",
            isMenuHeader = true,
        },
        {
          header = 'Los Santos',
          params = {
            event = 'bbv-mail:send:open',
            args = {
                location = 'LSantos'
              }
          }
        },
        {
          header = 'Paleto Bay',
          params = {
            event = 'bbv-mail:send:open',
            args = {
                location = 'Paleto'
              }
          }
        },
        {
          header = 'Sandy Shores',
          params = {
            event = 'bbv-mail:send:open',
            args = {
                location = 'Sandy'
              }
          }
        },
    })
    end
end)

RegisterNetEvent('bbv-mail:send:open',function(data) 
    local location = data.location

    if Config.Settings.Menu == "OX" then 
      local input = exports['ox_lib']:inputDialog('Postal Menu', {'CitizenID', 'Password'})
 
      if not input then return end 
      TriggerServerEvent('bbv-mail:charge',location..input[1]..input[2],location,Config.Settings.PostSize,Config.Settings.PostSlots)
    end
    if Config.Settings.Menu == "QB" then 
      local dialog = exports['qb-input']:ShowInput({
          header = "Test",
          submitText = "Bill",
          inputs = {
              {
                  text = "Citizen ID (#)",
                  name = "citizenid", 
                  type = "text",
                  isRequired = true, 
              },
              {
                  text = "Secret Code ",
                  name = "code", 
                  type = "password",
                  isRequired = true, 
              },
          },
      })
      TriggerServerEvent('bbv-mail:charge',location..dialog.citizenid..dialog.code,location,Config.Settings.PostSize,Config.Settings.PostSlots)
      end
end)

RegisterNetEvent('bbv-mail:charge:c',function(a,b,c,d)
  if Config.Settings.Framework == "OX" then 
    Wrapper:Stash(a,b,c,d)
  end
  if Config.Settings.Framework == "QB" then 
    Wrapper:Stash(a,a,Config.Settings.PostSize,Config.Settings.PostSlots)
  end
end)

RegisterNetEvent('bbv-mail:qb:stash:receive',function(a)
  TriggerServerEvent("inventory:server:OpenInventory", "stash", a, {maxweight = Config.Settings.PostSize, slots = Config.Settings.PostSlots})
  TriggerEvent("inventory:client:SetCurrentStash", a)
end)