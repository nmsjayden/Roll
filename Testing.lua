local Fluent = safeLoad("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua")
if not Fluent then return end

local SaveManager = safeLoad("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua")
local InterfaceManager = safeLoad("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua")

if not SaveManager or not InterfaceManager then
    warn("Failed to load SaveManager or InterfaceManager")
    return
end

-- Create the main window and tabs
local Window = Fluent:CreateWindow({
    Title = "Aura Management GUI",
    SubTitle = "by dawid",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
    AuraManagement = Window:AddTab({ Title = "Aura Management", Icon = "settings" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "cog" })
}

local Options = Fluent.Options

-- Set up SaveManager and InterfaceManager
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})

InterfaceManager:SetFolder("AuraManagerGUI")
SaveManager:SetFolder("AuraManagerGUI/config")

-- Load saved auras and settings
local savedAuras = SaveManager:Load("aurasToDelete") or {"Heat", "Flames Curse", "Dark Matter", "Frigid", "Sorcerous", "Starstruck", "Voltage"}
local amountToDelete = SaveManager:Load("amountToDelete") or 6

-- Notify user if auras are successfully loaded
Fluent:Notify({
    Title = "Aura Management",
    Content = "Auras and settings have been loaded.",
    Duration = 5
})

-- Aura Management Setup
Tabs.AuraManagement:AddTextbox("AuraInput", {
    Title = "Add/Remove Aura",
    Placeholder = "Enter aura name",
    Default = "",
    Callback = function(auraName)
        if auraName ~= "" then
            local found = false
            for i, aura in ipairs(savedAuras) do
                if aura == auraName then
                    table.remove(savedAuras, i)
                    Fluent:Notify({ Title = "Aura Removed", Content = auraName, Duration = 3 })
                    found = true
                    break
                end
            end
            if not found then
                table.insert(savedAuras, auraName)
                Fluent:Notify({ Title = "Aura Added", Content = auraName, Duration = 3 })
            end
            SaveManager:Save("aurasToDelete", savedAuras)  -- Save changes
        end
    end
})

Tabs.AuraManagement:AddParagraph({
    Title = "Current Auras",
    Content = table.concat(savedAuras, ", ")
})

Tabs.AuraManagement:AddTextbox("AmountToDelete", {
    Title = "Amount to Delete",
    Placeholder = "Enter amount",
    Default = tostring(amountToDelete),
    Callback = function(amount)
        amountToDelete = tonumber(amount) or 6
        Fluent:Notify({ Title = "Amount Updated", Content = "Delete amount set to " .. amountToDelete, Duration = 3 })
        SaveManager:Save("amountToDelete", amountToDelete)  -- Save amount setting
    end
})

-- Settings Tab: Unload Script Button
Tabs.Settings:AddButton({
    Title = "Unload Script",
    Callback = function()
        Fluent:Notify({ Title = "Script", Content = "Unloading the script.", Duration = 5 })
        -- Logic for unloading the script
    end
})

-- Save configurations when the GUI is unloaded or saved manually
SaveManager:BuildConfigSection(Tabs.Settings)
InterfaceManager:BuildInterfaceSection(Tabs.Settings)

-- Background Script Execution for Active Aura Management
spawn(function()
    while true do
        task.wait(0.01)
        if isScriptActive then
            game:GetService("ReplicatedStorage").Remotes.ZachRLL:InvokeServer()
            local r = game:GetService("ReplicatedStorage")
            local f = r:FindFirstChild("Auras")
            if f then
                for _, b in pairs(f:GetChildren()) do
                    r.Remotes.AcceptAura:FireServer(b.Name, true)
                end
            end
            for _, d in ipairs(savedAuras) do
                game:GetService("ReplicatedStorage").Remotes.DeleteAura:FireServer(d, tostring(amountToDelete))
            end
        end
    end
end)

-- Load saved configuration on startup
pcall(function()
    SaveManager:LoadAutoloadConfig()
end)

-- Initialize the first tab and notify user
Window:SelectTab(1)
Fluent:Notify({ Title = "Aura Management GUI", Content = "The script has been loaded.", Duration = 8 })
