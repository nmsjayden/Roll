-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Variables
local aurasToDelete = {
    "Heat", "Flames Curse", "Dark Matter", "Frigid", "Sorcerous", "Starstruck", "Voltage",
    "Constellar", "Iridescent", "Gale", "Shiver", "Bloom", "Fiend", "Tidal", "Flame",
    "Frost", "Antimatter", "Numerical", "Orbital", "Moonlit", "Glacial", "Prism",
    "Nebula", "Cupid", "Storm", "Aurora", "Infernal", "Azure Periastron", "Gladiator",
    "Neptune", "Constellation", "Reborn", "Storm: True Form", "Omniscient", "Acceleration",
    "Grim Reaper", "Infinity", "Prismatic", "Eternal", "Serenity", "Sakura"
}
local amountToDelete, isActive, isLocked, isMinimized = "6", false, false, false

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
frame.Size, frame.Position = UDim2.new(0, 300, 0, 300), UDim2.new(0.5, -150, 0.5, -150)
frame.BackgroundColor3, frame.Active, frame.Draggable = Color3.new(0.2, 0.2, 0.2), true, true

local scrollFrame = Instance.new("ScrollingFrame", frame)
scrollFrame.Size, scrollFrame.Position = UDim2.new(0, 280, 0, 160), UDim2.new(0, 10, 0, 80)
scrollFrame.BackgroundColor3, scrollFrame.CanvasSize = Color3.new(0.1, 0.1, 0.1), UDim2.new(0, 0, 10, 0)
scrollFrame.ScrollBarThickness = 10

local auraListLabel = Instance.new("TextLabel", scrollFrame)
auraListLabel.Size = UDim2.new(1, -10, 1, 0)
auraListLabel.Position = UDim2.new(0, 5, 0, 5)
auraListLabel.Text = table.concat(aurasToDelete, "\n")
auraListLabel.TextWrapped, auraListLabel.TextYAlignment = true, Enum.TextYAlignment.Top
auraListLabel.BackgroundColor3, auraListLabel.TextColor3 = Color3.new(0.1, 0.1, 0.1), Color3.new(1, 1, 1)

local toggleButton = Instance.new("TextButton", frame)
toggleButton.Size, toggleButton.Position = UDim2.new(0, 280, 0, 40), UDim2.new(0, 10, 0, 10)
toggleButton.BackgroundColor3, toggleButton.Text = Color3.new(0.3, 0.8, 0.3), "Toggle Script: OFF"
toggleButton.MouseButton1Click:Connect(function()
    isActive = not isActive
    toggleButton.Text = "Toggle Script: " .. (isActive and "ON" or "OFF")
    toggleButton.BackgroundColor3 = isActive and Color3.new(0.3, 0.8, 0.3) or Color3.new(0.8, 0.3, 0.3)
end)

local addAuraBox = Instance.new("TextBox", frame)
addAuraBox.Size, addAuraBox.Position = UDim2.new(0, 180, 0, 30), UDim2.new(0, 10, 0, 50)
addAuraBox.PlaceholderText, addAuraBox.BackgroundColor3 = "Enter Aura Name", Color3.new(0.9, 0.9, 0.9)

local addAuraButton = Instance.new("TextButton", frame)
addAuraButton.Size, addAuraButton.Position = UDim2.new(0, 100, 0, 30), UDim2.new(0, 200, 0, 50)
addAuraButton.Text, addAuraButton.BackgroundColor3 = "Add Aura", Color3.new(0.3, 0.5, 0.8)
addAuraButton.MouseButton1Click:Connect(function()
    if addAuraBox.Text ~= "" then
        table.insert(aurasToDelete, addAuraBox.Text)
        addAuraBox.Text = ""
        auraListLabel.Text = table.concat(aurasToDelete, "\n")
    end
end)

local removeAuraBox = Instance.new("TextBox", frame)
removeAuraBox.Size, removeAuraBox.Position = UDim2.new(0, 180, 0, 30), UDim2.new(0, 10, 0, 240)
removeAuraBox.PlaceholderText, removeAuraBox.BackgroundColor3 = "Remove Aura Name", Color3.new(0.9, 0.9, 0.9)

local removeAuraButton = Instance.new("TextButton", frame)
removeAuraButton.Size, removeAuraButton.Position = UDim2.new(0, 100, 0, 30), UDim2.new(0, 200, 0, 240)
removeAuraButton.Text, removeAuraButton.BackgroundColor3 = "Remove Aura", Color3.new(0.8, 0.3, 0.3)
removeAuraButton.MouseButton1Click:Connect(function()
    for i, aura in ipairs(aurasToDelete) do
        if aura == removeAuraBox.Text then
            table.remove(aurasToDelete, i)
            break
        end
    end
    removeAuraBox.Text = ""
    auraListLabel.Text = table.concat(aurasToDelete, "\n")
end)

local minimizeButton = Instance.new("TextButton", frame)
minimizeButton.Size, minimizeButton.Position = UDim2.new(0, 40, 0, 40), UDim2.new(1, -50, 0, 10)
minimizeButton.Text, minimizeButton.BackgroundColor3 = "-", Color3.new(0.8, 0.8, 0.3)

local reopenButton = Instance.new("TextButton", gui)
reopenButton.Size, reopenButton.Position = UDim2.new(0, 50, 0, 50)
reopenButton.Text, reopenButton.Visible = "Open", false
reopenButton.BackgroundColor3, reopenButton.BackgroundTransparency = Color3.new(0.2, 0.2, 1), 0.5
reopenButton.TextColor3, reopenButton.TextSize = Color3.new(1, 1, 1), 20
reopenButton.Draggable, reopenButton.Active = true, true

minimizeButton.MouseButton1Click:Connect(function()
    isMinimized = true
    frame.Visible = false
    reopenButton.Visible = true
end)

reopenButton.MouseButton1Click:Connect(function()
    isMinimized = false
    frame.Visible = true
    reopenButton.Visible = false
end)
