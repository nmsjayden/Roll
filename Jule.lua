local function a()
    local r=game:GetService("ReplicatedStorage")
    local f=r:FindFirstChild("Auras")
    if f then
        for _,b in pairs(f:GetChildren()) do
            r.Remotes.AcceptAura:FireServer(b.Name,true)
        end
    end
end
-- CHANGE THESE AURAS HERE IF ITS DELETING SOMETHING HERE THAT U WANT
local aurasToDelete={"Heat","Flames Curse","Dark Matter","Frigid","Sorcerous","Starstruck","Voltage","Constellar","Iridescent","Gale","Shiver","Bloom","Fiend","Tidal","Flame","Frost","Antimatter","Numerical","Orbital","Moonlit","Glacial","Bloom","Prism","Nebula","Iridescent","Cupid","Storm","Aurora","Infernal","Azure Periastron","Gladiator","Neptune","Constellation","Reborn","Storm: True Form","Omniscient","Acceleration","Grim Reaper","Infinity","Prismatic","Eternal","Serenity","Sakura"}
local c=0
local amountToDelete="6"

while true do
    task.wait(0.1)
    game:GetService("ReplicatedStorage").Remotes.ZachRLL:InvokeServer()
    c=c+1
    if c>=5 then
        a()
        c=0
    end
    task.wait(0.02)
    for _,d in ipairs(aurasToDelete) do
        game:GetService("ReplicatedStorage").Remotes.DeleteAura:FireServer(d,amountToDelete)
        
    end
end
