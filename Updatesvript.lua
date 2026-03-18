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
    HitSound = true, SkyWalk = false, FlySpeed = 20,
    Spin = false, SpinSpeed = 50
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

local SubMenu = Instance.new("Frame", ScreenGui)
SubMenu.Size = UDim2.new(0, 300, 0, 260); SubMenu.Position = UDim2.new(0.5, 150, 0.5, -130)
SubMenu.BackgroundColor3 = Color3.fromRGB(25, 25, 25); SubMenu.Visible = false
Instance.new("UICorner", SubMenu); MakeRainbowStroke(SubMenu, 2) 

local SubMenu2 = Instance.new("Frame", ScreenGui); SubMenu2.Size = UDim2.new(0, 250, 0, 200); SubMenu2.Position = UDim2.new(0.5, -420, 0.5, -100); SubMenu2.BackgroundColor3 = Color3.fromRGB(30, 30, 35); SubMenu2.Visible = false
Instance.new("UICorner", SubMenu2); MakeRainbowStroke(SubMenu2, 2) 

-- [[ MENU XOAY 360 MỚI ]] --
local SubMenu3 = Instance.new("Frame", ScreenGui); SubMenu3.Size = UDim2.new(0, 250, 0, 150); SubMenu3.Position = UDim2.new(0.5, -125, 0.5, 180); SubMenu3.BackgroundColor3 = Color3.fromRGB(20, 25, 30); SubMenu3.Visible = false
Instance.new("UICorner", SubMenu3); MakeRainbowStroke(SubMenu3, 2.5)
local SubTitle3 = Instance.new("TextLabel", SubMenu3); SubTitle3.Size = UDim2.new(1, 0, 0, 30); SubTitle3.Text = "360° SPIN MENU"; SubTitle3.TextColor3 = Color3.fromRGB(255, 255, 0); SubTitle3.BackgroundTransparency = 1; SubTitle3.Font = Enum.Font.FredokaOne
local CloseSub3 = Instance.new("TextButton", SubMenu3); CloseSub3.Size = UDim2.new(0, 30, 0, 30); CloseSub3.Position = UDim2.new(1, -30, 0, 0); CloseSub3.Text = "X"; CloseSub3.TextColor3 = Color3.fromRGB(255,0,0); CloseSub3.BackgroundTransparency = 1; CloseSub3.Font = Enum.Font.FredokaOne
CloseSub3.MouseButton1Click:Connect(function() PlayClickSound(); SubMenu3.Visible = false end)

local SpinContainer = Instance.new("Frame", SubMenu3); SpinContainer.Size = UDim2.new(1, -10, 1, -40); SpinContainer.Position = UDim2.new(0, 5, 0, 35); SpinContainer.BackgroundTransparency = 1
local SpinList = Instance.new("UIListLayout", SpinContainer); SpinList.Padding = UDim.new(0, 5)

EnableDragging(Toggle); EnableDragging(Main); EnableDragging(SubMenu); EnableDragging(SubMenu2); EnableDragging(SubMenu3)
-- [[ TIẾP TỤC CÁC NÚT VÀ LOGIC ]] --
local function AddSpinToggle(Text, Flag)
    local Btn = Instance.new("TextButton", SpinContainer); Btn.Size = UDim2.new(1, 0, 0, 35); Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Btn.Text = Text .. " [OFF]"; Btn.TextColor3 = Color3.new(1,1,1); Btn.Font = Enum.Font.SourceSansBold; Instance.new("UICorner", Btn)
    Btn.MouseButton1Click:Connect(function()
        PlayClickSound(); getgenv().Config[Flag] = not getgenv().Config[Flag]
        Btn.Text = Text .. " [" .. (getgenv().Config[Flag] and "ON" or "OFF") .. "]"; Btn.TextColor3 = getgenv().Config[Flag] and Color3.new(0,1,0) or Color3.new(1,1,1)
    end)
end

local function AddSpinSlider(Text, Flag, Min, Max)
    local F = Instance.new("Frame", SpinContainer); F.Size = UDim2.new(1, 0, 0, 45); F.BackgroundTransparency = 1
    local L = Instance.new("TextLabel", F); L.Size = UDim2.new(1, 0, 0, 20); L.Text = Text .. ": " .. getgenv().Config[Flag]; L.TextColor3 = Color3.new(1,1,1); L.BackgroundTransparency = 1
    local B = Instance.new("TextButton", F); B.Size = UDim2.new(0.9, 0, 0, 8); B.Position = UDim2.new(0.05, 0, 0.6, 0); B.BackgroundColor3 = Color3.new(0,0,0); B.Text = ""
    local Fill = Instance.new("Frame", B); Fill.Size = UDim2.new(getgenv().Config[Flag]/Max,0,1,0); Fill.BackgroundColor3 = Color3.new(1,1,0)
    B.MouseButton1Down:Connect(function()
        local M = LocalPlayer:GetMouse(); local C; C = RunService.RenderStepped:Connect(function()
            if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then C:Disconnect() return end
            local P = math.clamp((M.X - B.AbsolutePosition.X) / B.AbsoluteSize.X, 0, 1); local V = math.floor(Min + (Max - Min) * P); getgenv().Config[Flag] = V; L.Text = Text .. ": " .. V; Fill.Size = UDim2.new(P, 0, 1, 0)
        end)
    end)
end

AddSpinToggle("Bật Xoay 360°", "Spin")
AddSpinSlider("Tốc Độ Xoay", "SpinSpeed", 0, 100)

local BuyX30Btn = Instance.new("TextButton", Container); BuyX30Btn.Size = UDim2.new(1, 0, 0, 35); BuyX30Btn.BackgroundColor3 = Color3.fromRGB(255, 100, 0); BuyX30Btn.Text = "⚡ MUA X30 BĂNG GẠC ⚡"; BuyX30Btn.TextColor3 = Color3.new(1,1,1); BuyX30Btn.Font = Enum.Font.FredokaOne
BuyX30Btn.MouseButton1Click:Connect(function()
    PlayClickSound()
    local args = {"b\196\131ng g\225\186\161c", 30}
    pcall(function() game:GetService("ReplicatedStorage"):WaitForChild("KnitPackages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.7.0"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("ShopService"):WaitForChild("RE"):WaitForChild("buyItem"):FireServer(unpack(args)) end)
    Notify("Đã thực thi mua X30!")
end)

local OpenSpinBtn = Instance.new("TextButton", Container); OpenSpinBtn.Size = UDim2.new(1, 0, 0, 35); OpenSpinBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 255); OpenSpinBtn.Text = "🌀 MỞ SPIN 360 MENU 🌀"; OpenSpinBtn.TextColor3 = Color3.new(1,1,1); OpenSpinBtn.Font = Enum.Font.FredokaOne
OpenSpinBtn.MouseButton1Click:Connect(function() PlayClickSound(); SubMenu3.Visible = not SubMenu3.Visible end)

AddToggle("Speed Bypass (Tốc Độ 500)", "Speed") 
AddSlider("Chỉnh WalkSpeed", "WalkSpeed", 16, 500)
AddToggle("Hitbox (No Fling)", "Hitbox")
AddSlider("Kích Thước Hitbox", "Size", 2, 100)
AddToggle("Attack Aura", "Aura")
AddToggle("Sky Walk (Bay)", "SkyWalk")
AddToggle("Anti-Void", "AntiVoid")

-- [[ HỆ THỐNG LOGIC CHÍNH ]] --
local SpinAngle = 0
RunService.Stepped:Connect(function()
    pcall(function()
        local Char = LocalPlayer.Character
        local Hum = Char and Char:FindFirstChild("Humanoid")
        local HRP = Char and Char:FindFirstChild("HumanoidRootPart")
        
        if HRP and Hum then
            -- Bypass Speed 500 Cực Nhanh
            if getgenv().Config.Speed and Hum.MoveDirection.Magnitude > 0 then
                local SpeedMult = (getgenv().Config.WalkSpeed / 16) * 0.45
                HRP.CFrame = HRP.CFrame + (Hum.MoveDirection * SpeedMult)
            end
            
            -- Xoay 360 Mượt (Người khác thấy)
            if getgenv().Config.Spin then
                SpinAngle = SpinAngle + (getgenv().Config.SpinSpeed / 10)
                HRP.CFrame = HRP.CFrame * CFrame.Angles(0, math.rad(SpinAngle), 0)
            end
            
            -- Skywalk Logic
            if getgenv().Config.SkyWalk then
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    HRP.Velocity = Vector3.new(HRP.Velocity.X, 40, HRP.Velocity.Z)
                else
                    HRP.Velocity = Vector3.new(HRP.Velocity.X, -1, HRP.Velocity.Z)
                end
            end
            
            if getgenv().Config.AntiVoid and HRP.Position.Y < -50 then HRP.CFrame = CFrame.new(HRP.Position.X, 50, HRP.Position.Z) end
        end
    end)
end)

-- Logic Hitbox & Aura
spawn(function()
    while task.wait(0.1) do
        if getgenv().Config.Hitbox then
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local targetHRP = v.Character.HumanoidRootPart
                    targetHRP.Size = Vector3.new(getgenv().Config.Size, getgenv().Config.Size, getgenv().Config.Size)
                    targetHRP.Transparency = 0.7; targetHRP.CanCollide = false
                end
            end
        end
        if getgenv().Config.Aura then
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    if (LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude < 25 then
                        VirtualUser:CaptureController(); VirtualUser:ClickButton1(Vector2.new(0,0))
                    end
                end
            end
        end
    end
end)

Notify("PHUC NGUYEN V10.3 - SPIN 360 & SPEED 500 LOADED!")
