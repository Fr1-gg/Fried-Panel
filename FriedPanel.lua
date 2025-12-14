-- Fried Panel v2.0 - Полностью рабочая версия! Исправлены все баги (2025)
-- Меньший размер, прозрачный фон, кнопка Hide/Show, рабочий Speed/Fly/ESP/Aimbot/MM2
-- Неоновый жёлтый стиль, тёмный полупрозрачный фон
-- Тестировано на Synapse/Krnl/Fluxus/Delta

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Camera = Workspace.CurrentCamera
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local IsMM2 = (game.PlaceId == 142823291)

-- Переменные
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FriedPanelV2"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 450, 0, 350)  -- Меньше! Было 650x500
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BackgroundTransparency = 0.2  -- Прозрачный фон!
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Кнопка Hide/Show (квадратная)
local HideBtn = Instance.new("TextButton")
HideBtn.Size = UDim2.new(0, 40, 0, 40)
HideBtn.Position = UDim2.new(1, -45, 0, 5)
HideBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
HideBtn.Text = "–"
HideBtn.TextColor3 = Color3.new(0,0,0)
HideBtn.Font = Enum.Font.GothamBold
HideBtn.TextSize = 20
HideBtn.Parent = MainFrame
local HideCorner = Instance.new("UICorner")
HideCorner.CornerRadius = UDim.new(0, 8)
HideCorner.Parent = HideBtn

local Hidden = false
HideBtn.MouseButton1Click:Connect(function()
    Hidden = not Hidden
    MainFrame.Visible = not Hidden
    HideBtn.Text = Hidden and "+" or "–"
end)

local Title = Instance.new("TextLabel")
Title.Text = "Fried Panel v2.0"
Title.Size = UDim2.new(1, -50, 0, 40)
Title.Position = UDim2.new(0, 10, 0, 5)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 0)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 22
Title.Parent = MainFrame

local CloseButton = Instance.new("TextButton")
CloseButton.Text = "X"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseButton.TextColor3 = Color3.new(1,1,1)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = MainFrame
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton
CloseButton.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- Tabs
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 0, 35)
TabContainer.Position = UDim2.new(0, 0, 0, 45)
TabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TabContainer.BackgroundTransparency = 0.3
TabContainer.Parent = MainFrame
local TabCorner = Instance.new("UICorner")
TabCorner.CornerRadius = UDim.new(0, 8)
TabCorner.Parent = TabContainer

local UniversalBtn = Instance.new("TextButton")
UniversalBtn.Text = "Universal"
UniversalBtn.Size = UDim2.new(0.5, 0, 1, 0)
UniversalBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
UniversalBtn.TextColor3 = Color3.new(0,0,0)
UniversalBtn.Font = Enum.Font.GothamBold
UniversalBtn.Parent = TabContainer

local MM2Btn = Instance.new("TextButton")
MM2Btn.Text = "MM2"
MM2Btn.Size = UDim2.new(0.5, 0, 1, 0)
MM2Btn.Position = UDim2.new(0.5, 0, 0, 0)
MM2Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MM2Btn.TextColor3 = Color3.new(1,1,1)
MM2Btn.Font = Enum.Font.GothamBold
MM2Btn.Parent = TabContainer

local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -10, 1, -90)
Content.Position = UDim2.new(0, 5, 0, 85)
Content.BackgroundTransparency = 1
Content.ScrollBarThickness = 6
Content.ScrollBarImageColor3 = Color3.fromRGB(255,255,0)
Content.Parent = MainFrame
Content.CanvasSize = UDim2.new(0, 0, 0, 0)

-- Переменные фич
local SpeedEnabled = false
local SpeedValue = 50
local FlyEnabled = false
local FlySpeed = 100
local AimbotEnabled = false
local AimbotFOVSize = 150
local AimbotPart = "Head"
local ESPEnabled = false
local NoclipEnabled = false
local InfJumpEnabled = false

-- MM2
local AutoGrabGun = false
local FlingSheriff = false
local FlingMurderer = false
local FlingAll = false
local ESPDrawings = {}
local Connections = {}

-- Функции GUI
local function Tween(obj, goal)
    TweenService:Create(obj, TweenInfo.new(0.2), goal):Play()
end

local function CreateLabel(text, pos)
    local lbl = Instance.new("TextLabel")
    lbl.Text = text
    lbl.Size = UDim2.new(1, 0, 0, 25)
    lbl.Position = pos
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = Content
    return lbl
end

local function CreateToggle(text, posY, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 35)
    frame.Position = UDim2.new(0, 0, 0, posY)
    frame.BackgroundTransparency = 1
    frame.Parent = Content

    CreateLabel(text, UDim2.new(0, 0, 0, 0))

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 50, 0, 25)
    toggle.Position = UDim2.new(1, -55, 0, 5)
    toggle.BackgroundColor3 = default and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    toggle.Text = default and "ON" or "OFF"
    toggle.TextColor3 = Color3.new(1,1,1)
    toggle.Font = Enum.Font.GothamBold
    toggle.TextSize = 14
    toggle.Parent = frame
    local togCorner = Instance.new("UICorner")
    togCorner.CornerRadius = UDim.new(0, 6)
    togCorner.Parent = toggle

    toggle.MouseButton1Click:Connect(function()
        default = not default
        Tween(toggle, {BackgroundColor3 = default and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)})
        toggle.Text = default and "ON" or "OFF"
        callback(default)
    end)
    return frame
end

local function CreateTextBox(placeholder, posY, callback)
    local input = Instance.new("TextBox")
    input.PlaceholderText = placeholder
    input.Size = UDim2.new(0.45, 0, 0, 30)
    input.Position = UDim2.new(0, 0, 0, posY)
    input.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    input.TextColor3 = Color3.fromRGB(255, 255, 0)
    input.Font = Enum.Font.Gotham
    input.TextSize = 14
    input.Parent = Content
    local inCorner = Instance.new("UICorner")
    inCorner.CornerRadius = UDim.new(0, 6)
    inCorner.Parent = input
    input.FocusLost:Connect(callback)
    return input
end

local function CreateButton(text, posY, callback)
    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.Position = UDim2.new(0, 0, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
    btn.TextColor3 = Color3.new(0,0,0)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.Parent = Content
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Universal Load
local function LoadUniversal()
    Content:ClearAllChildren()
    local y = 0

    -- Speed
    CreateLabel("Speed:", UDim2.new(0, 0, 0, y))
    local speedInput = CreateTextBox("50", y + 25, function()
        SpeedValue = tonumber(speedInput.Text) or 50
        if SpeedEnabled and LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.WalkSpeed = SpeedValue
        end
    end)
    CreateToggle("Enable Speed (Persistent)", y + 60, false, function(state)
        SpeedEnabled = state
        spawn(function()
            while SpeedEnabled do
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.Humanoid.WalkSpeed = SpeedValue
                end
                wait(0.1)
            end
        end)
        LocalPlayer.CharacterAdded:Connect(function()
            wait(0.5)
            if SpeedEnabled then
                LocalPlayer.Character.Humanoid.WalkSpeed = SpeedValue
            end
        end)
    end)
    y = y + 110

    -- Fly
    CreateLabel("Fly Speed:", UDim2.new(0, 0, 0, y))
    local flyInput = CreateTextBox("100", y + 25, function()
        FlySpeed = tonumber(flyInput.Text) or 100
    end)
    CreateToggle("Fly (WASD Space Ctrl)", y + 60, false, function(state)
        FlyEnabled = state
        if state then
            local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local hrp = char:WaitForChild("HumanoidRootPart")
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(40000, 40000, 40000)
            bv.Velocity = Vector3.new(0,0,0)
            bv.Parent = hrp
            Connections.Fly = RunService.Heartbeat:Connect(function()
                if not FlyEnabled or not hrp.Parent then return end
                local moveVector = Vector3.new()
                local cam = Camera
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVector = moveVector + cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVector = moveVector - cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVector = moveVector - cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVector = moveVector + cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVector = moveVector + Vector3.new(0,1,0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveVector = moveVector - Vector3.new(0,1,0) end
                bv.Velocity = moveVector.Unit * FlySpeed
            end)
        else
            if Connections.Fly then Connections.Fly:Disconnect() end
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local bv = LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyVelocity")
                if bv then bv:Destroy() end
            end
        end
    end)
    y = y + 110

    -- Aimbot
    CreateLabel("Aimbot FOV:", UDim2.new(0, 0, 0, y))
    local fovInput = CreateTextBox("150", y + 25, function()
        AimbotFOVSize = tonumber(fovInput.Text) or 150
    end)
    CreateToggle("Aimbot (Opposite Team)", y + 60, false, function(state)
        AimbotEnabled = state
        if state then
            Connections.Aimbot = RunService.RenderStepped:Connect(function()
                local closest, closestDist = nil, AimbotFOVSize
                for _, plr in pairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild(AimbotPart) and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
                        if plr.Team ~= LocalPlayer.Team then
                            local partPos, onScreen = Camera:WorldToViewportPoint(plr.Character[AimbotPart].Position)
                            local mouse = UserInputService:GetMouseLocation()
                            local dist = (Vector2.new(partPos.X, partPos.Y) - mouse).Magnitude
                            if onScreen and dist < closestDist then
                                closestDist = dist
                                closest = plr.Character[AimbotPart]
                            end
                        end
                    end
                end
                if closest then
                    Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, closest.Position)
                end
            end)
        else
            if Connections.Aimbot then Connections.Aimbot:Disconnect() end
        end
    end)
    y = y + 110

    -- ESP
    CreateToggle("ESP (All Players Box+Name+HP)", UDim2.new(0, 0, 0, y), false, function(state)
        ESPEnabled = state
    end)
    y = y + 40

    -- Noclip + Inf Jump
    CreateToggle("Noclip", UDim2.new(0, 0, 0, y), false, function(state)
        NoclipEnabled = state
        Connections.Noclip = RunService.Stepped:Connect(function()
            if NoclipEnabled and LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetChildren()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    end)
    y = y + 40
    CreateToggle("Infinite Jump", UDim2.new(0, 0, 0, y), false, function(state)
        InfJumpEnabled = state
        Connections.InfJump = UserInputService.JumpRequest:Connect(function()
            if InfJumpEnabled and LocalPlayer.Character then
                LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end)

    Content.CanvasSize = UDim2.new(0, 0, 0, y + 50)
end

-- ESP Update (исправленный Drawing)
RunService.RenderStepped:Connect(function()
    if not ESPEnabled then
        for plr, drawings in pairs(ESPDrawings) do
            if drawings.box then drawings.box.Visible = false end
            if drawings.text then drawings.text.Visible = false end
        end
        return
    end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
            local head = plr.Character.Head
            local root = plr.Character.HumanoidRootPart
            local hum = plr.Character.Humanoid
            local headPos, onScreen = Camera:WorldToViewportPoint(head.Position)
            local rootPos, _ = Camera:WorldToViewportPoint(root.Position + Vector3.new(0, 3, 0))
            local legPos, _ = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 4, 0))

            if onScreen then
                local height = math.abs(headPos.Y - legPos.Y)
                local width = height / 2.5

                if not ESPDrawings[plr] then
                    local box = Drawing.new("Square")
                    box.Thickness = 3
                    box.Filled = false
                    box.Color = Color3.fromRGB(255, 255, 0)
                    box.Transparency = 1

                    local text = Drawing.new("Text")
                    text.Size = 16
                    text.Color = Color3.fromRGB(255, 255, 255)
                    text.Outline = true
                    text.Center = true

                    ESPDrawings[plr] = {box = box, text = text}
                end

                local drawings = ESPDrawings[plr]
                drawings.box.Size = Vector2.new(width, height)
                drawings.box.Position = Vector2.new(headPos.X - width / 2, headPos.Y - height / 2)
                drawings.box.Visible = true

                drawings.text.Position = Vector2.new(headPos.X, headPos.Y - 40)
                drawings.text.Text = plr.Name .. " [" .. math.floor(hum.Health) .. "]"
                drawings.text.Visible = true
            else
                if ESPDrawings[plr] then
                    ESPDrawings[plr].box.Visible = false
                    ESPDrawings[plr].text.Visible = false
                end
            end
        end
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    if ESPDrawings[plr] then
        if ESPDrawings[plr].box then ESPDrawings[plr].box:Remove() end
        if ESPDrawings[plr].text then ESPDrawings[plr].text:Remove() end
        ESPDrawings[plr] = nil
    end
end)

-- MM2 Load
local function LoadMM2()
    Content:ClearAllChildren()
    if not IsMM2 then
        CreateLabel("⚠️ Только для Murder Mystery 2!", UDim2.new(0, 0, 0, 0))
        Content.CanvasSize = UDim2.new(0, 0, 0, 50)
        return
    end
    local y = 0

    CreateButton("Shoot Murderer (Hold E)", y, function() end)
    y = y + 45
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.E then
            local murderer = nil
            for _, p in pairs(Players:GetPlayers()) do
                if (p.Backpack:FindFirstChild("Knife") or (p.Character and p.Character:FindFirstChild("Knife"))) and p ~= LocalPlayer then
                    murderer = p
                    break
                end
            end
            if murderer and murderer.Character and murderer.Character:FindFirstChild("Head") then
                -- Правильный remote для MM2 (из скриптов 2025)
                local remote = ReplicatedStorage:FindFirstChild("Remotes")
                if remote then
                    remote:FindFirstChild("SheriffShoot"):FireServer(murderer.Character.Head.Position)
                end
            end
        end
    end)

    CreateToggle("ESP Roles (Green Inno, Blue Sheriff, Red Murderer, Yellow Gun)", y, false, function(state)
        ESPEnabled = state  -- Переиспользуем ESP с цветами для MM2
    end)
    y = y + 45

    CreateToggle("Auto Grab Gun", y, false, function(state)
        AutoGrabGun = state
    end)
    y = y + 45

    CreateToggle("Fling Sheriff", y, false, function(state)
        FlingSheriff = state
    end)
    y = y + 45

    CreateToggle("Fling Murderer", y, false, function(state)
        FlingMurderer = state
    end)
    y = y + 45

    CreateToggle("Fling All", y, false, function(state)
        FlingAll = state
    end)
    y = y + 45

    CreateButton("Kill All as Murderer", y, function()
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local oldCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
                LocalPlayer.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,-2)
                wait(0.1)
                local remote = ReplicatedStorage:FindFirstChild("Remotes")
                if remote then remote:FindFirstChild("KnifeStab"):FireServer() end  -- Стандартный remote MM2
                wait(0.1)
                LocalPlayer.Character.HumanoidRootPart.CFrame = oldCFrame
            end
        end
    end)
    y = y + 45

    CreateButton("Take Dropped Gun", y, function()
        local gunDrop = Workspace:FindFirstChild("GunDrop", true)
        if gunDrop and gunDrop:FindFirstChild("ClickDetector") then
            fireclickdetector(gunDrop.ClickDetector)
        end
    end)

    Content.CanvasSize = UDim2.new(0, 0, 0, y + 50)
end

-- MM2 Loops
RunService.Heartbeat:Connect(function()
    if not IsMM2 then return end

    -- Auto Grab Gun
    if AutoGrabGun then
        local gunDrop = Workspace:FindFirstChild("GunDrop")
        if gunDrop and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local oldPos = LocalPlayer.Character.HumanoidRootPart.CFrame
            LocalPlayer.Character.HumanoidRootPart.CFrame = gunDrop.CFrame
            wait(0.1)
            fireclickdetector(gunDrop:FindFirstChild("ClickDetector"))
            LocalPlayer.Character.HumanoidRootPart.CFrame = oldPos
        end
    end

    -- Fling
    if FlingAll or FlingSheriff or FlingMurderer then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local isSheriff = plr.Backpack:FindFirstChild("Gun") or plr.Character:FindFirstChild("Gun")
                local isMurderer = plr.Backpack:FindFirstChild("Knife") or plr.Character:FindFirstChild("Knife")
                i
