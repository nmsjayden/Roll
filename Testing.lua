local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Fluent " .. Fluent.Version,
    SubTitle = "by dawid",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
    AuraManagement = Window:AddTab({ Title = "Aura Management", Icon = "layers" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

-- Aura List
local auras = {"Fire", "Water", "Earth", "Air"}
local function updateAuraList()
    local content = table.concat(auras, "\n")
    Tabs.AuraManagement:AddParagraph({
        Title = "Aura List",
        Content = content
    })
end

-- Add/Remove Aura Button
Tabs.AuraManagement:AddButton({
    Title = "Add/Remove Aura",
    Description = "Toggle the presence of auras.",
    Callback = function()
        if table.find(auras, "Light") then
            table.remove(auras, table.find(auras, "Light"))
        else
            table.insert(auras, "Light")
        end
        updateAuraList()
    end
})

-- Quickroll Button
Tabs.Main:AddButton({
    Title = "Quickroll",
    Description = "Perform a quickroll action.",
    Callback = function()
        print("Quickroll activated!")
    end
})

-- Aura Script Toggle
local auraScriptActive = false
Tabs.AuraManagement:AddToggle("AuraScriptToggle", {
    Title = "Aura Script On/Off",
    Default = false,
    Callback = function(state)
        auraScriptActive = state
        print("Aura Script is now", auraScriptActive and "Active" or "Inactive")
    end
})

-- SaveManager and InterfaceManager Integration
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

Fluent:Notify({
    Title = "Fluent",
    Content = "The script has been loaded.",
    Duration = 8
})

-- Load Autoload Config
SaveManager:LoadAutoloadConfig()
