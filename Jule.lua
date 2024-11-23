-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Variables
local aurasToDelete = {
    "Heat", "Flames Curse", "Dark Matter", "Frigid", "Sorcerous", "Starstruck", "Voltage", 
    "Constellar", "Iridescent", "Gale", "Shiver", "Bloom", "Fiend", "Tidal", "Flame", 
    "Frost", "Antimatter", "Numerical", "Orbital", "Moonlit", "Glacial", "Bloom", "Prism", 
    "Nebula", "Iridescent", "Cupid", "Storm", "Aurora", "Infernal", "Azure Periastron", 
    "Gladiator", "Neptune", "Constellation", "Reborn", "Storm: True Form", "Omniscient", 
    "Acceleration", "Grim Reaper", "Infinity", "Prismatic", "Eternal", "Serenity", "Sakura"
}
local amountToDelete, isActive, isLocked = "6", false, false
local guiMinimized = false

-- Functions
local function processAuras()
    local auraFolder = ReplicatedStorage:FindFirstChild("Auras")
    if auraFolder then
        for _, aura in pairs(auraFolder:GetChildren()) do
            ReplicatedStorage.Remotes.AcceptAura:FireServer(aura.Name, true)
        end
    end
    for _, aura in ipairs(aurasToDelete) do
        ReplicatedStorage.Remotes.DeleteAura:FireServer(aura, amountToDelete)
    end
end

task.spawn(function()
    while task.wait(0.1) do
        if isActive then
            ReplicatedStorage.Remotes.ZachRLL:InvokeServer()
            processAuras()
        end
    end
end)

-- GUI Setup
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "AuraControlGUI"

local frame = Instance.new("Frame", gui)
frame.Size, frame.Position = UDim2.new(0, 300, 0, 400), UDim2.new(0.5, -150, 0.5, -200)
frame.BackgroundColor3, frame.Draggable, frame.Active = Color3.new(0.2, 0.2, 0.2), true, true

local header = Instance.new("Frame", frame)
header.Size, header.Position = UDim2.new(1, 0, 0, 40), UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)

local closeButton = Instance.new("TextButton", header)
closeButton.Size, closeButton.Position = UDim2.new(0, 30, 0, 30), UDim2.new(1, -35, 0, 5)
closeButton.Text, closeButton.BackgroundColor3 = "X", Color3.new(0.8, 0.2, 0.2)
closeButton.MouseButton1Click:Connect(function()
    guiMinimized = true
    frame.Visible = false
    lockButton.Visible = true
end)

local toggleButton = Instance.new("TextButton", header)
toggleButton.Size, toggleButton.Position = UDim2.new(0.9, -50, 0, 30), UDim2.new(0.05, 10, 0, 5)
toggleButton.BackgroundColor3, toggleButton.Text = Color3.new(0.3, 0.8, 0.3), "Toggle Script: OFF"
toggleButton.MouseButton1Click:Connect(function()
    isActive = not isActive
    toggleButton.Text = "Toggle Script: " .. (isActive and "ON" or "OFF")
    toggleButton.BackgroundColor3 = isActive and Color3.new(0.3, 0.8, 0.3) or Color3.new(0.8, 0.3, 0.3)
end)

local scrollFrame = Instance.new("ScrollingFrame", frame)
scrollFrame.Size, scrollFrame.Position = UDim2.new(1, 0, 1, -140), UDim2.new(0, 0, 0, 140)
scrollFrame.CanvasSize = UDim2.new(0, 0, 2, 0)
scrollFrame.ScrollBarThickness = 10
scrollFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)

local auraListLabel = Instance.new("TextLabel", scrollFrame)
auraListLabel.Size = UDim2.new(1, -10, 0, 200)
auraListLabel.Text, auraListLabel.TextWrapped = "Auras: " .. table.concat(aurasToDelete, ", "), true
auraListLabel.TextYAlignment, auraListLabel.BackgroundTransparency = Enum.TextYAlignment.Top, 1
auraListLabel.TextColor3 = Color3.new(1, 1, 1)

local addAuraBox = Instance.new("TextBox", frame)
addAuraBox.Size, addAuraBox.Position = UDim2.new(0.6, 0, 0, 30), UDim2.new(0.05, 0, 0, 300)
addAuraBox.PlaceholderText, addAuraBox.BackgroundColor3 = "Enter Aura Name", Color3.new(0.9, 0.9, 0.9)

local confirmButton = Instance.new("TextButton", frame)
confirmButton.Size, confirmButton.Position = UDim2.new(0.3, 0, 0, 30), UDim2.new(0.7, 0, 0, 300)
confirmButton.Text, confirmButton.BackgroundColor3 = "Add Aura", Color3.new(0.3, 0.5, 0.8)
confirmButton.MouseButton1Click:Connect(function()
    if addAuraBox.Text ~= "" then
        table.insert(aurasToDelete, addAuraBox.Text)
        auraListLabel.Text = "Auras: " .. table.concat(aurasToDelete, ", ")
        addAuraBox.Text = ""
    end
end)

local removeAuraBox = Instance.new("TextBox", frame)
removeAuraBox.Size, removeAuraBox.Position = UDim2.new(0.6, 0, 0, 30), UDim2.new(0.05, 0, 0, 340)
removeAuraBox.PlaceholderText, removeAuraBox.BackgroundColor3 = "Remove Aura Name", Color3.new(0.9, 0.9, 0.9)

local removeButton = Instance.new("TextButton", frame)
removeButton.Size, removeButton.Position = UDim2.new(0.3, 0, 0, 30), UDim2.new(0.7, 0, 0, 340)
removeButton.Text, removeButton.BackgroundColor3 = "Remove Aura", Color3.new(0.8, 0.3, 0.3)
removeButton.MouseButton1Click:Connect(function()
    for i, aura in ipairs(aurasToDelete) do
        if aura == removeAuraBox.Text then
            table.remove(aurasToDelete, i)
            auraListLabel.Text = "Auras: " .. table.concat(aurasToDelete, ", ")
            removeAuraBox.Text = ""
            break
        end
    end
end)

local lockButton = Instance.new("TextButton", gui)
lockButton.Size, lockButton.Position = UDim2.new(0, 50, 0, 50), UDim2.new(0, 10, 0, 10)
lockButton.Text, lockButton.BackgroundColor3 = "Lock", Color3.new(0.5, 0.5, 0.5)
lockButton.MouseButton1Click:Connect(function()
    isLocked = not isLocked
    frame.Draggable = not isLocked
    lockButton.Text = isLocked and "Unlock" or "Lock"
end)

local maximizeButton = Instance.new("TextButton", gui)
maximizeButton.Size, maximizeButton.Position = UDim2.new(0, 50, 0, 50), UDim2.new(0, 10, 0, 70)
maximizeButton.Text, maximizeButton.Visible = "+", false
maximizeButton.BackgroundColor3 = Color3.new(0.5, 0.5, 0.5)
maximizeButton.MouseButton1Click:Connect(function()
    guiMinimized = false
    frame.Visible = true
    lockButton.Visible = false
end)
