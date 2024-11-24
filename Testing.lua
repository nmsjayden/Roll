-- Combined GUI with Tabs for Aura Management and Potion Collector

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local potionsFolder = workspace:WaitForChild("Game"):WaitForChild("Potions")

-- Variables
local aurasToDelete = {
    "Heat", "Flames Curse", "Dark Matter", "Frigid", "Sorcerous", "Starstruck", "Voltage",
    "Constellar", "Iridescent", "Gale", "Shiver", "Bloom", "Fiend", "Tidal", "Flame",
    "Frost", "Antimatter", "Numerical", "Orbital", "Moonlit", "Glacial", "Prism",
    "Nebula", "Cupid", "Storm", "Aurora", "Infernal", "Azure Periastron", "GLADIATOR",
    "Neptune", "Constellation", "Reborn", "Storm: True Form", "Omniscient", "Acceleration",
    "Grim Reaper", "Infinity", "Prismatic", "Eternal", "Serenity", "Sakura"
}
local isAuraScriptActive = false
local potionCollectorActive = false

-- GUI Setup
local gui = Instance.new("ScreenGui")
gui.Parent = game:GetService("CoreGui")
gui.Name = "CombinedGUI"

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 500)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui

-- Tabs
local tabsFrame = Instance.new("Frame")
tabsFrame.Size = UDim2.new(1, 0, 0, 40)
tabsFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
tabsFrame.BorderSizePixel = 0
tabsFrame.Parent = mainFrame

local auraTabButton = Instance.new("TextButton")
auraTabButton.Size = UDim2.new(0.5, -1, 1, 0)
auraTabButton.Position = UDim2.new(0, 0, 0, 0)
auraTabButton.Text = "Aura Management"
auraTabButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
auraTabButton.TextColor3 = Color3.new(1, 1, 1)
auraTabButton.Parent = tabsFrame

local potion
