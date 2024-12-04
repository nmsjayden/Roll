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

local Tabs = {
    Main = Window:CreateTab{
        Title = "Main",
        Icon = "circle-user-round"
    },
    Settings = Window:CreateTab{
        Title = "Settings",
        Icon = "settings"
    }
}

local Options = Library.Options

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

-- Create Subheading "Quick Roll"
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

-- Create Subheading "Aura List Config"
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

-- Create Add/Remove Aura button (combined into one)
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
        
        -- Update the aura list display
        updateAuraList()
    else
        Library:Notify{
            Title = "Invalid Input",
            Content = "Please enter a valid aura name.",
            Duration = 4
        }
    end
end

Tabs.Main:CreateButton{
    Title = "Add/Remove Aura",
    Description = "Adds or removes the aura from the list of auras to delete.",
    Callback = addOrRemoveAura
}

-- Create a scrolling frame for displaying the aura list
local auraListFrame = Instance.new("ScrollingFrame")
auraListFrame.Size = UDim2.new(1, 0, 0.3, 0) -- Adjust the size as needed
auraListFrame.Position = UDim2.new(0, 0, 0.7, 0)
auraListFrame.BackgroundTransparency = 1
auraListFrame.Parent = Tabs.Main

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.FillDirection = Enum.FillDirection.Vertical
UIListLayout.Parent = auraListFrame

-- Function to update the aura list in the display
local function updateAuraList()
    -- Clear current list
    for _, child in pairs(auraListFrame:GetChildren()) do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end

    -- Add updated list of auras
    for _, aura in ipairs(aurasToDelete) do
        local auraLabel = Instance.new("TextLabel")
        auraLabel.Text = aura
        auraLabel.Size = UDim2.new(1, 0, 0, 25)
        auraLabel.TextSize = 16
        auraLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        auraLabel.BackgroundTransparency = 1
        auraLabel.Parent = auraListFrame
    end
end

-- Initial update of the aura list when the script loads
updateAuraList()

-- Interface and save managers
InterfaceManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes{}
InterfaceManager:SetFolder("FluentScriptHub")
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
