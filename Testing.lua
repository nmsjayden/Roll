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

-- Main GUI creation
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game:GetService("CoreGui")
screenGui.Name = "AuraPotionGUI"

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 400)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.Parent = screenGui
mainFrame.Visible = true

mainFrame.Active = true
mainFrame.Draggable = true

-- Tabs
local tabButtonsFrame = Instance.new("Frame")
tabButtonsFrame.Size = UDim2.new(0, 400, 0, 50)
tabButtonsFrame.Position = UDim2.new(0, 0, 0, 0)
tabButtonsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
tabButtonsFrame.Parent = mainFrame

local auraTabButton = Instance.new("TextButton")
auraTabButton.Size = UDim2.new(0.33, 0, 1, 0)
auraTabButton.Position = UDim2.new(0, 0, 0, 0)
auraTabButton.Text = "Aura Management"
auraTabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
auraTabButton.Parent = tabButtonsFrame

local potionTabButton = Instance.new("TextButton")
potionTabButton.Size = UDim2.new(0.33, 0, 1, 0)
potionTabButton.Position = UDim2.new(0.33, 0, 0, 0)
potionTabButton.Text = "Potion Collector"
potionTabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
potionTabButton.Parent = tabButtonsFrame

local settingsTabButton = Instance.new("TextButton")
settingsTabButton.Size = UDim2.new(0.33, 0, 1, 0)
settingsTabButton.Position = UDim2.new(0.66, 0, 0, 0)
settingsTabButton.Text = "Settings"
settingsTabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
settingsTabButton.Parent = tabButtonsFrame

-- Frames for each tab
local auraFrame = Instance.new("Frame")
auraFrame.Size = UDim2.new(1, 0, 1, -50)
auraFrame.Position = UDim2.new(0, 0, 0, 50)
auraFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
auraFrame.Parent = mainFrame
auraFrame.Visible = true

local potionFrame = Instance.new("Frame")
potionFrame.Size = UDim2.new(1, 0, 1, -50)
potionFrame.Position = UDim2.new(0, 0, 0, 50)
potionFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
potionFrame.Parent = mainFrame
potionFrame.Visible = false

local settingsFrame = Instance.new("Frame")
settingsFrame.Size = UDim2.new(1, 0, 1, -50)
settingsFrame.Position = UDim2.new(0, 0, 0, 50)
settingsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
settingsFrame.Parent = mainFrame
settingsFrame.Visible = false

-- Unload Script button in settings tab
local unloadButton = Instance.new("TextButton")
unloadButton.Size = UDim2.new(0.5, 0, 0, 50)
unloadButton.Position = UDim2.new(0.25, 0, 0.4, 0)
unloadButton.Text = "Unload Script"
unloadButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
unloadButton.Parent = settingsFrame

unloadButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()  -- Unload the script (destroys the GUI)
end)

-- Show different frames based on selected tab
auraTabButton.MouseButton1Click:Connect(function()
    auraFrame.Visible = true
    potionFrame.Visible = false
    settingsFrame.Visible = false
end)

potionTabButton.MouseButton1Click:Connect(function()
    auraFrame.Visible = false
    potionFrame.Visible = true
    settingsFrame.Visible = false
end)

settingsTabButton.MouseButton1Click:Connect(function()
    auraFrame.Visible = false
    potionFrame.Visible = false
    settingsFrame.Visible = true
end)

-- Aura Management (using previous code as reference)
-- (Aura Management GUI elements such as buttons, text boxes, and list are already handled in your provided code)

-- Potion Collector (using previous code as reference)
-- (Potion Collector buttons, logic, etc. are already handled in your provided code)
