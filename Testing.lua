local function safeLoad(url)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    if not success then
        warn("Failed to load:", url)
        return nil
    end
    return result
end

local Fluent = safeLoad("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua")
if not Fluent then return end

local SaveManager = safeLoad("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua")
local InterfaceManager = safeLoad("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua")

if not SaveManager or not InterfaceManager then
    warn("Failed to load SaveManager or InterfaceManager")
    return
end

local Window = Fluent:CreateWindow({
    Title = "Fluent " .. Fluent.Version,
    SubTitle = "by dawid",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

-- Add a safeguard for transparency handling in TColorpicker
local function safeSetTransparency(colorpicker, transparency)
    local clampedTransparency = math.clamp(transparency or 0, 0, 1)
    colorpicker.Transparency = clampedTransparency
end

-- Main content setup (unchanged logic)
do
    Fluent:Notify({
        Title = "Notification",
        Content = "This is a notification",
        SubContent = "SubContent",
        Duration = 5
    })

    Tabs.Main:AddParagraph({ Title = "Paragraph", Content = "This is a paragraph.\nSecond line!" })

    Tabs.Main:AddButton({
        Title = "Button",
        Description = "Very important button",
        Callback = function()
            Window:Dialog({
                Title = "Title",
                Content = "This is a dialog",
                Buttons = {
                    { Title = "Confirm", Callback = function() print("Confirmed the dialog.") end },
                    { Title = "Cancel", Callback = function() print("Cancelled the dialog.") end }
                }
            })
        end
    })

    local TColorpicker = Tabs.Main:AddColorpicker("TransparencyColorpicker", {
        Title = "Colorpicker",
        Transparency = 0,
        Default = Color3.fromRGB(96, 205, 255)
    })

    safeSetTransparency(TColorpicker, 0.5) -- Example to set transparency safely
    TColorpicker:OnChanged(function()
        safeSetTransparency(TColorpicker, TColorpicker.Transparency)
        print("TColorpicker changed:", TColorpicker.Value, "Transparency:", TColorpicker.Transparency)
    end)
end

-- SaveManager and InterfaceManager setup
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})

InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

-- Autoload configuration handling
pcall(function()
    SaveManager:LoadAutoloadConfig()
end)

Window:SelectTab(1)
Fluent:Notify({ Title = "Fluent", Content = "The script has been loaded.", Duration = 8 })
