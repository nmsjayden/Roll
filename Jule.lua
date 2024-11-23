-- // Create a GUI with a toggleable script functionality
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local ToggleButton = Instance.new("TextButton")

-- // Configure GUI components
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Name = "AuraScriptGUI"

Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 200, 0, 100)
Frame.Position = UDim2.new(0.5, -100, 0.5, -50)
Frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
Frame.Active = true
Frame.Draggable = true

ToggleButton.Parent = Frame
ToggleButton.Size = UDim2.new(0, 180, 0, 50)
ToggleButton.Position = UDim2.new(0, 10, 0, 25)
ToggleButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
ToggleButton.TextColor3 = Color3.new(1, 1, 1)
ToggleButton.Font = Enum.Font.SourceSans
ToggleButton.Text = "Toggle Script: OFF"
ToggleButton.TextSize = 20

-- // Script variables
local isScriptRunning = false
local connection

-- // Define the script function
local function auraScript()
    local function a()
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
        "Nebula", "Iridescent", "Cupid", "Storm", "Aurora", "Infernal", "Azure Periastron", 
        "Gladiator", "Neptune", "Constellation", "Reborn", "Storm: True Form", "Omniscient", 
        "Acceleration", "Grim Reaper", "Infinity", "Prismatic", "Eternal", "Serenity", "Sakura"
    }
    
    local c = 0
    local amountToDelete = "6"
    
    while isScriptRunning do
        task.wait(0.1)
        game:GetService("ReplicatedStorage").Remotes.ZachRLL:InvokeServer()
        c = c + 1
        if c >= 5 then
            a()
            c = 0
        end
        task.wait(0.02)
        for _, d in ipairs(aurasToDelete) do
            game:GetService("ReplicatedStorage").Remotes.DeleteAura:FireServer(d, amountToDelete)
        end
    end
end

-- // Toggle button functionality
ToggleButton.MouseButton1Click:Connect(function()
    if isScriptRunning then
        isScriptRunning = false
        ToggleButton.Text = "Toggle Script: OFF"
        if connection then
            connection:Disconnect()
        end
    else
        isScriptRunning = true
        ToggleButton.Text = "Toggle Script: ON"
        connection = task.spawn(auraScript)
    end
end)
