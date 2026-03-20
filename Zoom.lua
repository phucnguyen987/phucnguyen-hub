-- Script Unlock Camera Zoom cho Admin (Test Game)
local Player = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Thiết lập các thông số Camera
Player.CameraMaxZoomDistance = 500 -- Khoảng cách zoom tối đa (thay đổi tùy ý)
Player.CameraMinZoomDistance = 0.5 -- Khoảng cách zoom tối thiểu (nhìn từ bên trong)
Player.CameraMode = Enum.CameraMode.Classic -- Chế độ camera tự do

-- Thông báo kích hoạt thành công
print("Admin Camera Unlocked! Bạn có thể dùng tay zoom xa ra ngay bây giờ.")

-- Chống việc Script của game tự động reset lại tầm nhìn
Player:GetPropertyChangedSignal("CameraMaxZoomDistance"):Connect(function()
    if Player.CameraMaxZoomDistance < 500 then
        Player.CameraMaxZoomDistance = 500
    end
end)
