local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
assert(Fluent, "Failed to load Fluent library!")

local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
assert(SaveManager, "Failed to load SaveManager!")

local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
assert(InterfaceManager, "Failed to load InterfaceManager!")

local Window = Fluent:CreateWindow({
    Title = "Custom GUI",
    SubTitle = "QuickRoll Integration",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})
assert(Window, "Window creation failed!")

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}
assert(Tabs.Main, "Failed to create Main tab!")
assert(Tabs.Settings, "Failed to create Settings tab!")

-- QuickRoll toggle functionality
local QuickRollEnabled = false
local function toggleQuickRoll()
    QuickRollEnabled = not QuickRollEnabled
    print("QuickRoll toggled:", QuickRollEnabled)
end

Tabs.Main:AddToggle("QuickRollToggle", {
    Title = "QuickRoll",
    Default = false,
    Callback = function(Value)
        toggleQuickRoll()
    end
})

Tabs.Main:AddButton({
    Title = "Roll Now",
    Description = "Perform a QuickRoll.",
    Callback = function()
        if QuickRollEnabled then
            print("Rolling...")
        else
            print("QuickRoll is disabled.")
        end
    end
})
