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

-- Reference to the Potions folder in Workspace > Game > Potions
local potionsFolder = workspace:WaitForChild("Game"):WaitForChild("Potions")

-- Function to find the nearest gem
local function findNearestGem()
    local closestGem = nil
    local closestDistance = math.huge

    for _, obj in pairs(potionsFolder:GetChildren()) do
        if obj:IsA("Model") and obj.Name == "Gem" then
            local gemPart = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
            if gemPart then
                local distance = (character.PrimaryPart.Position - gemPart.Position).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closestGem = gemPart
                end
            end
        end
    end

    if closestGem then
        print("Nearest Gem found at position:", closestGem.Position)
    else
        print("No Gems found nearby.")
    end

    return closestGem
end

-- Function to teleport to the gem and interact with its ProximityPrompt
local function teleportToGemAndInteract()
    while toggleActive do
        local success, errorMessage = pcall(function()
            local gem = findNearestGem()
            if gem then
                -- Teleport to the Gem's position
                character:SetPrimaryPartCFrame(gem.CFrame)

                -- Wait a moment for the teleportation to complete
                wait(0.5) -- Adjust as needed to ensure character is fully teleported

                -- Find a ProximityPrompt near the Gem
                for _, prompt in pairs(workspace:GetDescendants()) do
                    if prompt:IsA("ProximityPrompt") and (prompt.Parent.Position - character.PrimaryPart.Position).Magnitude < 10 then
                        print("Interacting with ProximityPrompt near Gem!")
                        prompt:InputHoldBegin()
                        wait(0.5) -- Simulate interaction time
                        prompt:InputHoldEnd()
                        break
                    end
                end
            else
                print("No Gem to teleport to. Retrying in 10 seconds...")
            end
        end)

        if not success then
            print("Error during teleportation or interaction: " .. errorMessage)
        end

        wait(10) -- Retry every 10 seconds
    end
end

-- Toggle logic for the main functionality
toggleButton.MouseButton1Click:Connect(function()
    toggleActive = not toggleActive
    if toggleActive then
        toggleButton.Text = "Toggle Gem Collector (On)"
        toggleButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        teleportToGemAndInteract()
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
