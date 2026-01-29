-- [[ SCRIPT BY PHUC.LUA - SLAP DUELS REMASTERED V3 - FAST TP & TIMER ]]

if _G.EatHub then _G.EatHub:Destroy() end

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/liebertsx/Tora-Library/main/src/librarynew", true))()
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local Running, bypassSpeed, infJumpEnabled = false, 16, false

-- ==========================================
-- HÀM HỖ TRỢ
-- ==========================================
local function SafeTP(targetCFrame)
    local char = lp.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        root.Velocity = Vector3.new(0,0,0)
        root.CFrame = targetCFrame + Vector3.new(0, 3, 0)
    end
end

local function CreateESP(plr)
    if plr == lp then return end
    local head = plr.Character and plr.Character:FindFirstChild("Head")
    if head and not head:FindFirstChild("ESPIcon") then
        local billboard = Instance.new("BillboardGui", head)
        billboard.Name = "ESPIcon"
        billboard.Size = UDim2.new(4.5, 0, 4.5, 0) 
        billboard.AlwaysOnTop = true
        billboard.ExtentsOffset = Vector3.new(0, 5, 0) 
        local image = Instance.new("ImageLabel", billboard)
        image.Size, image.BackgroundTransparency = UDim2.new(1, 0, 1, 0), 1
        image.Image = "rbxthumb://type=AvatarHeadShot&id="..plr.UserId.."&w=420&h=420"
        Instance.new("UICorner", image).CornerRadius = UDim.new(1, 0)
        local stroke = Instance.new("UIStroke", image)
        stroke.Thickness, stroke.Color = 2.5, Color3.fromRGB(255, 255, 255)
    end
end

-- ==========================================
-- BỘ ĐẾM THỜI GIAN (TIMER UI)
-- ==========================================
if game.CoreGui:FindFirstChild("PhucLuaTimer") then game.CoreGui.PhucLuaTimer:Destroy() end
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "PhucLuaTimer"
ScreenGui.Enabled = false

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 130, 0, 45)
Frame.Position = UDim2.new(0.5, -65, 0.05, 0)
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BackgroundTransparency = 0.4
Frame.Active, Frame.Draggable = true, true
Instance.new("UICorner", Frame)

local TimerText = Instance.new("TextLabel", Frame)
TimerText.Size = UDim2.new(1, 0, 1, 0)
TimerText.BackgroundTransparency = 1
TimerText.TextColor3 = Color3.fromRGB(0, 255, 255)
TimerText.TextSize = 18
TimerText.Font = Enum.Font.GothamBold
TimerText.Text = "Wait: 0s"

-- ==========================================
-- GIAO DIỆN CHÍNH
-- ==========================================
local MainWin = library:CreateWindow("SLAP DUELS")

MainWin:AddToggle({ text = "Auto Win", callback = function(v) Running = v end })

MainWin:AddList({
    text = "TP Lobby",
    values = {"1v1", "2v2", "3v3", "4v4"},
    callback = function(v)
        local t = nil
        if v == "1v1" then t = workspace.Lobby.PadSets["1v1_Set2"].Team2Pad
        elseif v == "2v2" then t = workspace.Lobby.PadSets["2v2_Set2"].Team1Pad
        elseif v == "3v3" then t = workspace.Lobby.PadSets["3v3_Set2"].Team1Pad
        elseif v == "4v4" then t = workspace.Lobby.PadSets["4v4_Set2"].Team1Pad end
        if t then SafeTP(t.CFrame) end
    end
})

MainWin:AddList({ text = "TP Area", values = {"Shop", "Power"}, callback = function(v)
    if v == "Shop" then SafeTP(workspace.Pads.Crates.CFrame)
    elseif v == "Power" then SafeTP(workspace.Pads.Powers.CFrame) end
end})

MainWin:AddBox({ text = "Speed", value = "16", callback = function(v) bypassSpeed = tonumber(v) or 16 end })
MainWin:AddToggle({ text = "Inf Jump", callback = function(v) infJumpEnabled = v end })
MainWin:AddToggle({ text = "ESP Icon", callback = function(v) 
    _G.ESP = v 
    if not v then
        for _, p in pairs(Players:GetPlayers()) do
            pcall(function() if p.Character.Head:FindFirstChild("ESPIcon") then p.Character.Head.ESPIcon:Destroy() end end)
        end
    end
end})

MainWin:AddLabel({ text = "By: Phuc.Lua" })

-- ==========================================
-- HỆ THỐNG TP SIÊU TỐC (FAST TP)
-- ==========================================
task.spawn(function()
    while true do
        task.wait(0.1)
        if Running then
            local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
            if root then
                -- Tìm cặp vạch gần nhất
                local startPart, endPart = nil, nil
                for _, v in pairs(workspace:GetDescendants()) do
                    if v.Name == "StartPart" and (v.Position - root.Position).Magnitude < 250 then
                        startPart = v
                        endPart = v.Parent:FindFirstChild("EndPart")
                        if startPart and endPart then break end
                    end
                end

                if startPart and endPart then
                    ScreenGui.Enabled = true
                    TimerText.Text = "FAST WINNING..."
                    
                    -- TP qua lại liên tục với tốc độ cao (0.5s)
                    while Running and startPart and endPart and startPart.Parent == endPart.Parent do
                        SafeTP(startPart.CFrame)
                        task.wait(0.5) -- TỐC ĐỘ SIÊU NHANH
                        if not Running then break end
                        SafeTP(endPart.CFrame)
                        task.wait(0.5) -- TỐC ĐỘ SIÊU NHANH
                        
                        -- Nếu quay về Lobby (khoảng cách > 300) thì dừng để quét trận mới
                        if (lp.Character.HumanoidRootPart.Position - startPart.Position).Magnitude > 300 then
                            break
                        end
                    end
                else
                    ScreenGui.Enabled = false
                end
            end
        else
            ScreenGui.Enabled = false
        end
    end
end)

RS.Heartbeat:Connect(function()
    if _G.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("Head") then CreateESP(p) end
        end
    end
    pcall(function()
        local char = lp.Character
        local hum, root = char.Humanoid, char.HumanoidRootPart
        if hum.MoveDirection.Magnitude > 0 and bypassSpeed > 16 then
            root.CFrame = root.CFrame + (hum.MoveDirection * ((bypassSpeed/16 - 1) * 0.25))
        end
    end)
end)

UIS.JumpRequest:Connect(function()
    if infJumpEnabled then
        local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(3) end
    end
end)

_G.EatHub = library:Init()
