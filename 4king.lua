local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Title = "SuwanHub Dev"
if not Title then Title = "Default Title" end  -- Ensure Title is not nil

local Window = Fluent:CreateWindow({
    Title = Title,
    SubTitle = "by pdkd",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Rose",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- Define cafe positions and orientations
local cafes = {
    cafe1 = { Position = Vector3.new(-73.9494095, 4.10031939, -749.017273), Orientation = Vector3.new(-0.0284150746, -1.52888813e-08, 0.999596238) },
    cafe2 = { Position = Vector3.new(-299.202576, 3.59841084, -1349.04773), Orientation = Vector3.new(-0.994277477, 4.05993674e-08, 0.106828123) },
    cafe3 = { Position = Vector3.new(-904.326965, 3.69128799, -1351.78259), Orientation = Vector3.new(0.996615529, -7.59682877e-08, -0.0822041482) },
    cafe4 = { Position = Vector3.new(-865.555847, 1.9520539, -1085.23315), Orientation = Vector3.new(0.208453849, 6.29686099e-08, 0.978032231) },
    cafe5 = { Position = Vector3.new(-881.631714, 3.82531571, -515.015259), Orientation = Vector3.new(0.999491751, -1.40339145e-08, -0.0318792537) }
}

-- Create a dropdown to select a cafe
local selectedCafe = "cafe1" -- Default selected cafe

local Dropdown = Tabs.Main:AddDropdown("CafeDropdown", {
    Title = "Select Cafe",
    Values = {"Cafe 1", "Cafe 2", "Cafe 3", "Cafe 4", "Cafe 5"},
    Multi = false,
    Default = 1,
})

Dropdown:OnChanged(function(Value)
    if Value == "Cafe 1" then
        selectedCafe = "cafe1"
    elseif Value == "Cafe 2" then
        selectedCafe = "cafe2"
    elseif Value == "Cafe 3" then
        selectedCafe = "cafe3"
    elseif Value == "Cafe 4" then
        selectedCafe = "cafe4"
    elseif Value == "Cafe 5" then
        selectedCafe = "cafe5"
    end
end)

-- Function to teleport the player to the selected cafe
local function teleportToCafe()
    local cafe = cafes[selectedCafe]
    if cafe then
        local player = game.Players.LocalPlayer
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            -- Teleport player and apply orientation
            player.Character.HumanoidRootPart.CFrame = CFrame.new(cafe.Position) * CFrame.Angles(cafe.Orientation.X, cafe.Orientation.Y, cafe.Orientation.Z)
            print("Teleported to " .. selectedCafe)
        else
            print("Error: HumanoidRootPart not found or player is missing.")
        end
    else
        print("Error: Cafe data is missing.")
    end
end

-- Add a button to teleport to the selected cafe
Tabs.Main:AddButton({
    Title = "Teleport to Selected Cafe",
    Description = "Click to teleport to the selected cafe",
    Callback = function()
        teleportToCafe()
    end
})

Tabs.Main:AddButton({
    Title = "Remove camera walk",
    Description = "Click to remove the camera walk feature",
    Callback = function()
        local cooldownJump = workspace:FindFirstChild("VEE_Z3")
        if cooldownJump and cooldownJump:FindFirstChild("camera walk") then
            cooldownJump["camera walk"]:Destroy()  -- Removes the "Cooldown jump" object
            Fluent:Notify({
                Title = "Camera walk Removed",
                Content = "The camera walk feature has been removed.",
                Duration = 5
            })
        else
            Fluent:Notify({
                Title = "Error",                Content = "Camera walk feature not found.",
                Duration = 5
            })
        end
    end
})

Tabs.Main:AddButton({
    Title = "Remove Proximity Prompt Hold Duration",
    Description = "Click to set HoldDuration to 0 for all ProximityPrompts under 'Cash Register'",
    Callback = function()
        local cashRegister = workspace:FindFirstChild("Cash Register")
        if cashRegister then
            for _, descendant in ipairs(cashRegister:GetDescendants()) do
                if descendant:IsA("ProximityPrompt") then
                    descendant.HoldDuration = 0  -- Set the HoldDuration to 0
                end
            end
            Fluent:Notify({
                Title = "Success",
                Content = "The HoldDuration for ProximityPrompts has been set to 0.",
                Duration = 5
            })
        else
            Fluent:Notify({
                Title = "Error",
                Content = "Cash Register not found.",
                Duration = 5
            })
        end
    end
})


Slider:SetValue(_G.HeadSize)

-- Addons
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})

InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

SaveManager:LoadAutoloadConfig()
