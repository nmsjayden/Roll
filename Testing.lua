-- Safeload: Check if the script is running inside a Roblox game
if not game or not game.Players then
    print("This script must be run inside a Roblox game.")
    return
end

-- Safely load the UILib
local success, UILib = pcall(function()
    return loadstring(game:HttpGet('https://raw.githubusercontent.com/StepBroFurious/Script/main/HydraHubUi.lua'))()
end)

-- Check if UILib was loaded successfully
if not success then
    print("Failed to load UILib.")
    return
end

-- Create a small window with a more compact size
local Window = UILib.new("Grand Piece Online", game.Players.LocalPlayer.UserId, "Buyer", {
    Width = 300,   -- Smaller width for mobile compatibility
    Height = 400   -- Smaller height for mobile compatibility
})

-- Create the Main Category and SubButton
local Category1 = Window:Category("Main", "http://www.roblox.com/asset/?id=8395621517")
local SubButton1 = Category1:Button("Combat", "http://www.roblox.com/asset/?id=8395747586")

-- Create a section with smaller elements inside the Combat Button
local Section1 = SubButton1:Section("Section", "Left", {
    Width = 250,  -- Smaller section width
    Height = 300  -- Smaller section height
})

-- Button for Kill All
Section1:Button({
    Title = "Kill All",
    ButtonName = "KILL!!",
    Description = "Kills everyone",
    Size = UDim2.new(0, 200, 0, 40)  -- Reduced button size for mobile
}, function(value)
    print(value)  -- Print the action or value triggered
    -- Add your "Kill All" functionality here
end)

-- Toggle for Auto Farm Coins
Section1:Toggle({
    Title = "Auto Farm Coins",
    Description = "Automatically farms coins for you.",
    Default = false,
    Size = UDim2.new(0, 200, 0, 40)  -- Reduced toggle size for mobile
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
    Max = 120,
    Size = UDim2.new(0, 200, 0, 40)  -- Reduced slider size for mobile
}, function(value)
    print(value)  -- Print the walkspeed value
    -- Add functionality for changing walkspeed here
end)

-- Color Picker
Section1:ColorPicker({
    Title = "Colorpicker",
    Description = "Pick a color.",
    Default = Color3.new(1, 0, 0),  -- Use Color3 values between 0 and 1 for RGB
    Size = UDim2.new(0, 200, 0, 40)  -- Reduced color picker size for mobile
}, function(value)
    print(value)  -- Print the selected color
    -- Add functionality for using the selected color here
end)

-- Textbox for Damage Multiplier
Section1:Textbox({
    Title = "Damage Multiplier",
    Description = "Enter a value for damage multiplier.",
    Default = "",
    Size = UDim2.new(0, 200, 0, 40)  -- Reduced textbox size for mobile
}, function(value)
    print(value)  -- Print the textbox input value
    -- Add functionality for applying the damage multiplier here
end)

-- Keybind for Kill All
Section1:Keybind({
    Title = "Kill All",
    Description = "Press this key to kill all enemies.",
    Default = Enum.KeyCode.Q,
    Size = UDim2.new(0, 200, 0, 40)  -- Reduced keybind size for mobile
}, function(value)
    print(value)  -- Print the key pressed for the Kill All action
    -- Add functionality for keybinding to "Kill All" here
end)
