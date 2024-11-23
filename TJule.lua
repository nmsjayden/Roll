local button = script.Parent

-- Wait for the button to load if necessary
if not button:IsA("TextButton") then
    warn("Script.Parent is not a TextButton. Check the hierarchy!")
    return
end

button.Text = "Start Collector"

local toggle = false
local function toggleCollector()
    toggle = not toggle
    button.Text = toggle and "Stop Collector" or "Start Collector"
    print(toggle and "Collector Activated" or "Collector Deactivated")
end

button.MouseButton1Click:Connect(toggleCollector)
