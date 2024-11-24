-- Combined GUI with Tabs for Aura Management and Potion Collector
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local potionsFolder = workspace:WaitForChild("Game"):WaitForChild("Potions")

local toggleActive = false
local isAuraScriptActive = false
local aurasToDelete = {
    "Heat", "Flames Curse", "Dark Matter", "Frigid", "Sorcerous", "Starstruck", "Voltage",
    "Constellar", "Iridescent", "Gale", "Shiver", "Bloom", "Fiend", "Tidal", "Flame", 
    "Frost", "Antimatter", "Numerical", "Orbital", "Moonlit", "Glacial", "Bloom", "Prism", 
    "Nebula", "Iridescent", "Cupid", "Storm", "Aurora", "Infernal", "Azure Periastron", 
    "GLADIATOR", "Neptune", "Constellation", "Reborn", "Storm: True Form", "Omniscient", 
    "Acceleration", "Grim Reaper", "Infinity", "Prismatic", "Eternal", "Serenity", "Sakura"
}

-- Function to process auras
local function processAuras()
    local f = ReplicatedStorage:FindFirstChild("Auras")
    if f then
        for _, b in pairs(f:GetChildren()) do
            ReplicatedStorage.Remotes.AcceptAura:FireServer(b.Name, true)
        end
    end
end

-- Function to delete auras
local function deleteAuras()
    for _, d in ipairs(aurasToDelete) do
        ReplicatedStorage.Remotes.DeleteAura:FireServer(d, "6")
    end
end

-- Aura Script Loop
task.spawn(function()
    while true do
        task.wait(0.01)
        if isAuraScriptActive then
            ReplicatedStorage.Remotes.ZachRLL:InvokeServer()
            processAuras()
            deleteAuras()
        end
    end
end)

-- Function to find the nearest potion
local function findNearestPotion(character)
    local closestPotion, closestDistance = nil, math.huge
    for _, obj in pairs(potionsFolder:GetChildren()) do
        if obj:IsA("Model") and (obj.Name == "Gem" or obj.Name == "speed_potion" or obj.Name == "ultimate_potion" or obj.Name == "luck_potion") then
            local potionPart = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
            if potionPart then
                local distance = (character.PrimaryPart.Position - potionPart.Position).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closestPotion = potionPart
                end
            end
        end
    end
    return closestPotion
end

-- Function to teleport to a potion
local function teleportToPotionAndInteract(character)
    while toggleActive do
        local potion = findNearestPotion(character)
        if potion then
            local newPosition = potion.Position + Vector3.new(0, 1, 0)
            character:SetPrimaryPartCFrame(CFrame.new(newPosition))
            for _, prompt in pairs(workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") and (prompt.Parent.Position - character.PrimaryPart.Position).Magnitude < 10 then
                    prompt:InputHoldBegin()
                    prompt:InputHoldEnd()
                    break
                end
            end
        end
        wait(0.1)
    end
end

-- Retry Potion Search
local function retryPotionSearch(character)
    while toggleActive do
        wait(10)
    end
end

-- Ensure teleporting starts after character is loaded
local function onCharacterAdded(newCharacter)
    if toggleActive then
        teleportToPotionAndInteract(newCharacter)
        retryPotionSearch(newCharacter)
    end
end
player.CharacterAdded:Connect(onCharacterAdded)

-- Base GUI setup
local gui = Instance.new("ScreenGui")
gui.Parent = game:GetService("CoreGui") -- Prevent unloading on reset
gui.Name = "AuraControlGUI"

-- Main frame of the GUI
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
mainFrame.Draggable = true
mainFrame.Active = true
mainFrame.Visible = true
mainFrame.Parent = gui

-- Header with Hide Button
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
header.Parent = mainFrame

-- Tab Buttons for Navigation
local tabButtonsFrame = Instance.new("Frame")
tabButtonsFrame.Size = UDim2.new(0, 300, 0, 40)
tabButtonsFrame.Position = UDim2.new(0, 0, 0, 40)
tabButtonsFrame.BackgroundTransparency = 1
tabButtonsFrame.Parent = mainFrame

local auraTabButton = Instance.new("TextButton")
auraTabButton.Size = UDim2.new(0, 100, 0, 40)
auraTabButton.Position = UDim2.new(0, 0, 0, 0)
auraTabButton.Text = "Aura Management"
auraTabButton.BackgroundColor3 = Color3.new(0.3, 0.5, 0.8)
auraTabButton.Parent = tabButtonsFrame

local potionTabButton = Instance.new("TextButton")
potionTabButton.Size = UDim2.new(0, 100, 0, 40)
potionTabButton.Position = UDim2.new(0, 100, 0, 0)
potionTabButton.Text = "Potion Collector"
potionTabButton.BackgroundColor3 = Color3.new(0.3, 0.8, 0.3)
potionTabButton.Parent = tabButtonsFrame

local settingsTabButton = Instance.new("TextButton")
settingsTabButton.Size = UDim2.new(0, 100, 0, 40)
settingsTabButton.Position = UDim2.new(0, 200, 0, 0)
settingsTabButton.Text = "Settings"
settingsTabButton.BackgroundColor3 = Color3.new(0.8, 0.8, 0.2)
settingsTabButton.Parent = tabButtonsFrame

-- Aura Management Tab
local auraTabFrame = Instance.new("Frame")
auraTabFrame.Size = UDim2.new(0, 300, 0, 360)
auraTabFrame.Position = UDim2.new(0, 0, 0, 80)
auraTabFrame.BackgroundTransparency = 1
auraTabFrame.Visible = false
auraTabFrame.Parent = mainFrame

-- Potion Collector Tab
local potionTabFrame = Instance.new("Frame")
potionTabFrame.Size = UDim2.new(0, 300, 0, 360)
potionTabFrame.Position = UDim2.new(0, 0, 0, 80)
potionTabFrame.BackgroundTransparency = 1
potionTabFrame.Visible = false
potionTabFrame.Parent = mainFrame

-- Settings Tab
local settingsTabFrame = Instance.new("Frame")
settingsTabFrame.Size = UDim2.new(0, 300, 0, 360)
settingsTabFrame.Position = UDim2.new(0, 0, 0, 80)
settingsTabFrame.BackgroundTransparency = 1
settingsTabFrame.Visible = false
settingsTabFrame.Parent = mainFrame

-- Unload Script Button for Settings Tab
local unloadButton = Instance.new("TextButton")
unloadButton.Size = UDim2.new(0.9, 0, 0, 40)
unloadButton.Position = UDim2.new(0.05, 0, 0, 50)
unloadButton.Text = "Unload Script"
unloadButton.BackgroundColor3 = Color3.new(0.8, 0.3, 0.3)
unloadButton.Parent = settingsTabFrame

unloadButton.MouseButton1Click:Connect(function()
    gui:Destroy() -- This will remove the GUI and stop the script
end)

-- Tab Switching Logic
auraTabButton.MouseButton1Click:Connect(function()
    auraTabFrame.Visible = true
    potionTabFrame.Visible = false
    settingsTabFrame.Visible = false
end)

potionTabButton.MouseButton1Click:Connect(function()
    auraTabFrame.Visible = false
    potionTabFrame.Visible = true
    settingsTabFrame.Visible = false
end)

settingsTabButton.MouseButton1Click:Connect(function()
    auraTabFrame.Visible = false
    potionTabFrame.Visible = false
    settingsTabFrame.Visible = true
end)

-- Initially show Aura Management Tab
auraTabFrame.Visible = true
