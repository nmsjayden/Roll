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

-- Reference to the potions folder
local potionsFolder = workspace:WaitForChild("Game"):WaitForChild("Potions")

-- Function to find nearest gem
local function findNearestGem()
    local closestGem = nil
    local closestDistance = math.huge

    -- Search specifically within the Potions > Gem folder
    for _, obj in pairs(potionsFolder:GetChildren()) do
        -- Ensure the object is valid, has a ProximityPrompt, and is named "Gem"
        local proximityPrompt = obj:FindFirstChildOfClass("ProximityPrompt")
        if obj and proximityPrompt and obj:IsA("BasePart") and obj.Name == "Gem" then
            local distance = (character.PrimaryPart.Position - obj.Position).Magnitude
            if distance < closestDistance then
                closestDistance = distance
                closestGem = obj
            end
        end
    end

    if closestGem then
        print("Successfully found a gem!")
    else
        print("No gems found. Retrying in 10 seconds...")
    end

    return closestGem
end

-- Function to walk to and interact with a gem using ProximityPrompt
local function collectGem()
    while toggleActive do
        local success, errorMessage = pcall(function()
            local gem = findNearestGem()
            if gem then
                -- Walk to the gem
                humanoid:MoveTo(gem.Position)

                -- Wait until near the gem
                local distanceCheck = humanoid.MoveToFinished:Wait()
                if distanceCheck and (character.PrimaryPart.Position - gem.Position).Magnitude < 5 then
                    -- Find and trigger the ProximityPrompt
                    local proximityPrompt = gem:FindFirstChildOfClass("ProximityPrompt")
                    if proximityPrompt then
                        proximityPrompt:InputHoldBegin() -- Begin interaction
                        wait(0.5) -- Simulate hold duration (adjust as needed)
                        proximityPrompt:InputHoldEnd() -- End interaction
                    end
                end
            else
                -- Wait and retry if no gem is found
                wait(10)  -- Increased retry time to 10 seconds
            end
        end)

        if not success then
            -- Handle any errors gracefully
            print("Error during gem collection: " .. errorMessage)
            wait(10) -- Retry after a delay
        end

        wait(0.5) -- Wait briefly before checking again
    end
end

-- Toggle logic for the main functionality
toggleButton.MouseButton1Click:Connect(function()
    toggleActive = not toggleActive
    if toggleActive then
        toggleButton.Text = "Toggle Gem Collector (On)"
        toggleButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        collectGem()
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
