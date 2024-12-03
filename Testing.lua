local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Aura Manager",
    SubTitle = "by nmsjayden",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Aura Management" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

-- Variables
local isScriptActive = false
local amountToDelete = "6"
local aurasToDelete = {
    "Heat", "Flames Curse", "Dark Matter", "Frigid", "Sorcerous", "Starstruck", "Voltage",
    "Constellar", "Iridescent", "Gale", "Shiver", "Bloom", "Fiend", "Tidal", "Flame",
    "Frost", "Antimatter", "Numerical", "Orbital", "Moonlit", "Glacial", "Bloom", "Prism",
    "Nebula", "Numerical", "/|Errxr|\", "Storm", "Storm: True Form", "GLADIATOR",
    "Prism: True Form", "Aurora", "Iridescent: True Form", "Grim Reaper: True Form",
    "Iridescent: True Form", "Syberis"
}

local function processAuras()
    local r = game:GetService("ReplicatedStorage")
    local f = r:FindFirstChild("Auras")
    if f then
        for _, b in pairs(f:GetChildren()) do
            r.Remotes.AcceptAura:FireServer(b.Name, true)
        end
    end
end

-- Toggle Script Behavior
local function toggleScript()
    isScriptActive = not isScriptActive
end

-- Main Functionality
Tabs.Main:AddToggle("ScriptToggle", {
    Title = "Enable Aura Script",
    Default = false,
    Callback = function(Value)
        isScriptActive = Value
    end
})

Tabs.Main:AddButton({
    Title = "Process Auras",
    Callback = function()
        processAuras()
    end
})

Tabs.Main:AddButton({
    Title = "Delete Auras",
    Callback = function()
        for _, d in ipairs(aurasToDelete) do
            game:GetService("ReplicatedStorage").Remotes.DeleteAura:FireServer(d, amountToDelete)
        end
    end
})

-- Background Task
spawn(function()
    while task.wait(0.01) do
        if isScriptActive then
            game:GetService("ReplicatedStorage").Remotes.ZachRLL:InvokeServer()
            processAuras()
            for _, d in ipairs(aurasToDelete) do
                game:GetService("ReplicatedStorage").Remotes.DeleteAura:FireServer(d, amountToDelete)
            end
        end
    end
end)

-- Save Manager and Settings
InterfaceManager:SetLibrary(Fluent)
SaveManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("AuraManagerHub")
SaveManager:SetFolder("AuraManagerHub/config")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)
Window:SelectTab(1)

SaveManager:LoadAutoloadConfig()
Fluent:Notify({
    Title = "Aura Manager",
    Content = "Script loaded successfully.",
    Duration = 5
})
