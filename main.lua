-- main.lua
-- Sniper Arena Cheat Script 

-- ================== SERVICES ==================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- ================== LOAD UI LIBRARY ==================
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/your-username/sniper-arena-cheat/main/KurbyLib.lua"))() -- Or paste the library code directly
local Window = Library:CreateWindow("Sniper Arena | Private")

-- ================== CREATE TABS ==================
local AimbotTab = Window:CreateTab("Aimbot", "target")
local VisualsTab = Window:CreateTab("Visuals", "eye")
local MovementTab = Window:CreateTab("Movement", "zap")
local SettingsTab = Window:CreateTab("Settings", "sliders")

-- Sub-tabs for organization
local AimbotMain = AimbotTab:CreateSubTab("Main", "target")
local AimbotSilent = AimbotTab:CreateSubTab("Silent", "shield")

local VisualsMain = VisualsTab:CreateSubTab("Main", "eye")
local MovementMain = MovementTab:CreateSubTab("Main", "zap")
local SettingsMain = SettingsTab:CreateSubTab("Main", "settings")

-- ================== FEATURE VARIABLES ==================
local Aimbot = {
    Enabled = false,
    FOV = 200,
    AimPart = "Head",
    Smoothness = 1,
    TeamCheck = true,
    WallCheck = false,
    Prediction = 0.15
}

local SilentAim = {
    Enabled = false,
    AimPart = "Head",
    TeamCheck = true
}

local WallBang = {
    Enabled = false
}

local AutoFire = {
    Enabled = false,
    Delay = 0.1
}

local Noclip = {
    Enabled = false
}

local Fly = {
    Enabled = false,
    Speed = 50
}

local Speed = {
    Enabled = false,
    Value = 32
}

local JumpPower = {
    Enabled = false,
    Value = 50
}

local InfiniteJump = {
    Enabled = false
}

local FOVCircle = {
    Enabled = false,
    Color = Color3.fromRGB(255, 255, 255),
    Thickness = 1
}

-- ================== HELPER FUNCTIONS ==================
local function getClosestPlayerInFOV(fov, aimPart, teamCheck)
    local mousePos = UserInputService:GetMouseLocation()
    local closestPlayer = nil
    local shortestDistance = fov

    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        if teamCheck and player.Team == LocalPlayer.Team then continue end

        local character = player.Character
        if not character then continue end

        local part = character:FindFirstChild(aimPart)
        if not part then continue end

        local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
        if not onScreen then continue end

        local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
        if distance < shortestDistance then
            shortestDistance = distance
            closestPlayer = player
        end
    end

    return closestPlayer
end

-- ================== SILENT AIM HOOK ==================
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod()

    if method == "FindPartOnRay" and SilentAim.Enabled then
        local target = getClosestPlayerInFOV(500, SilentAim.AimPart, SilentAim.TeamCheck)
        if target and target.Character then
            local hitPart = target.Character:FindFirstChild(SilentAim.AimPart)
            if hitPart then
                return hitPart, hitPart.Position
            end
        end
    end

    return oldNamecall(self, ...)
end)

-- ================== WALLBANG (Raycast Bypass) ==================
local oldRaycast = Workspace.Raycast
Workspace.Raycast = function(origin, direction, params)
    if WallBang.Enabled and params and params.FilterType == Enum.RaycastFilterType.Blacklist then
        -- Modify to ignore walls (simplified; may need game-specific tuning)
        return nil
    end
    return oldRaycast(origin, direction, params)
end

-- ================== FOV CIRCLE DRAWING ==================
local DrawingLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/linxule/DrawingLib/main/Drawing.lua"))()
local FOVCircleObj = DrawingLib.new("Circle")
FOVCircleObj.Visible = false
FOVCircleObj.Radius = Aimbot.FOV
FOVCircleObj.Color = FOVCircle.Color
FOVCircleObj.Thickness = FOVCircle.Thickness
FOVCircleObj.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

RunService.RenderStepped:Connect(function()
    if FOVCircle.Enabled then
        FOVCircleObj.Visible = true
        FOVCircleObj.Position = UserInputService:GetMouseLocation()
        FOVCircleObj.Radius = Aimbot.FOV
        FOVCircleObj.Color = FOVCircle.Color
    else
        FOVCircleObj.Visible = false
    end
end)

-- ================== AIMBOT (Right-Click Lock) ==================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 and Aimbot.Enabled then
        local target = getClosestPlayerInFOV(Aimbot.FOV, Aimbot.AimPart, Aimbot.TeamCheck)
        if target and target.Character then
            local targetPart = target.Character:FindFirstChild(Aimbot.AimPart)
            if targetPart then
                -- Smooth aim (optional)
                local targetPos = targetPart.Position
                local camPos = Camera.CFrame.Position
                local lookAt = CFrame.lookAt(camPos, targetPos)
                if Aimbot.Smoothness > 1 then
                    Camera.CFrame = Camera.CFrame:Lerp(lookAt, 1 / Aimbot.Smoothness)
                else
                    Camera.CFrame = lookAt
                end
            end
        end
    end
end)

-- ================== AUTOFIRE LOOP ==================
RunService.Heartbeat:Connect(function()
    if AutoFire.Enabled then
        local target = getClosestPlayerInFOV(Aimbot.FOV, Aimbot.AimPart, Aimbot.TeamCheck)
        if target then
            local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool and tool:IsA("Tool") then
                tool:Activate()
                task.wait(AutoFire.Delay)
            end
        end
    end
end)

-- ================== MOVEMENT HACKS ==================
local function applyMovementHacks()
    local character = LocalPlayer.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    if Speed.Enabled then
        humanoid.WalkSpeed = Speed.Value
    else
        humanoid.WalkSpeed = 16
    end

    if JumpPower.Enabled then
        humanoid.JumpPower = JumpPower.Value
    else
        humanoid.JumpPower = 50
    end

    if InfiniteJump.Enabled then
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
        humanoid.Jump = true
    end
end

RunService.Heartbeat:Connect(applyMovementHacks)

-- ================== NOCLIP ==================
local function setNoclip(state)
    local character = LocalPlayer.Character
    if not character then return end
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not state
        end
    end
end

-- ================== FLY ==================
local flyBodyGyro, flyBodyVelocity
local function toggleFly(state)
    local character = LocalPlayer.Character
    if not character then return end
    local root = character:WaitForChild("HumanoidRootPart")

    if state then
        flyBodyGyro = Instance.new("BodyGyro")
        flyBodyGyro.P = 9e4
        flyBodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        flyBodyGyro.CFrame = root.CFrame
        flyBodyGyro.Parent = root

        flyBodyVelocity = Instance.new("BodyVelocity")
        flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
        flyBodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        flyBodyVelocity.Parent = root

        -- Fly controls
        local controls = {
            W = false, A = false, S = false, D = false,
            Space = false, LeftShift = false
        }
        UserInputService.InputBegan:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.W then controls.W = true
            elseif input.KeyCode == Enum.KeyCode.A then controls.A = true
            elseif input.KeyCode == Enum.KeyCode.S then controls.S = true
            elseif input.KeyCode == Enum.KeyCode.D then controls.D = true
            elseif input.KeyCode == Enum.KeyCode.Space then controls.Space = true
            elseif input.KeyCode == Enum.KeyCode.LeftShift then controls.LeftShift = true
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.W then controls.W = false
            elseif input.KeyCode == Enum.KeyCode.A then controls.A = false
            elseif input.KeyCode == Enum.KeyCode.S then controls.S = false
            elseif input.KeyCode == Enum.KeyCode.D then controls.D = false
            elseif input.KeyCode == Enum.KeyCode.Space then controls.Space = false
            elseif input.KeyCode == Enum.KeyCode.LeftShift then controls.LeftShift = false
            end
        end)

        RunService.Heartbeat:Connect(function()
            if not Fly.Enabled then return end
            local moveVector = Vector3.new(
                (controls.D and 1 or 0) - (controls.A and 1 or 0),
                (controls.Space and 1 or 0) - (controls.LeftShift and 1 or 0),
                (controls.S and 1 or 0) - (controls.W and 1 or 0)
            )
            if moveVector.Magnitude > 0 then
                flyBodyVelocity.Velocity = (Camera.CFrame:VectorToWorldSpace(moveVector)) * Fly.Speed
                flyBodyGyro.CFrame = Camera.CFrame
            else
                flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
            end
        end)
    else
        if flyBodyGyro then flyBodyGyro:Destroy() end
        if flyBodyVelocity then flyBodyVelocity:Destroy() end
    end
end

-- ================== UI ELEMENTS ==================

-- Aimbot Main Section
local aimbotSection = AimbotMain:CreateSection("Aimbot Settings")
aimbotSection:CreateToggle("Enable Aimbot", false, function(val) Aimbot.Enabled = val end)
aimbotSection:CreateSlider("FOV", 50, 500, 200, function(val) Aimbot.FOV = val end)
aimbotSection:CreateDropdown("Aim Part", {"Head", "HumanoidRootPart", "Torso"}, "Head", function(val) Aimbot.AimPart = val end)
aimbotSection:CreateSlider("Smoothness", 1, 20, 1, function(val) Aimbot.Smoothness = val end)
aimbotSection:CreateToggle("Team Check", true, function(val) Aimbot.TeamCheck = val end)

-- Silent Aim Section
local silentSection = AimbotSilent:CreateSection("Silent Aim")
silentSection:CreateToggle("Enable Silent Aim", false, function(val) SilentAim.Enabled = val end)
silentSection:CreateDropdown("Silent Aim Part", {"Head", "HumanoidRootPart", "Torso"}, "Head", function(val) SilentAim.AimPart = val end)
silentSection:CreateToggle("Team Check", true, function(val) SilentAim.TeamCheck = val end)

-- Visuals Section
local visualsSection = VisualsMain:CreateSection("Visuals")
visualsSection:CreateToggle("FOV Circle", false, function(val) FOVCircle.Enabled = val end)
visualsSection:CreateToggle("WallBang (Shoot Through Walls)", false, function(val) WallBang.Enabled = val end)

-- Movement Section
local movementSection = MovementMain:CreateSection("Movement Hacks")
movementSection:CreateToggle("NoClip", false, function(val)
    Noclip.Enabled = val
    setNoclip(val)
end)
movementSection:CreateToggle("Fly", false, function(val)
    Fly.Enabled = val
    toggleFly(val)
end)
movementSection:CreateSlider("Fly Speed", 20, 200, 50, function(val) Fly.Speed = val end)
movementSection:CreateToggle("Speed Hack", false, function(val)
    Speed.Enabled = val
    applyMovementHacks()
end)
movementSection:CreateSlider("WalkSpeed", 16, 200, 32, function(val)
    Speed.Value = val
    applyMovementHacks()
end)
movementSection:CreateToggle("JumpPower Hack", false, function(val)
    JumpPower.Enabled = val
    applyMovementHacks()
end)
movementSection:CreateSlider("JumpPower", 50, 300, 50, function(val)
    JumpPower.Value = val
    applyMovementHacks()
end)
movementSection:CreateToggle("Infinite Jump", false, function(val) InfiniteJump.Enabled = val end)

-- AutoFire Section
local combatSection = AimbotMain:CreateSection("Combat")
combatSection:CreateToggle("AutoFire", false, function(val) AutoFire.Enabled = val end)
combatSection:CreateSlider("AutoFire Delay", 0.05, 0.5, 0.1, function(val) AutoFire.Delay = val end)

-- Settings Section
local settingsSection = SettingsMain:CreateSection("UI Settings")
settingsSection:CreateButton("Destroy UI", function()
    if getgenv()._KurbyUI then
        getgenv()._KurbyUI:Destroy()
    end
end)

-- ================== CLEANUP ON RESPAWN ==================
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    applyMovementHacks()
    if Noclip.Enabled then setNoclip(true) end
    if Fly.Enabled then toggleFly(true) end
end)

print("Sniper Arena Cheat Loaded! Use RightShift to toggle UI.")