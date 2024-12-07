-- Ensure compatibility with executors
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local potionsFolder = workspace:WaitForChild("Game"):WaitForChild("Potions")

-- Variables to track original position and retry failures
local originalPosition = nil
local failureCount = 0
local maxFailures = 3

-- Function to find the nearest potion (Gem, Speed Potion, Ultimate Potion, Luck Potion)
local function findNearestPotion(character)
    local closestPotion = nil
    local closestDistance = math.huge

    for _, obj in pairs(potionsFolder:GetChildren()) do
        if obj:IsA("Model") and (obj.Name == "Gem" or obj.Name == "speed_potion" or obj.Name == "ultimate_potion" or obj.Name == "luck_potion") then
            local potionPart = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
            if potionPart then
                local distance = (character.PrimaryPart.Position - potionPart.Position).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closestPotion = potionPart
                end
            end
        end
    end

    return closestPotion
end

-- Function to teleport to the potion and interact with its ProximityPrompt
local function teleportToPotionAndInteract(character)
    while true do
        local potion = findNearestPotion(character)

        if potion then
            -- Reset failure count when a potion is found
            failureCount = 0

            -- Teleport to the potion's position, slightly raised to avoid colliding with the ground
            local newPosition = potion.Position + Vector3.new(0, 5, 0)
            character:SetPrimaryPartCFrame(CFrame.new(newPosition))

            -- Interact with the ProximityPrompt near the potion
            for _, prompt in pairs(workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") and (prompt.Parent.Position - character.PrimaryPart.Position).Magnitude < 10 then
                    prompt:InputHoldBegin()
                    prompt:InputHoldEnd()
                    print("Successfully interacted with the ProximityPrompt!")
                    break
                end
            end
        else
            -- Increment failure count if no potion is found
            failureCount = failureCount + 1
            print("No potion found. Failure count: " .. failureCount)

            -- If failure count exceeds maxFailures, return to original position
            if failureCount >= maxFailures and originalPosition then
                print("Returning to original position...")
                character:SetPrimaryPartCFrame(originalPosition)
                failureCount = 0 -- Reset the failure count after returning
            end
        end

        wait(0.1) -- Try again in 0.1 seconds for fast interaction without delay
    end
end

-- Retry potion search every 10 seconds
local function retryPotionSearch(character)
    while true do
        wait(10)

        local gemCount = 0
        local speedPotionCount = 0
        local ultimatePotionCount = 0
        local luckPotionCount = 0

        for _, obj in pairs(potionsFolder:GetChildren()) do
            if obj:IsA("Model") then
                local potionPart = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                if potionPart then
                    local distance = (character.PrimaryPart.Position - potionPart.Position).Magnitude
                    if distance < 10 then
                        if obj.Name == "Gem" then
                            gemCount = gemCount + 1
                        elseif obj.Name == "speed_potion" then
                            speedPotionCount = speedPotionCount + 1
                        elseif obj.Name == "ultimate_potion" then
                            ultimatePotionCount = ultimatePotionCount + 1
                        elseif obj.Name == "luck_potion" then
                            luckPotionCount = luckPotionCount + 1
                        end
                    end
                end
            end
        end

        print("Uninteracted Gems: " .. gemCount .. ", Speed Potions: " .. speedPotionCount .. ", Ultimate Potions: " .. ultimatePotionCount .. ", Luck Potions: " .. luckPotionCount)
    end
end

-- Function to disable collision (noclip) for the character
local function disableCollision(character)
    RunService.Stepped:Connect(function()
        for _, v in pairs(character:GetChildren()) do
            if v:IsA("BasePart") then
                pcall(function()
                    v.CanCollide = false
                end)
            end
        end
    end)
end

-- Ensure teleporting starts after character is loaded
local function onCharacterAdded(newCharacter)
    -- Wait for the Humanoid to be loaded before starting interaction
    newCharacter:WaitForChild("Humanoid")

    -- Store the original position when the script is activated
    originalPosition = newCharacter.PrimaryPart.CFrame

    -- Start teleporting and interacting with potions
    coroutine.wrap(function()
        teleportToPotionAndInteract(newCharacter)
    end)()

    -- Start retrying potion search
    coroutine.wrap(function()
        retryPotionSearch(newCharacter)
    end)()

    -- Disable collisions for the character
    disableCollision(newCharacter)
end

-- Listen for character reset (re-apply teleportation and collision logic after reset)
player.CharacterAdded:Connect(onCharacterAdded)

-- Initialize script when it runs
if player.Character then
    onCharacterAdded(player.Character)
end
