---@diagnostic disable: trailing-space
local loopType = nil

-- Functions

---@param shadow boolean
---@param air boolean
local function setShadowAndAir(shadow, air)
    RopeDrawShadowEnabled(shadow)
    CascadeShadowsClearShadowSampleType()
    CascadeShadowsSetAircraftMode(air)
end

---@param entity boolean
---@param dynamic boolean
---@param tracker number
---@param depth number
---@param bounds number
local function setEntityTracker(entity, dynamic, tracker, depth, bounds)
    CascadeShadowsEnableEntityTracker(entity)
    CascadeShadowsSetDynamicDepthMode(dynamic)
    CascadeShadowsSetEntityTrackerScale(tracker)
    CascadeShadowsSetDynamicDepthValue(depth)
    CascadeShadowsSetCascadeBoundsScale(bounds)
end

---@param distance number
---@param tweak number
local function setLights(distance, tweak)
    SetFlashLightFadeDistance(distance)
    SetLightsCutoffDistanceTweak(tweak)
end

---@param notify string
local function notify(message)
    print(message)
end

---@param type string
local function umfpsBooster(type)
    if type == "reset" then
        setShadowAndAir(true, true)
        setEntityTracker(true, true, 5.0, 5.0, 5.0)
        setLights(10.0, 10.0)
        notify("Mode: Reset")
    elseif type == "ulow" then
        setShadowAndAir(false, false)
        setEntityTracker(true, false, 0.0, 0.0, 0.0)
        setLights(0.0, 0.0)
        notify("Mode: Ultra Low")
    elseif type == "low" then
        setShadowAndAir(false, false)
        setEntityTracker(true, false, 0.0, 0.0, 0.0)
        setLights(5.0, 5.0)
        notify("Mode: Low")
    elseif type == "medium" then
        setShadowAndAir(true, false)
        setEntityTracker(true, false, 5.0, 3.0, 3.0)
        setLights(3.0, 3.0)
        notify("Mode: Medium")
    else
        notify("Usage: /fps [reset/ulow/low/medium]")
        notify("Invalid type: " .. type)
        return
    end
    loopType = type
end

-- Commands

RegisterCommand("fps", function(_, args)
    if args[1] == nil then
        notify("Usage: /fps [reset/ulow/low/medium]")
        return
    end
    umfpsBooster(args[1])
end, false)

-- Main Loop

-- // Distance rendering and entity handler (need a revision)
CreateThread(function()
    while true do
        if loopType == "ulow" then
            --// Find closest ped and set the alpha
            for _, ped in ipairs(GetGamePool('CPed')) do
                if not IsEntityOnScreen(ped) then
                    SetEntityAlpha(ped, 0)
                else
                    if GetEntityAlpha(ped) == 0 then
                        SetEntityAlpha(ped, 255)
                    elseif GetEntityAlpha(ped) ~= 210 then
                        SetEntityAlpha(ped, 210)
                    end
                end
                SetPedAoBlobRendering(ped, false)
                Wait(1)
            end
            --// Find closest object and set the alpha
            for _, obj in ipairs(GetGamePool('CObject')) do
                if not IsEntityOnScreen(obj) then
                    SetEntityAlpha(obj, 0)
                    SetEntityAsNoLongerNeeded(obj)
                else
                    if GetEntityAlpha(obj) == 0 then
                        SetEntityAlpha(obj, 255)
                    elseif GetEntityAlpha(obj) ~= 170 then
                        SetEntityAlpha(obj, 170)
                    end
                end
                Wait(1)
            end
            DisableOcclusionThisFrame()
            SetDisableDecalRenderingThisFrame()
            RemoveParticleFxInRange(GetEntityCoords(PlayerPedId()), 10.0)
        elseif loopType == "low" then
            --// Find closest ped and set the alpha
            for _, ped in ipairs(GetGamePool('CPed')) do
                if not IsEntityOnScreen(ped) then
                    SetEntityAlpha(ped, 0)
                else
                    if GetEntityAlpha(ped) == 0 then
                        SetEntityAlpha(ped, 255)
                    elseif GetEntityAlpha(ped) ~= 210 then
                        SetEntityAlpha(ped, 210)
                    end
                end
                SetPedAoBlobRendering(ped, false)
                Wait(1)
            end
            --// Find closest object and set the alpha
            for _, obj in ipairs(GetGamePool('CObject')) do
                if not IsEntityOnScreen(obj) then
                    SetEntityAlpha(obj, 0)
                    SetEntityAsNoLongerNeeded(obj)
                else
                    if GetEntityAlpha(obj) == 0 then
                        SetEntityAlpha(obj, 255)
                    elseif GetEntityAlpha(ped) ~= 210 then
                        SetEntityAlpha(ped, 210)
                    end
                end
                Wait(1)
            end
            SetDisableDecalRenderingThisFrame()
            RemoveParticleFxInRange(GetEntityCoords(PlayerPedId()), 10.0)
        elseif loopType == "medium" then
            --// Find closest ped and set the alpha
            for _, ped in ipairs(GetGamePool('CPed')) do
                if not IsEntityOnScreen(ped) then
                    SetEntityAlpha(ped, 0)
                else
                    if GetEntityAlpha(ped) == 0 then
                        SetEntityAlpha(ped, 255)
                    end
                end
                SetPedAoBlobRendering(ped, false)
                Wait(1)
            end
            --// Find closest object and set the alpha
            for _, obj in ipairs(GetGamePool('CObject')) do
                if not IsEntityOnScreen(obj) then
                    SetEntityAlpha(obj, 0)
                    SetEntityAsNoLongerNeeded(obj)
                else
                    if GetEntityAlpha(obj) == 0 then
                        SetEntityAlpha(obj, 255)
                    end
                end
                Wait(1)
            end
        else
            Wait(500)
        end
        Wait(8)
    end
end)

--// Clear broken thing, disable rain, disable wind and other tiny thing that dont require the frame tick
CreateThread(function()
    while true do
        if loopType == "ulow" or loopType == "low" then
            local ped = PlayerPedId()

            ClearAllBrokenGlass()
            ClearAllHelpMessages()
            LeaderboardsReadClearAll()
            ClearBrief()
            ClearGpsFlags()
            ClearPrints()
            ClearSmallPrints()
            ClearReplayStats()
            LeaderboardsClearCacheData()
            ClearFocus()
            ClearPedBloodDamage(ped)
            ClearPedWetness(ped)
            ClearPedEnvDirt(ped)
            ResetPedVisibleDamage(ped)
            ClearExtraTimecycleModifier()
            ClearTimecycleModifier()
            ClearOverrideWeather()
            ClearHdArea()
            DisableVehicleDistantlights(false)
            DisableScreenblurFade()
            SetRainLevel(0.0)
            SetWindSpeed(0.0)
            Wait(300)
        elseif loopType == "medium" then
            ClearAllBrokenGlass()
            ClearAllHelpMessages()
            LeaderboardsReadClearAll()
            ClearBrief()
            ClearGpsFlags()
            ClearPrints()
            ClearSmallPrints()
            ClearReplayStats()
            LeaderboardsClearCacheData()
            ClearFocus()
            ClearHdArea()
            SetWindSpeed(0.0)
            Wait(1000)
        else
            Wait(1500)
        end
    end
end)
