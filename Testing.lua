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
local toggleAuraScriptButton = Instance.new("TextButton")
toggleAuraScriptButton.Size = UDim2.new(0.9, 0, 0, 40)
toggleAuraScriptButton.Position = UDim2.new(0.05, 0, 0, 20)
toggleAuraScriptButton.Text = "Toggle Aura Script"
toggleAuraScriptButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
toggleAuraScriptButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleAuraScriptButton.Parent = auraFrame

local auraTextbox = Instance.new("TextBox")
auraTextbox.Size = UDim2.new(0.9, 0, 0, 40)
auraTextbox.Position = UDim2.new(0.05, 0, 0, 70)
auraTextbox.PlaceholderText = "Input Aura Name"
auraTextbox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
auraTextbox.TextColor3 = Color3.fromRGB(255, 255, 255)
auraTextbox.Parent = auraFrame

local toggleAuraButton = Instance.new("TextButton")
toggleAuraButton.Size = UDim2.new(0.9, 0, 0, 40)
toggleAuraButton.Position = UDim2.new(0.05, 0, 0, 120)
toggleAuraButton.Text = "Add/Remove Aura"
toggleAuraButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
toggleAuraButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleAuraButton.Parent = auraFrame

local sideTabFrame = Instance.new("Frame")
sideTabFrame.Size = UDim2.new(0, 100, 1, 0)  -- Reduced width of the side tab
sideTabFrame.Position = UDim2.new(1, 0, 0, 0)
sideTabFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
sideTabFrame.Visible = false
sideTabFrame.Parent = auraFrame

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, 0)
scrollFrame.Position = UDim2.new(0, 0, 0, 0)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 1000)
scrollFrame.ScrollBarThickness = 10
scrollFrame.BackgroundTransparency = 1
scrollFrame.Parent = sideTabFrame

local auraListLabel = Instance.new("TextLabel")
auraListLabel.Size = UDim2.new(1, 0, 0, 1000)  -- Fixed size for the list
auraListLabel.Text = ""
auraListLabel.BackgroundTransparency = 1
auraListLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
auraListLabel.TextScaled = true
auraListLabel.TextWrapped = true
auraListLabel.TextSize = 24  -- Increased text size
auraListLabel.Parent = scrollFrame

-- Update the aura list dynamically
local function updateAuraList()
    auraListLabel.Text = table.concat(aurasToDelete, "\n")
end

toggleAuraScriptButton.MouseButton1Click:Connect(function()
    isAuraScriptActive = not isAuraScriptActive
    toggleAuraScriptButton.Text = isAuraScriptActive and "Aura Script On" or "Aura Script Off"
    toggleAuraScriptButton.BackgroundColor3 = isAuraScriptActive and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(70, 70, 70)
end)

toggleAuraButton.MouseButton1Click:Connect(function()
    local auraName = auraTextbox.Text
    if auraName ~= "" then
        -- Toggle aura presence in the list and update the button accordingly
        local auraIndex = table.find(aurasToDelete, auraName)
        if auraIndex then
            table.remove(aurasToDelete, auraIndex)
        else
            table.insert(aurasToDelete, auraName)
        end
        updateAuraList()  -- Update the side tab aura list
    end
end)

-- Potion Collector Button
local togglePotionButton = Instance.new("TextButton")
togglePotionButton.Size = UDim2.new(0.9, 0, 0, 40)
togglePotionButton.Position = UDim2.new(0.05, 0, 0, 20)
togglePotionButton.Text = "Start Potion Collector"
togglePotionButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
togglePotionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
togglePotionButton.Parent = potionFrame

togglePotionButton.MouseButton1Click:Connect(function()
    toggleActive = not toggleActive
    togglePotionButton.Text = toggleActive and "Potion Collector On" or "Start Potion Collector"
    togglePotionButton.BackgroundColor3 = toggleActive and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(70, 70, 70)

    if toggleActive and player.Character then
        teleportToPotionAndInteract(player.Character)
    end
end)

-- Tab Switching Logic
auraButton.MouseButton1Click:Connect(function()
    auraFrame.Visible = true
    potionFrame.Visible = false
    sideTabFrame.Visible = true -- Show side tab with aura list
end)

potionButton.MouseButton1Click:Connect(function()
    auraFrame.Visible = false
    potionFrame.Visible = true
    sideTabFrame.Visible = false -- Hide side tab when not in Aura Management
end)
