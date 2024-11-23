-- Parent this script to StarterPlayerScripts or similar
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local toggleActive = false

-- Create GUI
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local toggleButton = Instance.new("TextButton")

toggleButton.Size = UDim2.new(0, 200, 0, 50)
toggleButton.Position = UDim2.new(0.5, -100, 0.9, 0)
toggleButton.Text = "Toggle Gem Collector (Off)"
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
toggleButton.Parent = screenGui

-- Function to find nearest gem
local function findNearestGem()
    local closestGem = nil
    local closestDistance = math.huge

    for _, obj in pairs(workspace:GetChildren()) do
        -- Ensure obj is valid and has the IsA method
        if obj and obj:IsA("BasePart") and obj.Name == "Gem" then -- Assuming Gems are BasePart instances named "Gem"
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
        print("No gems found. Retrying in 5 seconds...")
    end

    return closestGem
end

-- Function to walk to and interact with a gem
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
                    -- Simulate interaction
                    firetouchinterest(character.PrimaryPart, gem, 0) -- Begin touch
                    wait(0.1)
                    firetouchinterest(character.PrimaryPart, gem, 1) -- End touch
                end
            else
                -- Wait and retry if no gem is found
                wait(5)
            end
        end)

        if not success then
            -- Handle any errors gracefully
            print("Error during gem collection: " .. errorMessage)
            wait(5) -- Retry after a delay
        end

        wait(0.5) -- Wait briefly before checking again
    end
end

-- Toggle logic
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
