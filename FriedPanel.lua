local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Camera = Workspace.CurrentCamera

local IsMM2 = (game.PlaceId == 142823291)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FriedPanel"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 650, 0, 500)
MainFrame.Position = UDim2.new(0.5, -325, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Text = "Fried Panel"
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = Color3.fromRGB(255, 255, 0) -- Неоновый жёлтый
Title.TextColor3 = Color3.fromRGB(0, 0, 0)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 28
Title.Parent = MainFrame

local CloseButton = Instance.new("TextButton")
CloseButton.Text = "X"
CloseButton.Size = UDim2.new(0, 40, 0, 50)
CloseButton.Position = UDim2.new(1, -40, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseButton.TextColor3 = Color3.new(1,1,1)
CloseButton.Parent = MainFrame
CloseButton.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 0, 40)
TabContainer.Position = UDim2.new(0, 0, 0, 50)
TabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TabContainer.Parent = MainFrame

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
Content.Size = UDim2.new(1, -20, 1, -100)
Content.Position = UDim2.new(0, 10, 0, 90)
Content.BackgroundTransparency = 1
Content.ScrollBarThickness = 8
Content.Parent = MainFrame
Content.CanvasSize = UDim2.new(0, 0, 0, 0)

local SpeedEnabled = false
local SpeedValue = 50
local FlyEnabled = false
local FlySpeed = 100
local AimbotEnabled = false
local AimbotFOV = 150
local AimbotPart = "Head"
local ESPEnabled = false
local NoclipEnabled = false
local InfJumpEnabled = false

local ShootMurdererBtn = nil
local AutoGrabGun = false
local FlingSheriff = false
local FlingMurderer = false
local FlingAll = false

local FlyConnection
local AimbotConnection
local ESPDrawings = {}

local function CreateLabel(text, pos)
    local lbl = Instance.new("TextLabel")
    lbl.Text = text
    lbl.Size = UDim2.new(1, -20, 0, 30)
    lbl.Position = pos
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(255, 255, 0)
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = Content
    return lbl
end

local function CreateButton(text, pos, callback)
    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
    btn.TextColor3 = Color3.new(0,0,0)
    btn.Font = Enum.Font.GothamBold
    btn.Parent = Content
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function CreateToggle(text, pos, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 40)
    frame.Position = pos
    frame.BackgroundTransparency = 1
    frame.Parent = Content

    local lbl = Instance.new("TextLabel")
    lbl.Text = text
    lbl.Size = UDim2.new(0.7, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(255, 255, 0)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 60, 0, 30)
    toggle.Position = UDim2.new(1, -70, 0.5, -15)
    toggle.BackgroundColor3 = default and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    toggle.Text = default and "ON" or "OFF"
    toggle.TextColor3 = Color3.new(0,0,0)
    toggle.Parent = frame

    toggle.MouseButton1Click:Connect(function()
        default = not default
        toggle.BackgroundColor3 = default and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        toggle.Text = default and "ON" or "OFF"
        callback(default)
    end)
    return toggle
end

local function LoadUniversal()
    Content:ClearAllChildren()
    local y = 10

    CreateLabel("Speed Hack (persistent after respawn)", UDim2.new(0, 10, 0, y))
    y = y + 40
    local speedInput = Instance.new("TextBox")
    speedInput.PlaceholderText = "50"
    speedInput.Size = UDim2.new(0.4, 0, 0, 40)
    speedInput.Position = UDim2.new(0, 10, 0, y)
    speedInput.Parent = Content
    CreateToggle("Speed Enabled", UDim2.new(0.5, 0, 0, y), false, function(state)
        SpeedEnabled = state
        if state and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = tonumber(speedInput.Text) or 50
        end
    end)
    y = y + 50

    LocalPlayer.CharacterAdded:Connect(function(char)
        wait(0.5)
        if SpeedEnabled and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = tonumber(speedInput.Text) or 50
        end
    end)

    CreateLabel("Fly Speed", UDim2.new(0, 10, 0, y))
    y = y + 40
    local flyInput = Instance.new("TextBox")
    flyInput.PlaceholderText = "100"
    flyInput.Size = UDim2.new(0.4, 0, 0, 40)
    flyInput.Position = UDim2.new(0, 10, 0, y)
    flyInput.Parent = Content
    CreateToggle("Fly", UDim2.new(0.5, 0, 0, y), false, function(state)
        FlyEnabled = state
        if state then
            local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local hrp = char:WaitForChild("HumanoidRootPart")
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            bv.Velocity = Vector3.new(0,0,0)
            bv.Parent = hrp
            FlyConnection = RunService.RenderStepped:Connect(function()
                if FlyEnabled and hrp then
                    local cam = Camera
                    local move = Vector3.new()
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0,1,0) end
                    bv.Velocity = move.Unit * (tonumber(flyInput.Text) or 100)
                end
            end)
        else
            if FlyConnection then FlyConnection:Disconnect() end
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local bv = LocalPlayer.Character.HumanoidRootPart:FindFirstChildOfClass("BodyVelocity")
                if bv then bv:Destroy() end
            end
        end
    end)
    y = y + 50

    CreateLabel("Aimbot FOV", UDim2.new(0, 10, 0, y))
    y = y + 40
    local fovInput = Instance.new("TextBox")
    fovInput.PlaceholderText = "150"
    fovInput.Size = UDim2.new(0.4, 0, 0, 40)
    fovInput.Position = UDim2.new(0, 10, 0, y)
    fovInput.Parent = Content
    CreateToggle("Aimbot", UDim2.new(0.5, 0, 0, y), false, function(state)
        AimbotEnabled = state
        if state then
            AimbotConnection = RunService.RenderStepped:Connect(function()
                if not AimbotEnabled then return end
                local closest = nil
                local closestDist = tonumber(fovInput.Text) or 150
                for _, plr in pairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and plr.Team ~= LocalPlayer.Team and plr.Character and plr.Character:FindFirstChild(AimbotPart) and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
                        local part = plr.Character[AimbotPart]
                        local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                        local mousePos = UserInputService:GetMouseLocation()
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mousePos.X, mousePos.Y)).Magnitude
                        if onScreen and dist < closestDist then
                            closestDist = dist
                            closest = part
                        end
                    end
                end
                if closest then
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, closest.Position)
                end
            end)
        else
            if AimbotConnection then AimbotConnection:Disconnect() end
        end
    end)
    y = y + 50

    CreateToggle("ESP (Box + Name + HP)", UDim2.new(0, 10, 0, y), false, function(state)
        ESPEnabled = state
    end)
    y = y + 50

    CreateToggle("Noclip", UDim2.new(0, 10, 0, y), false, function(state)
        NoclipEnabled = state
        if state then
            RunService.Stepped:Connect(function()
                if NoclipEnabled and LocalPlayer.Character then
                    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
            end)
        end
    end)
    y = y + 50

    CreateToggle("Infinite Jump", UDim2.new(0, 10, 0, y), false, function(state)
        InfJumpEnabled = state
        if state then
            UserInputService.JumpRequest:Connect(function()
                if InfJumpEnabled then
                    LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
                end
            end)
        end
    end)
    y = y + 50

    Content.CanvasSize = UDim2.new(0, 0, 0, y)
end

-- MM2 Features
local function LoadMM2()
    Content:ClearAllChildren()
    if not IsMM2 then
        CreateLabel("Этот скрипт работает только в Murder Mystery 2!", UDim2.new(0, 10, 0, 10))
        return
    end
    local y = 10

    CreateButton("Shoot Murderer (hold E)", UDim2.new(0, 10, 0, y), function()
    end)
    y = y + 50

    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.E then
            local murderer = nil
            for _, plr in pairs(Players:GetPlayers()) do
                if plr.Backpack:FindFirstChild("Knife") or (plr.Character and plr.Character:FindFirstChild("Knife")) then
                    murderer = plr
                    break
                end
            end
            if murderer and murderer.Character and murderer.Character:FindFirstChild("Head") then
                local args = { [1] = murderer.Character.Head.Position }
                game:GetService("ReplicatedStorage").Remotes.SheriffShoot:FireServer(unpack(args))
            end
        end
    end)

    CreateToggle("Auto Grab Dropped Gun", UDim2.new(0, 10, 0, y), false, function(state)
        AutoGrabGun = state
    end)
    y = y + 50

    CreateToggle("Fling Sheriff", UDim2.new(0, 10, 0, y), false, function(state)
        FlingSheriff = state
    end)
    y = y + 50

    CreateToggle("Fling Murderer", UDim2.new(0, 10, 0, y), false, function(state)
        FlingMurderer = state
    end)
    y = y + 50

    CreateToggle("Fling All Players", UDim2.new(0, 10, 0, y), false, function(state)
        FlingAll = state
    end)
    y = y + 50

    CreateButton("Kill All (as Murderer)", UDim2.new(0, 10, 0, y), function()
        if not LocalPlayer.Backpack:FindFirstChild("Knife") and not (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Knife")) then return end
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local oldPos = LocalPlayer.Character.HumanoidRootPart.Position
                LocalPlayer.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,3)
                wait(0.1)
                game:GetService("ReplicatedStorage").Remotes.KnifeStab:FireServer()
                wait(0.1)
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(oldPos)
            end
        end
    end)
    y = y + 60

    Content.CanvasSize = UDim2.new(0, 0, 0, y)
end

-- ESP Update
RunService.RenderStepped:Connect(function()
    if ESPEnabled then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("Humanoid") then
                local head = plr.Character.Head
                local hum = plr.Character.Humanoid
                local pos, visible = Camera:WorldToViewportPoint(head.Position)
                if visible then
                    if not ESPDrawings[plr] then
                        local box = Drawing.new("Square")
                        box.Thickness = 2
                        box.Color = Color3.fromRGB(255,255,0)
                        box.Filled = false
                        local text = Drawing.new("Text")
                        text.Size = 16
                        text.Color = Color3.fromRGB(255,255,255)
                        text.Center = true
                        ESPDrawings[plr] = {box = box, text = text}
                    end
                    local drawing = ESPDrawings[plr]
                    drawing.box.Visible = true
                    drawing.box.Size = Vector2.new(2000 / pos.Z, 4000 / pos.Z)
                    drawing.box.Position = Vector2.new(pos.X - drawing.box.Size.X/2, pos.Y - drawing.box.Size.Y/2)
                    drawing.text.Visible = true
                    drawing.text.Position = Vector2.new(pos.X, pos.Y - 40)
                    drawing.text.Text = plr.Name .. " [" .. math.floor(hum.Health) .. "]"
                else
                    if ESPDrawings[plr] then
                        ESPDrawings[plr].box.Visible = false
                        ESPDrawings[plr].text.Visible = false
                    end
                end
            end
        end
    else
        for _, d in pairs(ESPDrawings) do
            d.box.Visible = false
            d.text.Visible = false
        end
    end
end)

-- MM2 Auto Grab + Fling
RunService.Heartbeat:Connect(function()
    if IsMM2 then
        if AutoGrabGun then
            local gun = Workspace:FindFirstChild("GunDrop")
            if gun and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local oldPos = LocalPlayer.Character.HumanoidRootPart.CFrame
                LocalPlayer.Character.HumanoidRootPart.CFrame = gun.CFrame
                wait(0.2)
                fireclickdetector(gun.ClickDetector)
                wait(0.2)
                LocalPlayer.Character.HumanoidRootPart.CFrame = oldPos
            end
        end

        if FlingAll or FlingSheriff or FlingMurderer then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local isSheriff = plr.Backpack:FindFirstChild("Gun") or (plr.Character and plr.Character:FindFirstChild("Gun"))
                    local isMurderer = plr.Backpack:FindFirstChild("Knife") or (plr.Character and plr.Character:FindFirstChild("Knife"))
                    if FlingAll or (FlingSheriff and isSheriff) or (FlingMurderer and isMurderer) then
                        local body = Instance.new("BodyAngularVelocity")
                        body.AngularVelocity = Vector3.new(10000, 10000, 10000)
                        body.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
                        body.Parent = plr.Character.HumanoidRootPart
                        delay(0.5, function() body:Destroy() end)
                    end
                end
            end
        end
    end
end)

-- Tab switching
UniversalBtn.MouseButton1Click:Connect(function()
    LoadUniversal()
    UniversalBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
    MM2Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
end)

MM2Btn.MouseButton1Click:Connect(function()
    LoadMM2()
    MM2Btn.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
    UniversalBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
end)

-- Start
LoadUniversal()

print("Fried Panel полностью загружен!")
