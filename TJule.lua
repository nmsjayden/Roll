local DataStoreService = game:GetService("DataStoreService")
local playerDataStore = DataStoreService:GetDataStore("AuraDataStore")

local function saveAuras(player, auras)
    local success, error = pcall(function()
        playerDataStore:SetAsync(tostring(player.UserId), auras) -- Save auras with the player's UserId
    end)
    if not success then
        warn("Failed to save auras for " .. player.Name .. ": " .. error)
    end
end

local function loadAuras(player)
    local auras = {}
    local success, result = pcall(function()
        return playerDataStore:GetAsync(tostring(player.UserId)) -- Retrieve saved auras using the player's UserId
    end)
    if success and result then
        auras = result
    else
        warn("Failed to load auras for " .. player.Name)
    end
    return auras
end

-- Script Functionality
local function processAuras()
    local r = game:GetService("ReplicatedStorage")
    local f = r:FindFirstChild("Auras")
    if f then
        for _, b in pairs(f:GetChildren()) do
            r.Remotes.AcceptAura:FireServer(b.Name, true)
        end
    end
end

local aurasToDelete = {}
local isScriptActive = false
local amountToDelete = "6"

-- Script Toggle Behavior
local function toggleScript()
    isScriptActive = not isScriptActive
end

task.spawn(function()
    while true do
        task.wait(0.01) -- Reduced the wait time to make it faster
        if isScriptActive then
            game:GetService("ReplicatedStorage").Remotes.ZachRLL:InvokeServer()
            processAuras()
            for _, d in ipairs(aurasToDelete) do
                game:GetService("ReplicatedStorage").Remotes.DeleteAura:FireServer(d, amountToDelete)
            end
        end
    end
end)

-- GUI Creation
local gui = Instance.new("ScreenGui")
gui.Parent = game:GetService("CoreGui") -- Prevent unloading on reset
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
hideButton.Text = "X"  -- Changed to "X" as per request
hideButton.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
hideButton.Parent = header

local showButton = Instance.new("TextButton")
showButton.Size = UDim2.new(0, 50, 0, 50)
showButton.Position = UDim2.new(0, 10, 0, 10)
showButton.Text = "+"
showButton.BackgroundColor3 = Color3.new(0.2, 0.8, 0.2)
showButton.Draggable = true
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
toggleButton.BackgroundColor3 = Color3.new(0.8, 0.3, 0.3) -- Default to red (OFF)
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
auraTextbox.PlaceholderText = "Input Aura Name Here"  -- Updated placeholder text
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
        auraTextbox.Text = ""
        saveAuras(game.Players.LocalPlayer, aurasToDelete) -- Save updated auras
    end
end)

removeButton.MouseButton1Click:Connect(function()
    for i, aura in ipairs(aurasToDelete) do
        if aura == auraTextbox.Text then
            table.remove(aurasToDelete, i)
            auraListLabel.Text = "Auras: " .. table.concat(aurasToDelete, ", ")
            auraTextbox.Text = ""
            saveAuras(game.Players.LocalPlayer, aurasToDelete) -- Save updated auras
            break
        end
    end
end)

-- Load saved auras when the player joins
game.Players.PlayerAdded:Connect(function(player)
    local savedAuras = loadAuras(player)
    if savedAuras then
        aurasToDelete = savedAuras
        auraListLabel.Text = "Auras: " .. table.concat(aurasToDelete, ", ")
    end
end)
