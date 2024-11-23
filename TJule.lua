-- LocalScript (inside ScreenGui or TextButton)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local toggle = false
local button = script.Parent:WaitForChild("TextButton") -- Adjust this if the script is inside the TextButton
button.Text = "Start Collector"

-- Function to find the nearest gem
local function findNearestGem()
    local closestGem = nil
    local shortestDistance = math.huge
    local characterPosition = character.PrimaryPart.Position

    for _, gem in pairs(workspace:GetDescendants()) do
        if gem:IsA("BasePart") and gem.Name == "Gem" then
            local distance = (gem.Position - characterPosition).Magnitude
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
    if not gem or not character.PrimaryPart then return end
    humanoid:MoveTo(gem.Position)

    -- Wait until the player reaches the gem
    local reached = humanoid.MoveToFinished:Wait()
    if reached and gem:FindFirstChild("ProximityPrompt") then
        -- Fire the ProximityPrompt to "pick up" the Gem
        fireproximityprompt(gem.ProximityPrompt)
    end
end

-- Toggle function
local function toggleScript()
    toggle = not toggle
    button.Text = toggle and "Stop Collector" or "Start Collector"

    if toggle then
        print("Gem Collector Activated")
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
    else
        print("Gem Collector Deactivated")
    end
end

-- Button click listener
button.MouseButton1Click:Connect(function()
    toggleScript()
end)
