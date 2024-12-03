local UILib = loadstring(game:HttpGet('https://raw.githubusercontent.com/StepBroFurious/Script/main/HydraHubUi.lua'))()
local Window = UILib.new("Grand Piece Online", game.Players.LocalPlayer.UserId, "Buyer")

-- Creating the Main Category and SubButton
local Category1 = Window:Category("Main", "http://www.roblox.com/asset/?id=8395621517")
local SubButton1 = Category1:Button("Combat", "http://www.roblox.com/asset/?id=8395747586")

-- Creating the Section inside the Combat Button
local Section1 = SubButton1:Section("Section", "Left")

-- Button for Kill All
Section1:Button({
    Title = "Kill All",
    ButtonName = "KILL!!",
    Description = "Kills everyone"
}, function(value)
    print(value)  -- Print the action or value triggered
    -- Add your "Kill All" functionality here
end)

-- Toggle for Auto Farm Coins
Section1:Toggle({
    Title = "Auto Farm Coins",
    Description = "Automatically farms coins for you.",
    Default = false
}, function(value)
    print(value)  -- Print the toggle state (on/off)
    -- Add your Auto Farm functionality here
end)

-- Slider for Walkspeed
Section1:Slider({
    Title = "Walkspeed",
    Description = "Set your walkspeed.",
    Default = 16,
    Min = 0,
    Max = 120
}, function(value)
    print(value)  -- Print the walkspeed value
    -- Add functionality for changing walkspeed here
end)

-- Color Picker
Section1:ColorPicker({
    Title = "Colorpicker",
    Description = "Pick a color.",
    Default = Color3.new(1, 0, 0)  -- Use Color3 values between 0 and 1 for RGB
}, function(value)
    print(value)  -- Print the selected color
    -- Add functionality for using the selected color here
end)

-- Textbox for Damage Multiplier
Section1:Textbox({
    Title = "Damage Multiplier",
    Description = "Enter a value for damage multiplier.",
    Default = "",
}, function(value)
    print(value)  -- Print the textbox input value
    -- Add functionality for applying the damage multiplier here
end)

-- Keybind for Kill All
Section1:Keybind({
    Title = "Kill All",
    Description = "Press this key to kill all enemies.",
    Default = Enum.KeyCode.Q,
}, function(value)
    print(value)  -- Print the key pressed for the Kill All action
    -- Add functionality for keybinding to "Kill All" here
end)
