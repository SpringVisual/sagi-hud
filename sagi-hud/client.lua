local QBCore = nil
local useStandalone = Config.useStandalone
local useQBCore = Config.useQBCore

if useQBCore then
    QBCore = exports['qb-core']:GetCoreObject()
end

local playerStats = {
    health = 100,
    armor = 0,
    hunger = 100,
    thirst = 100
}

local function debugConfig()
    if Config.EnableDebug then
        print("Config Debug:")
        print("Use Standalone: " .. tostring(useStandalone))
        print("Use QBCore: " .. tostring(useQBCore))
        print("Show Health Bar: " .. tostring(Config.ShowHealthBar))
        print("Show Armor Bar: " .. tostring(Config.ShowArmorBar))
        print("Show Hunger Bar: " .. tostring(Config.ShowHungerBar))
        print("Show Thirst Bar: " .. tostring(Config.ShowThirstBar))
        print("Hunger Decrease Rate: " .. tostring(Config.HungerDecreaseRate))
        print("Thirst Decrease Rate: " .. tostring(Config.ThirstDecreaseRate))
    end
end

local function updateHUD()
    SendNUIMessage({
        action = "updateHUD",
        health = Config.ShowHealthBar and playerStats.health or nil,
        armor = Config.ShowArmorBar and playerStats.armor or nil,
        hunger = Config.ShowHungerBar and playerStats.hunger or nil,
        thirst = Config.ShowThirstBar and playerStats.thirst or nil
    })
end

CreateThread(function()
    while true do
        local ped = PlayerPedId()
        if Config.ShowHealthBar then
            playerStats.health = (GetEntityHealth(ped) - 100) / (GetEntityMaxHealth(ped) - 100) * 100
            playerStats.health = math.max(0, math.min(100, playerStats.health))
        end
        if Config.ShowArmorBar then
            playerStats.armor = GetPedArmour(ped)
        end
        if useQBCore then
            if Config.ShowHungerBar then
                playerStats.hunger = QBCore.Functions.GetPlayerData().metadata.hunger or 0
            end
            if Config.ShowThirstBar then
                playerStats.thirst = QBCore.Functions.GetPlayerData().metadata.thirst or 0
            end
        elseif useStandalone then
            if Config.ShowHungerBar and playerStats.hunger > 0 then
                playerStats.hunger = playerStats.hunger - Config.HungerDecreaseRate
            end
            if Config.ShowThirstBar and playerStats.thirst > 0 then
                playerStats.thirst = playerStats.thirst - Config.ThirstDecreaseRate
            end
        end
        updateHUD()
        debugConfig()
        Wait(1000)
    end
end)

function SetHealthAmount(amount)
    BeginScaleformMovieMethod(getMinimap(), "SET_PLAYER_HEALTH")
    ScaleformMovieMethodAddParamInt(amount)
    ScaleformMovieMethodAddParamFloat(0)
    ScaleformMovieMethodAddParamFloat(2000)
    ScaleformMovieMethodAddParamBool(false)
    EndScaleformMovieMethod()
end

function SetArmorAmount(amount)
    BeginScaleformMovieMethod(getMinimap(), "SET_PLAYER_ARMOUR")
    ScaleformMovieMethodAddParamInt(amount)
    ScaleformMovieMethodAddParamFloat(0)
    ScaleformMovieMethodAddParamFloat(2000)
    EndScaleformMovieMethod()
end

function ShowMinimap()
    local minimap = RequestScaleformMovie("minimap")
    SetRadarBigmapEnabled(true, false)
    Wait(0)
    SetRadarBigmapEnabled(false, false)
end