-- LocalScript

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local toggle = false

-- Keybind to toggle the script
local toggleKey = Enum.KeyCode.E

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
    local humanoidMoveTo = humanoid:MoveTo(gem.Position)
    
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

-- Keybind listener
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == toggleKey then
        toggleScript()
    end
end)
