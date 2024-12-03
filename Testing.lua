local function safeLoad(url)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    if not success then
        warn("Failed to load:", url)
        return nil
    end
    return result
end

local Fluent = safeLoad("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua")
if not Fluent then return end

local SaveManager = safeLoad("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua")
local InterfaceManager = safeLoad("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua")

if not SaveManager or not InterfaceManager then
    warn("Failed to load SaveManager or InterfaceManager")
    return
end

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

-- SaveManager and InterfaceManager Setup
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})

InterfaceManager:SetFolder("AuraManagerGUI")
SaveManager:SetFolder("AuraManagerGUI/config")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

-- Quick Roll Toggle
local isScriptActive = false
local function toggleQuickRoll()
    isScriptActive = not isScriptActive
    Fluent:Notify({
        Title = "Quick Roll",
        Content = "Quick Roll is now " .. (isScriptActive and "ON" or "OFF"),
        Duration = 5
    })
end

Tabs.Main:AddToggle({
    Title = "Quick Roll",
    Default = isScriptActive,
    Callback = toggleQuickRoll
})

-- Aura Management
local aurasToDelete = {
    "Heat", "Flames Curse", "Dark Matter", "Frigid", "Sorcerous", "Starstruck", "Voltage"
}

Tabs.AuraManagement:AddTextbox("AuraInput", {
    Title = "Add/Remove Aura",
    Placeholder = "Enter aura name",
    Default = "",
    Callback = function(auraName)
        if auraName ~= "" then
            local found = false
            for i, aura in ipairs(aurasToDelete) do
                if aura == auraName then
                    table.remove(aurasToDelete, i)
                    Fluent:Notify({ Title = "Aura Removed", Content = auraName, Duration = 3 })
                    found = true
                    break
                end
            end
            if not found then
                table.insert(aurasToDelete, auraName)
                Fluent:Notify({ Title = "Aura Added", Content = auraName, Duration = 3 })
            end
        end
    end
})

Tabs.AuraManagement:AddParagraph({
    Title = "Current Auras",
    Content = table.concat(aurasToDelete, ", ")
})

Tabs.AuraManagement:AddButton({
    Title = "Process Auras",
    Callback = function()
        local r = game:GetService("ReplicatedStorage")
        local f = r:FindFirstChild("Auras")
        if f then
            for _, b in pairs(f:GetChildren()) do
                r.Remotes.AcceptAura:FireServer(b.Name, true)
            end
        end
        Fluent:Notify({ Title = "Process Auras", Content = "Auras have been processed.", Duration = 5 })
    end
})

Tabs.AuraManagement:AddTextbox("AmountToDelete", {
    Title = "Amount to Delete",
    Placeholder = "Enter amount",
    Default = "6",
    Callback = function(amount)
        amountToDelete = tonumber(amount) or 6
        Fluent:Notify({ Title = "Amount Updated", Content = "Delete amount set to " .. amountToDelete, Duration = 3 })
    end
})

-- Settings Tab Buttons
Tabs.Settings:AddButton({
    Title = "Unload Script",
    Callback = function()
        Fluent:Notify({ Title = "Script", Content = "Unloading the script.", Duration = 5 })
        -- Add unloading logic here if applicable
    end
})

-- Background Script Execution
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
            for _, d in ipairs(aurasToDelete) do
                game:GetService("ReplicatedStorage").Remotes.DeleteAura:FireServer(d, tostring(amountToDelete))
            end
        end
    end
end)

-- Autoload configuration handling
pcall(function()
    SaveManager:LoadAutoloadConfig()
end)

Window:SelectTab(1)
Fluent:Notify({ Title = "Aura Management GUI", Content = "The script has been loaded.", Duration = 8 })
