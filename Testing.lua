local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local potionsFolder = workspace:WaitForChild("Game"):WaitForChild("Potions")
local toggleActive = false

local aurasToDelete = {
    "Heat", "Flames Curse", "Dark Matter", "Frigid", "Sorcerous", "Starstruck", "Voltage",
    "Constellar", "Iridescent", "Gale", "Shiver", "Bloom", "Fiend", "Tidal", "Flame", 
    "Frost", "Antimatter", "Numerical", "Orbital", "Moonlit", "Glacial", "Bloom", "Prism", 
    "Nebula", "Iridescent", "Cupid", "Storm", "Aurora", "Infernal", "Azure Periastron", 
    "GLADIATOR", "Neptune", "Constellation", "Reborn", "Storm: True Form", "Omniscient", 
    "Acceleration", "Grim Reaper", "Infinity", "Prismatic", "Eternal", "Serenity", "Sakura"
}
local isScriptActive = false
local amountToDelete = "6"

local function processAuras()
    local aurasFolder = ReplicatedStorage:FindFirstChild("Auras")
    if aurasFolder then
        for _, aura in pairs(aurasFolder:GetChildren()) do
            ReplicatedStorage.Remotes.AcceptAura:FireServer(aura.Name, true)
        end
    end
end

local function toggleAurasScript()
    isScriptActive = not isScriptActive
end

local function findNearestPotion(character)
    local closestPotion = nil
    local closestDistance = math.huge

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

local function teleportToPotionAndInteract(character)
    while toggleActive do
        local potion = findNearestPotion(character)
        if potion then
            character:SetPrimaryPartCFrame(CFrame.new(potion.Position + Vector3.new(0, 1, 0)))
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

local function retryPotionSearch(character)
    while toggleActive do
        wait(10)
        print("Searching for potions...")
    end
end

local function onCharacterAdded(newCharacter)
    local humanoid = newCharacter:WaitForChild("Humanoid")
    if toggleActive then
        teleportToPotionAndInteract(newCharacter)
        retryPotionSearch(newCharacter)
    end
end

player.CharacterAdded:Connect(onCharacterAdded)

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
mainFrame.Draggable = true
mainFrame.Active = true
mainFrame.Parent = screenGui

local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, 0, 0, 30)
tabFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
tabFrame.Parent = mainFrame

local auraTabButton = Instance.new("TextButton")
auraTabButton.Size = UDim2.new(0.5, -1, 1, 0)
auraTabButton.Position = UDim2.new(0, 0, 0, 0)
auraTabButton.Text = "Auras"
auraTabButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.8)
auraTabButton.Parent = tabFrame

local potionTabButton = Instance.new("TextButton")
potionTabButton.Size = UDim2.new(0.5, -1, 1, 0)
potionTabButton.Position = UDim2.new(0.5, 1, 0, 0)
potionTabButton.Text = "Potions"
potionTabButton.BackgroundColor3 = Color3.new(0.8, 0.3, 0.3)
potionTabButton.Parent = tabFrame

local auraFrame = Instance.new("Frame")
auraFrame.Size = UDim2.new(1, 0, 1, -30)
auraFrame.Position = UDim2.new(0, 0, 0, 30)
auraFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
auraFrame.Visible = true
auraFrame.Parent = mainFrame

local potionFrame = Instance.new("Frame")
potionFrame.Size = UDim2.new(1, 0, 1, -30)
potionFrame.Position = UDim2.new(0, 0, 0, 30)
potionFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
potionFrame.Visible = false
potionFrame.Parent = mainFrame

auraTabButton.MouseButton1Click:Connect(function()
    auraFrame.Visible = true
    potionFrame.Visible = false
end)

potionTabButton.MouseButton1Click:Connect(function()
    auraFrame.Visible = false
    potionFrame.Visible = true
end)

-- Aura Controls
local toggleAuraButton = Instance.new("TextButton")
toggleAuraButton.Size = UDim2.new(0.9, 0, 0, 40)
toggleAuraButton.Position = UDim2.new(0.05, 0, 0.05, 0)
toggleAuraButton.Text = "Toggle Aura Script: OFF"
toggleAuraButton.BackgroundColor3 = Color3.new(0.8, 0.3, 0.3)
toggleAuraButton.Parent = auraFrame

toggleAuraButton.MouseButton1Click:Connect(function()
    toggleAurasScript()
    toggleAuraButton.Text = "Toggle Aura Script: " .. (isScriptActive and "ON" or "OFF")
    toggleAuraButton.BackgroundColor3 = isScriptActive and Color3.new(0.3, 0.8, 0.3) or Color3.new(0.8, 0.3, 0.3)
end)

-- Potion Controls
local togglePotionButton = Instance.new("TextButton")
togglePotionButton.Size = UDim2.new(0.9, 0, 0, 40)
togglePotionButton.Position = UDim2.new(0.05, 0, 0.05, 0)
togglePotionButton.Text = "Toggle Potion Collector: OFF"
togglePotionButton.BackgroundColor3 = Color3.new(0.8, 0.3, 0.3)
togglePotionButton.Parent = potionFrame

togglePotionButton.MouseButton1Click:Connect(function()
    toggleActive = not toggleActive
    togglePotionButton.Text = "Toggle Potion Collector: " .. (toggleActive and "ON" or "OFF")
    togglePotionButton.BackgroundColor3 = toggleActive and Color3.new(0.3, 0.8, 0.3) or Color3.new(0.8, 0.3, 0.3)
    if toggleActive then
        teleportToPotionAndInteract(player.Character)
        retryPotionSearch(player.Character)
    end
end)
