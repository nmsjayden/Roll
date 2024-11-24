local Players = game:GetService("Players")
local player = Players.LocalPlayer
local rocksFolder = workspace:WaitForChild("Rocks")
local toggleActive = false
local autoClickerActive = false
local tapPosition = nil -- Store the set tap position
local guiTextLabel = nil
local settingTapPosition = false -- Flag to indicate when we should set the tap position after a screen tap

-- Function to find the nearest Thanksgiving instance (Thanksgiving1-Thanksgiving5)
local function findNearestThanksgiving(character)
    local closestThanksgiving = nil
    local closestDistance = math.huge

    for _, obj in pairs(rocksFolder:GetChildren()) do
        if obj:IsA("Model") and obj.Name:match("^Thanksgiving%d$") then
            local thanksgivingPart = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
            if thanksgivingPart then
                local distance = (character.PrimaryPart.Position - thanksgivingPart.Position).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closestThanksgiving = thanksgivingPart
                end
            end
        end
    end

    return closestThanksgiving
end

-- Function to teleport to a random position around the Thanksgiving instance and face it
local function teleportAroundThanksgiving(character, thanksgivingPart)
    local maxAttempts = 5
    local attempt = 0
    local newPosition

    repeat
        local offsetX = math.random(-10, 10)
        local offsetZ = math.random(-10, 10)
        newPosition = thanksgivingPart.Position + Vector3.new(offsetX, 1, offsetZ)
        attempt += 1
    until (character.PrimaryPart.Position - newPosition).Magnitude >= 5 and attempt <= maxAttempts

    if newPosition then
        -- Teleport the character to the random position
        character:SetPrimaryPartCFrame(CFrame.new(newPosition))

        -- Make the character face the Thanksgiving instance
        local lookAtPosition = thanksgivingPart.Position
        local newCFrame = CFrame.new(newPosition, lookAtPosition) -- Creates a CFrame facing the target
        character:SetPrimaryPartCFrame(newCFrame)
    end
end

-- Function to handle teleportation and simulate the logic
local function teleportAndSimulateFinger(character)
    while toggleActive do
        local success, err = pcall(function()
            local thanksgiving = findNearestThanksgiving(character)
            if thanksgiving then
                teleportAroundThanksgiving(character, thanksgiving)
            else
                print("No Thanksgiving instance found.")
            end
        end)

        if not success then
            print("Error occurred: " .. err)
        end

        wait(0.1) -- Reduced delay for faster teleportation
    end
end

-- Function to simulate a tap at the tapPosition (when the auto-clicker is active)
local function simulateTap()
    if tapPosition then
        -- Confirming tap position and simulating a tap on screen
        local userInputService = game:GetService("UserInputService")

        -- Here we simulate a 'TouchTap' event at the stored tapPosition
        -- Instead of creating InputObject, we can directly simulate the tap by triggering TouchTap

        -- Trigger the tap behavior by simulating a touch event
        local inputObject = Instance.new("InputObject")
        inputObject.UserInputType = Enum.UserInputType.Touch
        inputObject.Position = tapPosition
        userInputService.InputBegan:Fire(inputObject, false)

        -- Simulate the touch releasing (input ended)
        userInputService.InputEnded:Fire(inputObject)
    end
end

-- Function to handle tap position setting by waiting for a tap after button press
local function onInputBegan(input, gameProcessed)
    if settingTapPosition and not gameProcessed and input.UserInputType == Enum.UserInputType.Touch then
        -- Set the tap position when a touch input is received
        tapPosition = input.Position
        settingTapPosition = false -- Turn off the position-setting flag

        -- Update the GUI to show the position
        if guiTextLabel then
            guiTextLabel.Text = "Tap position set at: " .. tostring(tapPosition)
        end

        -- Confirm position set in the console
        print("New tap position set at: " .. tostring(tapPosition))
    end
end

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game:GetService("CoreGui")

-- Main GUI container
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 200)
mainFrame.Position = UDim2.new(0.5, -110, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Toggle Button for Thanksgiving Collector
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 200, 0, 50)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.Text = "Toggle Thanksgiving Collector (Off)"
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
toggleButton.Parent = mainFrame

-- Auto Clicker Toggle Button
local autoClickerButton = Instance.new("TextButton")
autoClickerButton.Size = UDim2.new(0, 200, 0, 50)
autoClickerButton.Position = UDim2.new(0, 10, 0, 70)
autoClickerButton.Text = "Auto Clicker (Off)"
autoClickerButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
autoClickerButton.Parent = mainFrame

-- Set Tap Position Button
local setTapButton = Instance.new("TextButton")
setTapButton.Size = UDim2.new(0, 200, 0, 50)
setTapButton.Position = UDim2.new(0, 10, 0, 130)
setTapButton.Text = "Set Tap Position"
setTapButton.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
setTapButton.Parent = mainFrame

-- Confirmation label for Tap Position
guiTextLabel = Instance.new("TextLabel")
guiTextLabel.Size = UDim2.new(0, 200, 0, 30)
guiTextLabel.Position = UDim2.new(0, 10, 0, 180)
guiTextLabel.Text = "Tap position: Not set"
guiTextLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
guiTextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
guiTextLabel.Parent = mainFrame

-- Toggle logic for the Thanksgiving Collector
toggleButton.MouseButton1Click:Connect(function()
    toggleActive = not toggleActive
    if toggleActive then
        toggleButton.Text = "Toggle Thanksgiving Collector (On)"
        toggleButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        teleportAndSimulateFinger(player.Character)
    else
        toggleButton.Text = "Toggle Thanksgiving Collector (Off)"
        toggleButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

-- Toggle logic for the Auto Clicker
autoClickerButton.MouseButton1Click:Connect(function()
    autoClickerActive = not autoClickerActive
    if autoClickerActive then
        autoClickerButton.Text = "Auto Clicker (On)"
        autoClickerButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        -- Start auto-clicking when activated
        while autoClickerActive do
            simulateTap()  -- Simulate the tap at the set position
            wait(0.2)  -- Interval between each tap
        end
    else
        autoClickerButton.Text = "Auto Clicker (Off)"
        autoClickerButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

-- Set tap position when the user taps on the screen
setTapButton.MouseButton1Click:Connect(function()
    settingTapPosition = true
    guiTextLabel.Text = "Tap anywhere to set position"
end)

-- Connect the InputBegan event to set the tap position
game:GetService("UserInputService").InputBegan:Connect(onInputBegan)
