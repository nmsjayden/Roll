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
local amountToDelete, isActive = "6", false

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
frame.Size, frame.Position = UDim2.new(0, 300, 0, 200), UDim2.new(0.5, -150, 0.5, -100)
frame.BackgroundColor3, frame.Draggable, frame.Active = Color3.new(0.2, 0.2, 0.2), true, true

local toggleButton = Instance.new("TextButton", frame)
toggleButton.Size, toggleButton.Position = UDim2.new(0, 280, 0, 40), UDim2.new(0, 10, 0, 10)
toggleButton.BackgroundColor3, toggleButton.Text = Color3.new(0.3, 0.8, 0.3), "Toggle Script: OFF"
toggleButton.MouseButton1Click:Connect(function()
    isActive = not isActive
    toggleButton.Text = "Toggle Script: " .. (isActive and "ON" or "OFF")
    toggleButton.BackgroundColor3 = isActive and Color3.new(0.3, 0.8, 0.3) or Color3.new(0.8, 0.3, 0.3)
end)

local addAuraBox = Instance.new("TextBox", frame)
addAuraBox.Size, addAuraBox.Position = UDim2.new(0, 180, 0, 40), UDim2.new(0, 10, 0, 60)
addAuraBox.PlaceholderText, addAuraBox.BackgroundColor3 = "Enter Aura Name", Color3.new(0.9, 0.9, 0.9)

local confirmButton = Instance.new("TextButton", frame)
confirmButton.Size, confirmButton.Position = UDim2.new(0, 100, 0, 40), UDim2.new(0, 200, 0, 60)
confirmButton.Text, confirmButton.BackgroundColor3 = "Add Aura", Color3.new(0.3, 0.5, 0.8)
confirmButton.MouseButton1Click:Connect(function()
    if addAuraBox.Text ~= "" then
        table.insert(aurasToDelete, addAuraBox.Text)
        addAuraBox.Text = ""
    end
end)

local auraListLabel = Instance.new("TextLabel", frame)
auraListLabel.Size, auraListLabel.Position = UDim2.new(0, 280, 0, 100), UDim2.new(0, 10, 0, 110)
auraListLabel.Text, auraListLabel.TextWrapped, auraListLabel.BackgroundColor3 = 
    "Auras: " .. table.concat(aurasToDelete, ", "), true, Color3.new(0.1, 0.1, 0.1)
auraListLabel.TextColor3, auraListLabel.TextYAlignment = Color3.new(1, 1, 1), Enum.TextYAlignment.Top
