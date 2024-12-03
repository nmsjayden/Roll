local library = (syn and loadstring(game:HttpGet("https://github.com/GhostDuckyy/UI-Libraries/blob/main/DEADCELL%20REMAKE/source.lua?raw=true"))()) or loadstring(game:HttpGet("https://github.com/GhostDuckyy/UI-Libraries/blob/main/DEADCELL%20REMAKE/Modified/source.lua?raw=true"))()

local theme = {
    ["Default"] = {
        ["Accent"] = Color3.fromRGB(61, 100, 227),
        ["Window Outline Background"] = Color3.fromRGB(39,39,47),
        ["Window Inline Background"] = Color3.fromRGB(23,23,30),
        ["Window Holder Background"] = Color3.fromRGB(32,32,38),
        ["Page Unselected"] = Color3.fromRGB(32,32,38),
        ["Page Selected"] = Color3.fromRGB(55,55,64),
        ["Section Background"] = Color3.fromRGB(27,27,34),
        ["Section Inner Border"] = Color3.fromRGB(50,50,58),
        ["Section Outer Border"] = Color3.fromRGB(19,19,27),
        ["Window Border"] = Color3.fromRGB(58,58,67),
        ["Text"] = Color3.fromRGB(245, 245, 245),
        ["Risky Text"] = Color3.fromRGB(245, 239, 120),
        ["Object Background"] = Color3.fromRGB(41,41,50)
    }    
}

-- Initialize Window
local window = library:new_window({size = Vector2.new(600, 450)})

-- Aura Management Page
local aura_page = window:new_page({name = "Aura Management"})
local aura_section = aura_page:new_section({name = "Aura Options", size = "Fill"})

-- Aura Toggle
local aura_script_enabled = false
aura_section:new_toggle({
    name = "Aura Script On/Off",
    callback = function(state)
        aura_script_enabled = state
        library.notify("Aura script " .. (state and "enabled" or "disabled"), 5)
    end
})

-- Add/Remove Aura
local auras = {}
aura_section:new_button({
    name = "Add/Remove Aura",
    callback = function()
        local aura_name = "Aura " .. tostring(#auras + 1)
        table.insert(auras, aura_name)
        library.notify(aura_name .. " added", 5)
    end
})

-- Potion Collector Page
local potion_page = window:new_page({name = "Potion Collector"})
local potion_section = potion_page:new_section({name = "Potion Options", size = "Fill"})

-- Potion Collector Toggle
local potion_collection_enabled = false
potion_section:new_toggle({
    name = "Potion Collection",
    callback = function(state)
        potion_collection_enabled = state
        library.notify("Potion collection " .. (state and "enabled" or "disabled"), 5)
    end
})

-- Settings Page
local settings_page = window:new_page({name = "Settings"})
local settings_section = settings_page:new_section({name = "Script Options", size = "Fill"})

-- Unload Script
settings_section:new_button({
    name = "Unload Script",
    callback = function()
        library.notify("Script unloaded", 5)
        library:Close()
    end
})

-- Theme Customization Section
local theme_section = settings_page:new_section({name = "Theme Settings", size = "Fill"})
local theme_pickers = {}

for theme_option, default_value in pairs(theme.Default) do
    theme_pickers[theme_option] = theme_section:new_colorpicker({
        name = theme_option,
        default = default_value,
        callback = function(color)
            library:ChangeThemeOption(theme_option, color)
        end
    })
end

-- Accent Effects
local effects_section = settings_page:new_section({name = "Effects", size = "Fill"})
effects_section:new_dropdown({
    name = "Accent Effects",
    options = {"None", "Rainbow", "Shift", "Reverse Shift"},
    default = "None",
    callback = function(effect)
        library.notify("Effect set to " .. effect, 5)
    end
})

effects_section:new_slider({
    name = "Effect Speed",
    min = 0,
    max = 2,
    default = 1,
    callback = function(speed)
        library.notify("Effect speed: " .. speed, 5)
    end
})

-- Handle Theme Loading
theme_section:new_button({
    name = "Load Default Theme",
    callback = function()
        library:SetTheme(theme.Default)
        library.notify("Default theme applied", 5)
    end
})

library:Close()
