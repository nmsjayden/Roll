local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Custom GUI",
    SubTitle = "QuickRoll Integration",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

-- QuickRoll toggle functionality
local QuickRollEnabled = false
local function toggleQuickRoll()
    QuickRollEnabled = not QuickRollEnabled
    if QuickRollEnabled then
        print("QuickRoll Enabled")
        -- Add your QuickRoll logic here, e.g., rolling logic
    else
        print("QuickRoll Disabled")
    end
end

Tabs.Main:AddToggle("QuickRollToggle", {
    Title = "QuickRoll",
    Default = false,
    Callback = function(Value)
        toggleQuickRoll()
    end
})

-- Example button to trigger a QuickRoll action
Tabs.Main:AddButton({
    Title = "Roll Now",
    Description = "Perform a QuickRoll.",
    Callback = function()
        if QuickRollEnabled then
            print("Rolling...")
            -- Execute rolling logic here
        else
            print("QuickRoll is disabled.")
        end
    end
})

-- Add other GUI features from your original script
Tabs.Main:AddSlider("QuickRollDelay", {
    Title = "QuickRoll Delay",
    Description = "Set the delay between rolls.",
    Default = 2,
    Min = 0.5,
    Max = 5,
    Rounding = 1,
    Callback = function(Value)
        print("QuickRoll Delay set to:", Value)
        -- Update delay logic here
    end
})

-- Example input for roll customization
Tabs.Main:AddInput("RollMultiplier", {
    Title = "Multiplier",
    Placeholder = "Enter multiplier...",
    Numeric = true,
    Callback = function(Value)
        print("Multiplier set to:", Value)
        -- Use the multiplier value here
    end
})

-- Addons
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("CustomScriptHub")
SaveManager:SetFolder("CustomScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

Fluent:Notify({
    Title = "Custom GUI",
    Content = "The script has been loaded.",
    Duration = 8
})

-- Automatically load config if available
SaveManager:LoadAutoloadConfig()
