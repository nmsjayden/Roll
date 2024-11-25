local player = game.Players.LocalPlayer
local rocksFolder = workspace:WaitForChild("Rocks")
local toggleActive, teleportDelay = false, 0.5

-- Function to find the nearest Rock/Thanksgiving instance
local function findNearestRock()
    local closest, dist = nil, math.huge
    for _, obj in pairs(rocksFolder:GetChildren()) do
        if obj:IsA("Model") and (obj.Name:match("^Thanksgiving%d$") or obj.Name:match("^RockTier%d$") or obj.Name:match("^CaveRockTier%d$")) then
            local part = obj:FindFirstChildWhichIsA("BasePart")
            if part then
                local d = (player.Character.PrimaryPart.Position - part.Position).Magnitude
                if d < dist then closest, dist = part, d end
            end
        end
    end
    return closest
end

-- Function to teleport the player around the found instance
local function teleportAround(part)
    local offset = Vector3.new(math.random(-10, 10), 1, math.random(-10, 10))
    player.Character:SetPrimaryPartCFrame(CFrame.new(part.Position + offset))
    player.Character:SetPrimaryPartCFrame(CFrame.lookAt(player.Character.PrimaryPart.Position, part.Position)) -- Make character face the object
end

-- GUI Setup
local screenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local frame = Instance.new("Frame", screenGui)
frame.Size, frame.Position, frame.BackgroundColor3, frame.Active, frame.Draggable = UDim2.new(0, 220, 0, 200), UDim2.new(0.5, -110, 0.5, -100), Color3.fromRGB(50, 50, 50), true, true

-- Minimize Button (-)
local minimizeButton = Instance.new("TextButton", frame)
minimizeButton.Size, minimizeButton.Position, minimizeButton.Text, minimizeButton.BackgroundColor3 = UDim2.new(0, 30, 0, 30), UDim2.new(1, -60, 0, 10), "-", Color3.fromRGB(105, 105, 105)

-- Unload Button (X)
local unloadButton = Instance.new("TextButton", frame)
unloadButton.Size, unloadButton.Position, unloadButton.Text, unloadButton.BackgroundColor3 = UDim2.new(0, 30, 0, 30), UDim2.new(1, -30, 0, 10), "X", Color3.fromRGB(105, 105, 105)

-- Maximize Button (+)
local maximizeButton = Instance.new("TextButton", screenGui)
maximizeButton.Size, maximizeButton.Position, maximizeButton.Text, maximizeButton.BackgroundColor3 = UDim2.new(0, 30, 0, 30), UDim2.new(1, -60, 0, 10), "+", Color3.fromRGB(105, 105, 105)
maximizeButton.Visible = false

-- Make Maximize Button draggable
maximizeButton.Active, maximizeButton.Draggable = true, true

-- Toggle Collector Button
local toggleButton = Instance.new("TextButton", frame)
toggleButton.Size, toggleButton.Position, toggleButton.Text, toggleButton.BackgroundColor3 = UDim2.new(0, 200, 0, 50), UDim2.new(0, 10, 0, 45), "Toggle Collector (Off)", Color3.fromRGB(255, 100, 100)

-- Teleport Speed Label
local speedLabel = Instance.new("TextLabel", frame)
speedLabel.Size, speedLabel.Position, speedLabel.Text, speedLabel.BackgroundColor3, speedLabel.TextColor3 = UDim2.new(0, 200, 0, 30), UDim2.new(0, 10, 0, 105), "Teleport Speed (seconds):", Color3.fromRGB(0, 0, 0), Color3.fromRGB(255, 255, 255)

-- Teleport Speed TextBox
local speedTextBox = Instance.new("TextBox", frame)
speedTextBox.Size, speedTextBox.Position, speedTextBox.Text, speedTextBox.BackgroundColor3, speedTextBox.PlaceholderText = UDim2.new(0, 200, 0, 30), UDim2.new(0, 10, 0, 135), "0.5", Color3.fromRGB(255, 255, 255), "Enter delay (seconds)"

-- Minimize Functionality
minimizeButton.MouseButton1Click:Connect(function() frame.Visible, maximizeButton.Visible = false, true end)

-- Maximize Functionality
maximizeButton.MouseButton1Click:Connect(function() frame.Visible, maximizeButton.Visible = true, false end)

-- Unload Functionality
unloadButton.MouseButton1Click:Connect(function() screenGui:Destroy() toggleActive = false print("Script unloaded.") end)

-- Toggle Collector Functionality
toggleButton.MouseButton1Click:Connect(function()
    toggleActive = not toggleActive
    if toggleActive then
        toggleButton.Text, toggleButton.BackgroundColor3 = "Toggle Collector (On)", Color3.fromRGB(100, 255, 100)
        -- Start checking for new instances and teleporting constantly
        while toggleActive do
            local targetObject = findNearestRock()
            if targetObject then teleportAround(targetObject) end
            wait(teleportDelay)
        end
    else
        toggleButton.Text, toggleButton.BackgroundColor3 = "Toggle Collector (Off)", Color3.fromRGB(255, 100, 100)
    end
end)

-- Update Teleport Delay
speedTextBox.FocusLost:Connect(function()
    local newDelay = tonumber(speedTextBox.Text)
    if newDelay and newDelay > 0 then
        teleportDelay = newDelay
        print("Teleport delay set to " .. teleportDelay .. " seconds.")
    else
        speedTextBox.Text = tostring(teleportDelay)
        print("Invalid input, keeping previous value.")
    end
end)
