-- Ensure compatibility with executors
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local potionsFolder = workspace:WaitForChild("Game"):WaitForChild("Potions")

-- Variables to store the original position and rotation (facing direction)
local originalPosition = nil
local originalRotation = nil
local returnedToOriginalPosition = false

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
        -- If the original position isn't set, save it along with facing direction
        if not originalPosition then
            originalPosition = character.PrimaryPart.Position
            originalRotation = character.PrimaryPart.CFrame.Rotation
            print("Saved original position and facing direction.")
        end

        -- Find the nearest potion
        local potion = findNearestPotion(character)

        if potion then
            -- Reset the returned flag since we found a new potion
            returnedToOriginalPosition = false

            -- Teleport to the potion's position, slightly raised to avoid colliding with the ground
            local newPosition = potion.Position + Vector3.new(0, 5, 0) -- Adjust height to 5 studs above the potion's position
            character:SetPrimaryPartCFrame(CFrame.new(newPosition))

            -- Immediately interact with a ProximityPrompt near the potion
            for _, prompt in pairs(workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") and (prompt.Parent.Position - character.PrimaryPart.Position).Magnitude < 10 then
                    -- Trigger the ProximityPrompt interaction
                    prompt:InputHoldBegin()
                    prompt:InputHoldEnd()
                    break
                end
            end
        else
            -- If no potions are found and we haven't yet returned to the original position, teleport back
            if not returnedToOriginalPosition and originalPosition then
                character:SetPrimaryPartCFrame(CFrame.new(originalPosition) * CFrame.fromEulerAnglesXYZ(0, originalRotation.Y, 0))
                returnedToOriginalPosition = true
                print("No more potions found. Returned to original position and facing direction.")
            end
        end

        wait(0.1) -- Try again in 0.1 seconds for fast interaction without delay
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

    -- Disable collisions for the character
    disableCollision(newCharacter)
end

-- Listen for character reset (re-apply teleportation and collision logic after reset)
player.CharacterAdded:Connect(onCharacterAdded)

-- Initialize script when it runs
if player.Character then
    onCharacterAdded(player.Character)
end
