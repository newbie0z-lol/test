local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- REMOVE OLD
if PlayerGui:FindFirstChild("ModernTopbar") then
	PlayerGui.ModernTopbar:Destroy()
end

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ModernTopbar"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- MAIN HOLDER
local Holder = Instance.new("Frame")
Holder.Parent = ScreenGui
Holder.AnchorPoint = Vector2.new(0.5,0)
Holder.Position = UDim2.new(0.5,0,0.035,0)
Holder.Size = UDim2.new(0,950,0,58)
Holder.BackgroundTransparency = 1

-- GLOW BORDER FRAME
local StrokeFrame = Instance.new("Frame")
StrokeFrame.Parent = Holder
StrokeFrame.Size = UDim2.new(1,0,0,48)
StrokeFrame.Position = UDim2.new(0,0,0,0)
StrokeFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
StrokeFrame.BackgroundTransparency = 0.8
StrokeFrame.BorderSizePixel = 0
StrokeFrame.ClipsDescendants = true

Instance.new("UICorner", StrokeFrame).CornerRadius = UDim.new(0,12)

-- MAIN STROKE
local UIStroke = Instance.new("UIStroke")
UIStroke.Parent = StrokeFrame
UIStroke.Thickness = 2
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- GLOW EFFECT
local Glow = Instance.new("ImageLabel")
Glow.Parent = StrokeFrame
Glow.AnchorPoint = Vector2.new(0.5,0.5)
Glow.Position = UDim2.new(0.5,0,0.5,0)
Glow.Size = UDim2.new(1,35,1,35)
Glow.BackgroundTransparency = 1
Glow.Image = "rbxassetid://5028857084"
Glow.ImageTransparency = 0.4
Glow.ScaleType = Enum.ScaleType.Slice
Glow.SliceCenter = Rect.new(24,24,276,276)
Glow.ZIndex = 0

-- MAIN BAR
local Main = Instance.new("Frame")
Main.Parent = Holder
Main.AnchorPoint = Vector2.new(0.5,0)
Main.Position = UDim2.new(0.5,0,0,0)
Main.Size = UDim2.new(1,-4,0,44)
Main.BackgroundColor3 = Color3.fromRGB(20,20,20)
Main.BackgroundTransparency = 0.35
Main.BorderSizePixel = 0
Main.ClipsDescendants = true

Instance.new("UICorner", Main).CornerRadius = UDim.new(0,10)

-- GLASS EFFECT
local Gradient = Instance.new("UIGradient")
Gradient.Parent = Main
Gradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(200,200,200))
})

Gradient.Transparency = NumberSequence.new({
	NumberSequenceKeypoint.new(0,0.92),
	NumberSequenceKeypoint.new(1,0.97)
})

-- LAYOUT
local Layout = Instance.new("UIListLayout")
Layout.Parent = Main
Layout.FillDirection = Enum.FillDirection.Horizontal
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.VerticalAlignment = Enum.VerticalAlignment.Center
Layout.Padding = UDim.new(0,14)

-- BUTTONS
local Buttons = {}

local ButtonNames = {
	"Aim",
	"Auto Heal",
	"Esp Máu",
	"Speed",
	"TBC Shoot",
	"Vehicle Speed",
	"Auto Attack"
}

local EnabledButtons = {}

for _,Name in ipairs(ButtonNames) do
	
	local Button = Instance.new("TextButton")
	Button.Parent = Main
	Button.Size = UDim2.new(0,118,0,28)
	Button.BackgroundColor3 = Color3.fromRGB(235,235,235)
	Button.Text = Name
	Button.TextColor3 = Color3.new(0,0,0)
	Button.Font = Enum.Font.GothamBold
	Button.TextSize = 13
	Button.BorderSizePixel = 0
	Button.AutoButtonColor = false
	
	Instance.new("UICorner", Button).CornerRadius = UDim.new(0,7)
	
	local BtnStroke = Instance.new("UIStroke")
	BtnStroke.Parent = Button
	BtnStroke.Color = Color3.fromRGB(170,170,170)
	BtnStroke.Thickness = 1
	
	-- BUTTON GLOW
	local BtnGlow = Instance.new("ImageLabel")
	BtnGlow.Parent = Button
	BtnGlow.AnchorPoint = Vector2.new(0.5,0.5)
	BtnGlow.Position = UDim2.new(0.5,0,0.5,0)
	BtnGlow.Size = UDim2.new(1,18,1,18)
	BtnGlow.BackgroundTransparency = 1
	BtnGlow.Image = "rbxassetid://5028857084"
	BtnGlow.ImageTransparency = 1
	BtnGlow.ScaleType = Enum.ScaleType.Slice
	BtnGlow.SliceCenter = Rect.new(24,24,276,276)
	
	EnabledButtons[Button] = false
	
	-- CLICK DOWN
	Button.MouseButton1Down:Connect(function()
		
		TweenService:Create(
			Button,
			TweenInfo.new(0.08),
			{
				Size = UDim2.new(0,112,0,24)
			}
		):Play()
		
	end)
	
	-- CLICK UP
	Button.MouseButton1Up:Connect(function()
		
		TweenService:Create(
			Button,
			TweenInfo.new(0.08),
			{
				Size = UDim2.new(0,118,0,28)
			}
		):Play()
		
	end)
	
	-- TOGGLE
	Button.MouseButton1Click:Connect(function()
		
		EnabledButtons[Button] = not EnabledButtons[Button]
		
		if EnabledButtons[Button] then
			
			TweenService:Create(
				Button,
				TweenInfo.new(0.15),
				{
					BackgroundColor3 = Color3.fromRGB(170,220,255)
				}
			):Play()
			
			BtnStroke.Color = Color3.fromRGB(80,180,255)
			BtnGlow.ImageTransparency = 0.45
			
		else
			
			TweenService:Create(
				Button,
				TweenInfo.new(0.15),
				{
					BackgroundColor3 = Color3.fromRGB(235,235,235)
				}
			):Play()
			
			BtnStroke.Color = Color3.fromRGB(170,170,170)
			BtnGlow.ImageTransparency = 1
		end
	end)
	
	table.insert(Buttons, Button)
end

-- TOGGLE BUTTON
local Toggle = Instance.new("TextButton")
Toggle.Parent = Holder
Toggle.AnchorPoint = Vector2.new(0.5,0)
Toggle.Position = UDim2.new(0.5,0,0,42)
Toggle.Size = UDim2.new(0,60,0,18)
Toggle.BackgroundColor3 = Color3.fromRGB(220,220,220)
Toggle.Text = "^"
Toggle.TextColor3 = Color3.new(0,0,0)
Toggle.Font = Enum.Font.GothamBold
Toggle.TextSize = 14
Toggle.BorderSizePixel = 0

Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0,5)

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Parent = Toggle
ToggleStroke.Color = Color3.fromRGB(160,160,160)

-- OPEN CLOSE
local Opened = true
local OriginalSize = Main.Size
local OriginalStroke = StrokeFrame.Size

Toggle.MouseButton1Click:Connect(function()
	
	Opened = not Opened
	
	if Opened then
		
		for _,v in pairs(Buttons) do
			v.Visible = true
		end
		
		TweenService:Create(
			Main,
			TweenInfo.new(0.3, Enum.EasingStyle.Quint),
			{
				Size = OriginalSize,
				BackgroundTransparency = 0.35
			}
		):Play()
		
		TweenService:Create(
			StrokeFrame,
			TweenInfo.new(0.3, Enum.EasingStyle.Quint),
			{
				Size = OriginalStroke
			}
		):Play()
		
		TweenService:Create(
			Toggle,
			TweenInfo.new(0.3, Enum.EasingStyle.Quint),
			{
				Position = UDim2.new(0.5,0,0,42)
			}
		):Play()
		
		Toggle.Text = "^"
		
	else
		
		TweenService:Create(
			Main,
			TweenInfo.new(0.3, Enum.EasingStyle.Quint),
			{
				Size = UDim2.new(1,-4,0,0),
				BackgroundTransparency = 1
			}
		):Play()
		
		TweenService:Create(
			StrokeFrame,
			TweenInfo.new(0.3, Enum.EasingStyle.Quint),
			{
				Size = UDim2.new(1,0,0,4)
			}
		):Play()
		
		TweenService:Create(
			Toggle,
			TweenInfo.new(0.3, Enum.EasingStyle.Quint),
			{
				Position = UDim2.new(0.5,0,0,2)
			}
		):Play()
		
		Toggle.Text = "v"
		
		task.delay(0.15,function()
			if not Opened then
				for _,v in pairs(Buttons) do
					v.Visible = false
				end
			end
		end)
	end
end)

-- RAINBOW ANIMATION
local hue = 0

RunService.RenderStepped:Connect(function(dt)
	
	hue += dt * 0.12
	
	if hue >= 1 then
		hue = 0
	end
	
	local Rainbow = Color3.fromHSV(hue,1,1)
	local Soft = Color3.fromHSV(hue,0.6,1)
	
	UIStroke.Color = Rainbow
	Glow.ImageColor3 = Soft
	
	-- PULSE
	local Pulse = math.sin(tick()*2.5) * 0.08
	
	Glow.ImageTransparency = 0.35 + Pulse
	
	for _,Button in pairs(Buttons) do
		
		if EnabledButtons[Button] then
			
			if Button:FindFirstChild("UIStroke") then
				Button.UIStroke.Color = Rainbow
			end
			
			if Button:FindFirstChildOfClass("ImageLabel") then
				Button:FindFirstChildOfClass("ImageLabel").ImageColor3 = Soft
				Button:FindFirstChildOfClass("ImageLabel").ImageTransparency = 0.42 + Pulse
			end
		end
	end
end)
