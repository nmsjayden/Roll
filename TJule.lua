-- This script assumes it's running in Roblox Studio and allows file system access via writefile() and makefolder()

-- Aura Data Setup
local aurasToDelete = {
    "Heat", "Flames Curse", "Dark Matter", "Frigid", "Sorcerous", "Starstruck", "Voltage",
    "Constellar", "Iridescent", "Gale", "Shiver", "Bloom", "Fiend", "Tidal", "Flame", 
    "Frost", "Antimatter", "Numerical", "Orbital", "Moonlit", "Glacial", "Bloom", "Prism", 
    "Nebula", "Iridescent", "Cupid", "Storm", "Aurora", "Infernal", "Azure Periastron", 
    "GLADIATOR", "Neptune", "Constellation", "Reborn", "Storm: True Form", "Omniscient", 
    "Acceleration", "Grim Reaper", "Infinity", "Prismatic", "Eternal", "Serenity", "Sakura"
}

-- File and Folder Setup
local folderName = "Jule"
local fileName = "AuraList.txt"

-- Create folder and file if they don't exist
local function createFolderAndFile()
    local success, errorMessage = pcall(function()
        -- Create folder if it doesn't exist
        if not isfolder(folderName) then
            makefolder(folderName)
        end
        -- Create file if it doesn't exist
        if not isfile(folderName .. "/" .. fileName) then
            writefile(folderName .. "/" .. fileName, table.concat(aurasToDelete, "\n"))
        end
    end)

    if not success then
        warn("Failed to create folder or file: " .. errorMessage)
    end
end

-- Load Aura List from the file
local function loadAurasFromFile()
    local success, storedAuras = pcall(function()
        return readfile(folderName .. "/" .. fileName)
    end)

    if success then
        -- Split file content into a list and update aurasToDelete
        aurasToDelete = {}
        for aura in storedAuras:gmatch("[^\r\n]+") do
            table.insert(aurasToDelete, aura)
        end
    else
        warn("Failed to load aura list: " .. storedAuras)
    end
end

-- Save Aura List to the file
local function saveAurasToFile()
    local success, errorMessage = pcall(function()
        writefile(folderName .. "/" .. fileName, table.concat(aurasToDelete, "\n"))
    end)

    if not success then
        warn("Failed to save aura list: " .. errorMessage)
    end
end

-- GUI and Script Setup (as in the original script)
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

-- Call createFolderAndFile() to ensure the folder and file exist when the script starts
createFolderAndFile()
loadAurasFromFile() -- Load previously saved auras

-- GUI Creation and Aura Management as before (this part remains unchanged)
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

-- Header with Hide Button
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
header.Parent = mainFrame

local hideButton = Instance.new("TextButton")
hideButton.Size = UDim2.new(0, 30, 0, 30)
hideButton.Position = UDim2.new(1, -35, 0, 5)
hideButton.Text = "X"
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

-- Hide and Show Button Functionality
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
toggleButton.Text = "Toggle Script: OFF"
toggleButton.BackgroundColor3 = Color3.new(0.8, 0.3, 0.3)
toggleButton.Parent = mainFrame

toggleButton.MouseButton1Click:Connect(function()
    toggleScript()
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
auraListLabel.Size = UDim2.new(0.9, 0, 0, 200)
auraListLabel.Position = UDim2.new(0.05, 0, 0, 200)
auraListLabel.Text = "Auras: " .. table.concat(aurasToDelete, ", ")
auraListLabel.BackgroundColor3 = Color3.new(0.9, 0.9, 0.9)
auraListLabel.Parent = mainFrame

-- Add Aura Button Logic
addButton.MouseButton1Click:Connect(function()
    local auraName = auraTextbox.Text
    if auraName ~= "" and not table.find(aurasToDelete, auraName) then
        table.insert(aurasToDelete, auraName)
        auraTextbox.Text = ""
        saveAurasToFile()  -- Save to file after adding
        auraListLabel.Text = "Auras: " .. table.concat(aurasToDelete, ", ")
    end
end)

-- Remove Aura Button Logic
removeButton.MouseButton1Click:Connect(function()
    local auraName = auraTextbox.Text
    local index = table.find(aurasToDelete, auraName)
    if index then
        table.remove(aurasToDelete, index)
        auraTextbox.Text = ""
        saveAurasToFile()  -- Save to file after removing
        auraListLabel.Text = "Auras: " .. table.concat(aurasToDelete, ", ")
    end
end)
