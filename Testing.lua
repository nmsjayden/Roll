local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local SaveManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/SaveManager.luau"))()
local InterfaceManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/InterfaceManager.luau"))()

local Window = Library:CreateWindow{
    Title = `Fluent {Library.Version}`,
    SubTitle = "by Actual Master Oogway",
    TabWidth = 160,
    Size = UDim2.fromOffset(830, 525),
    Resize = true,
    MinSize = Vector2.new(470, 380),
    Acrylic = true,
    Theme = "Dark",
}

-- Create the tabs
local Tabs = {
    Main = Window:CreateTab{ Title = "Main", Icon = "circle-user-round" },
    List = Window:CreateTab{ Title = "List", Icon = "list" },
    Settings = Window:CreateTab{ Title = "Settings", Icon = "settings" }
}

local Options = Library.Options

-- Create an independent button outside of the main interface for toggling visibility
local externalButton = Instance.new("TextButton")
externalButton.Parent = game.Players.LocalPlayer.PlayerGui
externalButton.Size = UDim2.new(0, 150, 0, 50) -- Adjust size as needed
externalButton.Position = UDim2.new(0.5, -75, 0, 100) -- Position it somewhere visible on the screen
externalButton.Text = "Toggle Interface"
externalButton.TextColor3 = Color3.fromRGB(255, 255, 255)
externalButton.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
externalButton.Font = Enum.Font.SourceSans
externalButton.TextSize = 24

-- Function to toggle the visibility of the interface window
local function toggleWindowVisibility()
    if Window.Visible then
        Window:Hide()  -- Hide the window if it's currently visible
    else
        Window:Show()  -- Show the window if it's currently hidden
    end
end

-- Connect the external button to toggle the window visibility
externalButton.MouseButton1Click:Connect(toggleWindowVisibility)

-- Utility function to load the aura list from file
local function loadAuraListFromFile()
    local auraList = {}
    local filePath = "Saved Auras/AuraList.txt"

    -- Ensure the folder exists
    local folderPath = "Saved Auras"
    if not isfolder(folderPath) then
        makefolder(folderPath)
    end

    -- If the file doesn't exist, fetch it from GitHub
    if not isfile(filePath) then
        local url = "https://raw.githubusercontent.com/nmsjayden/Roll/main/AuraList.txt"
        local success, response = pcall(function()
            return game:HttpGet(url)
        end)
        
        if success and response then
            writefile(filePath, response)
        else
            Library:Notify{
                Title = "Error",
                Content = "Failed to fetch AuraList from GitHub.",
                Duration = 6
            }
        end
    end

    -- Read the file and populate the aura list
    if isfile(filePath) then
        local fileContents = readfile(filePath)
        for line in string.gmatch(fileContents, "[^\r\n]+") do
            table.insert(auraList, line)
        end
    end

    return auraList
end

-- Load the aura list from the file initially
local aurasToDelete = loadAuraListFromFile()

-- Utility function to save aura list to a file
local function saveAuraListToFile()
    -- Ensure the folder exists
    local folderPath = "Saved Auras"
    if not isfolder(folderPath) then
        makefolder(folderPath)
    end

    -- File path for AuraList.txt
    local filePath = folderPath .. "/AuraList.txt"

    -- Remove the existing file if it exists
    if isfile(filePath) then
        delfile(filePath)
    end

    -- Write the updated auras to the file
    writefile(filePath, table.concat(aurasToDelete, "\n"))

    Library:Notify{
        Title = "Aura List Saved",
        Content = "Aura list has been automatically saved.",
        Duration = 6
    }
end

-- Create a dropdown to hold the aura list in the "List" tab
local listDropdown

-- Function to update the aura list display in the "List" tab
local function updateAuraList()
    local listValues = {}
    for _, aura in ipairs(aurasToDelete) do
        table.insert(listValues, aura)
    end

    -- If listDropdown exists, remove it before creating a new one
    if listDropdown then
        listDropdown:Destroy()
    end

    -- Create the dropdown with the updated list
    listDropdown = Tabs.List:CreateDropdown("AuraListDropdown", {
        Title = "Auras To Delete",
        Values = listValues,
        Multi = false,
        Default = 1,
    })

    listDropdown:OnChanged(function(Value)
        print("Aura selected:", Value)
    end)
end

-- Add a button to refresh the list
Tabs.List:CreateButton{
    Title = "Refresh Aura List",
    Description = "Click to refresh the list of auras.",
    Callback = updateAuraList
}

-- Initial update of the aura list when the script runs
updateAuraList()

local isScriptActive = false
local amountToDelete = "6"

local function processAuras()
    local r = game:GetService("ReplicatedStorage")
    local f = r:FindFirstChild("Auras")
    if f then
        for _, b in pairs(f:GetChildren()) do
            r.Remotes.AcceptAura:FireServer(b.Name, true)
        end
    end
end

local function toggleScript(state)
    isScriptActive = state
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

-- Create Subheading "Quick Roll" in Main tab
Tabs.Main:CreateParagraph("QuickRollSubheading", {
    Title = "Quick Roll",
    Content = "",
    TitleAlignment = "Middle",
    ContentAlignment = "Middle"
})

-- Create the Quick Roll Toggle in the Main tab
Tabs.Main:CreateToggle("Quick Roll Toggle", {
    Title = "Activate Quick Roll", 
    Default = false, 
    Callback = toggleScript
})

-- Create Subheading "Teleport Toggle" in Main tab
Tabs.Main:CreateParagraph("TeleportToggleSubheading", {
    Title = "Teleport Toggle",
    Content = "",
    TitleAlignment = "Middle",
    ContentAlignment = "Middle"
})

-- Teleport Script Toggle
local teleportScriptLoaded = false
local teleportScriptModule

local function executeTeleportScript()
    local success, result = pcall(function()
        -- Load the external teleport script
        teleportScriptModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/nmsjayden/Roll/refs/heads/main/TJule.lua"))()
    end)

    if success then
        print("Teleport script loaded successfully.")
    else
        warn("Failed to load teleport script: " .. result)
    end
end

local function toggleTeleportScript(state)
    if state then
        -- Load and execute the teleport script
        print("Loading teleport script...")
        executeTeleportScript()
        teleportScriptLoaded = true
    else
        -- Pause or resume the teleport script if it is running
        print("Toggling pause/resume for teleport script...")
        if teleportScriptModule and teleportScriptModule.togglePause then
            teleportScriptModule.togglePause()
        end
        teleportScriptLoaded = false
    end
end

-- Create the Teleport Script Toggle button
Tabs.Main:CreateToggle("TeleportScriptToggle", {
    Title = "Activate Teleport Script", 
    Default = false,  -- Default is set to false (off)
    Callback = toggleTeleportScript
})


-- Create Subheading "Aura List Config" in Main tab
Tabs.Main:CreateParagraph("AuraListConfigSubheading", {
    Title = "Aura List Config",
    Content = "",
    TitleAlignment = "Middle",
    ContentAlignment = "Middle"
})

-- Create a Textbox for adding/removing auras
local auraTextbox = Tabs.Main:CreateInput("AuraNameInput", {
    Title = "Aura Name",
    Default = "",
    Placeholder = "Enter Aura Name",
    Numeric = false,
    Finished = true,
})

-- Function to add or remove an aura from the aurasToDelete list
local function addOrRemoveAura()
    local auraName = auraTextbox.Value
    if auraName and auraName ~= "" then
        -- Check if the aura is already in the list
        local found = false
        for i, v in ipairs(aurasToDelete) do
            if v == auraName then
                -- Remove it if found
                table.remove(aurasToDelete, i)
                Library:Notify{
                    Title = "Aura Removed",
                    Content = "Aura '" .. auraName .. "' has been removed from the list.",
                    Duration = 4
                }
                found = true
                break
            end
        end
        
        if not found then
            -- Add the aura if not found
            table.insert(aurasToDelete, auraName)
            Library:Notify{
                Title = "Aura Added",
                Content = "Aura '" .. auraName .. "' has been added to the list.",
                Duration = 4
            }
        end

        -- Save the updated list automatically
        saveAuraListToFile()
        updateAuraList()
    else
        Library:Notify{
            Title = "Invalid Input",
            Content = "Please enter a valid aura name.",
            Duration = 4
        }
    end
end

-- Create Add/Remove Aura button (combined into one)
Tabs.Main:CreateButton{
    Title = "Add/Remove Aura",
    Description = "Adds or removes the aura from the list of auras to delete.",
    Callback = addOrRemoveAura
}

-- Interface and save managers
InterfaceManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetFolder("FluentScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

Library:Notify{
    Title = "Fluent",
    Content = "The script has been loaded.",
    Duration = 8
}

SaveManager:LoadAutoloadConfig()
