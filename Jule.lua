local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Variables
local scriptRunning = false
local aurasToDelete = {"Heat", "Flames Curse", "Dark Matter", "Frigid", "Sorcerous", "Starstruck", "Voltage", "Constellar", "Iridescent", "Gale", "Shiver", "Bloom", "Fiend", "Tidal", "Flame", "Frost", "Antimatter", "Numerical", "Orbital", "Moonlit", "Glacial", "Bloom", "Prism", "Nebula", "Iridescent", "Cupid", "Storm", "Aurora", "Infernal", "Azure Periastron", "Gladiator", "Neptune", "Constellation", "Reborn", "Storm: True Form", "Omniscient", "Acceleration", "Grim Reaper", "Infinity", "Prismatic", "Eternal", "Serenity", "Sakura"}
local amountToDelete = "6"

-- Function to process auras
local function processAuras()
    local f = ReplicatedStorage:FindFirstChild("Auras")
    if f then
        for _, b in pairs(f:GetChildren()) do
            ReplicatedStorage.Remotes.AcceptAura:FireServer(b.Name, true)
        end
    end
end

-- Main script loop
local function mainScript()
    local c = 0
    while scriptRunning do
        task.wait(0.1)
        ReplicatedStorage.Remotes.ZachRLL:InvokeServer()
        c = c + 1
        if c >= 5 then
            processAuras()
            c = 0
        end
        task.wait(0.02)
        for _, d in ipairs(aurasToDelete) do
            ReplicatedStorage.Remotes.DeleteAura:FireServer(d, amountToDelete)
        end
    end
end

-- GUI Creation
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local ToggleButton = Instance.new("TextButton")
local AddAuraLabel = Instance.new("TextLabel")
local AddAuraInput = Instance.new("TextBox")
local ConfirmButton = Instance.new("TextButton")

-- GUI Properties
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

Frame.Size = UDim2.new(0, 300, 0, 200)
Frame.Position = UDim2.new(0.5, -150, 0.5, -100)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

ToggleButton.Size = UDim2.new(0, 200, 0, 50)
ToggleButton.Position = UDim2.new(0, 50, 0, 20)
ToggleButton.Text = "Start Script"
ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 200, 100)
ToggleButton.Parent = Frame

AddAuraLabel.Size = UDim2.new(0, 200, 0, 20)
AddAuraLabel.Position = UDim2.new(0, 50, 0, 80)
AddAuraLabel.Text = "Add Aura to Delete:"
AddAuraLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
AddAuraLabel.BackgroundTransparency = 1
AddAuraLabel.Parent = Frame

AddAuraInput.Size = UDim2.new(0, 200, 0, 30)
AddAuraInput.Position = UDim2.new(0, 50, 0, 110)
AddAuraInput.PlaceholderText = "Enter Aura Name"
AddAuraInput.Parent = Frame

ConfirmButton.Size = UDim2.new(0, 200, 0, 50)
ConfirmButton.Position = UDim2.new(0, 50, 0, 150)
ConfirmButton.Text = "Confirm"
ConfirmButton.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
ConfirmButton.Parent = Frame

-- GUI Functionality
ToggleButton.MouseButton1Click:Connect(function()
    scriptRunning = not scriptRunning
    if scriptRunning then
        ToggleButton.Text = "Stop Script"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
        task.spawn(mainScript)
    else
        ToggleButton.Text = "Start Script"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 200, 100)
    end
end)

ConfirmButton.MouseButton1Click:Connect(function()
    local newAura = AddAuraInput.Text
    if newAura ~= "" then
        table.insert(aurasToDelete, newAura)
        AddAuraInput.Text = ""
        print("Added aura to delete: " .. newAura)
    end
end)
