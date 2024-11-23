-- Ensure compatibility with executors
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local potionsFolder = workspace:WaitForChild("Game"):WaitForChild("Potions")

local toggleActive = false
local currentCharacter = player.Character or player.CharacterAdded:Wait()
local humanoid = currentCharacter:WaitForChild("Humanoid")

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

-- Function to update character and humanoid when the character resets
local function onCharacterAdded(newCharacter)
    currentCharacter = newCharacter
    humanoid = currentCharacter:WaitForChild("Humanoid")
end

-- Connect to the CharacterAdded event to handle resets
player.CharacterAdded:Connect(onCharacterAdded)

-- Function to find the nearest potion (Gem, Speed Potion, Ultimate Potion, Luck Potion)
local function findNearestPotion()
    local closestPotion = nil
    local closestDistance = math.huge

    for _, obj in pairs(potionsFolder:GetChildren()) do
        if obj:IsA("Model") and (obj.Name == "Gem" or obj.Name == "speed_potion" or obj.Name == "ultimate_potion" or obj.Name == "luck_potion") then
            local potionPart = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
            if potionPart then
                local distance = (currentCharacter.PrimaryPart.Position - potionPart.Position).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closestPotion = potionPart
                end
            end
        end
    end

    return closestPotion
end

-- Function to teleport to the potion and interact with its ProximityPrompt continuously
local function teleportToPotionAndInteract()
    while toggleActive do
        local potion = findNearestPotion()
        if potion then
            -- Teleport to the potion's position, slightly raised to avoid colliding with the ground
            local newPosition = potion.Position + Vector3.new(0, 5, 0) -- Adjust height to 5 studs above the potion's position
            currentCharacter:SetPrimaryPartCFrame(CFrame.new(newPosition))

            -- Interact with ProximityPrompt near the potion
            for _, prompt in pairs(workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") and (prompt.Parent.Position - currentCharacter.PrimaryPart.Position).Magnitude < 10 then
                    -- Instantly trigger the ProximityPrompt interaction (without delay)
                    prompt:InputHoldBegin()
                    prompt:InputHoldEnd()  -- This allows continuous interaction as long as the player is within range
                    print("Successfully interacted with the ProximityPrompt!")
                    break -- Break to ensure only one interaction per potion
                end
            end
        end
        wait(0.1) -- Wait before trying again to prevent continuous interactions
    end
end

-- Retry the potion search every 10 seconds
local function retryPotionSearch()
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
                    local distance = (currentCharacter.PrimaryPart.Position - potionPart.Position).Magnitude
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

-- Toggle logic for the main functionality
toggleButton.MouseButton1Click:Connect(function()
    toggleActive = not toggleActive
    if toggleActive then
        toggleButton.Text = "Toggle Potion Collector (On)"
        toggleButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        teleportToPotionAndInteract() -- Start teleporting and interacting with potions
        retryPotionSearch() -- Start retrying potion search every 10 seconds
    else
        toggleButton.Text = "Toggle Potion Collector (Off)"
        toggleButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

-- Minimize/Maximize GUI logic
minimizeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    maximizeButton.Visible = true
end)

maximizeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    maximizeButton.Visible = false
end)

-- Custom drag functionality for the maximize (+) button
local dragging = false
local dragStart = nil
local startPos = nil

maximizeButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = maximizeButton.Position
    end
end)

maximizeButton.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - dragStart
        maximizeButton.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

maximizeButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
