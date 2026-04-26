-- main.lua – Sniper Arena Cheats (NoClip removed, stability improved)
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ========== UI LIBRARY ==========
local Library = { Toggled = true, Accent = Color3.fromRGB(160, 60, 255), _blockDrag = false }
local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled

local Icons = {
    home = { 16898613509, 48, 48, 820, 147 },
    flame = { 16898613353, 48, 48, 967, 306 },
    settings = { 16898613777, 48, 48, 771, 257 },
    account = { 16898613869, 48, 48, 661, 869 },
    eye = { 16898613353, 48, 48, 771, 563 },
    ["map-pin"] = { 16898613613, 48, 48, 820, 257 },
    ["bar-chart-2"] = { 16898612629, 48, 48, 967, 710 },
    swords = { 16898613777, 48, 48, 967, 759 },
    user = { 16898613869, 48, 48, 661, 869 },
    shield = { 16898613777, 48, 48, 869, 0 },
    zap = { 16898613869, 48, 48, 918, 906 },
    target = { 16898613869, 48, 48, 514, 771 },
    globe = { 16898613509, 48, 48, 771, 563 },
    layout = { 16898613509, 48, 48, 967, 612 },
    search = { 16898613699, 48, 48, 918, 857 },
    save = { 16898613699, 48, 48, 918, 453 },
    sliders = { 16898613777, 48, 48, 404, 771 }
}

local function Create(class, props)
    local obj = Instance.new(class)
    for i, v in next, props do
        if i ~= "Parent" then
            obj[i] = v
        end
    end
    obj.Parent = props.Parent
    return obj
end

local function Tween(obj, time, props)
    TweenService:Create(obj, TweenInfo.new(time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props):Play()
end

function Library:MakeDraggable(handle, target)
    target = target or handle
    local THRESHOLD = 4
    local dragging, didDrag = false, false
    local dStart, sPos

    handle.InputBegan:Connect(function(i)
        if (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) and not Library._blockDrag then
            dragging = true
            didDrag = false
            dStart = i.Position
            sPos = target.Position
        end
    end)

    handle.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - dStart
            if not didDrag and (math.abs(d.X) >= THRESHOLD or math.abs(d.Y) >= THRESHOLD) then
                didDrag = true
            end
            if didDrag then
                target.Position = UDim2.new(
                    sPos.X.Scale, sPos.X.Offset + d.X,
                    sPos.Y.Scale, sPos.Y.Offset + d.Y
                )
            end
        end
    end)

    return function()
        local v = didDrag
        didDrag = false
        return v
    end
end

function Library:GetIcon(name)
    return Icons[name] or Icons.home
end

function Library:CreateWindow(title)
    local ScreenGui = Create("ScreenGui", {
        Name = "KurbyLib",
        Parent = (RunService:IsStudio() and LocalPlayer.PlayerGui) or CoreGui,
        ResetOnSpawn = false
    })
    if getgenv then
        if getgenv()._KurbyUI then
            getgenv()._KurbyUI:Destroy()
        end
        getgenv()._KurbyUI = ScreenGui
    end

    local windowWidth = isMobile and 500 or 600
    local windowHeight = isMobile and 500 or 440
    
    local Main = Create("Frame", {
        Parent = ScreenGui,
        BackgroundColor3 = Color3.fromRGB(8, 8, 8),
        Position = UDim2.new(0.5, -windowWidth/2, 0.5, -windowHeight/2),
        Size = UDim2.new(0, windowWidth, 0, windowHeight)
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = Main })
    Create("UIStroke", { Color = Color3.fromRGB(45, 45, 45), Parent = Main })

    local Sidebar = Create("Frame", {
        Parent = Main,
        BackgroundColor3 = Color3.fromRGB(13, 13, 13),
        Size = UDim2.new(0, isMobile and 60 or 50, 1, 0)
    })
    Create("UIStroke", { Color = Color3.fromRGB(35, 35, 35), ApplyStrokeMode = "Border", Parent = Sidebar })

    Create("TextLabel", {
        Parent = Sidebar,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 36),
        Font = "GothamBold",
        Text = "K",
        TextColor3 = Library.Accent,
        TextSize = isMobile and 26 or 22
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
        Padding = UDim.new(0, isMobile and 6 or 4)
    })

    local Container = Create("Frame", {
        Parent = Main,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, isMobile and 60 or 50, 0, 0),
        Size = UDim2.new(1, -(isMobile and 60 or 50), 1, 0)
    })

    local DragBar = Create("Frame", {
        Name = "DragBar",
        Parent = Main,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 48),
        ZIndex = 0
    })
    local DragSide = Create("Frame", {
        Name = "DragSide",
        Parent = Sidebar,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 36),
        ZIndex = 10
    })
    local wasDragging = Library:MakeDraggable(DragBar, Main)
    Library:MakeDraggable(DragSide, Main)

    local Header = Create("Frame", { Parent = Container, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 48) })
    Create("TextLabel", {
        Parent = Header,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 16, 0, 0),
        Size = UDim2.new(0, 180, 1, 0),
        Font = "GothamBold",
        Text = title or "Kurby Hub",
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = isMobile and 20 or 18,
        TextXAlignment = "Left"
    })

    local CloseBtn = Create("TextButton", {
        Name = "CloseBtn",
        Parent = Header,
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundColor3 = Color3.fromRGB(200, 55, 55),
        Position = UDim2.new(1, -12, 0.5, 0),
        Size = UDim2.new(0, isMobile and 28 or 22, 0, isMobile and 28 or 22),
        Font = "GothamBold",
        Text = "X",
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = isMobile and 14 or 12,
        AutoButtonColor = false,
        ZIndex = 10
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = CloseBtn })
    CloseBtn.MouseEnter:Connect(function()
        Tween(CloseBtn, 0.15, { BackgroundColor3 = Color3.fromRGB(255, 70, 70) })
    end)
    CloseBtn.MouseLeave:Connect(function()
        Tween(CloseBtn, 0.15, { BackgroundColor3 = Color3.fromRGB(200, 55, 55) })
    end)
    CloseBtn.MouseButton1Click:Connect(function()
        if wasDragging() then return end
        toggled = false
        Main.Visible = false
    end)

    local SubTabBar = Create("Frame", {
        Parent = Header,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 200, 0, 0),
        Size = UDim2.new(1, -240, 1, 0)
    })
    Create("UIListLayout", {
        Parent = SubTabBar,
        FillDirection = "Horizontal",
        Padding = UDim.new(0, 16),
        VerticalAlignment = "Center"
    })
    Create("Frame", {
        Parent = Header,
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 1, -1),
        Size = UDim2.new(1, 0, 0, 1)
    })

    local Folder = Create("Frame", {
        Parent = Container,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 48),
        Size = UDim2.new(1, 0, 1, -48)
    })

    local toggled = true

    local function toggleUI()
        toggled = not toggled
        Main.Visible = toggled
    end

    UIS.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.RightShift then
            toggleUI()
        end
    end)

    if isMobile then
        local ToggleBtn = Create("ImageButton", {
            Name = "MobileToggle",
            Parent = ScreenGui,
            BackgroundColor3 = Color3.fromRGB(20, 20, 20),
            Position = UDim2.new(1, -70, 1, -70),
            Size = UDim2.new(0, 54, 0, 54),
            Image = "",
            AutoButtonColor = false,
            ZIndex = 100
        })
        Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = ToggleBtn })
        Create("UIStroke", { Color = Library.Accent, Thickness = 3, Parent = ToggleBtn })
        Create("TextLabel", {
            Parent = ToggleBtn,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Font = "GothamBold",
            Text = "K",
            TextColor3 = Library.Accent,
            TextSize = 24,
            ZIndex = 101
        })
        local wasDraggingBtn = Library:MakeDraggable(ToggleBtn)
        ToggleBtn.InputEnded:Connect(function(i)
            if (i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1) and not wasDraggingBtn() then
                toggleUI()
            end
        end)
    end

    local Window = { Current = nil }

    function Window:CreateTab(name, iconName)
        local Btn = Create("ImageButton", {
            Name = name .. "Tab",
            Parent = List,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, isMobile and 60 or 50)
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
        local iconSize = isMobile and 28 or 24
        local Ico = Create("ImageLabel", {
            Name = "Icon",
            Parent = Btn,
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, -iconSize/2, 0.5, -iconSize/2),
            Size = UDim2.new(0, iconSize, 0, iconSize),
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
                    if v:FindFirstChild("Indicator") then
                        Tween(v.Indicator, 0.25, { BackgroundTransparency = 1 })
                    end
                    if v:FindFirstChild("Icon") then
                        Tween(v.Icon, 0.25, { ImageColor3 = Color3.fromRGB(140, 140, 140) })
                    end
                    for _, f in next, v:GetChildren() do
                        if f:IsA("Frame") and f.Name ~= "Indicator" then
                            Tween(f, 0.25, { BackgroundTransparency = 1 })
                        end
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
            for _, st in next, Tab.SubTabs do
                st.Btn.Visible = true
            end
            if Tab.CurrentST then
                Tab.CurrentST:Select()
            elseif Tab.SubTabs[1] then
                Tab.SubTabs[1]:Select()
            end
        end

        Btn.MouseButton1Click:Connect(function()
            Tab:Select()
        end)
        Btn.MouseEnter:Connect(function()
            if not Window.Current or Window.Current.Tab ~= Tab then
                Tween(Highlight, 0.2, { BackgroundTransparency = 0.92 })
            end
        end)
        Btn.MouseLeave:Connect(function()
            if not Window.Current or Window.Current.Tab ~= Tab then
                Tween(Highlight, 0.2, { BackgroundTransparency = 1 })
            end
        end)

        function Tab:CreateSubTab(stName, stIconName)
            local stIconData = Library:GetIcon(stIconName or "layout")
            local SBtn = Create("Frame", {
                Parent = SubTabBar,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 0, 1, 0),
                AutomaticSize = "X",
                Visible = false
            })
            local SClick = Create("TextButton", {
                Parent = SBtn,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = ""
            })
            local SIco = Create("ImageLabel", {
                Name = "Icon",
                Parent = SBtn,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0.5, -8),
                Size = UDim2.new(0, 16, 0, 16),
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
                Position = UDim2.new(0, 20, 0, 0),
                Size = UDim2.new(0, 0, 1, 0),
                AutomaticSize = "X",
                Font = "Gotham",
                Text = stName,
                TextColor3 = Color3.fromRGB(160, 160, 160),
                TextSize = isMobile and 15 or 13
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
                ScrollBarThickness = isMobile and 6 or 2,
                ScrollBarImageColor3 = Library.Accent
            })
            Create("UIListLayout", {
                Parent = SPage,
                Padding = UDim.new(0, isMobile and 14 or 10),
                HorizontalAlignment = "Center"
            })
            Create("UIPadding", {
                Parent = SPage,
                PaddingTop = UDim.new(0, isMobile and 18 or 14),
                PaddingLeft = UDim.new(0, isMobile and 22 or 18),
                PaddingRight = UDim.new(0, isMobile and 22 or 18)
            })

            local SubTab = { Page = SPage, Btn = SBtn }

            function SubTab:Select()
                if Tab.CurrentST then
                    Tab.CurrentST.Page.Visible = false
                    Tween(Tab.CurrentST.Btn.Label, 0.2, { TextColor3 = Color3.fromRGB(160, 160, 160) })
                    Tween(Tab.CurrentST.Btn.Icon, 0.2, { ImageColor3 = Color3.fromRGB(160, 160, 160) })
                    local oldLine = Tab.CurrentST.Btn:FindFirstChildOfClass("Frame")
                    if oldLine then
                        Tween(oldLine, 0.2, { BackgroundTransparency = 1 })
                    end
                end
                Tab.CurrentST = SubTab
                SPage.Visible = true
                Tween(SText, 0.2, { TextColor3 = Color3.new(1, 1, 1) })
                Tween(SIco, 0.2, { ImageColor3 = Library.Accent })
                Tween(SLine, 0.2, { BackgroundTransparency = 0 })
            end
            SClick.MouseButton1Click:Connect(function()
                SubTab:Select()
            end)
            table.insert(Tab.SubTabs, SubTab)

            function SubTab:CreateSection(secName)
                local Sec = Create("Frame", {
                    Parent = SPage,
                    BackgroundColor3 = Color3.fromRGB(16, 16, 16),
                    Size = UDim2.new(1, 0, 0, isMobile and 36 or 30)
                })
                Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Sec })
                Create("Frame", {
                    Parent = Sec,
                    BackgroundColor3 = Library.Accent,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 0, 0, 6),
                    Size = UDim2.new(0, 2, 0, isMobile and 24 or 18)
                })
                Create("TextLabel", {
                    Parent = Sec,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 0),
                    Size = UDim2.new(1, -10, 1, 0),
                    Font = "GothamBold",
                    Text = secName:upper(),
                    TextColor3 = Color3.fromRGB(190, 190, 190),
                    TextSize = isMobile and 13 or 11,
                    TextXAlignment = "Left"
                })
                local Content = Create("Frame", {
                    Parent = SPage,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 0)
                })
                local L = Create("UIListLayout", { Parent = Content, Padding = UDim.new(0, isMobile and 8 or 6) })
                L:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    Content.Size = UDim2.new(1, 0, 0, L.AbsoluteContentSize.Y)
                    SPage.CanvasSize = UDim2.new(0, 0, 0, SPage.UIListLayout.AbsoluteContentSize.Y + 40)
                end)
                local S = {}

                function S:CreateToggle(n, def, cb)
                    local toggleValue = def or false
                    local elementHeight = isMobile and 52 or 42
                    local F = Create("Frame", {
                        Parent = Content,
                        BackgroundColor3 = Color3.fromRGB(13, 13, 13),
                        Size = UDim2.new(1, 0, 0, elementHeight)
                    })
                    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = F })
                    Create("TextLabel", {
                        Parent = F,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 12, 0, 0),
                        Size = UDim2.new(1, -64, 1, 0),
                        Font = "Gotham",
                        Text = n,
                        TextColor3 = Color3.fromRGB(225, 225, 225),
                        TextSize = isMobile and 16 or 14,
                        TextXAlignment = "Left"
                    })
                    
                    local toggleWidth = isMobile and 44 or 36
                    local toggleHeight = isMobile and 22 or 18
                    local O = Create("Frame", {
                        Parent = F,
                        AnchorPoint = Vector2.new(1, 0.5),
                        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                        Position = UDim2.new(1, -12, 0.5, 0),
                        Size = UDim2.new(0, toggleWidth, 0, toggleHeight)
                    })
                    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = O })
                    
                    local knobSize = isMobile and 18 or 14
                    local I = Create("Frame", {
                        Parent = O,
                        BackgroundColor3 = Color3.new(1, 1, 1),
                        Position = UDim2.new(0, 2, 0.5, -knobSize/2),
                        Size = UDim2.new(0, knobSize, 0, knobSize)
                    })
                    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = I })
                    
                    local function u()
                        Tween(O, 0.2, { BackgroundColor3 = toggleValue and Library.Accent or Color3.fromRGB(35, 35, 35) })
                        Tween(I, 0.2, { Position = toggleValue and UDim2.new(1, -knobSize-2, 0.5, -knobSize/2) or UDim2.new(0, 2, 0.5, -knobSize/2) })
                        if cb then cb(toggleValue) end
                    end
                    
                    F.InputBegan:Connect(function(i)
                        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                            toggleValue = not toggleValue
                            u()
                        end
                    end)
                    u()
                    
                    return {
                        Set = function(_, v) toggleValue = v; u() end,
                        Get = function() return toggleValue end
                    }
                end

                function S:CreateButton(n, cb)
                    local elementHeight = isMobile and 52 or 42
                    local B = Create("TextButton", {
                        Parent = Content,
                        BackgroundColor3 = Color3.fromRGB(13, 13, 13),
                        Size = UDim2.new(1, 0, 0, elementHeight),
                        Text = "",
                        AutoButtonColor = false
                    })
                    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = B })
                    Create("TextLabel", {
                        Parent = B,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 1, 0),
                        Font = "Gotham",
                        Text = n,
                        TextColor3 = Color3.fromRGB(225, 225, 225),
                        TextSize = isMobile and 16 or 14
                    })
                    B.MouseEnter:Connect(function()
                        Tween(B, 0.15, { BackgroundColor3 = Color3.fromRGB(20, 20, 20) })
                    end)
                    B.MouseLeave:Connect(function()
                        Tween(B, 0.15, { BackgroundColor3 = Color3.fromRGB(13, 13, 13) })
                    end)
                    B.MouseButton1Click:Connect(function()
                        if cb then cb() end
                    end)
                end

                function S:CreateSlider(n, min, max, def, cb)
                    min = min or 0
                    max = max or 100
                    local currentValue = def or min
                    local isDragging = false
                    cb = cb or function() end
                    
                    local elementHeight = isMobile and 60 or 50
                    local F = Create("Frame", {
                        Parent = Content,
                        BackgroundColor3 = Color3.fromRGB(13, 13, 13),
                        Size = UDim2.new(1, 0, 0, elementHeight)
                    })
                    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = F })
                    Create("TextLabel", {
                        Parent = F,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 12, 0, 0),
                        Size = UDim2.new(1, -70, 0, isMobile and 28 or 24),
                        Font = "Gotham",
                        Text = n,
                        TextColor3 = Color3.fromRGB(225, 225, 225),
                        TextSize = isMobile and 16 or 14,
                        TextXAlignment = "Left"
                    })
                    local Val = Create("TextLabel", {
                        Parent = F,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(1, -60, 0, 0),
                        Size = UDim2.new(0, 48, 0, isMobile and 28 or 24),
                        Font = "GothamBold",
                        Text = tostring(currentValue),
                        TextColor3 = Library.Accent,
                        TextSize = isMobile and 15 or 13,
                        TextXAlignment = "Right"
                    })
                    
                    local barHeight = isMobile and 8 or 6
                    local Bar = Create("Frame", {
                        Parent = F,
                        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                        Position = UDim2.new(0, 12, 0, isMobile and 38 or 32),
                        Size = UDim2.new(1, -24, 0, barHeight)
                    })
                    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Bar })
                    local Fill = Create("Frame", {
                        Parent = Bar,
                        BackgroundColor3 = Library.Accent,
                        Size = UDim2.new((currentValue - min) / (max - min), 0, 1, 0)
                    })
                    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Fill })
                    
                    local knobSize = isMobile and 14 or 12
                    local Knob = Create("Frame", {
                        Parent = Fill,
                        AnchorPoint = Vector2.new(1, 0.5),
                        BackgroundColor3 = Color3.new(1, 1, 1),
                        Position = UDim2.new(1, 0, 0.5, 0),
                        Size = UDim2.new(0, knobSize, 0, knobSize)
                    })
                    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Knob })
                    
                    local function updateValue(input)
                        local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                        local val = min + (max - min) * pos
                        val = math.floor(val * 100) / 100
                        currentValue = val
                        Fill.Size = UDim2.new(pos, 0, 1, 0)
                        Val.Text = tostring(currentValue)
                        cb(currentValue)
                    end
                    
                    Bar.InputBegan:Connect(function(i)
                        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                            isDragging = true
                            Library._blockDrag = true
                            updateValue(i)
                        end
                    end)
                    
                    UIS.InputEnded:Connect(function(i)
                        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                            isDragging = false
                            Library._blockDrag = false
                        end
                    end)
                    
                    UIS.InputChanged:Connect(function(i)
                        if isDragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                            updateValue(i)
                        end
                    end)
                    
                    return {
                        SetValue = function(_, v)
                            if v == nil then return end
                            v = math.clamp(v, min, max)
                            local pos = (v - min) / (max - min)
                            currentValue = v
                            Fill.Size = UDim2.new(pos, 0, 1, 0)
                            Val.Text = tostring(v)
                            cb(v)
                        end,
                        GetValue = function() return currentValue end
                    }
                end

                function S:CreateDropdown(n, items, def, cb)
                    items = items or {}
                    cb = cb or function() end
                    local selected = def or items[1] or "None"
                    local elementHeight = isMobile and 52 or 42
                    local F = Create("Frame", {
                        Parent = Content,
                        BackgroundColor3 = Color3.fromRGB(13, 13, 13),
                        Size = UDim2.new(1, 0, 0, elementHeight),
                        ClipsDescendants = true
                    })
                    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = F })

                    local MainBtn = Create("TextButton", {
                        Parent = F,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, elementHeight),
                        Text = "",
                        AutoButtonColor = false
                    })
                    local Lbl = Create("TextLabel", {
                        Parent = F,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 12, 0, 0),
                        Size = UDim2.new(1, -44, 0, elementHeight),
                        Font = "Gotham",
                        Text = n,
                        TextColor3 = Color3.fromRGB(225, 225, 225),
                        TextSize = isMobile and 16 or 14,
                        TextXAlignment = "Left"
                    })
                    local SelLbl = Create("TextLabel", {
                        Parent = F,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 12, 0, 0),
                        Size = UDim2.new(1, -64, 0, elementHeight),
                        Font = "Gotham",
                        Text = tostring(selected),
                        TextColor3 = Library.Accent,
                        TextSize = isMobile and 15 or 13,
                        TextXAlignment = "Right"
                    })
                    local Arrow = Create("TextLabel", {
                        Parent = F,
                        BackgroundTransparency = 1,
                        AnchorPoint = Vector2.new(1, 0.5),
                        Position = UDim2.new(1, -12, 0, elementHeight/2),
                        Size = UDim2.new(0, isMobile and 24 or 20, 0, isMobile and 24 or 20),
                        Font = "GothamBold",
                        Text = "v",
                        TextColor3 = Color3.fromRGB(140, 140, 140),
                        TextSize = isMobile and 14 or 12
                    })

                    local ItemList = Create("Frame", {
                        Parent = F,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 6, 0, elementHeight),
                        Size = UDim2.new(1, -12, 0, 0)
                    })
                    local LList = Create("UIListLayout", { Parent = ItemList, Padding = UDim.new(0, isMobile and 4 or 3) })

                    local opened = false

                    local function uDropdown()
                        local h = opened and (elementHeight + LList.AbsoluteContentSize.Y + 8) or elementHeight
                        Tween(F, 0.25, { Size = UDim2.new(1, 0, 0, h) })
                        Tween(Arrow, 0.25, { Rotation = opened and 180 or 0 })
                    end

                    local function refresh(list)
                        items = list
                        for _, c in next, ItemList:GetChildren() do
                            if c:IsA("TextButton") then c:Destroy() end
                        end
                        for _, item in next, list do
                            local itemHeight = isMobile and 40 or 30
                            local Btn = Create("TextButton", {
                                Parent = ItemList,
                                BackgroundColor3 = Color3.fromRGB(20, 20, 20),
                                Size = UDim2.new(1, 0, 0, itemHeight),
                                Font = "Gotham",
                                Text = tostring(item),
                                TextColor3 = (selected == item) and Library.Accent or Color3.fromRGB(200, 200, 200),
                                TextSize = isMobile and 15 or 13,
                                AutoButtonColor = false
                            })
                            Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = Btn })

                            Btn.MouseEnter:Connect(function()
                                Tween(Btn, 0.1, { BackgroundColor3 = Color3.fromRGB(26, 26, 26) })
                            end)
                            Btn.MouseLeave:Connect(function()
                                Tween(Btn, 0.1, { BackgroundColor3 = Color3.fromRGB(20, 20, 20) })
                            end)

                            Btn.MouseButton1Click:Connect(function()
                                selected = item
                                SelLbl.Text = tostring(item)
                                opened = false
                                uDropdown()
                                cb(item)
                                refresh(items)
                            end)
                        end
                        if opened then uDropdown() end
                    end

                    refresh(items)
                    MainBtn.MouseButton1Click:Connect(function()
                        opened = not opened
                        uDropdown()
                    end)

                    return {
                        Refresh = refresh,
                        Set = function(_, v) selected = v; SelLbl.Text = tostring(v); cb(v); refresh(items) end,
                        Get = function() return selected end
                    }
                end

                function S:CreateKeybind(n, defKey, cb)
                    local currentKey = defKey or Enum.KeyCode.None
                    cb = cb or function() end
                    local elementHeight = isMobile and 52 or 42
                    local F = Create("Frame", {
                        Parent = Content,
                        BackgroundColor3 = Color3.fromRGB(13, 13, 13),
                        Size = UDim2.new(1, 0, 0, elementHeight)
                    })
                    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = F })
                    Create("TextLabel", {
                        Parent = F,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 12, 0, 0),
                        Size = UDim2.new(1, -100, 1, 0),
                        Font = "Gotham",
                        Text = n,
                        TextColor3 = Color3.fromRGB(225, 225, 225),
                        TextSize = isMobile and 16 or 14,
                        TextXAlignment = "Left"
                    })
                    
                    local keyBtnWidth = isMobile and 80 or 70
                    local keyBtnHeight = isMobile and 32 or 26
                    local KeyBtn = Create("TextButton", {
                        Parent = F,
                        AnchorPoint = Vector2.new(1, 0.5),
                        BackgroundColor3 = Color3.fromRGB(22, 22, 22),
                        Position = UDim2.new(1, -10, 0.5, 0),
                        Size = UDim2.new(0, keyBtnWidth, 0, keyBtnHeight),
                        Font = "GothamBold",
                        Text = currentKey.Name,
                        TextColor3 = Library.Accent,
                        TextSize = isMobile and 14 or 12,
                        AutoButtonColor = false
                    })
                    Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = KeyBtn })
                    
                    local waiting = false
                    
                    KeyBtn.MouseButton1Click:Connect(function()
                        waiting = true
                        KeyBtn.Text = "..."
                    end)
                    
                    UIS.InputBegan:Connect(function(input, gameProcessed)
                        if gameProcessed then return end
                        if waiting then
                            if input.UserInputType == Enum.UserInputType.Keyboard then
                                waiting = false
                                currentKey = input.KeyCode
                                KeyBtn.Text = currentKey.Name
                                cb(currentKey)
                            end
                        end
                    end)
                    
                    return {
                        SetKey = function(_, key) currentKey = key; KeyBtn.Text = key.Name; cb(key) end,
                        GetKey = function() return currentKey end
                    }
                end

                function S:CreateColorPicker(n, defaultColor, cb)
                    local hue = 0
                    local isRainbow = false
                    local rainbowConnection = nil
                    local currentColor = defaultColor or Color3.new(1, 0, 0)

                    local containerHeight = isMobile and 85 or 65
                    local container = Create("Frame", {
                        Parent = Content,
                        BackgroundColor3 = Color3.fromRGB(13, 13, 13),
                        Size = UDim2.new(1, 0, 0, containerHeight),
                        ClipsDescendants = false
                    })
                    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = container })

                    local label = Create("TextLabel", {
                        Parent = container,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 10, 0, 5),
                        Size = UDim2.new(1, -20, 0, isMobile and 24 or 20),
                        Font = "Gotham",
                        Text = n,
                        TextColor3 = Color3.fromRGB(225, 225, 225),
                        TextSize = isMobile and 14 or 12,
                        TextXAlignment = "Left"
                    })

                    local colorDisplay = Create("Frame", {
                        Parent = container,
                        BackgroundColor3 = currentColor,
                        Position = UDim2.new(0, 10, 0, isMobile and 34 or 28),
                        Size = UDim2.new(0, isMobile and 90 or 80, 0, isMobile and 30 or 25)
                    })
                    Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = colorDisplay })
                    Create("UIStroke", { Color = Color3.fromRGB(255, 255, 255), Thickness = 1, Parent = colorDisplay })

                    local rgbButton = Create("TextButton", {
                        Parent = container,
                        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
                        Position = UDim2.new(0, isMobile and 110 or 100, 0, isMobile and 34 or 28),
                        Size = UDim2.new(0, isMobile and 70 or 60, 0, isMobile and 30 or 25),
                        Font = "GothamBold",
                        Text = "RGB",
                        TextColor3 = Color3.new(1, 1, 1),
                        TextSize = isMobile and 14 or 12,
                        AutoButtonColor = false
                    })
                    Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = rgbButton })

                    local buttonSize = isMobile and 30 or 25
                    local redBtn = Create("TextButton", {
                        Parent = container,
                        BackgroundColor3 = Color3.fromRGB(255, 50, 50),
                        Position = UDim2.new(0, isMobile and 190 or 170, 0, isMobile and 34 or 28),
                        Size = UDim2.new(0, buttonSize, 0, buttonSize),
                        Text = "",
                        AutoButtonColor = false
                    })
                    Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = redBtn })

                    local greenBtn = Create("TextButton", {
                        Parent = container,
                        BackgroundColor3 = Color3.fromRGB(50, 255, 50),
                        Position = UDim2.new(0, isMobile and 225 or 200, 0, isMobile and 34 or 28),
                        Size = UDim2.new(0, buttonSize, 0, buttonSize),
                        Text = "",
                        AutoButtonColor = false
                    })
                    Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = greenBtn })

                    local blueBtn = Create("TextButton", {
                        Parent = container,
                        BackgroundColor3 = Color3.fromRGB(50, 50, 255),
                        Position = UDim2.new(0, isMobile and 260 or 230, 0, isMobile and 34 or 28),
                        Size = UDim2.new(0, buttonSize, 0, buttonSize),
                        Text = "",
                        AutoButtonColor = false
                    })
                    Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = blueBtn })

                    local whiteBtn = Create("TextButton", {
                        Parent = container,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Position = UDim2.new(0, isMobile and 295 or 260, 0, isMobile and 34 or 28),
                        Size = UDim2.new(0, buttonSize, 0, buttonSize),
                        Text = "",
                        AutoButtonColor = false
                    })
                    Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = whiteBtn })

                    local function updateColor(color)
                        if not color then return end
                        currentColor = color
                        colorDisplay.BackgroundColor3 = color
                        if cb then cb(color) end
                    end

                    local function startRainbow()
                        isRainbow = true
                        rgbButton.TextColor3 = Color3.fromRGB(160, 60, 255)
                        if rainbowConnection then rainbowConnection:Disconnect() end
                        rainbowConnection = RunService.RenderStepped:Connect(function()
                            hue = (hue + 0.01) % 1
                            updateColor(Color3.fromHSV(hue, 1, 1))
                        end)
                    end

                    local function stopRainbow()
                        isRainbow = false
                        rgbButton.TextColor3 = Color3.new(1, 1, 1)
                        if rainbowConnection then
                            rainbowConnection:Disconnect()
                            rainbowConnection = nil
                        end
                    end

                    rgbButton.MouseButton1Click:Connect(function()
                        if isRainbow then stopRainbow() else startRainbow() end
                    end)

                    redBtn.MouseButton1Click:Connect(function()
                        stopRainbow()
                        updateColor(Color3.fromRGB(255, 50, 50))
                    end)

                    greenBtn.MouseButton1Click:Connect(function()
                        stopRainbow()
                        updateColor(Color3.fromRGB(50, 255, 50))
                    end)

                    blueBtn.MouseButton1Click:Connect(function()
                        stopRainbow()
                        updateColor(Color3.fromRGB(50, 50, 255))
                    end)

                    whiteBtn.MouseButton1Click:Connect(function()
                        stopRainbow()
                        updateColor(Color3.fromRGB(255, 255, 255))
                    end)

                    return {
                        SetColor = function(_, color) stopRainbow(); updateColor(color) end,
                        SetRainbow = function(_, enabled) if enabled then startRainbow() else stopRainbow() end end,
                        GetColor = function() return currentColor end,
                        IsRainbow = function() return isRainbow end
                    }
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

-- ========== END UI LIBRARY ==========

-- ========== CHEAT FEATURES ==========
local Cheat = {
    Aimbot = false,
    AutoFire = false,
    WallBang = false,
    ESP = false,
    TeamCheck = true,
    AimbotFOV = 120,
    AimbotSmoothness = 0.3,
    TargetPart = "Head",
    AutoFireDelay = 0.1,
    ESPColor = Color3.new(1,0,0),
    ESPRainbow = false,
    SkeletonESP = false,
    SkeletonColor = Color3.new(0,1,0),
    SkeletonRainbow = false,
    SkeletonThickness = 1,
    ShowHead = true, ShowTorso = true, ShowArms = true, ShowLegs = true,
    ShowForearms = true, ShowShins = true,
    BoxESP = true, ESPBoxSize = 3,
    ShowFOVCircle = true,
}

-- Locate shoot remote (Sniper Arena)
local ShootGunRemote = nil
local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
if Remotes then
    ShootGunRemote = Remotes:FindFirstChild("ShootGun")
end

-- FOV Circle (drawing)
local fovCircle = nil
local function UpdateFOVCircle()
    if Cheat.ShowFOVCircle and Cheat.Aimbot then
        if not fovCircle then
            fovCircle = Drawing.new("Circle")
            fovCircle.Thickness = isMobile and 2 or 1
            fovCircle.Radius = Cheat.AimbotFOV
            fovCircle.Filled = false
            fovCircle.Color = Color3.fromRGB(255, 255, 255)
            fovCircle.Transparency = 0.7
            fovCircle.Visible = true
        end
        local aimPos = UIS:GetMouseLocation()
        fovCircle.Position = aimPos
        fovCircle.Radius = Cheat.AimbotFOV
    else
        if fovCircle then
            fovCircle.Visible = false
            fovCircle:Remove()
            fovCircle = nil
        end
    end
end

-- Aimbot target selection
local function GetBestTarget()
    local bestTarget = nil
    local bestScore = Cheat.AimbotFOV
    local aimPos = UIS:GetMouseLocation()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                if Cheat.TeamCheck then
                    local localTeam = LocalPlayer.Team
                    local targetTeam = player.Team
                    if localTeam and targetTeam and localTeam == targetTeam then continue end
                end
                local part = char:FindFirstChild(Cheat.TargetPart) or char:FindFirstChild("HumanoidRootPart")
                if part then
                    local screenPoint, onScreen = Camera:WorldToViewportPoint(part.Position)
                    if onScreen then
                        local delta = Vector2.new(screenPoint.X - aimPos.X, screenPoint.Y - aimPos.Y)
                        local dist = delta.Magnitude
                        if dist < bestScore then
                            bestScore = dist
                            bestTarget = part
                        end
                    end
                end
            end
        end
    end
    return bestTarget
end

-- Smooth aim movement
local function SmoothAim()
    if not Cheat.Aimbot then return end
    local targetPart = GetBestTarget()
    if targetPart then
        local screenPoint = Camera:WorldToViewportPoint(targetPart.Position)
        if screenPoint.Z > 0 then
            local aimPos = UIS:GetMouseLocation()
            local delta = Vector2.new(screenPoint.X - aimPos.X, screenPoint.Y - aimPos.Y)
            if delta.Magnitude > 1 then
                local smoothDelta = delta * Cheat.AimbotSmoothness
                if mousemoverel then
                    mousemoverel(smoothDelta.X, smoothDelta.Y)
                else
                    game:GetService("VirtualInputManager"):SendMouseMoveEvent(smoothDelta.X, smoothDelta.Y)
                end
            end
        end
    end
end

-- Auto‑fire logic
local lastShot = 0
local function AutoFireLogic()
    if not Cheat.AutoFire then return end
    local targetPart = GetBestTarget()
    if targetPart then
        local screenPoint = Camera:WorldToViewportPoint(targetPart.Position)
        if screenPoint.Z > 0 then
            local aimPos = UIS:GetMouseLocation()
            local dist = (Vector2.new(screenPoint.X, screenPoint.Y) - aimPos).Magnitude
            if dist < 30 and tick() - lastShot > Cheat.AutoFireDelay then
                if ShootGunRemote then
                    local origin = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if origin then
                        local targetPos = targetPart.Position
                        pcall(function()
                            ShootGunRemote:FireServer(origin.Position, targetPos, targetPart, targetPos)
                        end)
                        lastShot = tick()
                    end
                end
            end
        end
    end
end

-- Wallbang (shoot through walls on mouse click)
local function SetupWallBang()
    UIS.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if Cheat.WallBang then
                local targetPart = GetBestTarget()
                if targetPart and ShootGunRemote then
                    local origin = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if origin then
                        pcall(function()
                            ShootGunRemote:FireServer(origin.Position, targetPart.Position, targetPart, targetPart.Position)
                        end)
                    end
                end
            end
        end
    end)
end

-- ESP Boxes
local espBoxes = {}
local function UpdateESP()
    for _, obj in pairs(espBoxes) do pcall(function() obj:Destroy() end) end
    espBoxes = {}
    if not Cheat.ESP then return end
    local espColor = Cheat.ESPRainbow and Color3.fromHSV(tick()%1,1,1) or Cheat.ESPColor
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                if Cheat.BoxESP then
                    local box = Instance.new("BoxHandleAdornment")
                    box.Size = Vector3.new(Cheat.ESPBoxSize, Cheat.ESPBoxSize*1.5, Cheat.ESPBoxSize)
                    box.Adornee = hrp
                    box.Color3 = espColor
                    box.AlwaysOnTop = true
                    box.Transparency = 0.5
                    pcall(function() box.Parent = hrp end)
                    table.insert(espBoxes, box)
                end
            end
        end
    end
end

-- Skeleton ESP (lines between bones)
local skeletonLines = {}
local function UpdateSkeletonESP()
    for _, item in pairs(skeletonLines) do
        pcall(function() if item.line then item.line:Remove() end end)
    end
    skeletonLines = {}
    if not Cheat.SkeletonESP then return end
    local skeletonColor = Cheat.SkeletonRainbow and Color3.fromHSV(tick()%1,1,1) or Cheat.SkeletonColor
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            if char then
                local head = char:FindFirstChild("Head")
                local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
                local leftArm = char:FindFirstChild("LeftUpperArm") or char:FindFirstChild("Left Arm")
                local rightArm = char:FindFirstChild("RightUpperArm") or char:FindFirstChild("Right Arm")
                local leftLeg = char:FindFirstChild("LeftUpperLeg") or char:FindFirstChild("Left Leg")
                local rightLeg = char:FindFirstChild("RightUpperLeg") or char:FindFirstChild("Right Leg")
                local leftForearm = char:FindFirstChild("LeftLowerArm")
                local rightForearm = char:FindFirstChild("RightLowerArm")
                local leftShin = char:FindFirstChild("LeftLowerLeg")
                local rightShin = char:FindFirstChild("RightLowerLeg")
                
                local function addLine(partA, partB)
                    if partA and partB then
                        local line = Drawing.new("Line")
                        line.Visible = true
                        line.Color = skeletonColor
                        line.Thickness = Cheat.SkeletonThickness
                        line.Transparency = 0.7
                        table.insert(skeletonLines, { line = line, partA = partA, partB = partB })
                    end
                end
                
                if Cheat.ShowHead and torso and head then addLine(torso, head) end
                if Cheat.ShowArms then
                    if torso and leftArm then addLine(torso, leftArm) end
                    if torso and rightArm then addLine(torso, rightArm) end
                end
                if Cheat.ShowLegs then
                    if torso and leftLeg then addLine(torso, leftLeg) end
                    if torso and rightLeg then addLine(torso, rightLeg) end
                end
                if Cheat.ShowForearms then
                    if leftArm and leftForearm then addLine(leftArm, leftForearm) end
                    if rightArm and rightForearm then addLine(rightArm, rightForearm) end
                end
                if Cheat.ShowShins then
                    if leftLeg and leftShin then addLine(leftLeg, leftShin) end
                    if rightLeg and rightShin then addLine(rightLeg, rightShin) end
                end
            end
        end
    end
end

-- Update skeleton line positions every frame
local function UpdateSkeletonPositions()
    for _, item in pairs(skeletonLines) do
        if item and item.line and item.partA and item.partB then
            local success, a, b = pcall(function()
                return Camera:WorldToViewportPoint(item.partA.Position), Camera:WorldToViewportPoint(item.partB.Position)
            end)
            if success and a and b then
                if a.Z > 0 and b.Z > 0 then
                    item.line.From = Vector2.new(a.X, a.Y)
                    item.line.To = Vector2.new(b.X, b.Y)
                    item.line.Visible = true
                else
                    item.line.Visible = false
                end
            else
                if item.line then item.line.Visible = false end
            end
        end
    end
end

-- Render loop
RunService.RenderStepped:Connect(function()
    SmoothAim()
    AutoFireLogic()
    UpdateESP()
    UpdateSkeletonESP()
    UpdateSkeletonPositions()
    UpdateFOVCircle()
end)

-- Initialize wallbang listener
SetupWallBang()

-- ========== UI CREATION ==========
local Window = Library:CreateWindow("Sniper Arena Cheats")

-- Combat Tab
local CombatTab = Window:CreateTab("Combat", "swords")
local CombatSub = CombatTab:CreateSubTab("Aimbot", "target")
local Sec = CombatSub:CreateSection("Aimbot Settings")
local aimbotToggle = Sec:CreateToggle("Aimbot", Cheat.Aimbot, function(v) Cheat.Aimbot = v; UpdateFOVCircle() end)
local autoFireToggle = Sec:CreateToggle("Auto Fire", Cheat.AutoFire, function(v) Cheat.AutoFire = v end)
local wallbangToggle = Sec:CreateToggle("Wall Bang", Cheat.WallBang, function(v) Cheat.WallBang = v end)
local teamCheckToggle = Sec:CreateToggle("Team Check", Cheat.TeamCheck, function(v) Cheat.TeamCheck = v end)
Sec:CreateSlider("Aimbot FOV", 20, 360, Cheat.AimbotFOV, function(v) Cheat.AimbotFOV = v; UpdateFOVCircle() end)
Sec:CreateSlider("Smoothness", 0.05, 1, Cheat.AimbotSmoothness, function(v) Cheat.AimbotSmoothness = v end)
Sec:CreateSlider("Auto Fire Delay", 0.05, 0.5, Cheat.AutoFireDelay, function(v) Cheat.AutoFireDelay = v end)
Sec:CreateDropdown("Target Part", {"Head","HumanoidRootPart"}, Cheat.TargetPart, function(v) Cheat.TargetPart = v end)
Sec:CreateToggle("Show FOV Circle", Cheat.ShowFOVCircle, function(v) Cheat.ShowFOVCircle = v; UpdateFOVCircle() end)

-- Visuals Tab
local VisualTab = Window:CreateTab("Visuals", "eye")
local VisSub = VisualTab:CreateSubTab("ESP", "eye")
local VisSec = VisSub:CreateSection("ESP")
VisSec:CreateToggle("ESP Enabled", Cheat.ESP, function(v) Cheat.ESP = v end)
VisSec:CreateToggle("Box ESP", Cheat.BoxESP, function(v) Cheat.BoxESP = v end)
VisSec:CreateSlider("Box Size", 1, 8, Cheat.ESPBoxSize, function(v) Cheat.ESPBoxSize = v end)
VisSec:CreateColorPicker("Box Color", Cheat.ESPColor, function(v) Cheat.ESPColor = v; Cheat.ESPRainbow = false end)
VisSec:CreateToggle("Rainbow Box", Cheat.ESPRainbow, function(v) Cheat.ESPRainbow = v end)

-- Skeleton Section
local SkeletonSec = VisSub:CreateSection("Skeleton ESP")
SkeletonSec:CreateToggle("Skeleton ESP", Cheat.SkeletonESP, function(v) Cheat.SkeletonESP = v end)
SkeletonSec:CreateSlider("Skeleton Thickness", 1, 3, Cheat.SkeletonThickness, function(v) Cheat.SkeletonThickness = v end)
SkeletonSec:CreateColorPicker("Skeleton Color", Cheat.SkeletonColor, function(v) Cheat.SkeletonColor = v; Cheat.SkeletonRainbow = false end)
SkeletonSec:CreateToggle("Rainbow Skeleton", Cheat.SkeletonRainbow, function(v) Cheat.SkeletonRainbow = v end)

-- Body parts toggles
local BodySec = VisSub:CreateSection("Body Parts")
BodySec:CreateToggle("Head", Cheat.ShowHead, function(v) Cheat.ShowHead = v end)
BodySec:CreateToggle("Torso", Cheat.ShowTorso, function(v) Cheat.ShowTorso = v end)
BodySec:CreateToggle("Arms", Cheat.ShowArms, function(v) Cheat.ShowArms = v end)
BodySec:CreateToggle("Legs", Cheat.ShowLegs, function(v) Cheat.ShowLegs = v end)
BodySec:CreateToggle("Forearms", Cheat.ShowForearms, function(v) Cheat.ShowForearms = v end)
BodySec:CreateToggle("Shins", Cheat.ShowShins, function(v) Cheat.ShowShins = v end)

-- Settings Tab (config save/load)
local SettingsTab = Window:CreateTab("Settings", "sliders")
local SettingsSub = SettingsTab:CreateSubTab("Config", "save")
local SettingsSec = SettingsSub:CreateSection("Configuration")
SettingsSec:CreateButton("Save Config", function()
    getgenv().SniperArenaConfig = Cheat
end)
SettingsSec:CreateButton("Load Config", function()
    if getgenv().SniperArenaConfig then
        local cfg = getgenv().SniperArenaConfig
        Cheat.Aimbot = cfg.Aimbot; aimbotToggle.Set(Cheat.Aimbot)
        Cheat.AutoFire = cfg.AutoFire; autoFireToggle.Set(Cheat.AutoFire)
        Cheat.WallBang = cfg.WallBang; wallbangToggle.Set(Cheat.WallBang)
        Cheat.TeamCheck = cfg.TeamCheck; teamCheckToggle.Set(Cheat.TeamCheck)
        Cheat.AimbotFOV = cfg.AimbotFOV; UpdateFOVCircle()
        Cheat.AimbotSmoothness = cfg.AimbotSmoothness
        Cheat.AutoFireDelay = cfg.AutoFireDelay
        Cheat.TargetPart = cfg.TargetPart
        Cheat.ESP = cfg.ESP
        Cheat.BoxESP = cfg.BoxESP
        Cheat.ESPBoxSize = cfg.ESPBoxSize
        Cheat.ESPColor = cfg.ESPColor
        Cheat.ESPRainbow = cfg.ESPRainbow
        Cheat.SkeletonESP = cfg.SkeletonESP
        Cheat.SkeletonThickness = cfg.SkeletonThickness
        Cheat.SkeletonColor = cfg.SkeletonColor
        Cheat.SkeletonRainbow = cfg.SkeletonRainbow
        Cheat.ShowHead = cfg.ShowHead
        Cheat.ShowTorso = cfg.ShowTorso
        Cheat.ShowArms = cfg.ShowArms
        Cheat.ShowLegs = cfg.ShowLegs
        Cheat.ShowForearms = cfg.ShowForearms
        Cheat.ShowShins = cfg.ShowShins
        Cheat.ShowFOVCircle = cfg.ShowFOVCircle; UpdateFOVCircle()
    end
end)

print("Sniper Arena Cheats Loaded – Press RightShift to open UI")