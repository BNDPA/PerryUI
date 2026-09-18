-- 1. Load the library
local PerryUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/BNDPA/PerryUI/main/Beta.lua"))()

-- 2. Define title and subtitle
local Window = PerryUI.CreateWindow("My Custom Script", "by ScriptDeveloper")

-- 3. Create tabs
local MainTab = Window:CreateTab("Main")
local SettingsTab = Window:CreateTab("Settings")

-- 4. Add a toggle switch
MainTab:AddToggle("God Mode", "Makes character invulnerable", false, function(state)
    print("God Mode State:", state)
end)

-- 5. Add a single-click button
MainTab:AddButton("Rejoin Server", "Rejoins the current server instance", function()
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId)
end)

-- 6. Add a button triggering a notification (Notice)
SettingsTab:AddButton("Show Info", "Displays script details", function()
    PerryUI:Notify("Information", "Script loaded and ready to use!", 3)
end)
