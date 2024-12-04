-- A reference to the live-updating paragraph for the aura list
local auraListParagraph

-- Function to update the displayed aura list
local function updateAuraListDisplay()
    local content = table.concat(aurasToDelete, ", ")
    if content == "" then
        content = "No auras in the list."
    end
    auraListParagraph:SetText(content)
end

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

-- Create the live-updating aura list paragraph
auraListParagraph = Tabs.Main:CreateParagraph("AuraListDisplay", {
    Title = "Current Auras to Delete",
    Content = "No auras in the list.",
    TitleAlignment = "Middle",
    ContentAlignment = "Left"
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

        -- Update the displayed aura list
        updateAuraListDisplay()
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

-- Initialize the list display
updateAuraListDisplay()
