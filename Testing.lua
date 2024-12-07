local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local SaveManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/SaveManager.luau"))()
local InterfaceManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/InterfaceManager.luau"))()

local Window = Library:CreateWindow{
    Title = `Digitized-Moon Hub {Library.Version}`,
    SubTitle = "by Aro Moon",
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

local externalButton = Instance.new("TextButton", game.Players.LocalPlayer.PlayerGui)
externalButton.Size = UDim2.new(0, 150, 0, 50)
externalButton.Position = UDim2.new(0.5, -75, 0, 100)
externalButton.Text = "Toggle Interface"
externalButton.TextColor3 = Color3.fromRGB(255, 255, 255)
externalButton.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
externalButton.Font = Enum.Font.SourceSans
externalButton.TextSize = 24

local function toggleWindowVisibility()
    Window.Visible = not Window.Visible
end

externalButton.MouseButton1Click:Connect(toggleWindowVisibility)

local function ensureFolderExists(folderPath)
    if not isfolder(folderPath) then
        makefolder(folderPath)
    end
end

local function loadAuraListFromFile()
    local auraList = {}
    local folderPath = "Saved Auras"
    local filePath = folderPath .. "/AuraList.txt"

    ensureFolderExists(folderPath)

    if not isfile(filePath) then
        local url = "https://raw.githubusercontent.com/nmsjayden/Roll/main/AuraList.txt"
        local success, response = pcall(game.HttpGet, game, url)
        
        if success and response then
            writefile(filePath, response)
        else
            Library:Notify{ Title = "Error", Content = "Failed to fetch AuraList from GitHub.", Duration = 6 }
        end
    end

    if isfile(filePath) then
        for line in string.gmatch(readfile(filePath), "[^\r\n]+") do
            table.insert(auraList, line)
        end
    end

    return auraList
end

local aurasToDelete = loadAuraListFromFile()

local function saveAuraListToFile()
    ensureFolderExists("Saved Auras")
    local filePath = "Saved Auras/AuraList.txt"

    if isfile(filePath) then
        delfile(filePath)
    end

    writefile(filePath, table.concat(aurasToDelete, "\n"))
    Library:Notify{ Title = "Aura List Saved", Content = "Aura list has been automatically saved.", Duration = 6 }
end

local function updateAuraList()
    if listDropdown then
        listDropdown:Destroy()
    end

    listDropdown = Tabs.List:CreateDropdown("AuraListDropdown", {
        Title = "Auras To Delete",
        Values = aurasToDelete,
        Multi = false,
        Default = 1,
    })

    listDropdown:OnChanged(function(Value)
        print("Aura selected:", Value)
    end)
end

updateAuraList()

local isScriptActive = false
local amountToDelete = "1"

local function processAuras()
    local auras = game:GetService("ReplicatedStorage"):FindFirstChild("Auras")
    if auras then
        for _, aura in pairs(auras:GetChildren()) do
            game:GetService("ReplicatedStorage").Remotes.AcceptAura:FireServer(aura.Name, true)
        end
    end
end

task.spawn(function()
    while true do
        task.wait(0.01)
        if isScriptActive then
            game:GetService("ReplicatedStorage").Remotes.ZachRLL:InvokeServer()
            processAuras()
            for _, aura in ipairs(aurasToDelete) do
                game:GetService("ReplicatedStorage").Remotes.DeleteAura:FireServer(aura, amountToDelete)
            end
        end
    end
end)

Tabs.Main:CreateParagraph("TopBlankBox", { Title = "", Content = "", TitleAlignment = "Middle", ContentAlignment = "Middle" })
Tabs.Main:CreateParagraph("QuickRollSubheading", { Title = "Quick Roll", Content = "", TitleAlignment = "Middle", ContentAlignment = "Middle" })
Tabs.Main:CreateToggle("Quick Roll Toggle", { Title = "Activate Quick Roll", Default = false, Callback = function(state) isScriptActive = state end })

local teleportScriptLoaded = false
local teleportScriptModule

local function executeTeleportScript()
    local success, result = pcall(function()
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
        print("Loading teleport script...")
        executeTeleportScript()
        teleportScriptLoaded = true
    else
        print("Toggling pause/resume for teleport script...")
        if teleportScriptModule and teleportScriptModule.togglePause then
            teleportScriptModule.togglePause()
        end
        teleportScriptLoaded = false
    end
end

Tabs.Main:CreateToggle("TeleportScriptToggle", { Title = "Activate Teleport Script", Default = false, Callback = toggleTeleportScript })

Tabs.Main:CreateParagraph("AuraListConfigSubheading", { Title = "Aura List Config", Content = "", TitleAlignment = "Middle", ContentAlignment = "Middle" })

local auraTextbox = Tabs.Main:CreateInput("AuraNameInput", {
    Title = "Aura Name",
    Default = "",
    Placeholder = "Enter Aura Name",
    Numeric = false,
    Finished = true,
})

local function addOrRemoveAura()
    local auraName = auraTextbox.Value
    if auraName and auraName ~= "" then
        local found = false
        for i, v in ipairs(aurasToDelete) do
            if v == auraName then
                table.remove(aurasToDelete, i)
                Library:Notify{ Title = "Aura Removed", Content = "Aura '" .. auraName .. "' has been removed from the list.", Duration = 4 }
                found = true
                break
            end
        end
        
        if not found then
            table.insert(aurasToDelete, auraName)
            Library:Notify{ Title = "Aura Added", Content = "Aura '" .. auraName .. "' has been added to the list.", Duration = 4 }
        end

        saveAuraListToFile()
        updateAuraList()
    else
        Library:Notify{ Title = "Invalid Input", Content = "Please enter a valid aura name.", Duration = 4 }
    end
end

Tabs.Main:CreateButton{ Title = "Add/Remove Aura", Description = "Adds or removes the aura from the list of auras to delete.", Callback = addOrRemoveAura }
Tabs.Main:CreateParagraph("BlankBox", { Title = "", Content = "", TitleAlignment = "Middle", ContentAlignment = "Middle" })

InterfaceManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetFolder("Digitized-Moon Hub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

Library:Notify{ Title = "Aro Moon ;)", Content = "The script has been loaded.", Duration = 8 }
SaveManager:LoadAutoloadConfig()
