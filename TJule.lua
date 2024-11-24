-- Ensure compatibility with executors
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local potionsFolder = workspace:WaitForChild("Game"):WaitForChild("Potions")
local toggleActive = false

-- Function to find the nearest potion (Gem, Speed Potion, Ultimate Potion, Luck Potion)
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

-- Function to teleport to the potion and instantly interact with its ProximityPrompt
local function teleportToPotionAndInteract(character)
    while toggleActive do
        local potion = findNearestPotion(character)
        if potion then
            -- Teleport to the potion's position, slightly raised to avoid colliding with the ground
            local newPosition = potion.Position + Vector3.new(0, 1, 0) -- Adjust height to 5 studs above the potion's position
            character:SetPrimaryPartCFrame(CFrame.new(newPosition))

            -- Immediately interact with a ProximityPrompt near the potion
            local interacted = false
            for _, prompt in pairs(workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") and (prompt.Parent.Position - character.PrimaryPart.Position).Magnitude < 10 then
                    -- Trigger the ProximityPrompt interaction as quickly as possible
                    prompt:InputHoldBegin()
                    prompt:InputHoldEnd()  -- Instantly trigger the interaction without delay
                    interacted = true
                    break
                end
            end

            if interacted then
                print("Successfully interacted with the ProximityPrompt!")
            end
        end
        wait(0.1) -- Try again in 0.1 seconds for fast interaction without delay
    end
end

-- Function to start retrying potion search every 10 seconds
local function retryPotionSearch(character)
    while toggleActive do
        wait(10) -- Retry searching for items every 10 seconds
        local gemCount = 0
        local speedPotionCount = 0
        local ultimatePotionCount = 0
        local luckPotionCount = 0

        -- Count all uninteracted potions (Gem, Speed, Ultimate, Luck)
        for _, obj in pairs(potionsFolder:GetChildren()) do
            if obj:IsA("Model") then
                local potionPart = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                if potionPart then
                    local distance = (character.PrimaryPart.Position - potionPart.Position).Magnitude
                    if distance < 10 then
                        if obj.Name == "Gem" then
                            gemCount = gemCount + 1
                        elseif obj.Name == "speed_potion" then
                            speedPotionCount = speedPotionCount + 1
                        elseif obj.Name == "ultimate_potion" then
                            ultimatePotionCount = ultimatePotionCount + 1
                        elseif obj.Name == "luck_potion" then
                            luckPotionCount = luckPotionCount + 1
                        end
                    end
                end
            end
        end

        -- Output the count of uninteracted potions to the console
        print("Uninteracted Gems: " .. gemCount .. ", Speed Potions: " .. speedPotionCount .. ", Ultimate Potions: " .. ultimatePotionCount .. ", Luck Potions: " .. luckPotionCount)
    end
end

-- Ensure teleporting starts after character is loaded
local function onCharacterAdded(newCharacter)
    -- Wait for the Humanoid to be loaded before starting interaction
    local humanoid = newCharacter:WaitForChild("Humanoid")
    
    -- Start teleporting and interacting with potions
    if toggleActive then
        teleportToPotionAndInteract(newCharacter) -- Start teleporting and interacting
        retryPotionSearch(newCharacter) -- Start retrying potion search
    end
end

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game:GetService("CoreGui") -- Parent to CoreGui to prevent reset issues

-- Main GUI container
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 80)
mainFrame.Position = UDim2.new(0.5, -110, 0.5, -40) -- Centered on screen
mainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
mainFrame.Active = true
mainFrame.Draggable = true -- Main GUI is draggable
mainFrame.Visible = true
mainFrame.Parent = screenGui

-- Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 200, 0, 50)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.Text = "Toggle Potion Collector (Off)"
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
toggleButton.Parent = mainFrame

-- Minimize Button
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 20, 0, 20)
minimizeButton.Position = UDim2.new(1, -30, 0, 10)
minimizeButton.Text = "-"
minimizeButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
minimizeButton.Parent = mainFrame

-- Maximize Button
local maximizeButton = Instance.new("TextButton")
maximizeButton.Size = UDim2.new(0, 20, 0, 20)
maximizeButton.Position = UDim2.new(0.5, -10, 0.5, 50)
maximizeButton.Text = "+"
maximizeButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
maximizeButton.Visible = false
maximizeButton.Active = true
maximizeButton.Parent = screenGui

-- Toggle logic for the main functionality
toggleButton.MouseButton1Click:Connect(function()
    toggleActive = not toggleActive
    if toggleActive then
        toggleButton.Text = "Toggle Potion Collector (On)"
        toggleButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        teleportToPotionAndInteract(player.Character) -- Start teleporting and interacting with potions
        retryPotionSearch(player.Character) -- Start retrying potion search every 10 seconds
    else
        toggleButton.Text = "Toggle Potion Collector (Off)"
        toggleButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

-- Listen for character reset (re-apply teleportation logic after reset)
player.CharacterAdded:Connect(onCharacterAdded)

-- Minimize/Maximize GUI logic
minimizeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    maximizeButton.Visible = true
end)

maximizeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    maximizeButton.Visible = false
end)
