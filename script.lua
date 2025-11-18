--========================================================--
--== INTRO FADE ==========================================--
--========================================================--

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")

StarterGui:SetCore("ResetButtonCallback", false)

local introGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
introGui.IgnoreGuiInset = true
introGui.ResetOnSpawn = false

local introFrame = Instance.new("Frame", introGui)
introFrame.Size = UDim2.new(1,0,1,0)
introFrame.BackgroundColor3 = Color3.new(0,0,0)

local introText = Instance.new("TextLabel", introFrame)
introText.Size = UDim2.new(1,0,1,0)
introText.BackgroundTransparency = 1
introText.Text = "SCRIPT BY PHUCNGUYEN"
introText.TextColor3 = Color3.new(1,1,1)
introText.TextSize = 45
introText.Font = Enum.Font.GothamBold
introText.TextTransparency = 1

for i = 1, 20 do
	introText.TextTransparency = 1 - i/20
	task.wait(0.05)
end

task.wait(1.5)

for i = 1, 20 do
	introFrame.BackgroundTransparency = i/20
	introText.TextTransparency = i/20
	task.wait(0.05)
end

introGui:Destroy()


--========================================================--
--== KEY SYSTEM ==========================================--
--========================================================--

local correctKey = "phucvip"

local KeyGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
KeyGui.IgnoreGuiInset = true
KeyGui.ResetOnSpawn = false

local KeyFrame = Instance.new("Frame", KeyGui)
KeyFrame.Size = UDim2.new(0,400,0,260)
KeyFrame.Position = UDim2.new(0.35,0,0.28,0)
KeyFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0,12)

local title = Instance.new("TextLabel", KeyFrame)
title.Text = "NHẬP KEY"
title.Size = UDim2.new(1,0,0,50)
title.Font = Enum.Font.GothamBold
title.TextSize = 30
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1

local KeyBox = Instance.new("TextBox", KeyFrame)
KeyBox.Size = UDim2.new(1,-40,0,50)
KeyBox.Position = UDim2.new(0,20,0,70)
KeyBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
KeyBox.PlaceholderText = "Nhập key..."
KeyBox.TextColor3 = Color3.new(1,1,1)
KeyBox.TextSize = 20
KeyBox.Font = Enum.Font.Gotham
Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0,10)

local Confirm = Instance.new("TextButton", KeyFrame)
Confirm.Size = UDim2.new(1,-40,0,50)
Confirm.Position = UDim2.new(0,20,0,135)
Confirm.BackgroundColor3 = Color3.fromRGB(70,70,70)
Confirm.Text = "Xác nhận"
Confirm.TextColor3 = Color3.new(1,1,1)
Confirm.Font = Enum.Font.GothamBold
Confirm.TextSize = 22
Instance.new("UICorner", Confirm).CornerRadius = UDim.new(0,10)

local GetKey = Instance.new("TextButton", KeyFrame)
GetKey.Size = UDim2.new(1,-40,0,50)
GetKey.Position = UDim2.new(0,20,0,195)
GetKey.BackgroundColor3 = Color3.fromRGB(70,70,70)
GetKey.Text = "GET KEY"
GetKey.TextColor3 = Color3.new(1,1,1)
GetKey.Font = Enum.Font.GothamBold
GetKey.TextSize = 22
Instance.new("UICorner", GetKey).CornerRadius = UDim.new(0,10)

local Notify = Instance.new("TextLabel", KeyFrame)
Notify.Size = UDim2.new(1,0,0,40)
Notify.Position = UDim2.new(0,0,0,-35)
Notify.BackgroundTransparency = 1
Notify.Font = Enum.Font.GothamBold
Notify.TextSize = 22
Notify.TextColor3 = Color3.new(1,1,1)
Notify.TextTransparency = 1

local function Show(msg,color)
	Notify.Text = msg
	Notify.TextColor3 = color
	Notify.TextTransparency = 0
	task.wait(2)
	for i = 0,1,0.05 do
		Notify.TextTransparency = i
		task.wait(0.04)
	end
end

GetKey.MouseButton1Click:Connect(function()
	setclipboard("https://pastefy.app/9NTEAOOX")
	Show("Đã sao chép link GetKey!", Color3.fromRGB(0,255,255))
end)

local KeyValidated = false

Confirm.MouseButton1Click:Connect(function()
	if KeyBox.Text == correctKey then
		KeyValidated = true
		Show("Success", Color3.fromRGB(0,255,0))
		task.wait(1)
		KeyGui:Destroy()
	else
		Show("Sai Key!", Color3.fromRGB(255,0,0))
	end
end)

repeat task.wait() until KeyValidated == true


--========================================================--
--== MAIN UI =============================================--
--========================================================--

local MainGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
MainGui.IgnoreGuiInset = true
MainGui.ResetOnSpawn = false
MainGui.Enabled = true

local MainFrame = Instance.new("Frame", MainGui)
MainFrame.Size = UDim2.new(0,460,0,320)
MainFrame.Position = UDim2.new(0.32,0,0.25,0)
MainFrame.BackgroundColor3 = Color3.fromRGB(35,35,35)
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,12)

local UIS = game:GetService("UserInputService")

-- DRAGGING FIXED
local dragging = false
local dragStart, startPos

MainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position
	end
end)

MainFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
		local delta = input.Position - dragStart
		MainFrame.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end
end)

MainFrame.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

-- Toggle UI
local ToggleBtn = Instance.new("TextButton", MainGui)
ToggleBtn.Size = UDim2.new(0,40,0,40)
ToggleBtn.Position = UDim2.new(0.92,0,0.15,0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
ToggleBtn.Text = "⚙"
ToggleBtn.TextColor3 = Color3.new(1,1,1)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 24
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1,0)

ToggleBtn.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible
end)


--========================================================--
--== TABS =================================================--
--========================================================--

local Tabs = Instance.new("Frame", MainFrame)
Tabs.Size = UDim2.new(1,0,0,45)
Tabs.BackgroundTransparency = 1

local function CreateTab(name,x)
	local btn = Instance.new("TextButton", Tabs)
	btn.Size = UDim2.new(0,150,0,40)
	btn.Position = UDim2.new(0,x,0,0)
	btn.Text = name
	btn.Font = Enum.Font.GothamBold
	btn.TextColor3 = Color3.new(1,1,1)
	btn.TextSize = 20
	btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)
	return btn
end

local TabHome = CreateTab("Home",10)
local TabSettings = CreateTab("Settings",160)


--========================================================--
--== CONTENT FRAMES ======================================--
--========================================================--

local HomeFrame = Instance.new("Frame", MainFrame)
HomeFrame.Size = UDim2.new(1,-20,1,-60)
HomeFrame.Position = UDim2.new(0,10,0,50)
HomeFrame.BackgroundTransparency = 1

local SettingsFrame = HomeFrame:Clone()
SettingsFrame.Parent = MainFrame
SettingsFrame.Visible = false

TabHome.MouseButton1Click:Connect(function()
	HomeFrame.Visible = true
	SettingsFrame.Visible = false
end)

TabSettings.MouseButton1Click:Connect(function()
	HomeFrame.Visible = false
	SettingsFrame.Visible = true
end)


-- BUTTON CREATOR
local function MakeBtn(parent,text,y)
	local b = Instance.new("TextButton", parent)
	b.Size = UDim2.new(1,-20,0,45)
	b.Position = UDim2.new(0,10,0,y)
	b.BackgroundColor3 = Color3.fromRGB(65,65,65)
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextSize = 22
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
	return b
end


--========================================================--
--== HOME TAB FEATURES ===================================--
--========================================================--

local BtnJump = MakeBtn(HomeFrame,"Nhảy vô hạn",0)
local BtnSpeed = MakeBtn(HomeFrame,"Chỉnh tốc độ chạy",55)
local BtnTP = MakeBtn(HomeFrame,"Teleport Tool",110)
local BtnNoclip = MakeBtn(HomeFrame,"Noclip",165)


-- Infinite Jump
UIS.JumpRequest:Connect(function()
	if LocalPlayer.Character then
		LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
	end
end)

-- Speed UI
BtnSpeed.MouseButton1Click:Connect(function()

	local popup = Instance.new("Frame", MainGui)
	popup.Size = UDim2.new(0,250,0,150)
	popup.Position = UDim2.new(0.38,0,0.35,0)
	popup.BackgroundColor3 = Color3.fromRGB(40,40,40)
	Instance.new("UICorner", popup).CornerRadius = UDim.new(0,10)

	local input = Instance.new("TextBox", popup)
	input.Size = UDim2.new(1,-20,0,40)
	input.Position = UDim2.new(0,10,0,50)
	input.BackgroundColor3 = Color3.fromRGB(60,60,60)
	input.PlaceholderText = "Nhập tốc độ..."
	input.Font = Enum.Font.GothamBold
	input.TextSize = 20
	input.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", input).CornerRadius = UDim.new(0,8)

	local apply = Instance.new("TextButton", popup)
	apply.Size = UDim2.new(1,-20,0,40)
	apply.Position = UDim2.new(0,10,0,100)
	apply.BackgroundColor3 = Color3.fromRGB(90,90,90)
	apply.Text = "Áp dụng"
	apply.TextColor3 = Color3.new(1,1,1)
	apply.Font = Enum.Font.GothamBold
	apply.TextSize = 20
	Instance.new("UICorner", apply).CornerRadius = UDim.new(0,8)

	apply.MouseButton1Click:Connect(function()
		local spd = tonumber(input.Text)
		if spd and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
			LocalPlayer.Character.Humanoid.WalkSpeed = spd
		end
		popup:Destroy()
	end)
end)

-- Noclip
local noclip = false
BtnNoclip.MouseButton1Click:Connect(function()
	noclip = not noclip
end)

game:GetService("RunService").Stepped:Connect(function()
	if noclip and LocalPlayer.Character then
		for _,v in pairs(LocalPlayer.Character:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end
end)

-- Teleport Tool
BtnTP.MouseButton1Click:Connect(function()
	local tool = Instance.new("Tool")
	tool.RequiresHandle = false
	tool.Name = "TP Tool"

	tool.Activated:Connect(function()
		local mouse = LocalPlayer:GetMouse()
		if mouse and mouse.Hit then
			LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position)
		end
	end)

	tool.Parent = LocalPlayer.Backpack
end)


--========================================================--
--== SETTINGS TAB (ESP USING HIGHLIGHT) ==================--
--========================================================--

local BtnESP = MakeBtn(SettingsFrame,"ESP Người chơi",0)

local espEnabled = false
local highlights = {}

BtnESP.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	if not espEnabled then
		for _,h in pairs(highlights) do h:Destroy() end
		highlights = {}
	end
end)

Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function(char)
		if espEnabled then
			local h = Instance.new("Highlight")
			h.FillTransparency = 1
			h.OutlineColor = Color3.fromRGB(0,255,0)
			h.Parent = char
			highlights[plr] = h
		end
	end)
end)
