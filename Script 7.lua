local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Universal Hub",
   LoadingTitle = "Universal Hub",
   LoadingSubtitle = "by Milka",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "UniversalHub",
      FileName = "Config"
   },
   KeySystem = false
})

-- Variables
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Lighting = game:GetService("Lighting")

-- Settings table
local settings = {
    speedEnabled = false,
    speedValue = 40,
    jumpEnabled = false,
    jumpValue = 50,
    flyEnabled = false,
    flySpeed = 50,
    noclipEnabled = false,
    bhopEnabled = false,
    fullBright = false,
    playerEsp = false,
    hitboxEnabled = false,
    hitboxSize = 50,
    originalBrightness = Lighting.Brightness,
    originalFog = Lighting.FogEnd,
    originalClock = Lighting.ClockTime
}

-- Flying Variables
local bodyVelocity, bodyGyro

-- NoClip Connection
local noclipConnection

-- [TABS CREATION]
local MainTab = Window:CreateTab("Main", nil)
local MovementTab = Window:CreateTab("Movement", nil)
local VisualsTab = Window:CreateTab("Visuals", nil)
local CombatTab = Window:CreateTab("Combat", nil)
local UtilityTab = Window:CreateTab("Utility", nil)

-- [MAIN TAB]
local MainSection = MainTab:CreateSection("Main Controls")

-- Welcome Notification
Rayfield:Notify({
   Title = "Welcome to Universal Hub",
   Content = "Script by Milka | Enjoy!",
   Duration = 6.5
})

-- [MOVEMENT TAB]
local MovementSection = MovementTab:CreateSection("Movement Features")

-- Walkspeed Slider
MovementTab:CreateSlider({
   Name = "Walkspeed",
   Range = {16, 500},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 40,
   Callback = function(Value)
      settings.speedValue = Value
      if settings.speedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
         LocalPlayer.Character.Humanoid.WalkSpeed = Value
      end
   end,
})

-- Walkspeed Toggle
MovementTab:CreateToggle({
   Name = "Enable Walkspeed",
   CurrentValue = false,
   Callback = function(Value)
      settings.speedEnabled = Value
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
         if Value then
            LocalPlayer.Character.Humanoid.WalkSpeed = settings.speedValue
         else
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
         end
      end
   end,
})

-- Jump Power Slider
MovementTab:CreateSlider({
   Name = "Jump Power",
   Range = {50, 500},
   Increment = 1,
   Suffix = "Power",
   CurrentValue = 50,
   Callback = function(Value)
      settings.jumpValue = Value
      if settings.jumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
         LocalPlayer.Character.Humanoid.JumpPower = Value
      end
   end,
})

-- Jump Power Toggle
MovementTab:CreateToggle({
   Name = "Enable Jump Power",
   CurrentValue = false,
   Callback = function(Value)
      settings.jumpEnabled = Value
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
         if Value then
            LocalPlayer.Character.Humanoid.JumpPower = settings.jumpValue
         else
            LocalPlayer.Character.Humanoid.JumpPower = 50
         end
      end
   end,
})

-- Fly Speed Slider
MovementTab:CreateSlider({
   Name = "Fly Speed",
   Range = {10, 200},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 50,
   Callback = function(Value)
      settings.flySpeed = Value
   end,
})

-- Fly Toggle
MovementTab:CreateToggle({
   Name = "Enable Fly",
   CurrentValue = false,
   Callback = function(Value)
      settings.flyEnabled = Value
      if Value then
         enableFly()
      else
         disableFly()
      end
   end,
})

-- NoClip Toggle
MovementTab:CreateToggle({
   Name = "Enable NoClip",
   CurrentValue = false,
   Callback = function(Value)
      settings.noclipEnabled = Value
      if Value then
         enableNoClip()
      else
         disableNoClip()
      end
   end,
})

-- BHop Toggle
MovementTab:CreateToggle({
   Name = "Enable BHop",
   CurrentValue = false,
   Callback = function(Value)
      settings.bhopEnabled = Value
   end,
})

-- Infinite Jump Toggle
MovementTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         game:GetService("UserInputService").JumpRequest:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
               LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
            end
         end)
         Rayfield:Notify({
            Title = "Infinite Jump",
            Content = "Infinite Jump Enabled - Press Space to jump infinitely",
            Duration = 3
         })
      end
   end,
})

-- [VISUALS TAB]
local VisualsSection = VisualsTab:CreateSection("Visual Features")

-- Full Bright Toggle
VisualsTab:CreateToggle({
   Name = "Full Bright",
   CurrentValue = false,
   Callback = function(Value)
      settings.fullBright = Value
      if Value then
          Lighting.Brightness = 2
          Lighting.ClockTime = 14
          Lighting.FogEnd = 100000
          Lighting.GlobalShadows = false
      else
          Lighting.Brightness = 1
          Lighting.FogEnd = 100000
          Lighting.ClockTime = 14
          Lighting.GlobalShadows = true
      end
   end,
})

-- Player ESP Toggle
VisualsTab:CreateToggle({
   Name = "Player ESP",
   CurrentValue = false,
   Callback = function(Value)
      settings.playerEsp = Value
   end,
})

-- [COMBAT TAB]
local CombatSection = CombatTab:CreateSection("Combat Features")

-- Hitbox Size Slider
CombatTab:CreateSlider({
   Name = "Hitbox Size",
   Range = {10, 200},
   Increment = 1,
   Suffix = "Size",
   CurrentValue = 50,
   Callback = function(Value)
      settings.hitboxSize = Value
   end,
})

-- Hitbox Toggle
CombatTab:CreateToggle({
   Name = "Enable Hitbox Expander",
   CurrentValue = false,
   Callback = function(Value)
      settings.hitboxEnabled = Value
   end,
})

-- Silent Aim Section
local SilentAimSection = CombatTab:CreateSection("Silent Aim")

-- Silent Aim Settings
local SilentAimSettings = {
    Enabled = false,
    TeamCheck = false,
    VisibleCheck = false,
    TargetPart = "Head",
    SilentAimMethod = "Raycast",
    FOVRadius = 130,
    FOVVisible = false,
    ShowTarget = false,
    MouseHitPrediction = false,
    MouseHitPredictionAmount = 0.165,
    HitChance = 100
}

-- Silent Aim Toggle
CombatTab:CreateToggle({
   Name = "Enable Silent Aim",
   CurrentValue = false,
   Callback = function(Value)
      SilentAimSettings.Enabled = Value
   end,
})

-- Silent Aim Team Check
CombatTab:CreateToggle({
   Name = "Team Check",
   CurrentValue = false,
   Callback = function(Value)
      SilentAimSettings.TeamCheck = Value
   end,
})

-- Silent Aim Visible Check
CombatTab:CreateToggle({
   Name = "Visible Check",
   CurrentValue = false,
   Callback = function(Value)
      SilentAimSettings.VisibleCheck = Value
   end,
})

-- Target Part Dropdown
CombatTab:CreateDropdown({
   Name = "Target Part",
   Options = {"Head", "HumanoidRootPart", "Random"},
   CurrentOption = "Head",
   Callback = function(Option)
      SilentAimSettings.TargetPart = Option
   end,
})

-- Silent Aim Method Dropdown
CombatTab:CreateDropdown({
   Name = "Silent Aim Method",
   Options = {"Raycast", "FindPartOnRay", "FindPartOnRayWithIgnoreList", "FindPartOnRayWithWhitelist", "Mouse.Hit/Target"},
   CurrentOption = "Raycast",
   Callback = function(Option)
      SilentAimSettings.SilentAimMethod = Option
   end,
})

-- Hit Chance Slider
CombatTab:CreateSlider({
   Name = "Hit Chance",
   Range = {0, 100},
   Increment = 1,
   Suffix = "%",
   CurrentValue = 100,
   Callback = function(Value)
      SilentAimSettings.HitChance = Value
   end,
})

-- FOV Section
local FOVSection = CombatTab:CreateSection("FOV Settings")

-- Show FOV Toggle
CombatTab:CreateToggle({
   Name = "Show FOV Circle",
   CurrentValue = false,
   Callback = function(Value)
      SilentAimSettings.FOVVisible = Value
   end,
})

-- FOV Radius Slider
CombatTab:CreateSlider({
   Name = "FOV Radius",
   Range = {0, 360},
   Increment = 1,
   Suffix = "px",
   CurrentValue = 130,
   Callback = function(Value)
      SilentAimSettings.FOVRadius = Value
   end,
})

-- Show Target Toggle
CombatTab:CreateToggle({
   Name = "Show Target Indicator",
   CurrentValue = false,
   Callback = function(Value)
      SilentAimSettings.ShowTarget = Value
   end,
})

-- Prediction Section
local PredictionSection = CombatTab:CreateSection("Prediction Settings")

-- Mouse Hit Prediction Toggle
CombatTab:CreateToggle({
   Name = "Mouse Hit Prediction",
   CurrentValue = false,
   Callback = function(Value)
      SilentAimSettings.MouseHitPrediction = Value
   end,
})

-- Prediction Amount Slider
CombatTab:CreateSlider({
   Name = "Prediction Amount",
   Range = {0.1, 1},
   Increment = 0.01,
   Suffix = "",
   CurrentValue = 0.165,
   DecimalPlaces = 3,
   Callback = function(Value)
      SilentAimSettings.MouseHitPredictionAmount = Value
   end,
})

-- Aimbot Section
local AimbotSection = CombatTab:CreateSection("Aimbot")

-- Aimbot Settings
local AimbotSettings = {
    Enabled = false,
    TeamCheck = false,
    AliveCheck = true,
    WallCheck = false,
    Sensitivity = 0,
    ThirdPerson = false,
    ThirdPersonSensitivity = 3,
    TriggerKey = "MouseButton2",
    Toggle = false,
    LockPart = "Head"
}

-- Aimbot Toggle
CombatTab:CreateToggle({
   Name = "Enable Aimbot",
   CurrentValue = false,
   Callback = function(Value)
      AimbotSettings.Enabled = Value
   end,
})

-- Aimbot Team Check
CombatTab:CreateToggle({
   Name = "Team Check",
   CurrentValue = false,
   Callback = function(Value)
      AimbotSettings.TeamCheck = Value
   end,
})

-- Aimbot Alive Check
CombatTab:CreateToggle({
   Name = "Alive Check",
   CurrentValue = true,
   Callback = function(Value)
      AimbotSettings.AliveCheck = Value
   end,
})

-- Aimbot Wall Check
CombatTab:CreateToggle({
   Name = "Wall Check",
   CurrentValue = false,
   Callback = function(Value)
      AimbotSettings.WallCheck = Value
   end,
})

-- Aimbot Sensitivity Slider
CombatTab:CreateSlider({
   Name = "Sensitivity",
   Range = {0, 1},
   Increment = 0.01,
   Suffix = "s",
   CurrentValue = 0,
   DecimalPlaces = 2,
   Callback = function(Value)
      AimbotSettings.Sensitivity = Value
   end,
})

-- Aimbot Lock Part Dropdown
CombatTab:CreateDropdown({
   Name = "Lock Part",
   Options = {"Head", "HumanoidRootPart", "Torso", "UpperTorso"},
   CurrentOption = "Head",
   Callback = function(Option)
      AimbotSettings.LockPart = Option
   end,
})

-- Aimbot Trigger Key
CombatTab:CreateDropdown({
   Name = "Trigger Key",
   Options = {"MouseButton1", "MouseButton2", "MouseButton3", "LeftAlt", "LeftControl", "LeftShift", "RightAlt", "RightControl", "RightShift"},
   CurrentOption = "MouseButton2",
   Callback = function(Option)
      AimbotSettings.TriggerKey = Option
   end,
})

-- Aimbot Toggle Mode
CombatTab:CreateToggle({
   Name = "Toggle Mode",
   CurrentValue = false,
   Callback = function(Value)
      AimbotSettings.Toggle = Value
   end,
})

-- Aimbot Third Person
CombatTab:CreateToggle({
   Name = "Third Person",
   CurrentValue = false,
   Callback = function(Value)
      AimbotSettings.ThirdPerson = Value
   end,
})

-- Third Person Sensitivity Slider
CombatTab:CreateSlider({
   Name = "Third Person Sensitivity",
   Range = {0.1, 5},
   Increment = 0.1,
   Suffix = "",
   CurrentValue = 3,
   DecimalPlaces = 1,
   Callback = function(Value)
      AimbotSettings.ThirdPersonSensitivity = Value
   end,
})

-- [UTILITY TAB]
local UtilitySection = UtilityTab:CreateSection("Utility Features")

-- Keybind Info
UtilityTab:CreateButton({
   Name = "Show Keybinds",
   Callback = function()
      Rayfield:Notify({
         Title = "Keybinds",
         Content = "F - Toggle Fly\nX - Toggle Walkspeed\nRight Alt - Hide/Show Menu",
         Duration = 5
      })
   end,
})

-- Menu Toggle Keybind Info
UtilityTab:CreateButton({
   Name = "Menu Toggle Key",
   Callback = function()
      Rayfield:Notify({
         Title = "Menu Key",
         Content = "Press Right Alt to hide/show the menu",
         Duration = 3
      })
   end,
})

-- Script Info
UtilityTab:CreateButton({
   Name = "Script Info",
   Callback = function()
      Rayfield:Notify({
         Title = "Universal Hub",
         Content = "Created by Milka\nVersion 1.0\nAll features included",
         Duration = 5
      })
   end,
})

-- [FLY FUNCTIONS]
function enableFly()
    if not LocalPlayer.Character then return end
    local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    
    if not rootPart or not humanoid then return end
    
    humanoid.PlatformStand = true

    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Parent = rootPart

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyGyro.P = 10000
    bodyGyro.D = 500
    bodyGyro.CFrame = rootPart.CFrame
    bodyGyro.Parent = rootPart

    spawn(function()
        while settings.flyEnabled and bodyVelocity and bodyGyro do
            local camera = workspace.CurrentCamera
            local direction = Vector3.new(0, 0, 0)

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                direction = direction + camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                direction = direction - camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                direction = direction - camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                direction = direction + camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                direction = direction + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                direction = direction + Vector3.new(0, -1, 0)
            end

            if direction.Magnitude > 0 then
                direction = direction.Unit * settings.flySpeed
            end

            bodyVelocity.Velocity = direction
            bodyGyro.CFrame = CFrame.new(rootPart.Position, rootPart.Position + camera.CFrame.LookVector)

            wait()
        end
    end)
end

function disableFly()
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    if bodyGyro then
        bodyGyro:Destroy()
        bodyGyro = nil
    end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.PlatformStand = false
    end
end

-- [NOCLIP FUNCTIONS]
function enableNoClip()
    if noclipConnection then
        noclipConnection:Disconnect()
    end
    
    noclipConnection = RunService.Stepped:Connect(function()
        if not settings.noclipEnabled or not LocalPlayer.Character then return end
        
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
end

function disableNoClip()
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    
    if LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- [MAIN LOOP]
RunService.Heartbeat:Connect(function()
    -- Walkspeed loop
    if settings.speedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = settings.speedValue
    end
    
    -- Jump Power loop
    if settings.jumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = settings.jumpValue
    end
    
    -- BHop loop
    if settings.bhopEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local humanoid = LocalPlayer.Character.Humanoid
        if humanoid.FloorMaterial ~= Enum.Material.Air then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- [ESP LOOP]
RunService.RenderStepped:Connect(function()
    -- Hitbox Expander
    if settings.hitboxEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local rootPart = player.Character.HumanoidRootPart
                rootPart.Size = Vector3.new(settings.hitboxSize, settings.hitboxSize, settings.hitboxSize)
                rootPart.Transparency = 0.7
                rootPart.BrickColor = BrickColor.new("Really blue")
                rootPart.Material = "Neon"
                rootPart.CanCollide = false
            end
        end
    else
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local rootPart = player.Character.HumanoidRootPart
                if rootPart.Size.X > 2 then
                    rootPart.Size = Vector3.new(2, 2, 1)
                    rootPart.Transparency = 0
                    rootPart.Material = "Plastic"
                end
            end
        end
    end
    
    -- Player ESP
    if settings.playerEsp then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local char = player.Character
                local highlight = char:FindFirstChild("PlayerESP")
                
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "PlayerESP"
                    highlight.FillColor = Color3.fromRGB(0, 255, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.5
                    highlight.Parent = char
                end
            end
        end
    else
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character then
                local highlight = player.Character:FindFirstChild("PlayerESP")
                if highlight then
                    highlight:Destroy()
                end
            end
        end
    end
end)

-- [SILENT AIM FUNCTIONS]
-- Simple Silent Aim implementation
local function getClosestPlayerToMouse()
    local closestPlayer = nil
    local shortestDistance = SilentAimSettings.FOVRadius
    
    local mousePos = UserInputService:GetMouseLocation()
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if SilentAimSettings.TeamCheck and player.Team == LocalPlayer.Team then continue end
            
            local character = player.Character
            if not character then continue end
            
            local targetPart = character:FindFirstChild(SilentAimSettings.TargetPart == "Random" and 
                (math.random() > 0.5 and "Head" or "HumanoidRootPart") or SilentAimSettings.TargetPart)
            
            if not targetPart then continue end
            
            local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
            if not onScreen then continue end
            
            local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
            
            if distance < shortestDistance then
                shortestDistance = distance
                closestPlayer = player
            end
        end
    end
    
    return closestPlayer
end

-- [KEYBINDS]
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F then
        settings.flyEnabled = not settings.flyEnabled
        if settings.flyEnabled then
            enableFly()
            Rayfield:Notify({
                Title = "Fly",
                Content = "Fly Enabled",
                Duration = 2
            })
        else
            disableFly()
            Rayfield:Notify({
                Title = "Fly",
                Content = "Fly Disabled",
                Duration = 2
            })
        end
    end
    
    if input.KeyCode == Enum.KeyCode.X then
        settings.speedEnabled = not settings.speedEnabled
        if settings.speedEnabled then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = settings.speedValue
            end
            Rayfield:Notify({
                Title = "Walkspeed",
                Content = "Walkspeed Enabled",
                Duration = 2
            })
        else
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 16
            end
            Rayfield:Notify({
                Title = "Walkspeed",
                Content = "Walkspeed Disabled",
                Duration = 2
            })
        end
    end
    
    if input.KeyCode == Enum.KeyCode.RightAlt then
        local rayfieldGui = game:GetService("CoreGui"):FindFirstChild("Rayfield")
        if rayfieldGui then
            rayfieldGui.Enabled = not rayfieldGui.Enabled
        end
    end
end)

-- [CHARACTER RESPAWN HANDLING]
LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    wait(0.5)
    
    if settings.speedEnabled then
        newCharacter:WaitForChild("Humanoid").WalkSpeed = settings.speedValue
    end
    
    if settings.jumpEnabled then
        newCharacter:WaitForChild("Humanoid").JumpPower = settings.jumpValue
    end
    
    if settings.flyEnabled then
        wait(0.5)
        enableFly()
    end
    
    if settings.noclipEnabled then
        enableNoClip()
    end
end)