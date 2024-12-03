-- Original Script Functionality
local function processAuras()
    local r = game:GetService("ReplicatedStorage")
    local f = r:FindFirstChild("Auras")
    if f then
        for _, b in pairs(f:GetChildren()) do
            r.Remotes.AcceptAura:FireServer(b.Name, true)
        end
    end
end

local aurasToDelete = {
    "Heat", "Flames Curse", "Dark Matter", "Frigid", "Sorcerous", "Starstruck", "Voltage",
    "Constellar", "Iridescent", "Gale", "Shiver", "Bloom", "Fiend", "Tidal", "Flame", 
    "Frost", "Antimatter", "Numerical", "Orbital", "Moonlit", "Glacial", "Bloom", "Prism", 
    "Nebula", "Numerical", "/|Errxr|\\", "Storm", "Storm: True Form", "GLADIATOR", 
    "Prism: True Form", "Aurora", "Iridescent: True Form", "Grim Reaper: True Form", 
    "Iridescent: True Form", "Syberis"
}
local isScriptActive = false
local amountToDelete = "6"

-- Script Toggle Behavior
local function toggleScript()
    isScriptActive = not isScriptActive
end

task.spawn(function()
    while true do
        task.wait(0.01)
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
gui.Parent = game:GetService("CoreGui")
gui.Name = "AuraControlGUI"

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 300)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
mainFrame.Draggable = true
mainFrame.Active = true
mainFrame.Parent = gui

-- Header with Hide Button
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.new(0.08, 0.08, 0.08)
header.Parent = mainFrame

local hideButton = Instance.new("TextButton")
hideButton.Size = UDim2.new(0, 30, 0, 30)
hideButton.Position = UDim2.new(1, -35, 0, 5)
hideButton.Text = "X"
hideButton.BackgroundColor3 = Color3.new(0.6, 0.6, 0.6)
hideButton.Parent = header

local showButton = Instance.new("TextButton")
showButton.Size = UDim2.new(0, 50, 0, 50)
showButton.Position = UDim2.new(0, 10, 0, 10)
showButton.Text = "+"
showButton.BackgroundColor3 = Color3.new(0.6, 0.6, 0.6)
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
toggleButton.Text = "Quick Roll: OFF"
toggleButton.BackgroundColor3 = Color3.new(0.6, 0.6, 0.6)
toggleButton.Parent = mainFrame

toggleButton.MouseButton1Click:Connect(function()
    toggleScript()
    toggleButton.Text = "Quick Roll: " .. (isScriptActive and "ON" or "OFF")
    toggleButton.BackgroundColor3 = isScriptActive and Color3.new(0.8, 0.8, 0.8) or Color3.new(0.6, 0.6, 0.6)
end)

-- Aura Management Textbox and Combined Add/Remove Button
local auraTextbox = Instance.new("TextBox")
auraTextbox.Size = UDim2.new(0.9, 0, 0, 40)
auraTextbox.Position = UDim2.new(0.05, 0, 0, 100)
auraTextbox.PlaceholderText = "Input Aura Name Here"
auraTextbox.Text = ""
auraTextbox.BackgroundColor3 = Color3.new(0.9, 0.9, 0.9)
auraTextbox.Parent = mainFrame

local addRemoveButton = Instance.new("TextButton")
addRemoveButton.Size = UDim2.new(0.9, 0, 0, 40)
addRemoveButton.Position = UDim2.new(0.05, 0, 0, 150)
addRemoveButton.Text = "Add/Remove Aura"
addRemoveButton.BackgroundColor3 = Color3.new(0.6, 0.6, 0.6)
addRemoveButton.Parent = mainFrame

-- Aura List Display
local auraListLabel = Instance.new("TextLabel")
auraListLabel.Size = UDim2.new(0.9, 0, 0, 150)
auraListLabel.Position = UDim2.new(0.05, 0, 0, 200)
auraListLabel.Text = "Auras: " .. table.concat(aurasToDelete, ", ")
auraListLabel.TextWrapped = true
auraListLabel.TextYAlignment = Enum.TextYAlignment.Top
auraListLabel.BackgroundTransparency = 1
auraListLabel.TextColor3 = Color3.new(1, 1, 1)
auraListLabel.Parent = mainFrame

-- Add/Remove Button Logic
addRemoveButton.MouseButton1Click:Connect(function()
    local auraName = auraTextbox.Text
    if auraName ~= "" then
        local found = false
        for i, aura in ipairs(aurasToDelete) do
            if aura == auraName then
                table.remove(aurasToDelete, i)
                found = true
                break
            end
        end
        if not found then
            table.insert(aurasToDelete, auraName)
        end
        auraListLabel.Text = "Auras: " .. table.concat(aurasToDelete, ", ")
    end
end)

addRemoveButton.MouseButton1Down:Connect(function()
    addRemoveButton.BackgroundColor3 = Color3.new(0.8, 0.8, 0.8)
end)

addRemoveButton.MouseButton1Up:Connect(function()
    addRemoveButton.BackgroundColor3 = Color3.new(0.6, 0.6, 0.6)
end)
