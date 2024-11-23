-- Client-Side Script (For Player)
local player = game.Players.LocalPlayer
local playerId = tostring(player.UserId)  -- Player's UserId as unique identifier for saving
local DataStoreKey = playerId .. "_Auras" -- Unique key to save auras
local aurasToDelete = {}  -- Table for storing auras
local isScriptActive = false  -- To toggle the script's activity
local amountToDelete = "6"  -- Amount to delete each time

-- Helper function to load saved auras
local function loadAuras()
    local savedData = game:GetService("PlayerStorage"):GetAsync(DataStoreKey)
    if savedData then
        aurasToDelete = savedData
    end
end

-- Helper function to save auras
local function saveAuras()
    -- Use PlayerStorage to save the data locally (this can be used for mobile)
    game:GetService("PlayerStorage"):SetAsync(DataStoreKey, aurasToDelete)
end

-- Load saved auras when the player joins
loadAuras()

-- GUI and Script logic
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

-- Header with Hide/Show Button
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
header.Parent = mainFrame

local hideButton = Instance.new("TextButton")
hideButton.Size = UDim2.new(0, 30, 0, 30)
hideButton.Position = UDim2.new(1, -35, 0, 5)
hideButton.Text = "X"  -- Close button
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

-- Function to hide the GUI
hideButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    hideButton.Visible = false
    showButton.Visible = true
end)

-- Function to show the GUI
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

-- Toggle the script on/off
toggleButton.MouseButton1Click:Connect(function()
    isScriptActive = not isScriptActive
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
        auraTextbox.Text = ""
        saveAuras() -- Save the updated list
    end
end)

removeButton.MouseButton1Click:Connect(function()
    for i, aura in ipairs(aurasToDelete) do
        if aura == auraTextbox.Text then
            table.remove(aurasToDelete, i)
            auraListLabel.Text = "Auras: " .. table.concat(aurasToDelete, ", ")
            auraTextbox.Text = ""
            saveAuras() -- Save the updated list
            break
        end
    end
end)

-- Process Auras (Script Loop)
local function processAuras()
    local r = game:GetService("ReplicatedStorage")
    local f = r:FindFirstChild("Auras")
    if f then
        for _, b in pairs(f:GetChildren()) do
            r.Remotes.AcceptAura:FireServer(b.Name, true)
        end
    end
end

task.spawn(function()
    while true do
        task.wait(0.01) -- Faster
        if isScriptActive then
            game:GetService("ReplicatedStorage").Remotes.ZachRLL:InvokeServer()
            processAuras()
            for _, d in ipairs(aurasToDelete) do
                game:GetService("ReplicatedStorage").Remotes.DeleteAura:FireServer(d, amountToDelete)
            end
        end
    end
end)
