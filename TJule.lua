local Player = game.Players.LocalPlayer
local playerName = Player.Name
local LocalStorageService = game:GetService("LocalStorageService")

-- Key to store player-specific data
local storageKey = playerName .. "_Auras"

-- Default aura list if no saved data is found
local defaultAuras = {
    "Heat", "Flames Curse", "Dark Matter", "Frigid", "Sorcerous", "Starstruck", "Voltage",
    "Constellar", "Iridescent", "Gale", "Shiver", "Bloom", "Fiend", "Tidal", "Flame", 
    "Frost", "Antimatter", "Numerical", "Orbital", "Moonlit", "Glacial", "Bloom", "Prism", 
    "Nebula", "Iridescent", "Cupid", "Storm", "Aurora", "Infernal", "Azure Periastron", 
    "GLADIATOR", "Neptune", "Constellation", "Reborn", "Storm: True Form", "Omniscient", 
    "Acceleration", "Grim Reaper", "Infinity", "Prismatic", "Eternal", "Serenity", "Sakura"
}

-- Attempt to load saved aura list
local savedAuras = LocalStorageService:GetAsync(storageKey)

-- If no saved auras are found, use the default auras
local aurasToDelete = savedAuras or defaultAuras

local isScriptActive = false
local amountToDelete = "6"

-- Save the aura list to LocalStorage
local function saveAuras()
    local success, errorMessage = pcall(function()
        LocalStorageService:SetAsync(storageKey, aurasToDelete)
    end)
    if not success then
        warn("Failed to save aura list: " .. errorMessage)
    end
end

-- Script Toggle Behavior
local function toggleScript()
    isScriptActive = not isScriptActive
end

-- GUI Creation
local gui = Instance.new("ScreenGui")
gui.Parent = game:GetService("CoreGui")
gui.Name = "AuraControlGUI"

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
mainFrame.Draggable = true
mainFrame.Active = true
mainFrame.Visible = true
mainFrame.Parent = gui

-- Header with Hide Button
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
header.Parent = mainFrame

local hideButton = Instance.new("TextButton")
hideButton.Size = UDim2.new(0, 30, 0, 30)
hideButton.Position = UDim2.new(1, -35, 0, 5)
hideButton.Text = "X"
hideButton.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
hideButton.Parent = header

local showButton = Instance.new("TextButton")
showButton.Size = UDim2.new(0, 50, 0, 50)
showButton.Position = UDim2.new(0, 10, 0, 10)
showButton.Text = "+"
showButton.BackgroundColor3 = Color3.new(0.2, 0.8, 0.2)
showButton.Visible = false
showButton.Parent = gui

hideButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    hideButton.Visible = false
    showButton.Visible = true
end)

showButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    hideButton.Visible = true
    showButton.Visible = false
end)

-- Script Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0.9, 0, 0, 40)
toggleButton.Position = UDim2.new(0.05, 0, 0, 50)
toggleButton.Text = "Toggle Script: OFF"
toggleButton.BackgroundColor3 = Color3.new(0.8, 0.3, 0.3)
toggleButton.Parent = mainFrame

toggleButton.MouseButton1Click:Connect(function()
    toggleScript()
    toggleButton.Text = "Toggle Script: " .. (isScriptActive and "ON" or "OFF")
    toggleButton.BackgroundColor3 = isScriptActive and Color3.new(0.3, 0.8, 0.3) or Color3.new(0.8, 0.3, 0.3)
end)

-- Aura Management Textbox and Buttons
local auraTextbox = Instance.new("TextBox")
auraTextbox.Size = UDim2.new(0.9, 0, 0, 40)
auraTextbox.Position = UDim2.new(0.05, 0, 0, 100)
auraTextbox.PlaceholderText = "Input Aura Name Here"
auraTextbox.BackgroundColor3 = Color3.new(0.9, 0.9, 0.9)
auraTextbox.Parent = mainFrame

local addButton = Instance.new("TextButton")
addButton.Size = UDim2.new(0.45, -5, 0, 40)
addButton.Position = UDim2.new(0.05, 0, 0, 150)
addButton.Text = "Add Aura"
addButton.BackgroundColor3 = Color3.new(0.3, 0.5, 0.8)
addButton.Parent = mainFrame

local removeButton = Instance.new("TextButton")
removeButton.Size = UDim2.new(0.45, -5, 0, 40)
removeButton.Position = UDim2.new(0.5, 5, 0, 150)
removeButton.Text = "Remove Aura"
removeButton.BackgroundColor3 = Color3.new(0.8, 0.3, 0.3)
removeButton.Parent = mainFrame

-- Aura List
local auraListLabel = Instance.new("TextLabel")
auraListLabel.Size = UDim2.new(0.9, 0, 0, 150)
auraListLabel.Position = UDim2.new(0.05, 0, 0, 200)
auraListLabel.Text = "Auras: " .. table.concat(aurasToDelete, ", ")
auraListLabel.TextWrapped = true
auraListLabel.TextYAlignment = Enum.TextYAlignment.Top
auraListLabel.BackgroundTransparency = 1
auraListLabel.TextColor3 = Color3.new(1, 1, 1)
auraListLabel.Parent = mainFrame

-- Add/Remove Button Functionality
addButton.MouseButton1Click:Connect(function()
    if auraTextbox.Text ~= "" then
        table.insert(aurasToDelete, auraTextbox.Text)
        auraListLabel.Text = "Auras: " .. table.concat(aurasToDelete, ", ")
        saveAuras()  -- Save aura list to LocalStorage
        auraTextbox.Text = ""
    end
end)

removeButton.MouseButton1Click:Connect(function()
    for i, aura in ipairs(aurasToDelete) do
        if aura == auraTextbox.Text then
            table.remove(aurasToDelete, i)
            auraListLabel.Text = "Auras: " .. table.concat(aurasToDelete, ", ")
            saveAuras()  -- Save aura list to LocalStorage
            auraTextbox.Text = ""
            break
        end
    end
end)
