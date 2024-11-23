-- Ensure compatibility with executors
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local toggleActive = false

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui") -- Explicitly parent to PlayerGui for executor support

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
toggleButton.Text = "Toggle Gem Collector (Off)"
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

-- Potion Count TextLabel
local potionCountLabel = Instance.new("TextLabel")
potionCountLabel.Size = UDim2.new(0, 200, 0, 60)
potionCountLabel.Position = UDim2.new(0, 10, 0, 70) -- Position below the toggle button
potionCountLabel.Text = "Gems: 0\nSpeed Potion: 0\nUltimate Potion: 0"
potionCountLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
potionCountLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
potionCountLabel.BackgroundTransparency = 0.5
potionCountLabel.Parent = mainFrame

-- Reference to the Potions folder in Workspace > Game > Potions
local potionsFolder = workspace:WaitForChild("Game"):WaitForChild("Potions")

-- Counter for interacted potions
local interactedGemsCount = 0
local interactedSpeedPotionCount = 0
local interactedUltimatePotionCount = 0

-- Function to find the nearest gem
local function findNearestPotion(potionType)
    local closestPotion = nil
    local closestDistance = math.huge

    for _, obj in pairs(potionsFolder:GetChildren()) do
        if obj:IsA("Model") and (obj.Name == "Gem" or obj.Name == "speed_potion" or obj.Name == "ultimate_potion") then
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
local function teleportToPotionAndInteract(potionType)
    while toggleActive do
        local potion = findNearestPotion(potionType)
        if potion then
            -- Teleport to the potion's position, slightly raised to avoid colliding with the ground
            local newPosition = potion.Position + Vector3.new(0, 5, 0) -- Adjust height to 5 studs above the potion's position
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

            -- Increment the interacted count for the respective potion type
            if potionType == "Gem" then
                interactedGemsCount = interactedGemsCount + 1
            elseif potionType == "Speed Potion" then
                interactedSpeedPotionCount = interactedSpeedPotionCount + 1
            elseif potionType == "Ultimate Potion" then
                interactedUltimatePotionCount = interactedUltimatePotionCount + 1
            end

            if interacted then
                print("Successfully interacted with the ProximityPrompt!")
            end
        end
        wait(0.1) -- Try again in 0.1 seconds for fast interaction without delay
    end
end

-- Retry the gem/potion search every 10 seconds and count uninteracted items
local function retryPotionSearch()
    while toggleActive do
        wait(10) -- Retry searching for items every 10 seconds
        local gemCount = 0
        local speedPotionCount = 0
        local ultimatePotionCount = 0

        -- Count all uninteracted gems, speed potions, and ultimate potions
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
                        end
                    end
                end
            end
        end

        -- Update and print the number of uninteracted items
        potionCountLabel.Text = "Gems: " .. interactedGemsCount ..
                                "\nSpeed Potion: " .. interactedSpeedPotionCount ..
                                "\nUltimate Potion: " .. interactedUltimatePotionCount
        print("Uninteracted Gems: " .. gemCount .. ", Speed Potions: " .. speedPotionCount .. ", Ultimate Potions: " .. ultimatePotionCount)
    end
end

-- Toggle logic for the main functionality
toggleButton.MouseButton1Click:Connect(function()
    toggleActive = not toggleActive
    if toggleActive then
        toggleButton.Text = "Toggle Gem Collector (On)"
        toggleButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        teleportToPotionAndInteract("Gem")
        teleportToPotionAndInteract("Speed Potion")
        teleportToPotionAndInteract("Ultimate Potion")
        retryPotionSearch() -- Start retrying potion search every 10 seconds
    else
        toggleButton.Text = "Toggle Gem Collector (Off)"
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
