local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer

local character
local hrp
local savedCF

-- ===== Character (чтобы не пропадало после смерти)
local function onCharacterAdded(char)
	character = char
	hrp = char:WaitForChild("HumanoidRootPart")
end
player.CharacterAdded:Connect(onCharacterAdded)
if player.Character then onCharacterAdded(player.Character) end

-- ===== GUI
local gui = Instance.new("ScreenGui")
gui.Name = "AstraUniversalHub"
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.3, 0.3)
frame.Position = UDim2.fromScale(0.35, 0.35)
frame.BackgroundColor3 = Color3.fromRGB(18,18,22)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,16)

-- Заголовок
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.fromScale(1, 0.18)
title.BackgroundTransparency = 1
title.Text = "Astra Universal Hub"
title.TextColor3 = Color3.fromRGB(160,180,255)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

-- линия
local line = Instance.new("Frame", frame)
line.Size = UDim2.fromScale(0.9, 0.01)
line.Position = UDim2.fromScale(0.05, 0.18)
line.BackgroundColor3 = Color3.fromRGB(70,80,140)
line.BorderSizePixel = 0

-- кнопки
local function button(text, y)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.fromScale(0.9, 0.22)
	b.Position = UDim2.fromScale(0.05, y)
	b.Text = text
	b.TextColor3 = Color3.new(1,1,1)
	b.Font = Enum.Font.GothamSemibold
	b.TextScaled = true
	b.BackgroundColor3 = Color3.fromRGB(45,50,90)
	b.BorderSizePixel = 0
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,12)
	return b
end

local saveBtn  = button("Save Position", 0.22)
local tpBtn    = button("Teleport to Position", 0.46)
local lightBtn = button("Full Bright : OFF", 0.70)

-- ===== Save position
saveBtn.MouseButton1Click:Connect(function()
	if not hrp then return end
	savedCF = hrp.CFrame
	saveBtn.Text = "Position Saved ✓"
end)

-- ===== Teleport (стабильный)
tpBtn.MouseButton1Click:Connect(function()
	if not hrp or not savedCF then return end

	local ff = Instance.new("ForceField")
	ff.Visible = false
	ff.Parent = character

	hrp.CFrame = savedCF + Vector3.new(0, 8, 0)

	task.wait(0.3)
	ff:Destroy()
end)

-- ===== FULL BRIGHT
local fullBright = false
local old = {
	Brightness = Lighting.Brightness,
	ClockTime = Lighting.ClockTime,
	FogEnd = Lighting.FogEnd,
	GlobalShadows = Lighting.GlobalShadows,
	Ambient = Lighting.Ambient,
	OutdoorAmbient = Lighting.OutdoorAmbient
}

local function enableFullBright()
	Lighting.Brightness = 3
	Lighting.ClockTime = 14
	Lighting.FogEnd = 1e6
	Lighting.GlobalShadows = false
	Lighting.Ambient = Color3.new(1,1,1)
	Lighting.OutdoorAmbient = Color3.new(1,1,1)
end

local function disableFullBright()
	for k,v in pairs(old) do
		Lighting[k] = v
	end
end

lightBtn.MouseButton1Click:Connect(function()
	fullBright = not fullBright
	if fullBright then
		enableFullBright()
		lightBtn.Text = "Full Bright : ON"
	else
		disableFullBright()
		lightBtn.Text = "Full Bright : OFF"
	end
end)
