-- [[ PHUC NGUYEN X HUB - V11.0 VIP - PHẦN 1 ]] --

local CurrentVersion = 11.0
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
    FakeVip = false,
    VipTag = "[VIP PHUC]",
    VipColor = Color3.new(1, 1, 0),
    SpinBot = false,
    SpinSpeed = 50
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

local Title = Instance.new("TextLabel", Main); Title.Size = UDim2.new(1, 0, 0, 30); Title.Text = "PHUC NGUYEN X HUB V11"; Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.BackgroundTransparency = 1; Title.Font = Enum.Font.SourceSansBold; Title.TextSize = 18

local Container = Instance.new("ScrollingFrame", Main); Container.Size = UDim2.new(1, -10, 1, -40); Container.Position = UDim2.new(0, 5, 0, 35)
Container.BackgroundTransparency = 1; Container.ScrollBarThickness = 2; Container.AutomaticCanvasSize = Enum.AutomaticSize.Y
local UIList = Instance.new("UIListLayout", Container); UIList.Padding = UDim.new(0, 5)

-- [[ NÚT MUA x1 BĂNG GẠC - ĐẦU MENU ]] --
local BuyBtnX1 = Instance.new("TextButton", Container)
BuyBtnX1.Size = UDim2.new(1, 0, 0, 40)
BuyBtnX1.BackgroundColor3 = Color3.fromRGB(0, 170, 127)
BuyBtnX1.Text = "🛒 MUA x1 BĂNG GẠC (CLICK)"; BuyBtnX1.TextColor3 = Color3.new(1, 1, 1)
BuyBtnX1.Font = "FredokaOne"; BuyBtnX1.TextSize = 16
Instance.new("UICorner", BuyBtnX1)
MakeRainbowStroke(BuyBtnX1, 1.5)

BuyBtnX1.MouseButton1Click:Connect(function()
    PlayClickSound()
    local args = { "b\196\131ng g\225\186\161c", 1 }
    game:GetService("ReplicatedStorage"):WaitForChild("KnitPackages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.7.0"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("ShopService"):WaitForChild("RE"):WaitForChild("buyItem"):FireServer(unpack(args))
    Notify("Đã mua x1 Băng Gạc!")
end)

local SpecialMenu = Instance.new("Frame", ScreenGui); SpecialMenu.Size = UDim2.new(0, 260, 0, 340); SpecialMenu.Position = UDim2.new(0.5, 150, 0.5, -170); SpecialMenu.BackgroundColor3 = Color3.fromRGB(25, 20, 20); SpecialMenu.Visible = false; Instance.new("UICorner", SpecialMenu); MakeRainbowStroke(SpecialMenu, 2)
local SpecTitle = Instance.new("TextLabel", SpecialMenu); SpecTitle.Size = UDim2.new(1, 0, 0, 35); SpecTitle.Text = "VIETNAM SPECIAL"; SpecTitle.TextColor3 = Color3.new(1, 0.8, 0); SpecTitle.BackgroundTransparency = 1; SpecTitle.Font = "FredokaOne"
local SpecContainer = Instance.new("ScrollingFrame", SpecialMenu); SpecContainer.Size = UDim2.new(1, -10, 1, -45); SpecContainer.Position = UDim2.new(0, 5, 0, 40); SpecContainer.BackgroundTransparency = 1; SpecContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y; Instance.new("UIListLayout", SpecContainer).Padding = UDim.new(0, 5)

local SubMenu = Instance.new("Frame", ScreenGui); SubMenu.Size = UDim2.new(0, 300, 0, 260); SubMenu.Position = UDim2.new(0.5, 150, 0.5, -130); SubMenu.BackgroundColor3 = Color3.fromRGB(25, 25, 25); SubMenu.Visible = false; Instance.new("UICorner", SubMenu); MakeRainbowStroke(SubMenu, 2) 
local SubMenu2 = Instance.new("Frame", ScreenGui); SubMenu2.Size = UDim2.new(0, 250, 0, 200); SubMenu2.Position = UDim2.new(0.5, -420, 0.5, -100); SubMenu2.BackgroundColor3 = Color3.fromRGB(30, 30, 35); SubMenu2.Visible = false; Instance.new("UICorner", SubMenu2); MakeRainbowStroke(SubMenu2, 2) 

EnableDragging(Toggle); EnableDragging(Main); EnableDragging(SubMenu); EnableDragging(SubMenu2); EnableDragging(SpecialMenu)
-- [[ PHUC NGUYEN X HUB - FINAL V11.0 - PHẦN 2 ]] --

local AnimBtn = Instance.new("TextButton", SubMenu2); AnimBtn.Size = UDim2.new(0.8, 0, 0, 40); AnimBtn.Position = UDim2.new(0.1, 0, 0.25, 0); AnimBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60); AnimBtn.Text = "ANIMATION (Mới)"; AnimBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", AnimBtn)
AnimBtn.MouseButton1Click:Connect(function() PlayClickSound(); loadstring(game:HttpGet("https://raw.githubusercontent.com/phucnguyen987/phucnguyen-hub/refs/heads/main/Animation.lua"))() end)

local CmdBtn = Instance.new("TextButton", SubMenu2); CmdBtn.Size = UDim2.new(0.8, 0, 0, 40); CmdBtn.Position = UDim2.new(0.1, 0, 0.5, 0); CmdBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60); CmdBtn.Text = "COMMAND (Infinite Yield)"; CmdBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", CmdBtn)
CmdBtn.MouseButton1Click:Connect(function() PlayClickSound(); loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end)

local ToolsBtn = Instance.new("TextButton", Container); ToolsBtn.Size = UDim2.new(1, 0, 0, 35); ToolsBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 150); ToolsBtn.Text = ">>> MỞ TOOLS MENU <<<"; ToolsBtn.TextColor3 = Color3.new(1,1,1); ToolsBtn.Font = Enum.Font.FredokaOne
ToolsBtn.MouseButton1Click:Connect(function() PlayClickSound(); if Main.Visible then SubMenu2.Visible = not SubMenu2.Visible; SubMenu.Visible = false; SpecialMenu.Visible = false end end)

local VietnamBtn = Instance.new("TextButton", Container); VietnamBtn.Size = UDim2.new(1, 0, 0, 35); VietnamBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0); VietnamBtn.Text = "🌟 VIETNAM SPECIAL 🌟"; VietnamBtn.TextColor3 = Color3.new(1,1,1); VietnamBtn.Font = Enum.Font.FredokaOne
VietnamBtn.MouseButton1Click:Connect(function() PlayClickSound(); if Main.Visible then SpecialMenu.Visible = not SpecialMenu.Visible; SubMenu.Visible = false; SubMenu2.Visible = false end end)

-- [ SPIN BOT MƯỢT ] --
local SpinAngle = 0
RunService.Stepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local HRP = LocalPlayer.Character.HumanoidRootPart
        if getgenv().Config.SpinBot then
            SpinAngle = (SpinAngle + getgenv().Config.SpinSpeed) % 360
            HRP.CFrame = CFrame.new(HRP.Position) * CFrame.Angles(0, math.rad(SpinAngle), 0)
        end
        if getgenv().Config.SkyWalk then
            local Part = workspace:FindFirstChild("SkyPart") or Instance.new("Part", workspace)
            Part.Name = "SkyPart"; Part.Size = Vector3.new(6, 0.5, 6); Part.Anchored = true; Part.Transparency = 1; Part.CFrame = HRP.CFrame * CFrame.new(0, -3.2, 0)
        elseif workspace:FindFirstChild("SkyPart") then workspace.SkyPart:Destroy() end
    end
end)

-- [ REAL HITBOX LOGIC - 100% REAL ] --
RunService.RenderStepped:Connect(function()
    if getgenv().Config.Hitbox then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and not getgenv().Whitelist[v.Name] and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local HRP = v.Character.HumanoidRootPart
                -- Tăng kích thước thật và đảm bảo va chạm được Server ghi nhận
                HRP.Size = Vector3.new(getgenv().Config.Size, getgenv().Config.Size, getgenv().Config.Size)
                HRP.Transparency = getgenv().Config.Trans / 10
                HRP.BrickColor = BrickColor.new("Really red")
                HRP.Material = Enum.Material.Neon
                HRP.CanCollide = false
                HRP.Massless = true -- Giúp đối thủ không bị văng (No Fling)
            end
        end
    else
        -- Reset Hitbox về mặc định khi tắt
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                v.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
                v.Character.HumanoidRootPart.Transparency = 1
            end
        end
    end
end)

function AddToggle(Text, Flag)
    local Btn = Instance.new("TextButton", Container); Btn.Size = UDim2.new(1, 0, 0, 35); Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Btn.Text = "  " .. Text .. " [OFF]"; Btn.TextColor3 = Color3.fromRGB(150, 150, 150); Btn.TextXAlignment = "Left"; Btn.Font = Enum.Font.SourceSansBold; Instance.new("UICorner", Btn)
    Btn.MouseButton1Click:Connect(function()
        PlayClickSound(); getgenv().Config[Flag] = not getgenv().Config[Flag]
        Btn.Text = "  " .. Text .. " [" .. (getgenv().Config[Flag] and "ON" or "OFF") .. "]"; Btn.TextColor3 = getgenv().Config[Flag] and Color3.new(0,1,0) or Color3.fromRGB(150,150,150)
    end)
end

function AddSlider(Text, Flag, Min, Max)
    local F = Instance.new("Frame", Container); F.Size = UDim2.new(1, 0, 0, 45); F.BackgroundTransparency = 1
    local L = Instance.new("TextLabel", F); L.Size = UDim2.new(1, 0, 0, 20); L.Text = Text .. ": " .. getgenv().Config[Flag]; L.TextColor3 = Color3.new(1,1,1); L.BackgroundTransparency = 1
    local B = Instance.new("TextButton", F); B.Size = UDim2.new(0.9, 0, 0, 8); B.Position = UDim2.new(0.05, 0, 0.6, 0); B.BackgroundColor3 = Color3.new(0,0,0); B.Text = ""
    local Fill = Instance.new("Frame", B); Fill.Size = UDim2.new(0,0,1,0); Fill.BackgroundColor3 = Color3.new(1,0,0)
    B.MouseButton1Down:Connect(function()
        local M = LocalPlayer:GetMouse(); local C; C = RunService.RenderStepped:Connect(function()
            if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then C:Disconnect() return end
            local P = math.clamp((M.X - B.AbsolutePosition.X) / B.AbsoluteSize.X, 0, 1); local V = math.floor(Min + (Max - Min) * P); getgenv().Config[Flag] = V; L.Text = Text .. ": " .. V; Fill.Size = UDim2.new(P, 0, 1, 0)
        end)
    end)
end

AddToggle("Real Hitbox (100% TRÚNG)", "Hitbox")
AddSlider("Kích Thước Hitbox", "Size", 2, 100)
AddSlider("Độ Mờ Hitbox", "Trans", 0, 10) 
AddToggle("Hit Sound", "HitSound")
AddToggle("Sky Walk", "SkyWalk") 
AddToggle("Auto Attack (Aura)", "Aura")
AddToggle("Speed Bypass", "Speed") 
AddSlider("Tốc Độ", "WalkSpeed", 16, 300)
AddToggle("Nhảy Vô Hạn", "Jump")
AddToggle("Anti-Void", "AntiVoid")
AddToggle("Anti-Ragdoll", "NoRagdoll")

-- [ LOGIC SPEED & OTHERS ] --
RunService.Stepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local Hum = LocalPlayer.Character.Humanoid
        local HRP = LocalPlayer.Character.HumanoidRootPart
        if getgenv().Config.Speed and Hum.MoveDirection.Magnitude > 0 then
            Hum.WalkSpeed = 16
            HRP.CFrame = HRP.CFrame + (Hum.MoveDirection * (getgenv().Config.WalkSpeed - 16) * 0.02)
        end
        if getgenv().Config.NoRagdoll then Hum:SetStateEnabled(0, false); Hum:SetStateEnabled(1, false) end
    end
end)

UserInputService.JumpRequest:Connect(function() if getgenv().Config.Jump then LocalPlayer.Character.Humanoid:ChangeState("Jumping") end end)
Toggle.MouseButton1Click:Connect(function() PlayClickSound(); Main.Visible = not Main.Visible end)
Notify("PHUC NGUYEN HUB V11.0 VIP LOADED!")
