local CurrentVersion = 10.3
if CurrentVersion <= 7.0 then
    game.Players.LocalPlayer:Kick("\n\n⚠️ LỖI PHIÊN BẢN ⚠️\nScript Vision đã cũ.\nVui lòng cập nhật lên bản mới hơn!")
    while true do task.wait() end 
    return
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [[ HÀM HỖ TRỢ ]] --
local function PlayClickSound()
    task.spawn(function()
        local Sound = Instance.new("Sound", workspace)
        Sound.Name = "PhucClickSound"
        Sound.SoundId = "rbxassetid://12221967"
        Sound.Volume = 5
        Sound:Play()
        game:GetService("Debris"):AddItem(Sound, 1)
    end)
end

local NotifyGui = Instance.new("ScreenGui", CoreGui)
local function ShowKillNotify(TargetName)
    local KillLabel = Instance.new("TextLabel", NotifyGui)
    KillLabel.Size = UDim2.new(1, 0, 0, 50)
    KillLabel.Position = UDim2.new(0, 0, 0.2, 0)
    KillLabel.BackgroundTransparency = 1
    KillLabel.Text = "🔥 MỤC TIÊU [" .. TargetName .. "] ĐÃ BỊ HẠ GỤC! 🔥"
    KillLabel.TextColor3 = Color3.new(1, 0, 0)
    KillLabel.Font = Enum.Font.FredokaOne
    KillLabel.TextSize = 35
    KillLabel.TextStrokeTransparency = 0
    task.spawn(function()
        for i = 1, 100 do
            KillLabel.TextColor3 = Color3.fromHSV(tick() % 1, 1, 1)
            task.wait(0.02)
        end
        KillLabel:Destroy()
    end)
end

getgenv().Config = {
    Hitbox = false, Size = 20, Trans = 5, Aura = false,
    Speed = false, WalkSpeed = 16, Jump = false,
    NoRagdoll = true, AntiVoid = true,
    HitSound = true, SkyWalk = false, FlySpeed = 20
}
getgenv().Whitelist = {}
getgenv().TargetKill = nil 
getgenv().TargetESP = {} 

function Notify(Text)
    StarterGui:SetCore("SendNotification", {
        Title = "PHUC NGUYEN X HUB",
        Text = Text,
        Duration = 2,
    })
end

local function MakeRainbowStroke(Object, Thickness)
    local Stroke = Object:FindFirstChild("UIStroke") or Instance.new("UIStroke", Object)
    Stroke.Thickness = Thickness or 2
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    spawn(function()
        while Object.Parent do
            local hue = tick() % 5 / 5
            Stroke.Color = Color3.fromHSV(hue, 1, 1)
            task.wait()
        end
    end)
end

local function StandUp()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if hum then
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        hum.PlatformStand = false
    end
end

local function EnableDragging(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = frame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    frame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

if CoreGui:FindFirstChild("RedzClassicV76") then CoreGui.RedzClassicV76:Destroy() end
local ScreenGui = Instance.new("ScreenGui", CoreGui); ScreenGui.Name = "RedzClassicV76"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

local HideBtn = Instance.new("ImageButton", ScreenGui)
HideBtn.Size = UDim2.new(0, 40, 0, 40); HideBtn.Position = UDim2.new(0.95, -50, 0.05, 0)
HideBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0); HideBtn.BackgroundTransparency = 0.5
Instance.new("UICorner", HideBtn).CornerRadius = UDim.new(1, 0)
local HideIcon = Instance.new("TextLabel", HideBtn)
HideIcon.Size = UDim2.new(1,0,1,0); HideIcon.Text = "👁️"; HideIcon.BackgroundTransparency=1; HideIcon.TextSize=20

local Toggle = Instance.new("TextButton", ScreenGui)
Toggle.Size = UDim2.new(0, 50, 0, 50); Toggle.Position = UDim2.new(0.1, 0, 0.3, 0)
Toggle.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Toggle.Text = "PHUC"; Toggle.TextColor3 = Color3.fromRGB(255, 0, 0)
Toggle.Font = Enum.Font.FredokaOne; Toggle.TextSize = 18; Instance.new("UICorner", Toggle)
MakeRainbowStroke(Toggle, 2.5) 

local Main = Instance.new("Frame", ScreenGui); Main.Size = UDim2.new(0, 280, 0, 300)
Main.Position = UDim2.new(0.5, -140, 0.5, -130); Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Main.Visible = false
Instance.new("UICorner", Main); MakeRainbowStroke(Main, 3) 
local Title = Instance.new("TextLabel", Main); Title.Size = UDim2.new(1, 0, 0, 30); Title.Text = "PHUC NGUYEN X HUB"; Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.BackgroundTransparency = 1; Title.Font = Enum.Font.SourceSansBold; Title.TextSize = 18

local Container = Instance.new("ScrollingFrame", Main); Container.Size = UDim2.new(1, -10, 1, -40); Container.Position = UDim2.new(0, 5, 0, 35)
Container.BackgroundTransparency = 1; Container.ScrollBarThickness = 2; Container.AutomaticCanvasSize = Enum.AutomaticSize.Y
local UIList = Instance.new("UIListLayout", Container); UIList.Padding = UDim.new(0, 5)

local SubMenu = Instance.new("Frame", ScreenGui); SubMenu.Size = UDim2.new(0, 300, 0, 260); SubMenu.Position = UDim2.new(0.5, 150, 0.5, -130); SubMenu.BackgroundColor3 = Color3.fromRGB(25, 25, 25); SubMenu.Visible = false
Instance.new("UICorner", SubMenu); MakeRainbowStroke(SubMenu, 2) 

local SubTitle = Instance.new("TextLabel", SubMenu); SubTitle.Size = UDim2.new(1, 0, 0, 30); SubTitle.Text = "PLAYER TRACKER"; SubTitle.TextColor3 = Color3.fromRGB(0, 255, 0); SubTitle.BackgroundTransparency = 1; SubTitle.Font = Enum.Font.SourceSansBold; SubTitle.TextSize = 14
local CloseSub = Instance.new("TextButton", SubMenu); CloseSub.Size = UDim2.new(0, 30, 0, 30); CloseSub.Position = UDim2.new(1, -30, 0, 0); CloseSub.Text = "X"; CloseSub.TextColor3 = Color3.fromRGB(255,0,0); CloseSub.BackgroundTransparency = 1; CloseSub.Font = Enum.Font.SourceSansBold
CloseSub.MouseButton1Click:Connect(function() PlayClickSound(); SubMenu.Visible = false end)

local PlayerList = Instance.new("ScrollingFrame", SubMenu); PlayerList.Size = UDim2.new(1, -10, 1, -40); PlayerList.Position = UDim2.new(0, 5, 0, 35)
PlayerList.BackgroundTransparency = 1; PlayerList.ScrollBarThickness = 2; PlayerList.AutomaticCanvasSize = Enum.AutomaticSize.Y
local PListLayout = Instance.new("UIListLayout", PlayerList); PListLayout.Padding = UDim.new(0, 2)

local SubMenu2 = Instance.new("Frame", ScreenGui); SubMenu2.Size = UDim2.new(0, 250, 0, 200); SubMenu2.Position = UDim2.new(0.5, -420, 0.5, -100); SubMenu2.BackgroundColor3 = Color3.fromRGB(30, 30, 35); SubMenu2.Visible = false
Instance.new("UICorner", SubMenu2); MakeRainbowStroke(SubMenu2, 2) 

local CloseSub2 = Instance.new("TextButton", SubMenu2); CloseSub2.Size = UDim2.new(0, 30, 0, 30); CloseSub2.Position = UDim2.new(1, -30, 0, 0); CloseSub2.Text = "X"; CloseSub2.TextColor3 = Color3.fromRGB(255,0,0); CloseSub2.BackgroundTransparency = 1; CloseSub2.Font = Enum.Font.FredokaOne
CloseSub2.MouseButton1Click:Connect(function() PlayClickSound(); SubMenu2.Visible = false end)
local SubTitle2 = Instance.new("TextLabel", SubMenu2); SubTitle2.Size = UDim2.new(1, 0, 0, 30); SubTitle2.Text = "TOOLS MENU"; SubTitle2.TextColor3 = Color3.fromRGB(0, 200, 255); SubTitle2.BackgroundTransparency = 1; SubTitle2.Font = Enum.Font.FredokaOne

EnableDragging(Toggle); EnableDragging(Main); EnableDragging(SubMenu); EnableDragging(SubMenu2)

local BuyX30Btn = Instance.new("TextButton", Container); BuyX30Btn.Size = UDim2.new(1, 0, 0, 35); BuyX30Btn.BackgroundColor3 = Color3.fromRGB(255, 100, 0); BuyX30Btn.Text = "⚡ MUA X30 BĂNG GẠC ⚡"; BuyX30Btn.TextColor3 = Color3.new(1,1,1); BuyX30Btn.Font = Enum.Font.FredokaOne
BuyX30Btn.MouseButton1Click:Connect(function()
    PlayClickSound()
    local args = {"b\196\131ng g\225\186\161c", 30}
    pcall(function() game:GetService("ReplicatedStorage"):WaitForChild("KnitPackages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.7.0"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("ShopService"):WaitForChild("RE"):WaitForChild("buyItem"):FireServer(unpack(args)) end)
    Notify("Đã thực thi mua X30!")
end)

local AnimBtn = Instance.new("TextButton", SubMenu2); AnimBtn.Size = UDim2.new(0.8, 0, 0, 40); AnimBtn.Position = UDim2.new(0.1, 0, 0.25, 0); AnimBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60); AnimBtn.Text = "ANIMATION (Mới)"; AnimBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", AnimBtn)
AnimBtn.MouseButton1Click:Connect(function() PlayClickSound(); loadstring(game:HttpGet("https://raw.githubusercontent.com/phucnguyen987/phucnguyen-hub/refs/heads/main/Animation.lua"))() end)

local CmdBtn = Instance.new("TextButton", SubMenu2); CmdBtn.Size = UDim2.new(0.8, 0, 0, 40); CmdBtn.Position = UDim2.new(0.1, 0, 0.5, 0); CmdBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60); CmdBtn.Text = "COMMAND (Infinite Yield)"; CmdBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", CmdBtn)
CmdBtn.MouseButton1Click:Connect(function() PlayClickSound(); loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end)

local ToolsBtn = Instance.new("TextButton", Container); ToolsBtn.Size = UDim2.new(1, 0, 0, 35); ToolsBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 150); ToolsBtn.Text = ">>> MỞ TOOLS MENU <<<"; ToolsBtn.TextColor3 = Color3.new(1,1,1); ToolsBtn.Font = Enum.Font.FredokaOne
ToolsBtn.MouseButton1Click:Connect(function() PlayClickSound(); if Main.Visible then SubMenu2.Visible = not SubMenu2.Visible; SubMenu.Visible = false end end)

local KillStatus = Instance.new("TextLabel", ScreenGui); KillStatus.Size = UDim2.new(1, 0, 0, 30); KillStatus.Position = UDim2.new(0, 0, 0, 50); KillStatus.BackgroundTransparency = 1; KillStatus.Text = ""; KillStatus.TextColor3 = Color3.fromRGB(255, 0, 0); KillStatus.Font = Enum.Font.FredokaOne; KillStatus.TextSize = 20; KillStatus.TextStrokeTransparency = 0

local GUIVisible = true
HideBtn.MouseButton1Click:Connect(function() PlayClickSound(); GUIVisible = not GUIVisible; Toggle.Visible = GUIVisible; Main.Visible = false; SubMenu.Visible = false; SubMenu2.Visible = false; HideIcon.Text = GUIVisible and "👁️" or "🚫" end)

spawn(function()
    local Angle = 0
    while task.wait() do
        pcall(function()
            local Char = LocalPlayer.Character
            if Char and Char:FindFirstChild("Humanoid") and Char:FindFirstChild("HumanoidRootPart") then
                local MyHum = Char.Humanoid; local MyRoot = Char.HumanoidRootPart
                if getgenv().TargetKill then
                    local Target = Players:FindFirstChild(getgenv().TargetKill)
                    if Target and Target.Character and Target.Character:FindFirstChild("Humanoid") and Target.Character:FindFirstChild("HumanoidRootPart") then
                        local TarHum = Target.Character.Humanoid; local TarRoot = Target.Character.HumanoidRootPart; local Dist = (MyRoot.Position - TarRoot.Position).Magnitude
                        if TarHum.Health > 0 and TarHum.Health < 4 then
                            KillStatus.Text = ">>> KẾT LIỄU: " .. Target.Name .. " <<<"; StandUp(); MyRoot.CFrame = TarRoot.CFrame
                            VirtualUser:CaptureController(); keypress(Enum.KeyCode.E); task.wait(0.05); keyrelease(Enum.KeyCode.E)
                        elseif TarHum.Health > 0 then
                            KillStatus.Text = ">>> ĐANG SĂN: " .. Target.Name .. " <<<"; MyHum.PlatformStand = true; MyRoot.Velocity = Vector3.new(0,0,0)
                            Angle = Angle + 0.4; local CirclePos = TarRoot.Position + Vector3.new(math.cos(Angle) * 5, 3, math.sin(Angle) * 5)
                            MyRoot.CFrame = CFrame.new(CirclePos, TarRoot.Position)
                            VirtualUser:CaptureController(); VirtualUser:ClickButton1(Vector2.new(9999, 9999))
                        else ShowKillNotify(getgenv().TargetKill); getgenv().TargetKill = nil; KillStatus.Text = ""; MyHum.PlatformStand = false end
                    else getgenv().TargetKill = nil end
                end
            end
        end)
    end
end)

function RefreshPlayers()
    for _, v in pairs(PlayerList:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer then
            local PFrame = Instance.new("Frame", PlayerList); PFrame.Size = UDim2.new(1, 0, 0, 40); PFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35); Instance.new("UICorner", PFrame)
            local PName = Instance.new("TextLabel", PFrame); PName.Size = UDim2.new(0.35, 0, 1, 0); PName.BackgroundTransparency = 1; PName.Text = v.Name; PName.TextColor3 = Color3.new(1,1,1); PName.Font = Enum.Font.SourceSansBold; PName.TextSize = 13; PName.Position = UDim2.new(0.02,0,0,0); PName.TextXAlignment = "Left"
            local HPBtn = Instance.new("TextButton", PFrame); HPBtn.Size = UDim2.new(0.18, 0, 0.8, 0); HPBtn.Position = UDim2.new(0.38, 0, 0.1, 0); HPBtn.BackgroundColor3 = Color3.fromRGB(50,50,50); HPBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", HPBtn); HPBtn.Font = Enum.Font.SourceSansBold; HPBtn.TextSize = 11
            local SafeBtn = Instance.new("TextButton", PFrame); SafeBtn.Size = UDim2.new(0.18, 0, 0.8, 0); SafeBtn.Position = UDim2.new(0.58, 0, 0.1, 0); SafeBtn.BackgroundColor3 = Color3.fromRGB(50,50,50); SafeBtn.Text = "SAFE"; SafeBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", SafeBtn); SafeBtn.Font = Enum.Font.SourceSansBold; SafeBtn.TextSize = 10
            local KillBtn = Instance.new("TextButton", PFrame); KillBtn.Size = UDim2.new(0.2, 0, 0.8, 0); KillBtn.Position = UDim2.new(0.78, 0, 0.1, 0); KillBtn.BackgroundColor3 = Color3.fromRGB(150,0,0); KillBtn.Text = "KILL"; KillBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", KillBtn); KillBtn.Font = Enum.Font.SourceSansBold; KillBtn.TextSize = 12
            spawn(function()
                while PFrame.Parent do
                    pcall(function()
                        if v.Character and v.Character:FindFirstChild("Humanoid") then
                            local HP = math.floor(v.Character.Humanoid.Health); HPBtn.Text = HP .. "%"
                            if getgenv().TargetESP[v.Name] then HPBtn.BackgroundColor3 = Color3.new(1,0,0) else HPBtn.BackgroundColor3 = Color3.fromRGB(50,50,50) end
                        else HPBtn.Text = "X" end
                        if getgenv().Whitelist[v.Name] then SafeBtn.TextColor3 = Color3.new(0,1,0) else SafeBtn.TextColor3 = Color3.new(1,1,1) end
                        if getgenv().TargetKill == v.Name then KillBtn.Text = "STOP"; KillBtn.BackgroundColor3 = Color3.new(0,1,0) else KillBtn.Text = "KILL"; KillBtn.BackgroundColor3 = Color3.fromRGB(150,0,0) end
                    end)
                    task.wait(0.5)
                end
            end)
            HPBtn.MouseButton1Click:Connect(function() PlayClickSound(); getgenv().TargetESP[v.Name] = not getgenv().TargetESP[v.Name] end)
            SafeBtn.MouseButton1Click:Connect(function() PlayClickSound(); getgenv().Whitelist[v.Name] = not getgenv().Whitelist[v.Name] end)
            KillBtn.MouseButton1Click:Connect(function() PlayClickSound(); if getgenv().TargetKill == v.Name then getgenv().TargetKill = nil else getgenv().TargetKill = v.Name end end)
        end
    end
end

function AddToggle(Text, Flag)
    local Btn = Instance.new("TextButton", Container); Btn.Size = UDim2.new(1, 0, 0, 35); Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Btn.Text = "  " .. Text .. " [OFF]"; Btn.TextColor3 = Color3.fromRGB(150, 150, 150); Btn.TextXAlignment = "Left"; Btn.Font = Enum.Font.SourceSansBold
    Btn.MouseButton1Click:Connect(function()
        PlayClickSound(); if not Main.Visible then return end
        getgenv().Config[Flag] = not getgenv().Config[Flag]
        Btn.Text = "  " .. Text .. " [" .. (getgenv().Config[Flag] and "ON" or "OFF") .. "]"; Btn.TextColor3 = getgenv().Config[Flag] and Color3.new(0,1,0) or Color3.fromRGB(150,150,150)
        Notify((getgenv().Config[Flag] and "✅ ĐÃ BẬT: " or "❌ ĐÃ TẮT: ") .. Text)
    end)
end

function AddSlider(Text, Flag, Min, Max)
    local F = Instance.new("Frame", Container); F.Size = UDim2.new(1, 0, 0, 45); F.BackgroundTransparency = 1
    local L = Instance.new("TextLabel", F); L.Size = UDim2.new(1, 0, 0, 20); L.Text = Text .. ": " .. getgenv().Config[Flag]; L.TextColor3 = Color3.new(1,1,1); L.BackgroundTransparency = 1
    local B = Instance.new("TextButton", F); B.Size = UDim2.new(0.9, 0, 0, 8); B.Position = UDim2.new(0.05, 0, 0.6, 0); B.BackgroundColor3 = Color3.new(0,0,0); B.Text = ""
    local Fill = Instance.new("Frame", B); Fill.Size = UDim2.new((getgenv().Config[Flag]-Min)/(Max-Min),0,1,0); Fill.BackgroundColor3 = Color3.new(1,0,0)
    B.MouseButton1Down:Connect(function()
        if not Main.Visible then return end
        local M = LocalPlayer:GetMouse(); local C; C = RunService.RenderStepped:Connect(function()
            if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or not Main.Visible then C:Disconnect() return end
            local P = math.clamp((M.X - B.AbsolutePosition.X) / B.AbsoluteSize.X, 0, 1); local V = math.floor(Min + (Max - Min) * P); getgenv().Config[Flag] = V; L.Text = Text .. ": " .. V; Fill.Size = UDim2.new(P, 0, 1, 0)
        end)
    end)
end

AddToggle("Hitbox (No Fling)", "Hitbox"); AddSlider("Kích Thước Hitbox", "Size", 2, 100); AddSlider("Độ Mờ Hitbox", "Trans", 0, 10); AddToggle("Hit Sound (Âm Thanh)", "HitSound"); AddToggle("Sky Walk (Đi Trên Không)", "SkyWalk") 

local PlayerBtn = Instance.new("TextButton", Container); PlayerBtn.Size = UDim2.new(1,0,0,35); PlayerBtn.BackgroundColor3 = Color3.fromRGB(40,40,40); PlayerBtn.Text = ">>> MỞ PLAYER TRACKER (KILL/ESP) <<<"; PlayerBtn.TextColor3 = Color3.new(0,1,1); PlayerBtn.Font = "SourceSansBold"
PlayerBtn.MouseButton1Click:Connect(function() PlayClickSound(); if Main.Visible then SubMenu.Visible = not SubMenu.Visible; SubMenu2.Visible = false; if SubMenu.Visible then RefreshPlayers() end end end)

AddToggle("Attack Aura (Tầm Xa)", "Aura"); AddToggle("Speed Bypass (Anti-Kick)", "Speed"); AddSlider("Tốc Độ", "WalkSpeed", 16, 300); AddToggle("Nhảy Vô Hạn", "Jump"); AddToggle("Anti-Void", "AntiVoid"); AddToggle("Anti-Ragdoll", "NoRagdoll")

local HitSound = Instance.new("Sound", Workspace); HitSound.SoundId = "rbxassetid://169444938"; HitSound.Volume = 1
RunService.Heartbeat:Connect(function()
    if getgenv().Config.Hitbox then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and not getgenv().Whitelist[v.Name] and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local HRP = v.Character.HumanoidRootPart; HRP.Size = Vector3.new(getgenv().Config.Size, getgenv().Config.Size, getgenv().Config.Size)
                HRP.Transparency = getgenv().Config.Trans/10; HRP.CanCollide = false; HRP.BrickColor = BrickColor.new("Really red")
            end
        end
    end
end)

spawn(function()
    while task.wait() do
        pcall(function()
            if getgenv().Config.Aura then
                VirtualUser:CaptureController(); VirtualUser:ClickButton1(Vector2.new(9999, 9999))
                if getgenv().Config.HitSound then HitSound:Play() end
            end
        end)
    end
end)

RunService.Stepped:Connect(function()
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local Hum = LocalPlayer.Character.Humanoid; local HRP = LocalPlayer.Character.HumanoidRootPart
            if getgenv().Config.Speed and Hum.MoveDirection.Magnitude > 0 then
                Hum.WalkSpeed = 16; local ExtraSpeed = (getgenv().Config.WalkSpeed / 16) * 0.45; HRP.CFrame = HRP.CFrame + (Hum.MoveDirection * ExtraSpeed)
            end
            if getgenv().Config.SkyWalk then
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then HRP.Velocity = Vector3.new(HRP.Velocity.X, 35, HRP.Velocity.Z) else HRP.Velocity = Vector3.new(HRP.Velocity.X, -2, HRP.Velocity.Z) end
            end
            if getgenv().Config.NoRagdoll then Hum:SetStateEnabled(0, false); Hum:SetStateEnabled(1, false) end
            if getgenv().Config.AntiVoid and HRP.Position.Y < -50 then HRP.Velocity = Vector3.new(0, 60, 0) end
        end
    end)
end)

UserInputService.JumpRequest:Connect(function() if getgenv().Config.Jump then LocalPlayer.Character.Humanoid:ChangeState("Jumping") end end)
Toggle.MouseButton1Click:Connect(function() PlayClickSound(); Main.Visible = not Main.Visible; SubMenu.Visible = false; SubMenu2.Visible = false end)
Notify("PHUC NGUYEN HUB V10.3 - LOADED!")
