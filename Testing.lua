local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local potionsFolder = workspace:WaitForChild("Game"):WaitForChild("Potions")
local togglePotionActive = false
local toggleAuraActive = false

-- Aura Variables
local amountToDelete = 6
local isAuraScriptRunning = false

local aurasToDelete = {
    "Heat", "Flames Curse", "Dark Matter", "Frigid", "Sorcerous", "Starstruck", "Voltage",
    "Constellar", "Iridescent", "Gale", "Shiver", "Bloom", "Fiend", "Tidal", "Flame", 
    "Frost", "Antimatter", "Numerical", "Orbital", "Moonlit", "Glacial", "Bloom", "Prism", 
    "Nebula", "Iridescent", "Cupid", "Storm", "Aurora", "Infernal", "Azure Periastron", 
    "GLADIATOR", "Neptune", "Constellation", "Reborn", "Storm: True Form", "Omniscient", 
    "Acceleration", "Grim Reaper", "Infinity", "Prismatic", "Eternal", "Serenity", "Sakura"
}

local function processAuras()
    local aurasFolder = ReplicatedStorage:FindFirstChild("Auras")
    if not aurasFolder then return end
    for _, aura in pairs(aurasFolder:GetChildren()) do
        if table.find(aurasToDelete, aura.Name) then
            ReplicatedStorage.Remotes.AcceptAura:FireServer(aura.Name, true)
        end
    end
end

local function toggleAuraScript()
    toggleAuraActive = not toggleAuraActive
    while toggleAuraActive do
        processAuras()
        task.wait(1)
    end
end

-- Potion Variables
local function findNearestPotion(character)
    local closestPotion = nil
    local closestDistance = math.huge

    for _, obj in pairs(potionsFolder:GetChildren()) do
        if obj:IsA("Model") and (obj.Name == "Gem" or obj.Name:find("potion")) then
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

local function collectPotions(character)
    while togglePotionActive do
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

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 200)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, 0, 0, 30)
tabFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
tabFrame.Parent = mainFrame

local auraTabButton = Instance.new("TextButton")
auraTabButton.Size = UDim2.new(0.5, -1, 1, 0)
auraTabButton.Position = UDim2.new(0, 0, 0, 0)
auraTabButton.Text = "Auras"
auraTabButton.BackgroundColor3 = Color3.fromRGB(75, 75, 200)
auraTabButton.TextColor3 = Color3.new(1, 1, 1)
auraTabButton.Parent = tabFrame

local potionTabButton = Instance.new("TextButton")
potionTabButton.Size = UDim2.new(0.5, -1, 1, 0)
potionTabButton.Position = UDim2.new(0.5, 1, 0, 0)
potionTabButton.Text = "Potions"
potionTabButton.BackgroundColor3 = Color3.fromRGB(200, 75, 75)
potionTabButton.TextColor3 = Color3.new(1, 1, 1)
potionTabButton.Parent = tabFrame

local auraFrame = Instance.new("Frame")
auraFrame.Size = UDim2.new(1, 0, 1, -30)
auraFrame.Position = UDim2.new(0, 0, 0, 30)
auraFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
auraFrame.Visible = true
auraFrame.Parent = mainFrame

local potionFrame = Instance.new("Frame")
potionFrame.Size = UDim2.new(1, 0, 1, -30)
potionFrame.Position = UDim2.new(0, 0, 0, 30)
potionFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
potionFrame.Visible = false
potionFrame.Parent = mainFrame

-- Tab Switch
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
toggleAuraButton.BackgroundColor3 = Color3.fromRGB(200, 75, 75)
toggleAuraButton.TextColor3 = Color3.new(1, 1, 1)
toggleAuraButton.Parent = auraFrame

local auraAmountBox = Instance.new("TextBox")
auraAmountBox.Size = UDim2.new(0.9, 0, 0, 30)
auraAmountBox.Position = UDim2.new(0.05, 0, 0.5, 0)
auraAmountBox.Text = tostring(amountToDelete)
auraAmountBox.PlaceholderText = "Amount to Delete"
auraAmountBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
auraAmountBox.TextColor3 = Color3.new(1, 1, 1)
auraAmountBox.Parent = auraFrame

toggleAuraButton.MouseButton1Click:Connect(function()
    toggleAuraScript()
    toggleAuraButton.Text = "Toggle Aura Script: " .. (toggleAuraActive and "ON" or "OFF")
    toggleAuraButton.BackgroundColor3 = toggleAuraActive and Color3.fromRGB(75, 200, 75) or Color3.fromRGB(200, 75, 75)
end)

auraAmountBox.FocusLost:Connect(function()
    amountToDelete = tonumber(auraAmountBox.Text) or amountToDelete
end)

-- Potion Controls
local togglePotionButton = Instance.new("TextButton")
togglePotionButton.Size = UDim2.new(0.9, 0, 0, 40)
togglePotionButton.Position = UDim2.new(0.05, 0, 0.05, 0)
togglePotionButton.Text = "Toggle Potion Collector: OFF"
togglePotionButton.BackgroundColor3 = Color3.fromRGB(200, 75, 75)
togglePotionButton.TextColor3 = Color3.new(1, 1, 1)
togglePotionButton.Parent = potionFrame

togglePotionButton.MouseButton1Click:Connect(function()
    togglePotionActive = not togglePotionActive
    togglePotionButton.Text = "Toggle Potion Collector: " .. (togglePotionActive and "ON" or "OFF")
    togglePotionButton.BackgroundColor3 = togglePotionActive and Color3.fromRGB(75, 200, 75) or Color3.fromRGB(200, 75, 75)
    if togglePotionActive then
        collectPotions(player.Character)
    end
end)
