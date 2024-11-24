-- Services
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local potionsFolder = workspace:WaitForChild("Game"):WaitForChild("Potions")
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Variables
local aurasToDelete = {
    "Heat", "Flames Curse", "Dark Matter", "Frigid", "Sorcerous", "Starstruck", "Voltage",
    "Constellar", "Iridescent", "Gale", "Shiver", "Bloom", "Fiend", "Tidal", "Flame",
    "Frost", "Antimatter", "Numerical", "Orbital", "Moonlit", "Glacial", "Bloom", "Prism",
    "Nebula", "Iridescent", "Cupid", "Storm", "Aurora", "Infernal", "Azure Periastron",
    "GLADIATOR", "Neptune", "Constellation", "Reborn", "Storm: True Form", "Omniscient",
    "Acceleration", "Grim Reaper", "Infinity", "Prismatic", "Eternal", "Serenity", "Sakura"
}
local amountToDelete = "6"
local isAuraScriptActive = false
local isPotionScriptActive = false

-- Functions for Aura Management
local function processAuras()
    local auraFolder = replicatedStorage:FindFirstChild("Auras")
    if auraFolder then
        for _, aura in pairs(auraFolder:GetChildren()) do
            replicatedStorage.Remotes.AcceptAura:FireServer(aura.Name, true)
        end
    end
end

local function toggleAuraScript()
    isAuraScriptActive = not isAuraScriptActive
end

task.spawn(function()
    while true do
        task.wait(0.01)
        if isAuraScriptActive then
            replicatedStorage.Remotes.ZachRLL:InvokeServer()
            processAuras()
            for _, auraName in ipairs(aurasToDelete) do
                replicatedStorage.Remotes.DeleteAura:FireServer(auraName, amountToDelete)
            end
        end
    end
end)

-- Functions for Potion Collector
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

local function teleportToPotionAndInteract(character)
    while isPotionScriptActive do
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
        task.wait(0.1)
    end
end

local function retryPotionSearch(character)
    while isPotionScriptActive do
        task.wait(10)
        for _, obj in pairs(potionsFolder:GetChildren()) do
            -- Logic for counting or interacting with potions (can be expanded as needed)
        end
    end
end

local function togglePotionScript()
    isPotionScriptActive = not isPotionScriptActive
    if isPotionScriptActive then
        teleportToPotionAndInteract(player.Character)
        retryPotionSearch(player.Character)
    end
end

-- GUI Creation
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Tab Buttons
local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, 0, 0, 40)
tabContainer.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
tabContainer.Parent = mainFrame

local auraTabButton = Instance.new("TextButton")
auraTabButton.Size = UDim2.new(0.5, 0, 1, 0)
auraTabButton.Text = "Aura Management"
auraTabButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.8)
auraTabButton.Parent = tabContainer

local potionTabButton = Instance.new("TextButton")
potionTabButton.Size = UDim2.new(0.5, 0, 1, 0)
potionTabButton.Position = UDim2.new(0.5, 0, 0, 0)
potionTabButton.Text = "Potion Collector"
potionTabButton.BackgroundColor3 = Color3.new(0.8, 0.3, 0.3)
potionTabButton.Parent = tabContainer

-- Aura Management Tab
local auraTab = Instance.new("Frame")
auraTab.Size = UDim2.new(1, 0, 1, -40)
auraTab.Position = UDim2.new(0, 0, 0, 40)
auraTab.Visible = true
auraTab.Parent = mainFrame

local toggleAuraButton = Instance.new("TextButton")
toggleAuraButton.Size = UDim2.new(0.9, 0, 0, 40)
toggleAuraButton.Position = UDim2.new(0.05, 0, 0.05, 0)
toggleAuraButton.Text = "Toggle Aura Script: OFF"
toggleAuraButton.BackgroundColor3 = Color3.new(0.8, 0.3, 0.3)
toggleAuraButton.Parent = auraTab

local auraListLabel = Instance.new("TextLabel")
auraListLabel.Size = UDim2.new(0.9, 0, 0.7, 0)
auraListLabel.Position = UDim2.new(0.05, 0, 0.15, 0)
auraListLabel.Text = "Auras: " .. table.concat(aurasToDelete, ", ")
auraListLabel.TextWrapped = true
auraListLabel.BackgroundTransparency = 1
auraListLabel.TextColor3 = Color3.new(1, 1, 1)
auraListLabel.Parent = auraTab

toggleAuraButton.MouseButton1Click:Connect(function()
    toggleAuraScript()
    toggleAuraButton.Text = "Toggle Aura Script: " .. (isAuraScriptActive and "ON" or "OFF")
    toggleAuraButton.BackgroundColor3 = isAuraScriptActive and Color3.new(0.3, 0.8, 0.3) or Color3.new(0.8, 0.3, 0.3)
end)

-- Potion Collector Tab
local potionTab = Instance.new("Frame")
potionTab.Size = UDim2.new(1, 0, 1, -40)
potionTab.Position = UDim2.new(0, 0, 0, 40)
potionTab.Visible = false
potionTab.Parent = mainFrame

local togglePotionButton = Instance.new("TextButton")
togglePotionButton.Size = UDim2.new(0.9, 0, 0, 40)
togglePotionButton.Position = UDim2.new(0.05, 0, 0.05, 0)
togglePotionButton.Text = "Toggle Potion Collector: OFF"
togglePotionButton.BackgroundColor3 = Color3.new(0.8, 0.3, 0.3)
togglePotionButton.Parent = potionTab

togglePotionButton.MouseButton1Click:Connect(function()
    togglePotionScript()
    togglePotionButton.Text = "Toggle Potion Collector: " .. (isPotionScriptActive and "ON" or "OFF")
    togglePotionButton.BackgroundColor3 = isPotionScriptActive and Color3.new(0.3, 0.8, 0.3) or Color3.new(0.8, 0.3, 0.3)
end)

-- Tab Switching
auraTabButton.MouseButton1Click:Connect(function()
    auraTab.Visible = true
    potionTab.Visible = false
end)

potionTabButton.MouseButton1Click:Connect(function()
    auraTab.Visible = false
    potionTab.Visible = true
end)
