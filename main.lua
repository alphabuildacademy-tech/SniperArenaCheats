-- main.lua
-- Sniper Arena Cheat Script 

-- ================== KURBYLIB UI LIBRARY (EMBEDDED) ==================
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

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

    -- Sidebar
    local Sidebar = Create("Frame", {
        Parent = Main,
        BackgroundColor3 = Color3.fromRGB(13, 13, 13),
        Size = UDim2.new(0, 65, 1, 0)
    })
    Create("UIStroke", { Color = Color3.fromRGB(35, 35, 35), ApplyStrokeMode = "Border", Parent = Sidebar })

    -- Logo
    Create("TextLabel", {
        Parent = Sidebar,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 36),
        Font = "GothamBold",
        Text = "K",
        TextColor3 = Library.Accent,
        TextSize = 22
    })

    local List = Create("Frame", {
        Parent = Sidebar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 36),
        Size = UDim2.new(1, 0, 1, -36)
    })
    Create("UIListLayout", {
        Parent = List,
        HorizontalAlignment = "Center",
        Padding = UDim.new(0, 4)
    })

    -- Content area
    local Container = Create("Frame", {
        Parent = Main,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 65, 0, 0),
        Size = UDim2.new(1, -65, 1, 0)
    })

    local Header = Create("Frame", { Parent = Container, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 48) })
    Create("TextLabel", {
        Parent = Header,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 16, 0, 0),
        Size = UDim2.new(0, 180, 1, 0),
        Font = "GothamBold",
        Text = title or "Kurby Hub",
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 18,
        TextXAlignment = "Left"
    })

    local SubTabBar = Create("Frame", { Parent = Header, BackgroundTransparency = 1, Position = UDim2.new(0, 200, 0, 0), Size = UDim2.new(1, -200, 1, 0) })
    Create("UIListLayout", { Parent = SubTabBar, FillDirection = "Horizontal", Padding = UDim.new(0, 16), VerticalAlignment = "Center" })
    Create("Frame", { Parent = Header, BackgroundColor3 = Color3.fromRGB(30, 30, 30), BorderSizePixel = 0, Position = UDim2.new(0, 0, 1, -1), Size = UDim2.new(1, 0, 0, 1) })

    local Folder = Create("Frame", { Parent = Container, BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0, 48), Size = UDim2.new(1, 0, 1, -48) })
    Library:MakeDraggable(Main)

    -- Mobile detection & toggle
    local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled
    local toggled = true

    local function toggleUI()
        toggled = not toggled
        Main.Visible = toggled
    end

    -- RightShift to toggle (always active)
    UIS.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.RightShift then
            toggleUI()
        end
    end)

    local Window = { Current = nil }

    function Window:CreateTab(name, iconName)
        local Btn = Create("ImageButton", {
            Name = name .. "Tab",
            Parent = List,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 50)
        })

        local Highlight = Create("Frame", {
            Parent = Btn,
            BackgroundColor3 = Color3.fromRGB(30, 30, 30),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0)
        })
        Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Highlight })

        local Ind = Create("Frame", {
            Name = "Indicator",
            Parent = Btn,
            BackgroundColor3 = Library.Accent,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0.5, -12),
            Size = UDim2.new(0, 3, 0, 24),
            BackgroundTransparency = 1,
            ZIndex = 5
        })
        Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Ind })

        local iconData = Library:GetIcon(iconName or "home")
        local Ico = Create("ImageLabel", {
            Name = "Icon",
            Parent = Btn,
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, -18, 0.5, -18),
            Size = UDim2.new(0, 36, 0, 36),
            Image = "rbxassetid://" .. iconData[1],
            ImageRectSize = Vector2.new(iconData[2], iconData[3]),
            ImageRectOffset = Vector2.new(iconData[4], iconData[5]),
            ImageColor3 = Color3.fromRGB(140, 140, 140),
            ScaleType = Enum.ScaleType.Fit,
            ZIndex = 6
        })

        local Tab = { SubTabs = {}, CurrentST = nil }

        function Tab:Select()
            for _, v in next, List:GetChildren() do
                if v:IsA("ImageButton") then
                    if v:FindFirstChild("Indicator") then Tween(v.Indicator, 0.25, { BackgroundTransparency = 1 }) end
                    if v:FindFirstChild("Icon") then Tween(v.Icon, 0.25, { ImageColor3 = Color3.fromRGB(140, 140, 140) }) end
                    for _, f in next, v:GetChildren() do
                        if f:IsA("Frame") and f.Name ~= "Indicator" then Tween(f, 0.25, { BackgroundTransparency = 1 }) end
                    end
                end
            end
            if Window.Current then
                for _, st in next, Window.Current.Tab.SubTabs do
                    st.Btn.Visible = false
                    st.Page.Visible = false
                end
            end
            Window.Current = { Tab = Tab }
            Tween(Ico, 0.25, { ImageColor3 = Library.Accent })
            Tween(Ind, 0.25, { BackgroundTransparency = 0 })
            Tween(Highlight, 0.25, { BackgroundTransparency = 0.85 })
            for _, st in next, Tab.SubTabs do st.Btn.Visible = true end
            if Tab.CurrentST then Tab.CurrentST:Select() elseif Tab.SubTabs[1] then Tab.SubTabs[1]:Select() end
        end

        Btn.MouseButton1Click:Connect(function() Tab:Select() end)
        Btn.MouseEnter:Connect(function() if not Window.Current or Window.Current.Tab ~= Tab then Tween(Highlight, 0.2, { BackgroundTransparency = 0.92 }) end end)
        Btn.MouseLeave:Connect(function() if not Window.Current or Window.Current.Tab ~= Tab then Tween(Highlight, 0.2, { BackgroundTransparency = 1 }) end end)

        function Tab:CreateSubTab(stName, stIconName)
            local stIconData = Library:GetIcon(stIconName or "layout")
            local SBtn = Create("Frame", { Parent = SubTabBar, BackgroundTransparency = 1, Size = UDim2.new(0, 0, 1, 0), AutomaticSize = "X", Visible = false })
            local SClick = Create("TextButton", { Parent = SBtn, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = "" })
            local SIco = Create("ImageLabel", {
                Name = "Icon",
                Parent = SBtn,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0.5, -10),
                Size = UDim2.new(0, 20, 0, 20),
                Image = "rbxassetid://" .. stIconData[1],
                ImageRectSize = Vector2.new(stIconData[2], stIconData[3]),
                ImageRectOffset = Vector2.new(stIconData[4], stIconData[5]),
                ImageColor3 = Color3.fromRGB(160, 160, 160),
                ScaleType = Enum.ScaleType.Fit
            })
            local SText = Create("TextLabel", {
                Name = "Label",
                Parent = SBtn,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 22, 0, 0),
                Size = UDim2.new(0, 0, 1, 0),
                AutomaticSize = "X",
                Font = "Gotham",
                Text = stName,
                TextColor3 = Color3.fromRGB(160, 160, 160),
                TextSize = 13
            })
            local SLine = Create("Frame", {
                Parent = SBtn,
                BackgroundColor3 = Library.Accent,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 1, -2),
                Size = UDim2.new(1, 0, 0, 2)
            })
            local SPage = Create("ScrollingFrame", { 
                Parent = Folder, 
                BackgroundTransparency = 1, 
                BorderSizePixel = 0, 
                Size = UDim2.new(1, 0, 1, 0), 
                Visible = false, 
                ScrollBarThickness = isMobile and 4 or 2, 
                ScrollBarImageColor3 = Library.Accent,
                AutomaticCanvasSize = "Y",
                CanvasSize = UDim2.new(0, 0, 0, 0),
                ScrollingDirection = "Y"
            })
            Create("UIListLayout", { Parent = SPage, Padding = UDim.new(0, 10), HorizontalAlignment = "Center", Name = "Layout" })
            Create("UIPadding", { Parent = SPage, PaddingTop = UDim.new(0, 14), PaddingLeft = UDim.new(0, 18), PaddingRight = UDim.new(0, 18) })

            local SubTab = { Page = SPage, Btn = SBtn }

            function SubTab:Select()
                if Tab.CurrentST then
                    Tab.CurrentST.Page.Visible = false
                    Tween(Tab.CurrentST.Btn.Label, 0.2, { TextColor3 = Color3.fromRGB(160, 160, 160) })
                    Tween(Tab.CurrentST.Btn.Icon, 0.2, { ImageColor3 = Color3.fromRGB(160, 160, 160) })
                    local oldLine = Tab.CurrentST.Btn:FindFirstChildOfClass("Frame")
                    if oldLine then Tween(oldLine, 0.2, { BackgroundTransparency = 1 }) end
                end
                Tab.CurrentST = SubTab
                SPage.Visible = true
                Tween(SText, 0.2, { TextColor3 = Color3.new(1, 1, 1) })
                Tween(SIco, 0.2, { ImageColor3 = Library.Accent })
                Tween(SLine, 0.2, { BackgroundTransparency = 0 })
            end
            SClick.MouseButton1Click:Connect(function() SubTab:Select() end)
            table.insert(Tab.SubTabs, SubTab)

            function SubTab:CreateSection(secName)
                local Sec = Create("Frame", { Parent = SPage, BackgroundColor3 = Color3.fromRGB(16, 16, 16), Size = UDim2.new(1, 0, 0, 30) })
                Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Sec })
                Create("Frame", { Parent = Sec, BackgroundColor3 = Library.Accent, BorderSizePixel = 0, Position = UDim2.new(0, 0, 0, 6), Size = UDim2.new(0, 2, 0, 18) })
                Create("TextLabel", { Parent = Sec, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 0), Size = UDim2.new(1, -10, 1, 0), Font = "GothamBold", Text = secName:upper(), TextColor3 = Color3.fromRGB(190, 190, 190), TextSize = 11, TextXAlignment = "Left" })
                local Content = Create("Frame", { Parent = SPage, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0) })
                local L = Create("UIListLayout", { Parent = Content, Padding = UDim.new(0, 6) })
                L:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    Content.Size = UDim2.new(1, 0, 0, L.AbsoluteContentSize.Y)
                end)
                local S = {}

                -- TOGGLE
                function S:CreateToggle(n, def, cb)
                    local F = Create("TextButton", { Parent = Content, BackgroundColor3 = Color3.fromRGB(13, 13, 13), Size = UDim2.new(1, 0, 0, 42), Text = "", AutoButtonColor = false })
                    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = F })
                    Create("TextLabel", { Parent = F, BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(1, -64, 1, 0), Font = "Gotham", Text = n, TextColor3 = Color3.fromRGB(225, 225, 225), TextSize = 14, TextXAlignment = "Left" })
                    local O = Create("Frame", { Parent = F, AnchorPoint = Vector2.new(1, 0.5), BackgroundColor3 = Color3.fromRGB(35, 35, 35), Position = UDim2.new(1, -12, 0.5, 0), Size = UDim2.new(0, 36, 0, 18) })
                    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = O })
                    local I = Create("Frame", { Parent = O, BackgroundColor3 = Color3.new(1, 1, 1), Position = UDim2.new(0, 2, 0.5, -7), Size = UDim2.new(0, 14, 0, 14) })
                    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = I })
                    local t = def or false
                    local function u() Tween(O, 0.2, { BackgroundColor3 = t and Library.Accent or Color3.fromRGB(35, 35, 35) }); Tween(I, 0.2, { Position = t and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7) }); if cb then cb(t) end end
                    F.MouseButton1Click:Connect(function() t = not t; u() end)
                    u()
                    return { Set = function(_, v) t = v; u() end }
                end

                -- BUTTON
                function S:CreateButton(n, cb)
                    local B = Create("TextButton", { Parent = Content, BackgroundColor3 = Color3.fromRGB(13, 13, 13), Size = UDim2.new(1, 0, 0, 42), Text = "", AutoButtonColor = false })
                    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = B })
                    Create("TextLabel", { Parent = B, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Font = "Gotham", Text = n, TextColor3 = Color3.fromRGB(225, 225, 225), TextSize = 14 })
                    B.MouseEnter:Connect(function() Tween(B, 0.15, { BackgroundColor3 = Color3.fromRGB(20, 20, 20) }) end)
                    B.MouseLeave:Connect(function() Tween(B, 0.15, { BackgroundColor3 = Color3.fromRGB(13, 13, 13) }) end)
                    B.MouseButton1Click:Connect(function() if cb then cb() end end)
                end

                -- SLIDER
                function S:CreateSlider(n, min, max, def, cb)
                    min = min or 0; max = max or 100; def = def or min; cb = cb or function() end
                    local F = Create("Frame", { Parent = Content, BackgroundColor3 = Color3.fromRGB(13, 13, 13), Size = UDim2.new(1, 0, 0, 50) })
                    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = F })
                    Create("TextLabel", { Parent = F, BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(1, -70, 0, 24), Font = "Gotham", Text = n, TextColor3 = Color3.fromRGB(225, 225, 225), TextSize = 14, TextXAlignment = "Left" })
                    local Val = Create("TextLabel", { Parent = F, BackgroundTransparency = 1, Position = UDim2.new(1, -60, 0, 0), Size = UDim2.new(0, 48, 0, 24), Font = "GothamBold", Text = tostring(def), TextColor3 = Library.Accent, TextSize = 13, TextXAlignment = "Right" })
                    local Bar = Create("Frame", { Parent = F, BackgroundColor3 = Color3.fromRGB(35, 35, 35), Position = UDim2.new(0, 12, 0, 32), Size = UDim2.new(1, -24, 0, 6) })
                    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Bar })
                    local Fill = Create("Frame", { Parent = Bar, BackgroundColor3 = Library.Accent, Size = UDim2.new((def - min) / (max - min), 0, 1, 0) })
                    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Fill })
                    local Knob = Create("Frame", { Parent = Fill, AnchorPoint = Vector2.new(1, 0.5), BackgroundColor3 = Color3.new(1, 1, 1), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.new(0, 12, 0, 12) })
                    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Knob })
                    local dragging = false
                    local function move(input)
                        local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                        local val = math.floor(min + (max - min) * pos)
                        Fill.Size = UDim2.new(pos, 0, 1, 0)
                        Val.Text = tostring(val)
                        cb(val)
                    end
                    Bar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true; Library._blockDrag = true; move(i) end end)
                    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false; Library._blockDrag = false end end)
                    UIS.InputChanged:Connect(function(i) if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then move(i) end end)
                    return { Set = function(_, v) local p = (v - min)/(max - min); Fill.Size = UDim2.new(p, 0, 1, 0); Val.Text = tostring(v); cb(v) end }
                end

                -- DROPDOWN
                function S:CreateDropdown(n, items, def, cb)
                    items = items or {}; cb = cb or function() end
                    local F = Create("TextButton", { Parent = Content, BackgroundColor3 = Color3.fromRGB(13, 13, 13), Size = UDim2.new(1, 0, 0, 42), ClipsDescendants = true, Text = "", AutoButtonColor = false })
                    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = F })
                    local Lbl = Create("TextLabel", { Parent = F, BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(1, -44, 0, 42), Font = "Gotham", Text = def and (n .. ": " .. tostring(def)) or n, TextColor3 = Color3.fromRGB(225, 225, 225), TextSize = 14, TextXAlignment = "Left" })
                    local Arrow = Create("TextLabel", { Parent = F, BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -12, 0, 0), Size = UDim2.new(0, 20, 0, 42), Font = "GothamBold", Text = "v", TextColor3 = Color3.fromRGB(140, 140, 140), TextSize = 12 })
                    local ItemList = Create("Frame", { Parent = F, BackgroundTransparency = 1, Position = UDim2.new(0, 6, 0, 42), Size = UDim2.new(1, -12, 0, 0) })
                    Create("UIListLayout", { Parent = ItemList, Padding = UDim.new(0, 3) })
                    local opened = false
                    local function refresh(list)
                        for _, c in next, ItemList:GetChildren() do if c:IsA("TextButton") then c:Destroy() end end
                        for _, item in next, list do
                            local Btn = Create("TextButton", { Parent = ItemList, BackgroundColor3 = Color3.fromRGB(22, 22, 22), Size = UDim2.new(1, 0, 0, 28), Font = "Gotham", Text = tostring(item), TextColor3 = Color3.fromRGB(200, 200, 200), TextSize = 13, AutoButtonColor = false })
                            Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = Btn })
                            Btn.MouseEnter:Connect(function() Tween(Btn, 0.1, { BackgroundColor3 = Color3.fromRGB(30, 30, 30) }) end)
                            Btn.MouseLeave:Connect(function() Tween(Btn, 0.1, { BackgroundColor3 = Color3.fromRGB(22, 22, 22) }) end)
                            Btn.MouseButton1Click:Connect(function()
                                Lbl.Text = n .. ": " .. tostring(item)
                                opened = false
                                Arrow.Text = "v"
                                Tween(F, 0.25, { Size = UDim2.new(1, 0, 0, 42) })
                                cb(item)
                            end)
                        end
                    end
                    refresh(items)
                    F.MouseButton1Click:Connect(function()
                        opened = not opened
                        Arrow.Text = opened and "^" or "v"
                        local h = opened and (42 + ItemList.UIListLayout.AbsoluteContentSize.Y + 8) or 42
                        Tween(F, 0.25, { Size = UDim2.new(1, 0, 0, h) })
                    end)
                    return { Refresh = function(_, list) refresh(list) end }
                end

                -- TEXTBOX
                function S:CreateTextBox(n, placeholder, cb)
                    cb = cb or function() end
                    local F = Create("Frame", { Parent = Content, BackgroundColor3 = Color3.fromRGB(13, 13, 13), Size = UDim2.new(1, 0, 0, 42) })
                    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = F })
                    Create("TextLabel", { Parent = F, BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(0.4, 0, 1, 0), Font = "Gotham", Text = n, TextColor3 = Color3.fromRGB(225, 225, 225), TextSize = 14, TextXAlignment = "Left" })
                    local Box = Create("TextBox", {
                        Parent = F,
                        BackgroundColor3 = Color3.fromRGB(22, 22, 22),
                        AnchorPoint = Vector2.new(1, 0.5),
                        Position = UDim2.new(1, -10, 0.5, 0),
                        Size = UDim2.new(0.5, -10, 0, 26),
                        Font = "Gotham",
                        Text = "",
                        PlaceholderText = placeholder or "Enter...",
                        PlaceholderColor3 = Color3.fromRGB(100, 100, 100),
                        TextColor3 = Color3.new(1, 1, 1),
                        TextSize = 13,
                        ClearTextOnFocus = false
                    })
                    Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = Box })
                    Create("UIPadding", { Parent = Box, PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8) })
                    Box.Focused:Connect(function() Tween(Box, 0.15, { BackgroundColor3 = Color3.fromRGB(30, 30, 30) }) end)
                    Box.FocusLost:Connect(function(enter) Tween(Box, 0.15, { BackgroundColor3 = Color3.fromRGB(22, 22, 22) }); if enter then cb(Box.Text) end end)
                    return { Set = function(_, v) Box.Text = v end, Get = function() return Box.Text end }
                end

                -- LABEL
                function S:CreateLabel(n)
                    local F = Create("Frame", { Parent = Content, BackgroundColor3 = Color3.fromRGB(13, 13, 13), Size = UDim2.new(1, 0, 0, 32) })
                    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = F })
                    local Lbl = Create("TextLabel", { Parent = F, BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(1, -24, 1, 0), Font = "Gotham", Text = n, TextColor3 = Color3.fromRGB(180, 180, 180), TextSize = 13, TextXAlignment = "Left" })
                    return { Set = function(_, v) Lbl.Text = v end }
                end

                -- KEYBIND
                function S:CreateKeybind(n, defKey, cb)
                    cb = cb or function() end
                    local F = Create("Frame", { Parent = Content, BackgroundColor3 = Color3.fromRGB(13, 13, 13), Size = UDim2.new(1, 0, 0, 42) })
                    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = F })
                    Create("TextLabel", { Parent = F, BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(1, -100, 1, 0), Font = "Gotham", Text = n, TextColor3 = Color3.fromRGB(225, 225, 225), TextSize = 14, TextXAlignment = "Left" })
                    local KeyBtn = Create("TextButton", {
                        Parent = F,
                        AnchorPoint = Vector2.new(1, 0.5),
                        BackgroundColor3 = Color3.fromRGB(22, 22, 22),
                        Position = UDim2.new(1, -10, 0.5, 0),
                        Size = UDim2.new(0, 70, 0, 26),
                        Font = "GothamBold",
                        Text = defKey and defKey.Name or "None",
                        TextColor3 = Library.Accent,
                        TextSize = 12,
                        AutoButtonColor = false
                    })
                    Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = KeyBtn })
                    local binding = false
                    local currentKey = defKey
                    KeyBtn.MouseButton1Click:Connect(function()
                        binding = true
                        KeyBtn.Text = "..."
                    end)
                    UIS.InputBegan:Connect(function(input)
                        if binding then
                            if input.UserInputType == Enum.UserInputType.Keyboard then
                                currentKey = input.KeyCode
                                KeyBtn.Text = input.KeyCode.Name
                                binding = false
                            end
                        elseif currentKey and input.KeyCode == currentKey then
                            cb(currentKey)
                        end
                    end)
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

-- ================== END OF UI LIBRARY ==================

-- ================== SNIPER ARENA CHEAT SCRIPT ==================
local Workspace = game:GetService("Workspace")

-- ================== CREATE WINDOW ==================
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
    local mousePos = UIS:GetMouseLocation()
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
        FOVCircleObj.Position = UIS:GetMouseLocation()
        FOVCircleObj.Radius = Aimbot.FOV
        FOVCircleObj.Color = FOVCircle.Color
    else
        FOVCircleObj.Visible = false
    end
end)

-- ================== AIMBOT (Right-Click Lock) ==================
UIS.InputBegan:Connect(function(input, gameProcessed)
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
        UIS.InputBegan:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.W then controls.W = true
            elseif input.KeyCode == Enum.KeyCode.A then controls.A = true
            elseif input.KeyCode == Enum.KeyCode.S then controls.S = true
            elseif input.KeyCode == Enum.KeyCode.D then controls.D = true
            elseif input.KeyCode == Enum.KeyCode.Space then controls.Space = true
            elseif input.KeyCode == Enum.KeyCode.LeftShift then controls.LeftShift = true
            end
        end)
        UIS.InputEnded:Connect(function(input)
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