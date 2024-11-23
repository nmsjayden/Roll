-- LocalScript inside TextButton

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local primaryPart = character.PrimaryPart or humanoid.RootPart

local button = script.Parent -- The button this script is inside
local toggle = false

button.Text = "Start Collector"

-- Function to find the nearest gem
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

-- Function to move to the gem
local function moveToGem(gem)
    if not gem or not primaryPart then return end
    humanoid:MoveTo(gem.Position)

    -- Wait until the player reaches the gem
    humanoid.MoveToFinished:Wait()
    if gem:FindFirstChild("ProximityPrompt") then
        -- Fire the ProximityPrompt to "pick up" the Gem
        fireproximityprompt(gem.ProximityPrompt)
    elseif gem.Parent then
        -- If no ProximityPrompt, assume "pickup" means destroying or parenting the gem
        gem:Destroy()
    end
end

-- Main collection loop
local function startCollecting()
    while toggle do
        local nearestGem = findNearestGem()
        if nearestGem then
            moveToGem(nearestGem)
        else
            print("No gems found!")
            break
        end
        RunService.Heartbeat:Wait()
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
