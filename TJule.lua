-- Function to find the nearest potion (Gem, Speed Potion, Ultimate Potion, Luck Potion)
local function findNearestPotion(character)
    local closestPotion = nil
    local closestDistance = math.huge
    local characterPosition = character.PrimaryPart.Position

    -- Loop through all potions and find the closest one
    for _, obj in pairs(potionsFolder:GetChildren()) do
        if obj:IsA("Model") and (obj.Name == "Gem" or obj.Name == "speed_potion" or obj.Name == "ultimate_potion" or obj.Name == "luck_potion") then
            local potionPart = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
            if potionPart then
                local distance = (characterPosition - potionPart.Position).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closestPotion = potionPart
                end
            end
        end
    end

    -- Return the closest potion part or nil if no potion found
    return closestPotion
end

-- Function to teleport to the potion and instantly interact with its ProximityPrompt
local function teleportToPotionAndInteract(character)
    while toggleActive do
        local potion = findNearestPotion(character)
        if potion then
            -- Teleport to the potion's position, slightly raised to avoid colliding with the ground
            local newPosition = potion.Position + Vector3.new(0, 1, 0) -- Adjust height to avoid collision
            character:SetPrimaryPartCFrame(CFrame.new(newPosition))

            -- Check for ProximityPrompts nearby and interact with the nearest one
            local interacted = false
            local characterPosition = character.PrimaryPart.Position
            for _, prompt in pairs(workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") then
                    local distance = (prompt.Parent.Position - characterPosition).Magnitude
                    if distance < 10 then
                        -- Interact with the ProximityPrompt instantly without delay
                        prompt:InputHoldBegin()
                        prompt:InputHoldEnd()  -- Instantly trigger the interaction
                        interacted = true
                        break
                    end
                end
            end

            -- Feedback on interaction
            if interacted then
                print("Successfully interacted with the ProximityPrompt!")
            end
        end
        wait(0.1) -- Small delay for fast interaction loop
    end
end

-- Toggle to activate/deactivate potion collection
local toggleActive = false

-- Function to toggle potion collection
local function togglePotionScript(state)
    toggleActive = state
    local character = game.Players.LocalPlayer.Character
    if character then
        -- Start the potion collection when activated
        if toggleActive then
            teleportToPotionAndInteract(character)
        end
    end
end

-- Example button toggle in the GUI (integrate this with your UI framework)
Tabs.Main:CreateToggle("Potion Collector Toggle", {
    Title = "Activate Potion Collector",
    Default = false, 
    Callback = togglePotionScript
})
