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

-- Function to update the aura list display
local function updateAuraListDisplay(paragraph)
    local listContent = table.concat(aurasToDelete, "\n")
    paragraph:SetContent(listContent ~= "" and listContent or "No auras in the list.")
end

-- Function to add or remove an aura from the list
local function addOrRemoveAura(auraTextbox, paragraph)
    local auraName = auraTextbox.Value
    if auraName and auraName ~= "" then
        local found = false
        for i, v in ipairs(aurasToDelete) do
            if v == auraName then
                table.remove(aurasToDelete, i) -- Remove aura
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
            table.insert(aurasToDelete, auraName) -- Add aura
            Library:Notify{
                Title = "Aura Added",
                Content = "Aura '" .. auraName .. "' has been added to the list.",
                Duration = 4
            }
        end
        
        -- Update the displayed list
        updateAuraListDisplay(paragraph)
    else
        Library:Notify{
            Title = "Invalid Input",
            Content = "Please enter a valid aura name.",
            Duration = 4
        }
    end
end

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
    Callback = function(state)
        isScriptActive = state
    end
})

-- Create Subheading "Aura List Config"
Tabs.Main:CreateParagraph("AuraListConfigSubheading", {
    Title = "Aura List Config",
    Content = "",
    TitleAlignment = "Middle",
    ContentAlignment = "Middle"
})

-- Create the Textbox for Aura Name input
local auraTextbox = Tabs.Main:CreateInput("AuraNameInput", {
    Title = "Aura Name",
    Default = "",
    Placeholder = "Enter Aura Name",
    Numeric = false,
    Finished = true,
})

-- Create a Paragraph to display the aura list
local auraListParagraph = Tabs.Main:CreateParagraph("AuraListDisplay", {
    Title = "Current Auras",
    Content = table.concat(aurasToDelete, "\n"),
    TitleAlignment = "Middle",
    ContentAlignment = "Middle"
})

-- Create the Add/Remove button
Tabs.Main:CreateButton{
    Title = "Add/Remove Aura",
    Description = "Adds or removes the aura from the list of auras to delete.",
    Callback = function()
        addOrRemoveAura(auraTextbox, auraListParagraph)
    end
}

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
