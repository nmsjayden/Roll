-- LocalScript inside TextButton

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local primaryPart = character.PrimaryPart or humanoid.RootPart

local button = script.Parent -- The GUI button
local toggle = false

button.Text = "Start Collector"

-- Function to find the nearest gem (client-side only)
local function findNearestGem()
    local closestGem = nil
    local shortestDistance = math.huge

    for _, gem in pairs(workspace:GetDescendants()) do
        if gem:IsA("BasePart") and gem.Name == "Gem" then
            local distance = (primaryPart.Position - gem.Position).Magnitude
            if distance < shortestDistance then
                closestGem = gem
                shortestDistance = distance
            end
        end
    end

    return closestGem
end

-- Function to move the player to the gem
local function moveToGem(gem)
    if not gem or not primaryPart then return end

    humanoid:MoveTo(gem.Position)

    -- Wait until the player reaches the gem
    humanoid.MoveToFinished:Wait()

    -- Check for a ProximityPrompt (client-side interaction)
    if gem:FindFirstChild("ProximityPrompt") then
        fireproximityprompt(gem.ProximityPrompt)
    end

    -- Optionally highlight the gem locally (for visual feedback)
    gem.BrickColor = BrickColor.new("Bright green") -- Local-only change
end

-- Main gem collection loop
local function startCollecting()
    while toggle do
        local nearestGem = findNearestGem()
        if nearestGem then
            moveToGem(nearestGem)
        else
            print("No gems nearby!")
            break
        end
        RunService.Heartbeat:Wait() -- Wait a frame to prevent freezing
    end
end

-- Button click listener to toggle the script
button.MouseButton1Click:Connect(function()
    toggle = not toggle
    if toggle then
        button.Text = "Stop Collector"
        print("Collector Activated")
        startCollecting()
    else
        button.Text = "Start Collector"
        print("Collector Deactivated")
    end
end)
