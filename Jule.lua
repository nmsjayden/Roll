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
local amountToDelete = "6"
local isActive = false -- Toggle for the script

-- Functions
local function a()
    local auraFolder = ReplicatedStorage:FindFirstChild("Auras")
    if auraFolder then
        for _, aura in pairs(auraFolder:GetChildren()) do
            ReplicatedStorage.Remotes.AcceptAura:FireServer(aura.Name, true)
        end
    end
end

-- Main Script Execution
task.spawn(function()
    local c = 0
    while task.wait(0.1) do
        if not isActive then continue end

        ReplicatedStorage.Remotes.ZachRLL:InvokeServer()
        c = c + 1
        if c >= 5 then
            a()
            c = 0
        end
        task.wait(0.02)
        for _, aura in ipairs(aurasToDelete) do
            ReplicatedStorage.Remotes.DeleteAura:FireServer(aura, amountToDelete)
        end
    end
end)

-- GUI Setup
local gui = Instance.new("ScreenGui")
local frame = Instance.new("Frame")
local toggleButton = Instance.new("TextButton")
local addAuraBox = Instance.new("TextBox")
local confirmButton = Instance.new("TextButton")
local auraListLabel = Instance.new("TextLabel")

gui.Name = "AuraControlGUI"
gui.Parent = CoreGui -- Parent to CoreGui to persist across resets

frame.Name = "MainFrame"
frame.Parent = gui
frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
frame.Size = UDim2.new(0, 300, 0, 250)
frame.Position = UDim2.new(0.5, -150, 0.5, -125)
frame.Active = true
frame.Draggable = true

toggleButton.Name = "ToggleButton"
toggleButton.Parent = frame
toggleButton.Text = "Toggle Script: OFF"
toggleButton.Size = UDim2.new(0, 280, 0, 50)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.BackgroundColor3 = Color3.new(0.3, 0.8, 0.3)
toggleButton.MouseButton1Click:Connect(function()
    isActive = not isActive
    toggleButton.Text = "Toggle Script: " .. (isActive and "ON" or "OFF")
    toggleButton.BackgroundColor3 = isActive and Color3.new(0.3, 0.8, 0.3) or Color3.new(0.8, 0.3, 0.3)
end)

addAuraBox.Name = "AddAuraBox"
addAuraBox.Parent = frame
addAuraBox.PlaceholderText = "Enter Aura Name"
addAuraBox.Text = ""
addAuraBox.Size = UDim2.new(0, 180, 0, 40)
addAuraBox.Position = UDim2.new(0, 10, 0, 70)
addAuraBox.BackgroundColor3 = Color3.new(0.9, 0.9, 0.9)

confirmButton.Name = "ConfirmButton"
confirmButton.Parent = frame
confirmButton.Text = "Add Aura"
confirmButton.Size = UDim2.new(0, 100, 0, 40)
confirmButton.Position = UDim2.new(0, 200, 0, 70)
confirmButton.BackgroundColor3 = Color3.new(0.3, 0.5, 0.8)
confirmButton.MouseButton1Click:Connect(function()
    local newAura = addAuraBox.Text
    if newAura and newAura ~= "" then
        table.insert(aurasToDelete, newAura)
        print("Added Aura:", newAura)
        addAuraBox.Text = "" -- Clear input field
        auraListLabel.Text = "Auras: " .. table.concat(aurasToDelete, ", ")
    end
end)

auraListLabel.Name = "AuraListLabel"
auraListLabel.Parent = frame
auraListLabel.Text = "Auras: " .. table.concat(aurasToDelete, ", ")
auraListLabel.Size = UDim2.new(0, 280, 0, 80)
auraListLabel.Position = UDim2.new(0, 10, 0, 120)
auraListLabel.TextWrapped = true
auraListLabel.TextYAlignment = Enum.TextYAlignment.Top
auraListLabel.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
auraListLabel.TextColor3 = Color3.new(1, 1, 1)
