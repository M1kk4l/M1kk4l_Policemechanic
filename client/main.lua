local open = true

Citizen.CreateThread(function()
    SetDisplay(false)
    while true do
        sleeptimer = 500
        if IsPedInAnyVehicle(PlayerPedId(), true) then
            for k,v in pairs(cfg.location) do
                local dist = #(GetEntityCoords(PlayerPedId())-vector3(v[1],v[2],v[3]))
                if dist < 13 then
                    sleeptimer = 0 
                    DrawMarker(27, vector3(v[1], v[2], v[3]-0.89), 0, 0, 0, 0, 0, 0, 2.0001, 2.0001, 0.801, 26, 121, 217,255, 0, 0, 0, 1)
                    if dist < 2 and open == true then
                        sleeptimer = 0
                        SetTextComponentFormat("STRING")
                        AddTextComponentString("Tryk ~INPUT_CONTEXT~ for at åbne Mekanikeren.")
                        DisplayHelpTextFromStringLabel(0, 0, 1, -1)
                        if IsControlJustPressed(1,38) then
                            TriggerServerCallback('test', function(bool)
                                if bool then
                                    SetDisplay(true)
                                    open = false
                                end
                            end, 'hey')
                        end
                    end
                end
            end
        end
        Citizen.Wait(sleeptimer)
    end
end)

RegisterNUICallback("close", function(data)
    print('hello2')
    SetDisplay(false)
    open = true
end)

RegisterNUICallback("colorDone", function(data)
    SetDisplay(false)
    open = true
end)

RegisterNUICallback("Repair", function(data)
    SetDisplay(false)
    RepairVeh()
end)

RegisterNUICallback("Wash", function(data)
    for k,v in pairs(cfg.location) do   
        local dist = #(GetEntityCoords(PlayerPedId())-vector3(v[1],v[2],v[3]))
        if dist < 13 then
            SetDisplay(false)
            WashVeh(v[1],v[2],v[3])
        end
    end
end)

RegisterNUICallback("primaryColor", function(data)
    vehicle = GetVehiclePedIsIn(PlayerPedId())
    SetVehicleCustomPrimaryColour(vehicle, tonumber(data.rgb[1]), tonumber(data.rgb[2]), tonumber(data.rgb[3]))
end)
  
RegisterNUICallback("SecondaryColor", function(data)
    vehicle = GetVehiclePedIsIn(PlayerPedId())
    SetVehicleCustomSecondaryColour(vehicle, tonumber(data.rgb[1]), tonumber(data.rgb[2]), tonumber(data.rgb[3]))
end)

function SetDisplay(bool)
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "container",
        status = bool,
        resource = GetCurrentResourceName(),
    })
end

function RepairVeh()
    vehicle = GetVehiclePedIsIn(PlayerPedId())
---------------------------------------------------------------------------------------------
    exports['progressBars']:startUI(10000, "Reparerer køretøj...") -- ÆNDRE DETTE HVIS DET IKKE ER DEN RIGTIGE PROGRESSBAR
    ---------------------------------------------------------------------------------------------
    SetVehicleDoorOpen(vehicle, 4, false)
    FreezeEntityPosition(vehicle, true)

    Wait(10000)

    SetVehicleDoorOpen(vehicle, 4, false)
    FreezeEntityPosition(vehicle, false)
    SetVehicleEngineHealth(GetVehiclePedIsIn(PlayerPedId()), 9999)
    SetVehiclePetrolTankHealth(GetVehiclePedIsIn(PlayerPedId()), 9999)
    SetVehicleFixed(GetVehiclePedIsIn(PlayerPedId()))

    TriggerEvent("pNotify:SendNotification",{text = "Køretøj er blevet fikset!",type = "success",timeout = (5000),layout = "centerRight",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    open = true
end

function WashVeh(x,y,z)
---------------------------------------------------------------------------------------------
    exports['progressBars']:startUI(10000, "Vasker køretøj...") -- ÆNDRE DETTE HVIS DET IKKE ER DEN RIGTIGE PROGRESSBAR
---------------------------------------------------------------------------------------------

    FreezeEntityPosition(GetVehiclePedIsIn(PlayerPedId()), true)

    UseParticleFxAssetNextCall("core")
    particles  = StartParticleFxLoopedAtCoord("ent_amb_waterfall_splash_p", x,y,z, 0.0, 0.0, 0.0, 0.5, false, false, false, false)


    Wait(10000)

    StopParticleFxLooped(particles, 0)

    FreezeEntityPosition(GetVehiclePedIsIn(PlayerPedId()), false)

    local dirt = GetVehicleDirtLevel(GetVehiclePedIsIn(PlayerPedId()))

    SetVehicleDirtLevel(GetVehiclePedIsIn(PlayerPedId()), 0.0)
    SetVehicleUndriveable(GetVehiclePedIsIn(PlayerPedId()), false)

    TriggerEvent("pNotify:SendNotification",{text = "Køretøj er blevet gjort helt rent!",type = "success",timeout = (5000),layout = "centerRight",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})

    open = true
end