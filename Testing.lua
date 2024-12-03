local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Aura Manager",
    SubTitle = "by dawid",
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

local isScriptActive = false
local aurasToDelete = {
    "Heat", "Flames Curse", "Dark Matter", "Frigid", "Sorcerous", "Starstruck", "Voltage",
    "Constellar", "Iridescent", "Gale", "Shiver", "Bloom", "Fiend", "Tidal", "Flame", 
    "Frost", "Antimatter", "Numerical", "Orbital", "Moonlit", "Glacial", "Bloom", "Prism", 
    "Nebula", "Numerical", "/|Errxr|\", "Storm", "Storm: True Form", "GLADIATOR", 
    "Prism: True Form", "Aurora", "Iridescent: True Form", "Grim Reaper: True Form", 
    "Iridescent: True Form", "Syberis"
}
local amountToDelete = "6"

local function processAuras()
    local r = game:GetService("ReplicatedStorage")
    local f = r:FindFirstChild("Auras")
    if f then
        for _, b in pairs(f:GetChildren()) do
            r.Remotes.AcceptAura:FireServer(b.Name, true)
        end
    end
end

local function toggleScript()
    isScriptActive = not isScriptActive
    Fluent:Notify({
        Title = "Script Toggle",
        Content = isScriptActive and "Script Activated" or "Script Deactivated",
        Duration = 5
    })
end

Tabs.Main:AddButton({
    Title = "Toggle Aura Script",
    Description = "Start or stop the aura script",
    Callback = toggleScript
})

Tabs.Main:AddParagraph({
    Title = "Script Status",
    Content = function()
        return isScriptActive and "The script is running." or "The script is not running."
    end
})

Tabs.Main:AddInput("AmountToDelete", {
    Title = "Amount to Delete",
    Default = amountToDelete,
    Placeholder = "Enter a number",
    Numeric = true,
    Callback = function(Value)
        amountToDelete = Value
    end
})

Tabs.Main:AddDropdown("AuraList", {
    Title = "Auras to Delete",
    Values = aurasToDelete,
    Multi = true,
    Default = {},
    Callback = function(SelectedAuras)
        aurasToDelete = SelectedAuras
    end
})

task.spawn(function()
    while true do
        task.wait(0.01)
        if isScriptActive then
            game:GetService("ReplicatedStorage").Remotes.ZachRLL:InvokeServer()
            processAuras()
            for _, d in ipairs(aurasToDelete) do
                game:GetService("ReplicatedStorage").Remotes.DeleteAura:FireServer(d, amountToDelete)
            end
        end
    end
end)

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("AuraManager")
SaveManager:SetFolder("AuraManager/Configs")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

Fluent:Notify({
    Title = "Aura Manager",
    Content = "The script has been loaded.",
    Duration = 8
})

SaveManager:LoadAutoloadConfig()
