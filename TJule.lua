-- Ensure compatibility with executors
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local potionsFolder = workspace:WaitForChild("Game"):WaitForChild("Potions")

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

-- Function to teleport to the potion and instantly interact with its ProximityPrompt
local function teleportToPotionAndInteract(character)
    while true do
        local potion = findNearestPotion(character)
        if potion then
            -- Teleport to the potion's position, slightly raised to avoid colliding with the ground
            local newPosition = potion.Position + Vector3.new(0, 5, 0) -- Adjust height to 5 studs above the potion's position
            character:SetPrimaryPartCFrame(CFrame.new(newPosition))

            -- Immediately interact with a ProximityPrompt near the potion
            local interacted = false
            for _, prompt in pairs(workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") and (prompt.Parent.Position - character.PrimaryPart.Position).Magnitude < 10 then
                    -- Trigger the ProximityPrompt interaction as quickly as possible
                    prompt:InputHoldBegin()
                    prompt:InputHoldEnd() -- Instantly trigger the interaction without delay
                    interacted = true
                    break
                end
            end

            if interacted then
                print("Successfully interacted with the ProximityPrompt!")
            end
        end
        wait(0.1) -- Try again in 0.1 seconds for fast interaction without delay
    end
end

-- Retry potion search every 10 seconds
local function retryPotionSearch(character)
    while true do
        wait(10) -- Retry searching for items every 10 seconds
        local gemCount = 0
        local speedPotionCount = 0
        local ultimatePotionCount = 0
        local luckPotionCount = 0

        -- Count all uninteracted potions (Gem, Speed, Ultimate, Luck)
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

        -- Output the count of uninteracted potions to the console
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
