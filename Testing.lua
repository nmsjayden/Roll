-- Combined GUI with Tabs for Aura Management and Potion Collector

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local potionsFolder = workspace:WaitForChild("Game"):WaitForChild("Potions")

-- Variables
local aurasToDelete = {
    "Heat", "Flames Curse", "Dark Matter", "Frigid", "Sorcerous", "Starstruck", "Voltage",
    "Constellar", "Iridescent", "Gale", "Shiver", "Bloom", "Fiend", "Tidal", "Flame",
    "Frost", "Antimatter", "Numerical", "Orbital", "Moonlit", "Glacial", "Prism",
    "Nebula", "Cupid", "Storm", "Aurora", "Infernal", "Azure Periastron", "GLADIATOR",
    "Neptune", "Constellation", "Reborn", "Storm: True Form", "Omniscient", "Acceleration",
    "Grim Reaper", "Infinity", "Prismatic", "Eternal", "Serenity", "Sakura"
}
local isAuraScriptActive = false
local potionCollectorActive = false

-- GUI Setup
local gui = Instance.new("ScreenGui")
gui.Parent = game:GetService("CoreGui")
gui.Name = "CombinedGUI"

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 500)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui

-- Tabs
local tabsFrame = Instance.new("Frame")
tabsFrame.Size = UDim2.new(1, 0, 0, 40)
tabsFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
tabsFrame.BorderSizePixel = 0
tabsFrame.Parent = mainFrame

local auraTabButton = Instance.new("TextButton")
auraTabButton.Size = UDim2.new(0.5, -1, 1, 0)
auraTabButton.Position = UDim2.new(0, 0, 0, 0)
auraTabButton.Text = "Aura Management"
auraTabButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
auraTabButton.TextColor3 = Color3.new(1, 1, 1)
auraTabButton.Parent = tabsFrame

local potionTabButton = Instance.new("TextButton")
potionTabButton.Size = UDim2.new(0.5, -1, 1, 0)
potionTabButton.Position = UDim2.new(0.5, 1, 0, 0)
potionTabButton.Text = "Potion Collector"
potionTabButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
potionTabButton.TextColor3 = Color3.new(1, 1, 1)
potionTabButton.Parent = tabsFrame

-- Aura Management Tab
local auraTabFrame = Instance.new("Frame")
auraTabFrame.Size = UDim2.new(1, 0, 1, -40)
auraTabFrame.Position = UDim2.new(0, 0, 0, 40)
auraTabFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
auraTabFrame.Visible = true
auraTabFrame.Parent = mainFrame

-- "On" Button for Aura Management
local auraScriptToggleButton = Instance.new("TextButton")
auraScriptToggleButton.Size = UDim2.new(0.9, 0, 0, 40)
auraScriptToggleButton.Position = UDim2.new(0.05, 0, 0, 10)
auraScriptToggleButton.Text = "Aura Script: OFF"
auraScriptToggleButton.BackgroundColor3 = Color3.new(0.8, 0.3, 0.3)
auraScriptToggleButton.Parent = auraTabFrame

auraScriptToggleButton.MouseButton1Click:Connect(function()
    isAuraScriptActive = not isAuraScriptActive
    auraScriptToggleButton.Text = "Aura Script: " .. (isAuraScriptActive and "ON" or "OFF")
    auraScriptToggleButton.BackgroundColor3 = isAuraScriptActive and Color3.new(0.3, 0.8, 0.3) or Color3.new(0.8, 0.3, 0.3)
end)

-- Textbox for Aura Name
local auraTextbox = Instance.new("TextBox")
auraTextbox.Size = UDim2.new(0.9, 0, 0, 40)
auraTextbox.Position = UDim2.new(0.05, 0, 0, 60)
auraTextbox.PlaceholderText = "Enter Aura Name"
auraTextbox.BackgroundColor3 = Color3.new(0.9, 0.9, 0.9)
auraTextbox.Parent = auraTabFrame

-- Combined Add/Remove Aura Button
local addRemoveAuraButton = Instance.new("TextButton")
addRemoveAuraButton.Size = UDim2.new(0.9, 0, 0, 40)
addRemoveAuraButton.Position = UDim2.new(0.05, 0, 0, 110)
addRemoveAuraButton.Text = "Add/Remove Aura"
addRemoveAuraButton.BackgroundColor3 = Color3.new(0.3, 0.5, 0.8)
addRemoveAuraButton.Parent = auraTabFrame

addRemoveAuraButton.MouseButton1Click:Connect(function()
    local auraName = auraTextbox.Text
    if auraName ~= "" then
        local found = false
        for i, aura in ipairs(aurasToDelete) do
            if aura == auraName then
                table.remove(aurasToDelete, i)
                found = true
                break
            end
        end
        if not found then
            table.insert(aurasToDelete, auraName)
        end
        -- Update Aura List
        print("Auras to delete: " .. table.concat(aurasToDelete, ", "))
    end
end)

-- Potion Collector Tab
local potionTabFrame = Instance.new("Frame")
potionTabFrame.Size = UDim2.new(1, 0, 1, -40)
potionTabFrame.Position = UDim2.new(0, 0, 0, 40)
potionTabFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
potionTabFrame.Visible = false
potionTabFrame.Parent = mainFrame

-- Potion Collector Toggle Button
local potionCollectorButton = Instance.new("TextButton")
potionCollectorButton.Size = UDim2.new(0.9, 0, 0, 40)
potionCollectorButton.Position = UDim2.new(0.05, 0, 0, 10)
potionCollectorButton.Text = "Potion Collector: OFF"
potionCollectorButton.BackgroundColor3 = Color3.new(0.8, 0.3, 0.3)
potionCollectorButton.Parent = potionTabFrame

potionCollectorButton.MouseButton1Click:Connect(function()
    potionCollectorActive = not potionCollectorActive
    potionCollectorButton.Text = "Potion Collector: " .. (potionCollectorActive and "ON" or "OFF")
    potionCollectorButton.BackgroundColor3 = potionCollectorActive and Color3.new(0.3, 0.8, 0.3) or Color3.new(0.8, 0.3, 0.3)
end)

-- Tab Switching Logic
auraTabButton.MouseButton1Click:Connect(function()
    auraTabFrame.Visible = true
    potionTabFrame.Visible = false
end)

potionTabButton.MouseButton1Click:Connect(function()
    potionTabFrame.Visible = true
    auraTabFrame.Visible = false
end)
