-- Ensure compatibility with executors
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local potionsFolder = workspace:WaitForChild("Game"):WaitForChild("Potions")

-- Flag to pause or unpause the script
local paused = false

-- Variables to store the original position, the state of returning, and noclip status
local originalPosition = nil
local returnedToOriginalPosition = false
local noclipEnabled = false

-- Function to toggle the pause state
local function togglePause()
    paused = not paused
    if paused then
        print("Script paused.")
        disableNoclip(player.Character)
    else
        print("Script resumed.")
        enableNoclip(player.Character)
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

        -- If the original position isn't set, save it
        if not originalPosition then
            originalPosition = character.PrimaryPart.Position
            print("Saved original position: " .. math.round(originalPosition.X) .. ", " .. math.round(originalPosition.Y) .. ", " .. math.round(originalPosition.Z))
        end

        local potion = findNearestPotion(character)
        if potion then
            -- Reset the returned flag since we found a new potion
            returnedToOriginalPosition = false

            -- Enable noclip when a potion is found
            if not noclipEnabled then
                enableNoclip(character)
                noclipEnabled = true
            end

            -- Teleport to the potion's position, slightly raised to avoid colliding with the ground
            local newPosition = potion.Position + Vector3.new(0, 5, 0) -- Adjust height to 5 studs above the potion's position
            character:SetPrimaryPartCFrame(CFrame.new(newPosition))

            -- Immediately interact with a ProximityPrompt near the potion
            local interacted = false
            for _, prompt in pairs(workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") and (prompt.Parent.Position - character.PrimaryPart.Position).Magnitude < 10 then
                    -- Trigger the ProximityPrompt interaction
                    prompt:InputHoldBegin()
                    prompt:InputHoldEnd()
                    interacted = true
                    break
                end
            end
        else
            -- If no potions are found and we haven't yet returned to the original position, teleport back
            if not returnedToOriginalPosition and originalPosition then
                character:SetPrimaryPartCFrame(CFrame.new(originalPosition))
                returnedToOriginalPosition = true
                print("No more potions found. Returned to original position.")

                -- Disable noclip when no potions are found
                if noclipEnabled then
                    disableNoclip(character)
                    noclipEnabled = false
                end
            end
        end

        wait(0.1) -- Try again in 0.1 seconds for fast interaction without delay
    end
end

-- Function to disable noclip (collisions for the character)
local function disableNoclip(character)
    RunService.Stepped:Connect(function()
        if character and not paused then
            for _, v in pairs(character:GetChildren()) do
                if v:IsA("BasePart") then
                    pcall(function()
                        v.CanCollide = true
                    end)
                end
            end
        end
    end)
end

-- Function to enable noclip (disable collisions for the character)
local function enableNoclip(character)
    RunService.Stepped:Connect(function()
        if character and not paused then
            for _, v in pairs(character:GetChildren()) do
                if v:IsA("BasePart") then
                    pcall(function()
                        v.CanCollide = false
                    end)
                end
            end
        end
    end)
end

-- Function to disable collision (noclip) for the character when the script is paused
local function disableCollision(character)
    if not paused then
        enableNoclip(character)
    else
        disableNoclip(character)
    end
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

-- Expose the togglePause function to be used externally
return {
    togglePause = togglePause
}
