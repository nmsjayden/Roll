-- Ensure compatibility with executors
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local potionsFolder = workspace:WaitForChild("Game"):WaitForChild("Potions")

-- Flag to pause or unpause the script
local paused = false

-- Variables to store the original position and rotation
local originalPosition = nil
local returnedToOriginalPosition = false

-- Function to toggle the pause state
local function togglePause()
    paused = not paused
    if paused then
        print("Script paused.")
        -- Disable noclip when paused
        disableCollision(player.Character, true)
    else
        print("Script resumed.")
        -- Enable noclip when resumed (if potions are still being found)
        disableCollision(player.Character, false)
    end
end

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
        if paused then
            wait(1)  -- Pause the loop for a second before checking again if paused
            continue
        end

        -- Save original position when it's first encountered
        if not originalPosition then
            originalPosition = character.PrimaryPart.Position
            print("Saved original position:", originalPosition.X, originalPosition.Y, originalPosition.Z)
        end

        local potion = findNearestPotion(character)
        if potion then
            -- Reset the flag when new potions are found
            returnedToOriginalPosition = false

            -- Enable noclip when potions are found
            disableCollision(character, false)

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
            -- If no potions are found and we haven't returned to the original position yet
            if not returnedToOriginalPosition and originalPosition then
                -- Disable noclip when no potions are found and return to original position
                character:SetPrimaryPartCFrame(CFrame.new(originalPosition))
                disableCollision(character, true)
                returnedToOriginalPosition = true
                print("No more potions found. Returned to original position.")
            end
        end
        wait(0.1) -- Try again in 0.1 seconds for fast interaction without delay
    end
end

-- Function to disable collision (noclip) for the character
local function disableCollision(character, disable)
    RunService.Stepped:Connect(function()
        if paused then return end  -- Skip if paused
        for _, v in pairs(character:GetChildren()) do
            if v:IsA("BasePart") then
                pcall(function()
                    v.CanCollide = not disable  -- Set CanCollide to false for noclip, true to disable noclip
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
    disableCollision(newCharacter, false)
end

-- Listen for character reset (re-apply teleportation and collision logic after reset)
player.CharacterAdded:Connect(onCharacterAdded)

-- Initialize script when it runs
if player.Character then
    onCharacterAdded(player.Character)
end

-- Expose the togglePause function to be used externally
return {
    togglePause = togglePause
}
