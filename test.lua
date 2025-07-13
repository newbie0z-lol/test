-- SERVICES
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local player = LocalPlayer
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")
local Rep = game:GetService("ReplicatedStorage")
local WS = Workspace

-- Load Fluent UI
local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/LongThanhTz12/GUI-LIBARY-SCRIPT/refs/heads/main/guilibaryscript"))()
local Window = Fluent:CreateWindow({
    Title = "Rez Hub 💀 | Link Discord: https://discord.gg/J3pZMNdu",
    SubTitle = "by rez",
    TabWidth = 160,
    Theme = "Dark",
    Acrylic = false,
    Size = UDim2.fromOffset(500, 320),
    MinimizeKey = Enum.KeyCode.F1
})
local Tabs = {
    FarmTien = Window:AddTab({ Title = "Farm Tiền", Icon = "axe" })
}
local FarmWoodTab = Tabs.FarmTien

-- ANTI AFK
spawn(function()
	local vu = game:GetService("VirtualUser")
	player.Idled:Connect(function()
		vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
		task.wait(1)
		vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
	end)
end)

-- Bay tới cây bằng Tween
local function flyToPosition(part, offset, speed)
	local destination = part.Position + offset
	local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if not (hrp and part) then return end

	local distance = (hrp.Position - destination).Magnitude
	local tweenTime = math.clamp(distance / speed, 0.3, 3)
	local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Linear)
	local goal = { CFrame = CFrame.new(destination) }
	local tween = TweenService:Create(hrp, tweenInfo, goal)
	tween:Play()
	tween.Completed:Wait()
end

-- Equip Axe
local toolName = "Rìu"
local runningAxeLoop = false
local function PurchaseAxe()
	local invGui = player:WaitForChild("PlayerGui").Inventory.MainFrame.Container.Main.ToolList.ScrollingFrame
	if not invGui:FindFirstChild(toolName) then
		local shopService = Rep.KnitPackages._Index["sleitnick_knit@1.7.0"].knit.Services.ShopService.RE.buyItem
		shopService:FireServer(toolName, 99)
		task.wait(1)
	end
end
local function RequestToolFromServer()
	local invService = Rep.KnitPackages._Index["sleitnick_knit@1.7.0"].knit.Services.InventoryService.RE.updateInventory
	invService:FireServer("eue", toolName)
end
local function CheckAndEquipAxe()
	local char = player.Character
	local backpack = player:FindFirstChild("Backpack")
	local humanoid = char and char:FindFirstChildOfClass("Humanoid")
	if not (char and humanoid and backpack) then return end
	local currentTool = char:FindFirstChildOfClass("Tool")
	local axeInBackpack = backpack:FindFirstChild(toolName)
	if (not currentTool or currentTool.Name ~= toolName) and not axeInBackpack then
		RequestToolFromServer()
		task.wait(0.5)
		axeInBackpack = backpack:FindFirstChild(toolName)
		if not axeInBackpack then
			PurchaseAxe()
			axeInBackpack = backpack:FindFirstChild(toolName)
		end
	end
	if axeInBackpack then
		humanoid:EquipTool(axeInBackpack)
	end
end
local function StartAutoEquipLoop()
	if runningAxeLoop then return end
	runningAxeLoop = true
	task.spawn(function()
		while _G.AutoEquipAxe do
			CheckAndEquipAxe()
			task.wait(0.1)
		end
		runningAxeLoop = false
	end)
end

-- Arrow minigame
local rotationToKey = { [0]=Enum.KeyCode.Right, [90]=Enum.KeyCode.Down, [180]=Enum.KeyCode.Left, [270]=Enum.KeyCode.Up }
local function normalizeRotation(rot)
	return (math.floor((rot % 360) / 90 + 0.5) * 90) % 360
end
local function doArrowSequence()
	local gui = player:WaitForChild("PlayerGui").ArrowMinigame.Arrow.List
	for i = 1, 5 do
		local frame = gui:FindFirstChild(tostring(i))
		local img = frame and frame:FindFirstChild("ImageLabel")
		if img then
			local rot = normalizeRotation(img.Rotation)
			local key = rotationToKey[rot]
			if key then
				VIM:SendKeyEvent(true, key, false, game)
				task.wait(0.05)
				VIM:SendKeyEvent(false, key, false, game)
				task.wait(0.1)
			end
		end
	end
	task.wait(3)
	VIM:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
	task.wait(0.05)
	VIM:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
end
local arrowWatcherConn, runningArrow = nil, false
local function setupArrowWatcher()
	if runningArrow then return end
	runningArrow = true
	local arrowGui = player:WaitForChild("PlayerGui").ArrowMinigame
	if arrowGui.Enabled then doArrowSequence() end
	arrowWatcherConn = arrowGui:GetPropertyChangedSignal("Enabled"):Connect(function()
		if _G.AutoArrowMinigame and arrowGui.Enabled then
			doArrowSequence()
		end
	end)
end
local function disconnectArrowWatcher()
	if arrowWatcherConn then arrowWatcherConn:Disconnect() end
	runningArrow = false
end

-- Chop & Sell logic
local isSelling, isCutting, chopSellLoopRunning = false, false, false
local chopSellDisconnect
local function holdKey(keyCode, duration, prompt)
	local startTime = tick()
	while tick() - startTime < duration do
		if not prompt or not prompt:IsDescendantOf(game) or not prompt.Enabled then break end
		VIM:SendKeyEvent(true, keyCode, false, game)
		task.wait(0.1)
	end
	VIM:SendKeyEvent(false, keyCode, false, game)
end
local function waitForArrowMinigameFinish()
	if not _G.AutoArrowMinigame then return end
	local arrowGui = player:FindFirstChild("PlayerGui") and player.PlayerGui:FindFirstChild("ArrowMinigame")
	if not arrowGui then return end
	local start = tick()
	while not arrowGui.Enabled and tick() - start < 5 do task.wait(0.05) end
	if not arrowGui.Enabled then return end
	local finished = false
	local conn = arrowGui:GetPropertyChangedSignal("Enabled"):Connect(function()
		if not arrowGui.Enabled then finished = true end
	end)
	while arrowGui.Enabled and not finished and tick() - start < 10 do task.wait(0.05) end
	conn:Disconnect()
end
local function getChopSellRefs()
	local ok, refs = pcall(function()
		local gui = player:WaitForChild("PlayerGui")
		local Trees = WS.Lumberjack.Trees
		local Sell = WS.Lumberjack.Sell.Part
		local hrp = player.Character:WaitForChild("HumanoidRootPart")
		local label = gui.TopbarStandard.Holders.Left.logCount.IconButton.Menu.IconSpot.Contents.IconLabelContainer.IconLabel
		return { Trees = Trees, SellPart = Sell, HRP = hrp, label = label }
	end)
	return ok and refs or nil
end
local recentlyChopped = {}
local RECENTLY_TIMEOUT = 60
local function cleanupRecentlyChopped()
	local now = tick()
	for tree, t in pairs(recentlyChopped) do
		if now - t > RECENTLY_TIMEOUT then
			recentlyChopped[tree] = nil
		end
	end
end
local function chopTreesLoop(refs)
	isCutting = true
	while _G.AutoChopSell and not isSelling do
		local found = false
		for _, tree in ipairs(refs.Trees:GetChildren()) do
			if not _G.AutoChopSell or isSelling then break end
			local last = recentlyChopped[tree]
			if last and tick() - last < RECENTLY_TIMEOUT then continue end
			local prompt = tree:FindFirstChildWhichIsA("ProximityPrompt", true)
			if prompt and prompt.Enabled then
				local part = prompt.Parent:IsA("BasePart") and prompt.Parent or prompt:FindFirstAncestorWhichIsA("BasePart")
				if part then
					flyToPosition(part, Vector3.new(0, 3, 0), 30)
					task.wait(0.3)
					holdKey(Enum.KeyCode.F, prompt.HoldDuration or 1.5, prompt)
					waitForArrowMinigameFinish()
					task.wait(0.5)
					recentlyChopped[tree] = tick()
					cleanupRecentlyChopped()
					found = true
					break
				end
			end
		end
		if not found then task.wait(0.5) end
	end
	isCutting = false
end
local function startChopSellLoop()
	if chopSellLoopRunning then return end
	chopSellLoopRunning = true
	task.spawn(function()
		local refs = getChopSellRefs()
		if not refs then chopSellLoopRunning = false return end
		local labelConn = refs.label:GetPropertyChangedSignal("Text"):Connect(function()
			if isSelling or not _G.AutoChopSell then return end
			local count = tonumber(string.match(refs.label.Text, "Số lượng gỗ đã nhặt:%s*(%d+)"))
			if count and count >= 15 then
				isSelling = true
				flyToPosition(refs.SellPart, Vector3.new(0, 3, 0), 30)
				task.wait(0.3)
				local prompt = refs.SellPart:FindFirstChildWhichIsA("ProximityPrompt", true)
				if prompt and prompt.Enabled then
					holdKey(Enum.KeyCode.E, prompt.HoldDuration or 1.5, prompt)
				end
				task.wait(1)
				isSelling = false
				if not isCutting and _G.AutoChopSell then
					task.delay(0.5, function() chopTreesLoop(refs) end)
				end
			end
		end)
		chopSellDisconnect = function()
			if labelConn then labelConn:Disconnect() end
			chopSellLoopRunning = false
		end
		task.delay(1, function()
			if _G.AutoChopSell then chopTreesLoop(refs) end
		end)
		while _G.AutoChopSell do task.wait(1) end
		if chopSellDisconnect then chopSellDisconnect() end
	end)
end
local function stopChopSellLoop()
	_G.AutoChopSell = false
	isSelling, isCutting, chopSellLoopRunning = false, false, false
	if chopSellDisconnect then chopSellDisconnect() end
end

-- Toggle UI
Tabs.FarmTien:AddToggle("AutoEquipAxe", { Title = "Auto Lấy Rìu", Default = false }):OnChanged(function(state)
	_G.AutoEquipAxe = state
	if state then StartAutoEquipLoop() end
end)
player.CharacterAdded:Connect(function()
	if _G.AutoEquipAxe then task.wait(0.1) StartAutoEquipLoop() end
end)
Tabs.FarmTien:AddToggle("AutoArrowMinigame", { Title = "Auto Farm Gỗ", Default = false }):OnChanged(function(state)
	_G.AutoArrowMinigame = state
	if state then setupArrowWatcher() else disconnectArrowWatcher() end
end)
Tabs.FarmTien:AddToggle("AutoChopSell", { Title = "Auto Chặt & Bán Gỗ", Default = false }):OnChanged(function(state)
	_G.AutoChopSell = state
	if state then startChopSellLoop() else stopChopSellLoop() end
end)
Tabs.FarmTien:AddParagraph({
	Title = "Hướng dẫn",
	Content = "Bật các chức năng để tự động lấy rìu, farm gỗ, chặt và bán gỗ. Đảm bảo bạn đã vào khu vực Fram Gỗ."
})
