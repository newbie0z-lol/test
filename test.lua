
-- SERVICES
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local player = game.Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local VIM = game:GetService("VirtualInputManager")
local Rep = game:GetService("ReplicatedStorage")
local WS = Workspace

-- Load Fluent UI
local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/LongThanhTz12/GUI-LIBARY-SCRIPT/refs/heads/main/guilibaryscript"))()

-- Create Main Window
local Window = Fluent:CreateWindow({
    Title = "Rez Hub 💀 | Link Discord: https://discord.gg/J3pZMNdu",
    SubTitle = "by rez",
    TabWidth = 160,
    Theme = "Dark",
    Acrylic = false,
    Size = UDim2.fromOffset(500, 320),
    MinimizeKey = Enum.KeyCode.F1
})

-- Tab --
local Tabs = {
    Info = Window:AddTab({ Title = "Tab Info", Icon = "info" }),
    Farming = Window:AddTab({ Title = "Tab Farm Lv", Icon = "leaf" }),
    Setting = Window:AddTab({ Title = "Tab Setting", Icon = "settings" }),
    ChoiDo = Window:AddTab({ Title = "Tab Chơi Đồ", Icon = "rocket" }),
    Pvp = Window:AddTab({ Title = "Tab PvP", Icon = "sword" }),
    FarmTien = Window:AddTab({ Title = "Farm Tiền", Icon = "axe" })
}
local FarmWoodTab = Tabs.FarmTien



--// ========================== TIỆN ÍCH CHUNG ================================
--- ANTI AFK 20 PHÚT
spawn(function()
	local vu = game:GetService("VirtualUser")
	player.Idled:Connect(function()
		vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera and workspace.CurrentCamera.CFrame or CFrame.new())
		task.wait(1)
		vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera and workspace.CurrentCamera.CFrame or CFrame.new())
	end)
end)

---------------------------------------------------------------------------------------
local toolName       = "Rìu"
-- Flags
local runningAxeLoop = false

--// Hàm mua Rìu khi hết
local function PurchaseAxe()
	local invGui = player:WaitForChild("PlayerGui")
		:WaitForChild("Inventory")
		:WaitForChild("MainFrame")
		:WaitForChild("Container")
		:WaitForChild("Main")
		:WaitForChild("ToolList")
		:WaitForChild("ScrollingFrame")
	local hasAxe = invGui:FindFirstChild(toolName)
	if not hasAxe then
		local shopService = Rep:WaitForChild("KnitPackages")
			:WaitForChild("_Index")
			:WaitForChild("sleitnick_knit@1.7.0")
			:WaitForChild("knit")
			:WaitForChild("Services")
			:WaitForChild("ShopService")
			:WaitForChild("RE")
			:WaitForChild("buyItem")
		shopService:FireServer(toolName, 99)
		task.wait(1)
	end
end

--// Hàm Request tool từ server (nếu thiếu)
local function RequestToolFromServer()
	local invService = Rep:WaitForChild("KnitPackages")
		:WaitForChild("_Index")
		:WaitForChild("sleitnick_knit@1.7.0")
		:WaitForChild("knit")
		:WaitForChild("Services")
		:WaitForChild("InventoryService")
		:WaitForChild("RE")
		:WaitForChild("updateInventory")
	invService:FireServer("eue", toolName)
end

--// Check & equip, mua nếu hết
local function CheckAndEquipAxe()
	local char      = player.Character
	local backpack  = player:FindFirstChild("Backpack")
	local humanoid  = char and char:FindFirstChildOfClass("Humanoid")
	if not (char and humanoid and backpack) then return end

	local currentTool    = char:FindFirstChildOfClass("Tool")
	local axeInBackpack  = backpack:FindFirstChild(toolName)

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

--// Auto-equip loop
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

--// Arrow Minigame Helpers
local rotationToKey = { [0]=Enum.KeyCode.Right, [90]=Enum.KeyCode.Down, [180]=Enum.KeyCode.Left, [270]=Enum.KeyCode.Up }
local function normalizeRotation(rot)
	return (math.floor((rot % 360) / 90 + 0.5) * 90) % 360
end
local function doArrowSequence()
	local gui       = player:WaitForChild("PlayerGui")
	local arrowGui  = gui:WaitForChild("ArrowMinigame")
	local listFrame = arrowGui:WaitForChild("Arrow"):WaitForChild("List")

	for i = 1, 5 do
		local frame = listFrame:FindFirstChild(tostring(i))
		local img   = frame and frame:FindFirstChild("ImageLabel")
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
	local gui      = player:WaitForChild("PlayerGui")
	local arrowGui = gui:WaitForChild("ArrowMinigame")

	if arrowGui.Enabled then doArrowSequence() end
	arrowWatcherConn = arrowGui:GetPropertyChangedSignal("Enabled"):Connect(function()
		if _G.AutoArrowMinigame and arrowGui.Enabled then
			doArrowSequence()
		end
	end)
end

local function disconnectArrowWatcher()
	if arrowWatcherConn then
		arrowWatcherConn:Disconnect()
		arrowWatcherConn = nil
	end
	runningArrow = false
end

--// Chop & Sell Helpers
local isSelling, isCutting, chopSellLoopRunning = false, false, false
local chopSellDisconnect

local function holdKey(keyCode, duration, prompt)
	local startTime = tick()
	while tick() - startTime < duration do
		-- kiểm tra prompt còn tồn tại
		if prompt then
			local ok = prompt.Parent and prompt:IsDescendantOf(game)
			if ok and prompt:IsA("ProximityPrompt") then
				if not prompt.Enabled then ok = false end
				local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
				if hrp and prompt.MaxActivationDistance then
					local part = prompt.Parent:IsA("BasePart") and prompt.Parent
						or prompt:FindFirstAncestorWhichIsA("BasePart")
					if part and (hrp.Position - part.Position).Magnitude > (prompt.MaxActivationDistance + 2) then
						ok = false
					end
				end
			else
				ok = false
			end
			if not ok then break end
		end
		VIM:SendKeyEvent(true, keyCode, false, game)
		task.wait(0.1)
	end
	VIM:SendKeyEvent(false, keyCode, false, game)
end

local function waitForArrowMinigameFinish()
	if not _G.AutoArrowMinigame then return end
	local gui      = player:FindFirstChild("PlayerGui")
	local arrowGui = gui and gui:FindFirstChild("ArrowMinigame")
	if not arrowGui then return end

	local start = tick()
	while not arrowGui.Enabled and tick() - start < 5 do task.wait(0.05) end
	if not arrowGui.Enabled then return end

	local finished = false
	local conn = arrowGui:GetPropertyChangedSignal("Enabled"):Connect(function()
		if not arrowGui.Enabled then finished = true end
	end)

	local finishStart = tick()
	while arrowGui.Enabled and not finished and tick() - finishStart < 10 do
		task.wait(0.05)
	end
	conn:Disconnect()
end

local function getChopSellRefs()
	local ok, refs = pcall(function()
		local gui    = player:WaitForChild("PlayerGui")
		local Trees  = WS:WaitForChild("Lumberjack"):WaitForChild("Trees")
		local Sell   = WS:WaitForChild("Lumberjack"):WaitForChild("Sell"):WaitForChild("Part")
		local char   = player.Character or player.CharacterAdded:Wait()
		local hrp    = char:WaitForChild("HumanoidRootPart")
		local label  = gui:WaitForChild("TopbarStandard")
			.Holders.Left.logCount.IconButton.Menu
			.IconSpot.Contents.IconLabelContainer:WaitForChild("IconLabel")
		return { Trees = Trees, SellPart = Sell, HRP = hrp, label = label }
	end)
	return ok and refs or nil
end

local recentlyChopped     = {}
local RECENTLY_TIMEOUT    = 60
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
			if last and tick() - last < RECENTLY_TIMEOUT then
				continue
			end
			local prompt = tree:FindFirstChildWhichIsA("ProximityPrompt", true)
			if prompt and prompt.Enabled then
				local part = prompt.Parent:IsA("BasePart") and prompt.Parent
					or prompt:FindFirstAncestorWhichIsA("BasePart")
				if part then
					refs.HRP.CFrame = part.CFrame + Vector3.new(0, 3, 0)
					task.wait(0.5)
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

		local labelConn
		labelConn = refs.label:GetPropertyChangedSignal("Text"):Connect(function()
			if isSelling or not _G.AutoChopSell then return end
			local count = tonumber(string.match(refs.label.Text, "Số lượng gỗ đã nhặt:%s*(%d+)"))
			if count and count >= 15 then
				isSelling = true
				refs.HRP.CFrame = refs.SellPart.CFrame + Vector3.new(0, 3, 0)
				task.wait(0.5)
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

--// Toggle Auto Equip Axe
local ToggleAxe = Tabs.FarmTien:AddToggle("AutoEquipAxe", { Title = "Auto Lấy Rìu", Default = false })
ToggleAxe:OnChanged(function(state)
	_G.AutoEquipAxe = state
	if state then StartAutoEquipLoop() end
end)
player.CharacterAdded:Connect(function()
	if _G.AutoEquipAxe then
		task.wait(0.1)
		StartAutoEquipLoop()
	end
end)

--// Toggle Auto Arrow Minigame
local ToggleArrow = Tabs.FarmTien:AddToggle("AutoArrowMinigame", { Title = "Auto Farm Gỗ", Default = false })
ToggleArrow:OnChanged(function(state)
	_G.AutoArrowMinigame = state
	if state then setupArrowWatcher() else disconnectArrowWatcher() end
end)

--// Toggle Auto Chop & Sell
local ToggleChopSell = Tabs.FarmTien:AddToggle("AutoChopSell", { Title = "Auto Chặt & Bán Gỗ", Default = false })
ToggleChopSell:OnChanged(function(state)
	_G.AutoChopSell = state
	if state then startChopSellLoop() else stopChopSellLoop() end
end)

Tabs.FarmTien:AddParagraph({
	Title = "Hướng dẫn",
	Content = "Bật các chức năng để tự động lấy rìu, farm gỗ, chặt và bán gỗ. Đảm bảo bạn đã vào khu vực Fram Gỗ."
})
----Kết Thúc Job Gỗ---

