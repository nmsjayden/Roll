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

-- GUI Creation
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local tabsFrame = Instance.new("Frame")
tabsFrame.Size = UDim2.new(1, 0, 0, 40)
tabsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
tabsFrame.Parent = mainFrame

local auraButton = Instance.new("TextButton")
auraButton.Size = UDim2.new(0.5, -5, 1, 0)
auraButton.Position = UDim2.new(0, 0, 0, 0)
auraButton.Text = "Aura Management"
auraButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
auraButton.TextColor3 = Color3.fromRGB(255, 255, 255)
auraButton.Parent = tabsFrame

local potionButton = Instance.new("TextButton")
potionButton.Size = UDim2.new(0.5, -5, 1, 0)
potionButton.Position = UDim2.new(0.5, 5, 0, 0)
potionButton.Text = "Potion Collector"
potionButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
potionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
potionButton.Parent = tabsFrame

local auraFrame = Instance.new("Frame")
auraFrame.Size = UDim2.new(1, 0, 1, -40)
auraFrame.Position = UDim2.new(0, 0, 0, 40)
auraFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
auraFrame.Visible = true
auraFrame.Parent = mainFrame

local potionFrame = Instance.new("Frame")
potionFrame.Size = UDim2.new(1, 0, 1, -40)
potionFrame.Position = UDim2.new(0, 0, 0, 40)
potionFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
potionFrame.Visible = false
potionFrame.Parent = mainFrame

-- Aura Management UI
local auraTextbox = Instance.new("TextBox")
auraTextbox.Size = UDim2.new(0.9, 0, 0, 40)
auraTextbox.Position = UDim2.new(0.05, 0, 0, 20)
auraTextbox.PlaceholderText = "Input Aura Name"
auraTextbox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
auraTextbox.TextColor3 = Color3.fromRGB(255, 255, 255)
auraTextbox.Parent = auraFrame

local addButton = Instance.new("TextButton")
addButton.Size = UDim2.new(0.45, -5, 0, 40)
addButton.Position = UDim2.new(0.05, 0, 0, 70)
addButton.Text = "Add Aura"
addButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
addButton.TextColor3 = Color3.fromRGB(255, 255, 255)
addButton.Parent = auraFrame

local removeButton = Instance.new("TextButton")
removeButton.Size = UDim2.new(0.45, -5, 0, 40)
removeButton.Position = UDim2.new(0.5, 5, 0, 70)
removeButton.Text = "Remove Aura"
removeButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
removeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
removeButton.Parent = auraFrame

local auraListLabel = Instance.new("TextLabel")
auraListLabel.Size = UDim2.new(0.9, 0, 0.5, 0)
auraListLabel.Position = UDim2.new(0.05, 0, 0, 120)
auraListLabel.Text = "Auras: " .. table.concat(aurasToDelete, ", ")
auraListLabel.TextWrapped = true
auraListLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
auraListLabel.BackgroundTransparency = 1
auraListLabel.Parent = auraFrame

addButton.MouseButton1Click:Connect(function()
    if auraTextbox.Text ~= "" then
        table.insert(aurasToDelete, auraTextbox.Text)
        auraListLabel.Text = "Auras: " .. table.concat(aurasToDelete, ", ")
        auraTextbox.Text = ""
    end
end)

removeButton.MouseButton1Click:Connect(function()
    if auraTextbox.Text ~= "" then
        for i, aura in ipairs(aurasToDelete) do
            if aura == auraTextbox.Text then
                table.remove(aurasToDelete, i)
                break
            end
        end
        auraListLabel.Text = "Auras: " .. table.concat(aurasToDelete, ", ")
        auraTextbox.Text = ""
    end
end)

-- Potion Collector UI
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0.9, 0, 0, 40)
toggleButton.Position = UDim2.new(0.05, 0, 0.1, 0)
toggleButton.Text = "Start Potion Collector"
toggleButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Parent = potionFrame

toggleButton.MouseButton1Click:Connect(function()
    toggleActive = not toggleActive
    toggleButton.Text = toggleActive and "Potion Collector On" or "Start Potion Collector"
    toggleButton.BackgroundColor3 = toggleActive and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(70, 70, 70)

    if toggleActive and player.Character then
        teleportToPotionAndInteract(player.Character)
    end
end)

-- Tab Switching
auraButton.MouseButton1Click:Connect(function()
    auraFrame.Visible = true
    potionFrame.Visible = false
end)

potionButton.MouseButton1Click:Connect(function()
    auraFrame.Visible = false
    potionFrame.Visible = true
end)
