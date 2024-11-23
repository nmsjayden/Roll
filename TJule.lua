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
mainFrame.Size = UDim2.new(0, 220, 0, 160) -- Increased height to accommodate multiple potion counts
mainFrame.Position = UDim2.new(0.5, -110, 0.5, -80) -- Centered on screen
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
local lastPrintedCount = "" -- Variable to track the last printed counts to avoid spamming

-- Function to find the nearest potion (Gem, Speed Potion, or Ultimate Potion)
local function findNearestPotion(potionType)
    local closestPotion = nil
    local closestDistance = math.huge

    for _, obj in pairs(potionsFolder:GetChildren()) do
        if obj:IsA("Model") then
            -- Check if the potion matches the type we're looking for
            if potionType == "Gem" and obj.Name == "Gem" then
                closestPotion = obj
            elseif potionType == "Speed Potion" and obj.Name == "speed_potion" then
                closestPotion = obj
            elseif potionType == "Ultimate Potion" and obj.Name == "ultimate_potion" then
                closestPotion = obj
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
            -- Teleport directly to the Potion's position (no offset)
            local newPosition = potion.PrimaryPart.Position + Vector3.new(0, 2, 0)  -- Slight Y offset to prevent teleporting into the ground
            character:SetPrimaryPartCFrame(CFrame.new(newPosition))

            -- Immediately interact with a ProximityPrompt near the Potion
            local interacted = false
            for _, prompt in pairs(potion:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") then
                    -- Trigger the ProximityPrompt interaction as quickly as possible
                    pcall(function()
                        prompt:InputHoldBegin()
                        prompt:InputHoldEnd()  -- Instantly trigger the interaction without delay
                    end)
                    interacted = true
                    break
                end
            end

            if interacted then
                -- Increment the interacted count for the respective potion type
                if potionType == "Gem" then
                    interactedGemsCount = interactedGemsCount + 1
                elseif potionType == "Speed Potion" then
                    interactedSpeedPotionCount = interactedSpeedPotionCount + 1
                elseif potionType == "Ultimate Potion" then
                    interactedUltimatePotionCount = interactedUltimatePotionCount + 1
                end
            end
        end
        wait(0.1) -- Try again in 0.1 seconds for fast interaction without delay
    end
end

-- Function to constantly update the count of interacted potions
local function updatePotionCount()
    while toggleActive do
        -- Update the potion count label with the latest interacted counts
        potionCountLabel.Text = "Gems: " .. interactedGemsCount ..
                                "\nSpeed Potion: " .. interactedSpeedPotionCount ..
                                "\nUltimate Potion: " .. interactedUltimatePotionCount
        wait(1) -- Constantly update every second
    end
end

-- Toggle logic for the main functionality
toggleButton.MouseButton1Click:Connect(function()
    toggleActive = not toggleActive
    if toggleActive then
        toggleButton.Text = "Toggle Potion Collector (On)"
        toggleButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        teleportToPotionAndInteract("Gem")
        teleportToPotionAndInteract("Speed Potion")
        teleportToPotionAndInteract("Ultimate Potion")
        updatePotionCount() -- Start updating potion count constantly
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
        startPos = mainFrame.Position
    end
end)

maximizeButton.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

maximizeButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
