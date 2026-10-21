-- KillCam Skin (War Tycoon) + واجهة
-- يبدل صورة القاتل في شاشة "KILLED BY" لصورة السكن (يعتمد على الأحداث مو فحص مستمر)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LP = Players.LocalPlayer

local DEBUG = false -- خله true لو تبي يطبع أسماء الصور في الكونسول (F9)

---------------------------------------------------------------------
-- الحالة
---------------------------------------------------------------------
local State = { id = 7919170386, enabled = true }

local function imageFor(id)
	return ("rbxthumb://type=AvatarHeadShot&id=%d&w=420&h=420"):format(id)
end

local NEW_IMAGE = imageFor(State.id)

local hooked = {}
local watchedRoots = {}
local originals = setmetatable({}, { __mode = "k" }) -- الصورة الأصلية قبل التبديل
local lastSet = setmetatable({}, { __mode = "k" })   -- آخر صورة حطيناها

---------------------------------------------------------------------
-- المنطق الأساسي
---------------------------------------------------------------------
local function looksLikeAvatar(img)
	local s = img:lower()
	return s:find("rbxthumb", 1, true) or s:find("headshot", 1, true)
		or s:find("thumbnail", 1, true) or s:find("avatar", 1, true)
		or s:find("/users/", 1, true) or s:find("userid", 1, true)
end

local function setImage(img, value)
	if img.Image ~= lastSet[img] then
		originals[img] = img.Image
	end
	lastSet[img] = value
	img.Image = value
end

local function fix(img)
	if not State.enabled then return end
	if img.Image ~= NEW_IMAGE and looksLikeAvatar(img.Image) then
		setImage(img, NEW_IMAGE)
	end
end

local function hookImage(img)
	if hooked[img] then return end
	hooked[img] = true
	if DEBUG then print("IMG", img:GetFullName(), "|", img.Image) end
	fix(img)
	img:GetPropertyChangedSignal("Image"):Connect(function() fix(img) end)
end

-- احتياطي: إذا ما لقى صورة بالاسم، يبدل أكبر صورة مربعة (صورة القاتل)
local function fallback(root)
	if not State.enabled then return end
	if not root.Parent then return end
	local best, area = nil, 0
	for _, d in ipairs(root:GetDescendants()) do
		if d:IsA("ImageLabel") or d:IsA("ImageButton") then
			if d.Image == NEW_IMAGE then return end -- انبدلت خلاص
			local sz = d.AbsoluteSize
			if sz.X > 0 and sz.Y > 0 then
				local ratio = sz.X / sz.Y
				if ratio > 0.85 and ratio < 1.15 and sz.X * sz.Y > area then
					best, area = d, sz.X * sz.Y
				end
			end
		end
	end
	if best then setImage(best, NEW_IMAGE) end
end

local function scheduleFallback(root)
	task.delay(0.3, fallback, root)
	task.delay(1, fallback, root)
end

local function watchRoot(root)
	if watchedRoots[root] then return end
	watchedRoots[root] = true

	for _, d in ipairs(root:GetDescendants()) do
		if d:IsA("ImageLabel") or d:IsA("ImageButton") then hookImage(d) end
	end

	root.DescendantAdded:Connect(function(d)
		if d:IsA("ImageLabel") or d:IsA("ImageButton") then
			task.defer(hookImage, d)
		end
	end)

	-- إذا الواجهة مخفية وتظهر كل مرة تموت
	root:GetPropertyChangedSignal("Enabled"):Connect(function()
		if root.Enabled then scheduleFallback(root) end
	end)

	scheduleFallback(root)
end

local function isKilledByLabel(o)
	return o:IsA("TextLabel") and o.Text:upper():find("KILLED BY", 1, true) ~= nil
end

local function checkLabel(o)
	if isKilledByLabel(o) then
		local root = o:FindFirstAncestorOfClass("ScreenGui")
		if root then pcall(watchRoot, root) end
	end
end

local pg = LP:WaitForChild("PlayerGui")

-- فحص واحد فقط عند التشغيل
for _, o in ipairs(pg:GetDescendants()) do
	if o:IsA("TextLabel") then checkLabel(o) end
end

-- وبعدها نراقب بس العناصر الجديدة
pg.DescendantAdded:Connect(function(o)
	if o:IsA("TextLabel") then
		task.defer(checkLabel, o)
	end
end)

---------------------------------------------------------------------
-- دوال التحكم للواجهة
---------------------------------------------------------------------
local function refreshAll()
	for img in pairs(hooked) do
		if img.Parent then fix(img) end
	end
	for root in pairs(watchedRoots) do
		if root.Parent and root.Enabled then scheduleFallback(root) end
	end
end

local function restoreAll()
	for img, orig in pairs(originals) do
		if img.Parent and img.Image == lastSet[img] then
			img.Image = orig
		end
	end
end

local function resolveUserId(text)
	text = (text or ""):gsub("%s+", "")
	if text == "" then return nil end
	local n = tonumber(text)
	if n then return math.floor(n) end
	local ok, id = pcall(Players.GetUserIdFromNameAsync, Players, text)
	if ok then return id end
end

---------------------------------------------------------------------
-- الواجهة
---------------------------------------------------------------------
local DEFAULT_TITLE = "صورة القاتل (KILLED BY)"

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KillCamSkinGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local parented = false
pcall(function()
	if gethui then ScreenGui.Parent = gethui() parented = true end
end)
if not parented then
	parented = pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
end
if not parented or not ScreenGui.Parent then
	ScreenGui.Parent = pg
end

local function corner(obj, r)
	Instance.new("UICorner", obj).CornerRadius = UDim.new(0, r)
end

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 200)
MainFrame.Position = UDim2.new(0.5, -130, 0.4, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(150, 50, 255)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
corner(MainFrame, 8)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -70, 0, 35)
Title.Text = DEFAULT_TITLE
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
Title.TextWrapped = true
Title.Parent = MainFrame

local IdInput = Instance.new("TextBox")
IdInput.Size = UDim2.new(0.9, 0, 0, 38)
IdInput.Position = UDim2.new(0.05, 0, 0, 50)
IdInput.PlaceholderText = "ID أو اسم الشخص..."
IdInput.Text = tostring(State.id)
IdInput.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
IdInput.TextColor3 = Color3.fromRGB(255, 255, 255)
IdInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 160)
IdInput.Font = Enum.Font.Gotham
IdInput.TextSize = 13
IdInput.ClearTextOnFocus = false
IdInput.Parent = MainFrame
corner(IdInput, 6)

local ApplyBtn = Instance.new("TextButton")
ApplyBtn.Size = UDim2.new(0.9, 0, 0, 38)
ApplyBtn.Position = UDim2.new(0.05, 0, 0, 98)
ApplyBtn.Text = "تطبيق الصورة"
ApplyBtn.BackgroundColor3 = Color3.fromRGB(120, 40, 200)
ApplyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ApplyBtn.Font = Enum.Font.GothamBold
ApplyBtn.TextSize = 13
ApplyBtn.Parent = MainFrame
corner(ApplyBtn, 6)

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0.9, 0, 0, 38)
ToggleBtn.Position = UDim2.new(0.05, 0, 0, 146)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 150, 70)
ToggleBtn.Text = "الحالة: شغّال"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 13
ToggleBtn.Parent = MainFrame
corner(ToggleBtn, 6)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -30, 0, 5)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 12
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = MainFrame
corner(CloseBtn, 4)

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 25, 0, 25)
MinBtn.Position = UDim2.new(1, -60, 0, 5)
MinBtn.Text = "-"
MinBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 85)
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 14
MinBtn.BorderSizePixel = 0
MinBtn.Parent = MainFrame
corner(MinBtn, 4)

local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 40, 0, 40)
OpenBtn.Position = UDim2.new(0, 10, 0.5, 0)
OpenBtn.Text = "KILL"
OpenBtn.BackgroundColor3 = Color3.fromRGB(120, 40, 200)
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 10
OpenBtn.Visible = false
OpenBtn.Active = true
OpenBtn.Draggable = true
OpenBtn.Parent = ScreenGui
corner(OpenBtn, 20)

local function setVisible(v)
	MainFrame.Visible = v
	OpenBtn.Visible = not v
end

local statusToken = 0
local function setStatus(text, resetAfter)
	statusToken += 1
	local my = statusToken
	Title.Text = text
	if resetAfter then
		task.delay(resetAfter, function()
			if my == statusToken then Title.Text = DEFAULT_TITLE end
		end)
	end
end

local function updateToggleLook()
	if State.enabled then
		ToggleBtn.Text = "الحالة: شغّال"
		ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 150, 70)
	else
		ToggleBtn.Text = "الحالة: متوقف"
		ToggleBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 40)
	end
end

MinBtn.MouseButton1Click:Connect(function() setVisible(false) end)
OpenBtn.MouseButton1Click:Connect(function() setVisible(true) end)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end) -- السكربت يبقى شغال

local busy = false
ApplyBtn.MouseButton1Click:Connect(function()
	if busy then return end
	busy = true
	setStatus("جاري التحقق...")
	task.spawn(function()
		local id = resolveUserId(IdInput.Text)
		if not id then
			setStatus("خطأ: ID أو اسم غير صحيح!", 3)
			busy = false
			return
		end
		State.id = id
		NEW_IMAGE = imageFor(id)
		State.enabled = true
		updateToggleLook()
		refreshAll()
		setStatus("تم! بتبان الصورة بشاشة القتل", 3)
		busy = false
	end)
end)

ToggleBtn.MouseButton1Click:Connect(function()
	State.enabled = not State.enabled
	updateToggleLook()
	if State.enabled then
		refreshAll()
		setStatus("تم التشغيل", 2)
	else
		restoreAll()
		setStatus("تم الإيقاف ورجعت الصورة الأصلية", 2)
	end
end)

UserInputService.InputBegan:Connect(function(input, isTyping)
	if isTyping then return end
	if input.KeyCode == Enum.KeyCode.L then
		setVisible(not MainFrame.Visible)
	end
end)

print("[killcam_skin] شغّال")
