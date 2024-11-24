-- Combined GUI with Tabs for Aura Management and Potion Collector

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local potionsFolder = workspace:WaitForChild("Game"):WaitForChild("Potions")

-- Variables
local aurasToDelete = {}
local isAuraScriptActive = false
local potionCollectorActive = false
local dragging, dragStart, startPos

-- GUI Setup
local gui = Instance.new("ScreenGui")
gui.Parent = game:GetService("CoreGui")
gui.Name = "CompactAuraPotionGUI"

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 350)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = false
mainFrame.Parent = gui

-- Dragging functionality
mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

mainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Tabs
local tabsFrame = Instance.new("Frame")
tabsFrame.Size = UDim2.new(1, 0, 0, 30)
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

local potionTabButton = Instance.new("TextButton")
potionTabButton.Size = UDim2.new(0.5, -1, 1, 0)
potionTabButton.Position = UDim2.new(0.5, 1, 0, 0)
potionTabButton.Text = "Potion Collector"
potionTabButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
potionTabButton.TextColor3 = Color3.new(1, 1, 1)
potionTabButton.Parent = tabsFrame

-- Aura Management Tab
local auraTabFrame = Instance.new("Frame")
auraTabFrame.Size = UDim2.new(1, 0, 1, -30)
auraTabFrame.Position = UDim2.new(0, 0, 0, 30)
auraTabFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
auraTabFrame.Visible = true
auraTabFrame.Parent = mainFrame

-- "On" Button for Aura Management
local auraScriptToggleButton = Instance.new("TextButton")
auraScriptToggleButton.Size = UDim2.new(0.9, 0, 0, 30)
auraScriptToggleButton.Position = UDim2.new(0.05, 0, 0, 10)
auraScriptToggleButton.Text = "Aura Script: OFF"
auraScriptToggleButton.BackgroundColor3 = Color3.new(0.8, 0.3, 0.3)
auraScriptToggleButton.Parent = auraTabFrame

auraScriptToggleButton.MouseButton1Click:Connect(function()
    isAuraScriptActive = not isAuraScriptActive
    auraScriptToggleButton.Text = "Aura Script: " .. (isAuraScriptActive and "ON" or "OFF")
    auraScriptToggleButton.BackgroundColor3 = isAuraScriptActive and Color3.new(0.3, 0.8, 0.3) or Color3.new(0.8, 0.3, 0.3)
end)

-- Textbox for Aura Name
local auraTextbox = Instance.new("TextBox")
auraTextbox.Size = UDim2.new(0.9, 0, 0, 30)
auraTextbox.Position = UDim2.new(0.05, 0, 0, 50)
auraTextbox.PlaceholderText = "Enter Aura Name"
auraTextbox.BackgroundColor3 = Color3.new(0.9, 0.9, 0.9)
auraTextbox.Parent = auraTabFrame

-- Combined Add/Remove Aura Button
local addRemoveAuraButton = Instance.new("TextButton")
addRemoveAuraButton.Size = UDim2.new(0.9, 0, 0, 30)
addRemoveAuraButton.Position = UDim2.new(0.05, 0, 0, 90)
addRemoveAuraButton.Text = "Add/Remove Aura"
addRemoveAuraButton.BackgroundColor3 = Color3.new(0.3, 0.5, 0.8)
addRemoveAuraButton.Parent = auraTabFrame

-- Aura List Display
local auraListFrame = Instance.new("ScrollingFrame")
auraListFrame.Size = UDim2.new(0.9, 0, 0.6, -130)
auraListFrame.Position = UDim2.new(0.05, 0, 0, 130)
auraListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
auraListFrame.ScrollBarThickness = 8
auraListFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
auraListFrame.Parent = auraTabFrame

local auraListLayout = Instance.new("UIListLayout")
auraListLayout.Parent = auraListFrame

local function updateAuraList()
    auraListFrame:ClearAllChildren()
    for _, aura in ipairs(aurasToDelete) do
        local auraLabel = Instance.new("TextLabel")
        auraLabel.Size = UDim2.new(1, 0, 0, 20)
        auraLabel.Text = aura
        auraLabel.TextColor3 = Color3.new(1, 1, 1)
        auraLabel.BackgroundTransparency = 1
        auraLabel.Parent = auraListFrame
    end
    auraListFrame.CanvasSize = UDim2.new(0, 0, 0, #aurasToDelete * 20)
end

addRemoveAuraButton.MouseButton1Click:Connect(function()
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
        updateAuraList()
    end
end)

-- Potion Collector Tab
local potionTabFrame = Instance.new("Frame")
potionTabFrame.Size = UDim2.new(1, 0, 1, -30)
potionTabFrame.Position = UDim2.new(0, 0, 0, 30)
potionTabFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
potionTabFrame.Visible = false
potionTabFrame.Parent = mainFrame

-- Potion Collector Toggle Button
local potionCollectorButton = Instance.new("TextButton")
potionCollectorButton.Size = UDim2.new(0.9, 0, 0, 30)
potionCollectorButton.Position = UDim2.new(0.05, 0, 0, 10)
potionCollectorButton.Text = "Potion Collector: OFF"
potionCollectorButton.BackgroundColor3 = Color3.new(0.8, 0.3, 0.3)
potionCollectorButton.Parent = potionTabFrame

potionCollectorButton.MouseButton1Click:Connect(function()
    potionCollectorActive = not potionCollectorActive
    potionCollectorButton.Text = "Potion Collector: " .. (potionCollectorActive and "ON" or "OFF")
    potionCollectorButton.BackgroundColor3 = potionCollectorActive and Color3.new(0.3, 0.8, 0.3) or Color3.new(0.8, 0.3, 0.3)
end)

-- Tab Switching Logic
auraTabButton.MouseButton1Click:Connect(function()
    auraTabFrame.Visible = true
    potionTabFrame.Visible = false
end)

potionTabButton.MouseButton1Click:Connect(function()
    auraTabFrame.Visible = false
    potionTabFrame.Visible = true
end)
