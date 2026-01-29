local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

local ConfigFile = "PhucGodConfig.json"
local isEditMode = false
local LockTarget = nil
local Locking = false

if PlayerGui:FindFirstChild("PhucGod_V26") then PlayerGui.PhucGod_V26:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PhucGod_V26"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999 -- Đảm bảo UI luôn nằm trên cùng
ScreenGui.Parent = PlayerGui

-- ==========================================
-- 1. HÀM LƯU/LOAD (GIỮ NGUYÊN)
-- ==========================================
local function SaveToHardware()
    local Data = {}
    for _, v in pairs(ScreenGui:GetChildren()) do
        if v:IsA("TextButton") and v.Name:find("Key_") then
            Data[v.Name] = {
                X_Scale = v.Position.X.Scale, X_Offset = v.Position.X.Offset,
                Y_Scale = v.Position.Y.Scale, Y_Offset = v.Position.Y.Offset,
                SizeX = v.Size.X.Offset, SizeY = v.Size.Y.Offset
            }
        end
    end
    writefile(ConfigFile, HttpService:JSONEncode(Data))
end

local function LoadFromHardware()
    if not isfile(ConfigFile) then return end
    local Data = HttpService:JSONDecode(readfile(ConfigFile))
    for name, p in pairs(Data) do
        local btn = ScreenGui:FindFirstChild(name)
        if btn then
            btn.Position = UDim2.new(p.X_Scale, p.X_Offset, p.Y_Scale, p.Y_Offset)
            btn.Size = UDim2.new(0, p.SizeX, 0, p.SizeY)
        end
    end
end

-- ==========================================
-- 2. LOGIC LOCK TARGET
-- ==========================================
local function GetClosestPlayer()
    local closest, dist = nil, math.huge
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local d = (v.Character.HumanoidRootPart.Position - Player.Character.HumanoidRootPart.Position).Magnitude
            if d < dist then
                dist = d
                closest = v.Character.HumanoidRootPart
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if Locking and not isEditMode then
        if not LockTarget or not LockTarget.Parent then
            LockTarget = GetClosestPlayer()
        end
        if LockTarget then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, LockTarget.Position)
        end
    end
end)

-- ==========================================
-- 3. HÀM TẠO NÚT
-- ==========================================
local function makeDraggable(obj)
    local dragging, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if isEditMode and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = true
            dragStart = input.Position
            startPos = obj.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and isEditMode then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

local function createKey(name, key, pos, sx, sy)
    local btn = Instance.new("TextButton")
    btn.Name = "Key_" .. name
    btn.Size = UDim2.new(0, sx or 70, 0, sy or 70)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    btn.BackgroundTransparency = 0.5
    btn.Text = name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.Parent = ScreenGui
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    makeDraggable(btn)

    btn.MouseButton1Down:Connect(function()
        if isEditMode then return end
        if name == "LOCK" then
            Locking = not Locking
            LockTarget = Locking and GetClosestPlayer() or nil
            btn.BackgroundColor3 = Locking and Color3.new(1, 0, 0) or Color3.fromRGB(15, 15, 15)
            return
        end
        btn.BackgroundColor3 = Color3.new(1, 1, 1)
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[key], false, game)
    end)
    btn.MouseButton1Up:Connect(function()
        if isEditMode or name == "LOCK" then return end
        btn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        task.wait(0.01)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[key], false, game)
    end)
end

-- ==========================================
-- 4. DÀN PHÍM
-- ==========================================
createKey("ESC", "Escape", UDim2.new(0.01, 0, 0.15, 0), 70, 45)
createKey("TAB", "Tab", UDim2.new(0.01, 0, 0.22, 0), 70, 45)
createKey("F9", "F9", UDim2.new(0.01, 0, 0.29, 0), 70, 45)
createKey("LOCK", "L", UDim2.new(0.01, 0, 0.36, 0), 70, 45)

local wX, wY = 0.05, 0.65
createKey("W", "W", UDim2.new(wX + 0.07, 0, wY - 0.12, 0), 85, 85)
createKey("W2", "W", UDim2.new(wX + 0.15, 0, wY - 0.12, 0), 85, 85)
createKey("A", "A", UDim2.new(wX, 0, wY, 0), 85, 85)
createKey("S", "S", UDim2.new(wX + 0.07, 0, wY, 0), 85, 85)
createKey("D", "D", UDim2.new(wX + 0.14, 0, wY, 0), 85, 85)
createKey("SHFT", "LeftShift", UDim2.new(wX, 0, wY + 0.13, 0), 110, 55)
createKey("CTRL", "LeftControl", UDim2.new(wX + 0.1, 0, wY + 0.13, 0), 110, 55)

local qX, qY = 0.65, 0.45
local keys = {"Q","E","R","T","F","G","Z","X","C"}
for i,k in pairs(keys) do
    local row = math.floor((i-1)/3)
    local col = (i-1)%3
    createKey(k, k, UDim2.new(qX + (col*0.06), 0, qY + (row*0.12), 0), 75, 75)
end
createKey("SPACE", "Space", UDim2.new(0.7, 0, 0.82, 0), 100, 80)

for i=1, 6 do createKey(tostring(i), "Number"..i, UDim2.new(0.28 + (i*0.055), 0, 0.9, 0), 65, 65) end

-- ==========================================
-- 5. THANH MENU (ĐÃ FIX VỊ TRÍ)
-- ==========================================
local TopBar = Instance.new("Frame", ScreenGui)
TopBar.Size = UDim2.new(0.7, 0, 0, 50)
TopBar.Position = UDim2.new(0.15, 0, 0.8, 0) -- Đưa lên trên nút Menu một chút
TopBar.Visible = false
TopBar.BackgroundColor3 = Color3.new(0, 0, 0)
TopBar.BackgroundTransparency = 0.2
TopBar.ZIndex = 10 -- Đảm bảo nằm trên các nút phím
Instance.new("UICorner", TopBar)

local MenuBtn = Instance.new("TextButton", ScreenGui)
MenuBtn.Size = UDim2.new(0, 150, 0, 35)
MenuBtn.Position = UDim2.new(0.42, 0, 0.93, 0) -- Đưa xuống dưới đáy màn hình
MenuBtn.Text = "PHUC FIX V26 ▼"
MenuBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MenuBtn.TextColor3 = Color3.new(1, 1, 1)
MenuBtn.Font = Enum.Font.GothamBold
MenuBtn.ZIndex = 11
Instance.new("UICorner", MenuBtn)

MenuBtn.MouseButton1Click:Connect(function() TopBar.Visible = not TopBar.Visible end)

local function addTool(txt, x, cb)
    local b = Instance.new("TextButton", TopBar)
    b.Size = UDim2.new(0.15, 0, 0.7, 0)
    b.Position = UDim2.new(x, 0, 0.15, 0)
    b.Text = txt
    b.BackgroundColor3 = Color3.fromRGB(50,50,50)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 11
    b.ZIndex = 12
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(cb)
end

addTool("EDIT MODE", 0.02, function() 
    isEditMode = not isEditMode
    TopBar:FindFirstChildOfClass("TextButton").BackgroundColor3 = isEditMode and Color3.new(0.5,0,0) or Color3.fromRGB(50,50,50)
end)
addTool("SAVE ALL", 0.18, function() SaveToHardware() end)
addTool("LOAD ALL", 0.34, function() LoadFromHardware() end)
addTool("PHUC HUB", 0.50, function() 
    loadstring(game:HttpGet("https://raw.githubusercontent.com/phucnguyen987/phucnguyen-hub/refs/heads/main/Menu.lua"))() 
end)
addTool("ẨN GỐC", 0.66, function() 
    local tg = PlayerGui:FindFirstChild("TouchGui")
    if tg then tg.Enabled = not tg.Enabled end
end)
addTool("XÓA SCRIPT", 0.82, function() ScreenGui:Destroy() end)

task.wait(0.5)
LoadFromHardware()
