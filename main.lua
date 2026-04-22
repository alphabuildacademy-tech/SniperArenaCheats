-- main.lua
-- Sniper Arena Cheat Script [REWRITTEN]
-- Features: AimBot, Silent Aim, FOV, WallBang, AutoFire, NoClip, Fly, Speed, Jump, InfiniteJump

local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ================== KURBYLIB UI LIBRARY (EMBEDDED) ==================
local Library = { Toggled = true, Accent = Color3.fromRGB(160, 60, 255), _blockDrag = false }

local Icons = {
    home          = { 16898613509, 48, 48, 820, 147 },
    flame         = { 16898613353, 48, 48, 967, 306 },
    settings      = { 16898613777, 48, 48, 771, 257 },
    account       = { 16898613869, 48, 48, 661, 869 },
    eye           = { 16898613353, 48, 48, 771, 563 },
    ["map-pin"]   = { 16898613613, 48, 48, 820, 257 },
    ["bar-chart-2"] = { 16898612629, 48, 48, 967, 710 },
    swords        = { 16898613777, 48, 48, 967, 759 },
    user          = { 16898613869, 48, 48, 661, 869 },
    shield        = { 16898613777, 48, 48, 869,   0 },
    zap           = { 16898613869, 48, 48, 918, 906 },
    target        = { 16898613869, 48, 48, 514, 771 },
    globe         = { 16898613509, 48, 48, 771, 563 },
    layout        = { 16898613509, 48, 48, 967, 612 },
    search        = { 16898613699, 48, 48, 918, 857 },
    save          = { 16898613699, 48, 48, 918, 453 },
    sliders       = { 16898613777, 48, 48, 404, 771 },
}

local function Create(class, props)
    local obj = Instance.new(class)
    for i, v in next, props do if i ~= "Parent" then obj[i] = v end end
    obj.Parent = props.Parent
    return obj
end

local function Tween(obj, time, props)
    TweenService:Create(obj, TweenInfo.new(time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props):Play()
end

function Library:MakeDraggable(gui)
    local drag, dStart, sPos
    gui.InputBegan:Connect(function(i)
        if (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) and not Library._blockDrag then
            drag = true; dStart = i.Position; sPos = gui.Position
            i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then drag = false end end)
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - dStart
            gui.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + d.X, sPos.Y.Scale, sPos.Y.Offset + d.Y)
        end
    end)
end

function Library:GetIcon(name)
    return Icons[name] or Icons["home"]
end

function Library:CreateWindow(title)
    local ScreenGui = Create("ScreenGui", {
        Name = "KurbyLib",
        Parent = (RunService:IsStudio() and LocalPlayer.PlayerGui) or CoreGui,
        ResetOnSpawn = false
    })
    if getgenv then
        if getgenv()._KurbyUI then getgenv()._KurbyUI:Destroy() end
        getgenv()._KurbyUI = ScreenGui
    end

    local Main = Create("Frame", {
        Parent = ScreenGui,
        BackgroundColor3 = Color3.fromRGB(8, 8, 8),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 600, 0, 440)
    })
    local Scale = Create("UIScale", { Parent = Main })
    local function updateScale()
        local Cam = workspace.CurrentCamera
        if not Cam then return end
        local view = Cam.ViewportSize
        local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled
        local refX = isMobile and 1000 or 800
        local refY = isMobile and 700 or 550
        local scaleFactor = math.min(view.X / refX, view.Y / refY, 1)
        if isMobile then scaleFactor = scaleFactor * 0.8 end
        Scale.Scale = scaleFactor
    end
    updateScale()
    Camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
    
    Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = Main })
    Create("UIStroke", { Color = Color3.fromRGB(45, 45, 45), Parent = Main })

    local Sidebar = Create("Frame", { Parent = Main, BackgroundColor3 = Color3.fromRGB(13, 13, 13), Size = UDim2.new(0, 65, 1, 0) })
    Create("UIStroke", { Color = Color3.fromRGB(35, 35, 35), ApplyStrokeMode = "Border", Parent = Sidebar })
    Create("TextLabel", { Parent = Sidebar, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 36), Font = "GothamBold", Text = "S", TextColor3 = Library.Accent, TextSize = 22 })

    local List = Create("Frame", { Parent = Sidebar, BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0, 36), Size = UDim2.new(1, 0, 1, -36) })
    Create("UIListLayout", { Parent = List, HorizontalAlignment = "Center", Padding = UDim.new(0, 4) })

    local Container = Create("Frame", { Parent = Main, BackgroundTransparency = 1, Position = UDim2.new(0, 65, 0, 0), Size = UDim2.new(1, -65, 1, 0) })
    local Header = Create("Frame", { Parent = Container, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 48) })
    Create("TextLabel", { Parent = Header, BackgroundTransparency = 1, Position = UDim2.new(0, 16, 0, 0), Size = UDim2.new(0, 180, 1, 0), Font = "GothamBold", Text = title or "Sniper Arena", TextColor3 = Color3.new(1, 1, 1), TextSize = 18, TextXAlignment = "Left" })
    local SubTabBar = Create("Frame", { Parent = Header, BackgroundTransparency = 1, Position = UDim2.new(0, 200, 0, 0), Size = UDim2.new(1, -200, 1, 0) })
    Create("UIListLayout", { Parent = SubTabBar, FillDirection = "Horizontal", Padding = UDim.new(0, 16), VerticalAlignment = "Center" })
    Create("Frame", { Parent = Header, BackgroundColor3 = Color3.fromRGB(30, 30, 30), BorderSizePixel = 0, Position = UDim2.new(0, 0, 1, -1), Size = UDim2.new(1, 0, 0, 1) })
    local Folder = Create("Frame", { Parent = Container, BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0, 48), Size = UDim2.new(1, 0, 1, -48) })
    Library:MakeDraggable(Main)

    local toggled = true
    UIS.InputBegan:Connect(function(input) if input.KeyCode == Enum.KeyCode.RightShift then toggled = not toggled; Main.Visible = toggled end end)

    local Window = { Current = nil }
    function Window:CreateTab(name, iconName)
        local Btn = Create("ImageButton", { Name = name .. "Tab", Parent = List, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 50) })
        local Highlight = Create("Frame", { Parent = Btn, BackgroundColor3 = Color3.fromRGB(30, 30, 30), BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.new(1, 0, 1, 0) })
        Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Highlight })
        local Ind = Create("Frame", { Name = "Indicator", Parent = Btn, BackgroundColor3 = Library.Accent, BorderSizePixel = 0, Position = UDim2.new(0, 0, 0.5, -12), Size = UDim2.new(0, 3, 0, 24), BackgroundTransparency = 1, ZIndex = 5 })
        Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Ind })
        local iconData = Library:GetIcon(iconName or "home")
        local Ico = Create("ImageLabel", { Name = "Icon", Parent = Btn, BackgroundTransparency = 1, Position = UDim2.new(0.5, -18, 0.5, -18), Size = UDim2.new(0, 36, 0, 36), Image = "rbxassetid://" .. iconData[1], ImageRectSize = Vector2.new(iconData[2], iconData[3]), ImageRectOffset = Vector2.new(iconData[4], iconData[5]), ImageColor3 = Color3.fromRGB(140, 140, 140), ScaleType = Enum.ScaleType.Fit, ZIndex = 6 })
        local Tab = { SubTabs = {}, CurrentST = nil }
        function Tab:Select()
            for _, v in next, List:GetChildren() do if v:IsA("ImageButton") then if v:FindFirstChild("Indicator") then Tween(v.Indicator, 0.25, { BackgroundTransparency = 1 }) end if v:FindFirstChild("Icon") then Tween(v.Icon, 0.25, { ImageColor3 = Color3.fromRGB(140, 140, 140) }) end for _, f in next, v:GetChildren() do if f:IsA("Frame") and f.Name ~= "Indicator" then Tween(f, 0.25, { BackgroundTransparency = 1 }) end end end end
            if Window.Current then for _, st in next, Window.Current.Tab.SubTabs do st.Btn.Visible = false; st.Page.Visible = false end end
            Window.Current = { Tab = Tab }
            Tween(Ico, 0.25, { ImageColor3 = Library.Accent }); Tween(Ind, 0.25, { BackgroundTransparency = 0 }); Tween(Highlight, 0.25, { BackgroundTransparency = 0.85 })
            for _, st in next, Tab.SubTabs do st.Btn.Visible = true end
            if Tab.CurrentST then Tab.CurrentST:Select() elseif Tab.SubTabs[1] then Tab.SubTabs[1]:Select() end
        end
        Btn.MouseButton1Click:Connect(function() Tab:Select() end)
        function Tab:CreateSubTab(stName, stIconName)
            local stIconData = Library:GetIcon(stIconName or "layout")
            local SBtn = Create("Frame", { Parent = SubTabBar, BackgroundTransparency = 1, Size = UDim2.new(0, 0, 1, 0), AutomaticSize = "X", Visible = false })
            local SClick = Create("TextButton", { Parent = SBtn, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = "" })
            local SIco = Create("ImageLabel", { Name = "Icon", Parent = SBtn, BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0.5, -10), Size = UDim2.new(0, 20, 0, 20), Image = "rbxassetid://" .. stIconData[1], ImageRectSize = Vector2.new(stIconData[2], stIconData[3]), ImageRectOffset = Vector2.new(stIconData[4], stIconData[5]), ImageColor3 = Color3.fromRGB(160, 160, 160), ScaleType = Enum.ScaleType.Fit })
            local SText = Create("TextLabel", { Name = "Label", Parent = SBtn, BackgroundTransparency = 1, Position = UDim2.new(0, 22, 0, 0), Size = UDim2.new(0, 0, 1, 0), AutomaticSize = "X", Font = "Gotham", Text = stName, TextColor3 = Color3.fromRGB(160, 160, 160), TextSize = 13 })
            local SLine = Create("Frame", { Parent = SBtn, BackgroundColor3 = Library.Accent, BackgroundTransparency = 1, BorderSizePixel = 0, Position = UDim2.new(0, 0, 1, -2), Size = UDim2.new(1, 0, 0, 2) })
            local SPage = Create("ScrollingFrame", { Parent = Folder, BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.new(1, 0, 1, 0), Visible = false, ScrollBarThickness = 2, ScrollBarImageColor3 = Library.Accent, AutomaticCanvasSize = "Y", CanvasSize = UDim2.new(0, 0, 0, 0), ScrollingDirection = "Y" })
            Create("UIListLayout", { Parent = SPage, Padding = UDim.new(0, 10), HorizontalAlignment = "Center", Name = "Layout" })
            Create("UIPadding", { Parent = SPage, PaddingTop = UDim.new(0, 14), PaddingLeft = UDim.new(0, 18), PaddingRight = UDim.new(0, 18) })
            local SubTab = { Page = SPage, Btn = SBtn }
            function SubTab:Select()
                if Tab.CurrentST then Tab.CurrentST.Page.Visible = false; Tween(Tab.CurrentST.Btn.Label, 0.2, { TextColor3 = Color3.fromRGB(160, 160, 160) }); Tween(Tab.CurrentST.Btn.Icon, 0.2, { ImageColor3 = Color3.fromRGB(160, 160, 160) }); local oldLine = Tab.CurrentST.Btn:FindFirstChildOfClass("Frame"); if oldLine then Tween(oldLine, 0.2, { BackgroundTransparency = 1 }) end end
                Tab.CurrentST = SubTab; SPage.Visible = true; Tween(SText, 0.2, { TextColor3 = Color3.new(1, 1, 1) }); Tween(SIco, 0.2, { ImageColor3 = Library.Accent }); Tween(SLine, 0.2, { BackgroundTransparency = 0 })
            end
            SClick.MouseButton1Click:Connect(function() SubTab:Select() end)
            table.insert(Tab.SubTabs, SubTab)
            function SubTab:CreateSection(secName)
                local Sec = Create("Frame", { Parent = SPage, BackgroundColor3 = Color3.fromRGB(16, 16, 16), Size = UDim2.new(1, 0, 0, 30) })
                Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Sec }); Create("Frame", { Parent = Sec, BackgroundColor3 = Library.Accent, BorderSizePixel = 0, Position = UDim2.new(0, 0, 0, 6), Size = UDim2.new(0, 2, 0, 18) }); Create("TextLabel", { Parent = Sec, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 0), Size = UDim2.new(1, -10, 1, 0), Font = "GothamBold", Text = secName:upper(), TextColor3 = Color3.fromRGB(190, 190, 190), TextSize = 11, TextXAlignment = "Left" })
                local Content = Create("Frame", { Parent = SPage, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0) })
                local L = Create("UIListLayout", { Parent = Content, Padding = UDim.new(0, 6) }); L:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() Content.Size = UDim2.new(1, 0, 0, L.AbsoluteContentSize.Y) end)
                local S = {}
                function S:CreateToggle(n, def, cb)
                    local F = Create("TextButton", { Parent = Content, BackgroundColor3 = Color3.fromRGB(13, 13, 13), Size = UDim2.new(1, 0, 0, 42), Text = "", AutoButtonColor = false }); Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = F }); Create("TextLabel", { Parent = F, BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(1, -64, 1, 0), Font = "Gotham", Text = n, TextColor3 = Color3.fromRGB(225, 225, 225), TextSize = 14, TextXAlignment = "Left" })
                    local O = Create("Frame", { Parent = F, AnchorPoint = Vector2.new(1, 0.5), BackgroundColor3 = Color3.fromRGB(35, 35, 35), Position = UDim2.new(1, -12, 0.5, 0), Size = UDim2.new(0, 36, 0, 18) }); Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = O })
                    local I = Create("Frame", { Parent = O, BackgroundColor3 = Color3.new(1, 1, 1), Position = UDim2.new(0, 2, 0.5, -7), Size = UDim2.new(0, 14, 0, 14) }); Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = I })
                    local t = def or false; local function u() Tween(O, 0.2, { BackgroundColor3 = t and Library.Accent or Color3.fromRGB(35, 35, 35) }); Tween(I, 0.2, { Position = t and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7) }); if cb then cb(t) end end; F.MouseButton1Click:Connect(function() t = not t; u() end); u()
                    return { Set = function(_, v) t = v; u() end }
                end
                function S:CreateSlider(n, min, max, def, cb)
                    local F = Create("Frame", { Parent = Content, BackgroundColor3 = Color3.fromRGB(13, 13, 13), Size = UDim2.new(1, 0, 0, 50) }); Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = F }); Create("TextLabel", { Parent = F, BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(1, -70, 0, 24), Font = "Gotham", Text = n, TextColor3 = Color3.fromRGB(225, 225, 225), TextSize = 14, TextXAlignment = "Left" })
                    local Val = Create("TextLabel", { Parent = F, BackgroundTransparency = 1, Position = UDim2.new(1, -60, 0, 0), Size = UDim2.new(0, 48, 0, 24), Font = "GothamBold", Text = tostring(def), TextColor3 = Library.Accent, TextSize = 13, TextXAlignment = "Right" })
                    local Bar = Create("Frame", { Parent = F, BackgroundColor3 = Color3.fromRGB(35, 35, 35), Position = UDim2.new(0, 12, 0, 32), Size = UDim2.new(1, -24, 0, 6) }); Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Bar })
                    local Fill = Create("Frame", { Parent = Bar, BackgroundColor3 = Library.Accent, Size = UDim2.new((def - min) / (max - min), 0, 1, 0) }); Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Fill })
                    local Knob = Create("Frame", { Parent = Fill, AnchorPoint = Vector2.new(1, 0.5), BackgroundColor3 = Color3.new(1, 1, 1), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.new(0, 12, 0, 12) }); Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Knob })
                    local dragging = false; local function move(input) local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1); local val = math.floor(min + (max - min) * pos); Fill.Size = UDim2.new(pos, 0, 1, 0); Val.Text = tostring(val); cb(val) end; Bar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true; Library._blockDrag = true; move(i) end end); UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false; Library._blockDrag = false end end); UIS.InputChanged:Connect(function(i) if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then move(i) end end)
                end
                function S:CreateDropdown(n, items, def, cb)
                    local F = Create("TextButton", { Parent = Content, BackgroundColor3 = Color3.fromRGB(13, 13, 13), Size = UDim2.new(1, 0, 0, 42), ClipsDescendants = true, Text = "", AutoButtonColor = false }); Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = F })
                    local Lbl = Create("TextLabel", { Parent = F, BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(1, -44, 0, 42), Font = "Gotham", Text = def and (n .. ": " .. tostring(def)) or n, TextColor3 = Color3.fromRGB(225, 225, 225), TextSize = 14, TextXAlignment = "Left" }); local Arrow = Create("TextLabel", { Parent = F, BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -12, 0, 0), Size = UDim2.new(0, 20, 0, 42), Font = "GothamBold", Text = "v", TextColor3 = Color3.fromRGB(140, 140, 140), TextSize = 12 })
                    local ItemList = Create("Frame", { Parent = F, BackgroundTransparency = 1, Position = UDim2.new(0, 6, 0, 42), Size = UDim2.new(1, -12, 0, 0) }); Create("UIListLayout", { Parent = ItemList, Padding = UDim.new(0, 3) }); local opened = false
                    local function refresh(list) for _, c in next, ItemList:GetChildren() do if c:IsA("TextButton") then c:Destroy() end end for _, item in next, list do local Btn = Create("TextButton", { Parent = ItemList, BackgroundColor3 = Color3.fromRGB(22, 22, 22), Size = UDim2.new(1, 0, 0, 28), Font = "Gotham", Text = tostring(item), TextColor3 = Color3.fromRGB(200, 200, 200), TextSize = 13, AutoButtonColor = false }); Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = Btn }); Btn.MouseButton1Click:Connect(function() Lbl.Text = n .. ": " .. tostring(item); opened = false; Arrow.Text = "v"; Tween(F, 0.25, { Size = UDim2.new(1, 0, 0, 42) }); cb(item) end) end end
                    refresh(items); F.MouseButton1Click:Connect(function() opened = not opened; Arrow.Text = opened and "^" or "v"; local h = opened and (42 + ItemList.UIListLayout.AbsoluteContentSize.Y + 8) or 42; Tween(F, 0.25, { Size = UDim2.new(1, 0, 0, h) }) end)
                end
                function S:CreateButton(n, cb)
                    local B = Create("TextButton", { Parent = Content, BackgroundColor3 = Color3.fromRGB(13, 13, 13), Size = UDim2.new(1, 0, 0, 42), Text = "", AutoButtonColor = false }); Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = B }); Create("TextLabel", { Parent = B, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Font = "Gotham", Text = n, TextColor3 = Color3.fromRGB(225, 225, 225), TextSize = 14 }); B.MouseButton1Click:Connect(cb)
                end
                return S
            end
            return SubTab
        end
        if not Window.Current then Tab:Select() end
        return Tab
    end
    return Window
end

-- ================== GAME LOGIC & HOOKS ==================
local Framework = require(game:GetService("ReplicatedStorage"):WaitForChild("Framework"))
local Packets = Framework.Common.Network.Packets.queries

local Config = {
    Aimbot = { Enabled = false, FOV = 200, Smoothness = 1, Part = "Head", TeamCheck = true, Prediction = 0.12 },
    SilentAim = { Enabled = false, FOV = 300, Part = "Head", TeamCheck = true },
    WallBang = { Enabled = false },
    AutoFire = { Enabled = false, Delay = 0.1 },
    Movement = { Speed = 16, Jump = 50, Fly = false, FlySpeed = 50, Noclip = false, InfJump = false }
}

-- Helpers
local function getTarget(fov, teamCheck)
    local maxDist = fov
    local target = nil
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and (not teamCheck or p.Team ~= LocalPlayer.Team) then
            local char = p.Character
            if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                local part = char:FindFirstChild(Config.Aimbot.Part)
                if part then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                    if onScreen then
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - UIS:GetMouseLocation()).Magnitude
                        if dist < maxDist then
                            maxDist = dist
                            target = char
                        end
                    end
                end
            end
        end
    end
    return target
end

-- Silent Aim & WallBang Hooks
local oldShootInvoke = Packets.Shoot.invoke
Packets.Shoot.invoke = function(self, data)
    if Config.SilentAim.Enabled then
        local target = getTarget(Config.SilentAim.FOV, Config.SilentAim.TeamCheck)
        if target then
            local part = target:FindFirstChild(Config.SilentAim.Part)
            if part then
                local pred = part.Position + (part.Velocity * Config.Aimbot.Prediction)
                data.Direction = (pred - data.Origin).Unit
            end
        end
    end
    return oldShootInvoke(self, data)
end

-- Raycast Hook for WallBang
local oldRaycast = workspace.Raycast
workspace.Raycast = function(self, origin, direction, params)
    if Config.WallBang.Enabled then
        if params and params.FilterType == Enum.RaycastFilterType.Blacklist then
            -- Allow bullets to pass through walls by returning nil or filtering walls
            return nil
        end
    end
    return oldRaycast(self, origin, direction, params)
end

-- FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.NumSides = 64
FOVCircle.Radius = Config.Aimbot.FOV
FOVCircle.Filled = false
FOVCircle.Transparent = 1
FOVCircle.Color = Color3.new(1, 1, 1)
FOVCircle.Visible = false

RunService.RenderStepped:Connect(function()
    FOVCircle.Position = UIS:GetMouseLocation()
    FOVCircle.Radius = Config.Aimbot.FOV
    FOVCircle.Visible = Config.Aimbot.Enabled or Config.SilentAim.Enabled

    -- Aimbot Loop
    if Config.Aimbot.Enabled and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = getTarget(Config.Aimbot.FOV, Config.Aimbot.TeamCheck)
        if target then
            local part = target:FindFirstChild(Config.Aimbot.Part)
            if part then
                local camCFrame = Camera.CFrame
                local targetPos = part.Position + (part.Velocity * Config.Aimbot.Prediction)
                local lookAt = CFrame.new(camCFrame.Position, targetPos)
                Camera.CFrame = camCFrame:Lerp(lookAt, 1 / Config.Aimbot.Smoothness)
            end
        end
    end

    -- AutoFire
    if Config.AutoFire.Enabled then
        local target = getTarget(Config.Aimbot.FOV, Config.Aimbot.TeamCheck)
        if target then
            local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then tool:Activate() end
        end
    end
end)

-- Movement Hacks
RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return end

    hum.WalkSpeed = Config.Movement.Speed
    hum.JumpPower = Config.Movement.Jump

    if Config.Movement.Noclip then
        for _, v in ipairs(char:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end

    if Config.Movement.Fly then
        root.Velocity = Vector3.new(0, 0, 0)
        local move = Vector3.new(0, 0, 0)
        if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then move = move - Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then move = move - Camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then move = move + Camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0, 1, 0) end
        root.CFrame = root.CFrame + (move * (Config.Movement.FlySpeed / 50))
    end
end)

UIS.JumpRequest:Connect(function()
    if Config.Movement.InfJump then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- ================== UI SETUP ==================
local Win = Library:CreateWindow("Sniper Arena | Private")
local Tab1 = Win:CreateTab("Aimbot", "target")
local Tab2 = Win:CreateTab("Visuals", "eye")
local Tab3 = Win:CreateTab("Movement", "zap")
local Tab4 = Win:CreateTab("Settings", "sliders")

local AIM = Tab1:CreateSubTab("Main", "target")
local secAim = AIM:CreateSection("Aimbot Settings")
secAim:CreateToggle("Enabled", false, function(v) Config.Aimbot.Enabled = v end)
secAim:CreateSlider("FOV", 50, 800, 200, function(v) Config.Aimbot.FOV = v end)
secAim:CreateSlider("Smoothness", 1, 20, 1, function(v) Config.Aimbot.Smoothness = v end)
secAim:CreateDropdown("Target Part", {"Head", "HumanoidRootPart", "Torso"}, "Head", function(v) Config.Aimbot.Part = v end)
secAim:CreateToggle("Team Check", true, function(v) Config.Aimbot.TeamCheck = v end)

local SIL = Tab1:CreateSubTab("Silent", "shield")
local secSil = SIL:CreateSection("Silent Aim")
secSil:CreateToggle("Enabled", false, function(v) Config.SilentAim.Enabled = v end)
secSil:CreateSlider("Silent FOV", 50, 800, 300, function(v) Config.SilentAim.FOV = v end)
secSil:CreateToggle("WallBang", false, function(v) Config.WallBang.Enabled = v end)

local VIS = Tab2:CreateSubTab("Main", "eye")
local secVis = VIS:CreateSection("Visuals")
secVis:CreateToggle("Show FOV", true, function(v) FOVCircle.Visible = v end)

local MOV = Tab3:CreateSubTab("Main", "zap")
local secMov = MOV:CreateSection("Movement")
secMov:CreateToggle("Fly", false, function(v) Config.Movement.Fly = v end)
secMov:CreateSlider("Fly Speed", 10, 250, 50, function(v) Config.Movement.FlySpeed = v end)
secMov:CreateToggle("Noclip", false, function(v) Config.Movement.Noclip = v end)
secMov:CreateToggle("Inf Jump", false, function(v) Config.Movement.InfJump = v end)
secMov:CreateSlider("WalkSpeed", 16, 200, 16, function(v) Config.Movement.Speed = v v.WalkSpeed = v end)
secMov:CreateSlider("JumpPower", 50, 300, 50, function(v) Config.Movement.Jump = v end)

local SET = Tab4:CreateSubTab("Main", "settings")
local secSet = SET:CreateSection("UI Settings")
secSet:CreateButton("Destroy UI", function() if getgenv()._KurbyUI then getgenv()._KurbyUI:Destroy() end FOVCircle:Remove() end)

print("Sniper Arena Cheat Loaded!")