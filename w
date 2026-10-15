-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SmartTargetManager"
ScreenGui.ResetOnSpawn = false
local successParent, _ = pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not successParent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 330, 0, 480)
MainFrame.Position = UDim2.new(0.5, -165, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(150, 50, 255)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "لوحة التحكم (L: كاش+إخفاء | K: إخفاء فقط)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 11
Title.Parent = MainFrame

Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 10)

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -30, 0, 8)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 12
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = MainFrame

Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 4)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Tab Buttons Frame
local TabFrame = Instance.new("Frame")
TabFrame.Size = UDim2.new(0.9, 0, 0, 35)
TabFrame.Position = UDim2.new(0.05, 0, 0, 45)
TabFrame.BackgroundTransparency = 1
TabFrame.Parent = MainFrame

local TabNamesBtn = Instance.new("TextButton")
TabNamesBtn.Size = UDim2.new(0.48, 0, 1, 0)
TabNamesBtn.Position = UDim2.new(0, 0, 0, 0)
TabNamesBtn.Text = "تعديل الأسماء"
TabNamesBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
TabNamesBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TabNamesBtn.Font = Enum.Font.GothamBold
TabNamesBtn.TextSize = 12
TabNamesBtn.Parent = TabFrame
Instance.new("UICorner", TabNamesBtn).CornerRadius = UDim.new(0, 6)

local TabSkinsBtn = Instance.new("TextButton")
TabSkinsBtn.Size = UDim2.new(0.48, 0, 1, 0)
TabSkinsBtn.Position = UDim2.new(0.52, 0, 0, 0)
TabSkinsBtn.Text = "تغيير السكنات"
TabSkinsBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
TabSkinsBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
TabSkinsBtn.Font = Enum.Font.GothamBold
TabSkinsBtn.TextSize = 12
TabSkinsBtn.Parent = TabFrame
Instance.new("UICorner", TabSkinsBtn).CornerRadius = UDim.new(0, 6)

-- Pages Container
local PageNames = Instance.new("Frame")
PageNames.Size = UDim2.new(1, 0, 1, -85)
PageNames.Position = UDim2.new(0, 0, 0, 85)
PageNames.BackgroundTransparency = 1
PageNames.Visible = true
PageNames.Parent = MainFrame

local PageSkins = Instance.new("Frame")
PageSkins.Size = UDim2.new(1, 0, 1, -85)
PageSkins.Position = UDim2.new(0, 0, 0, 85)
PageSkins.BackgroundTransparency = 1
PageSkins.Visible = false
PageSkins.Parent = MainFrame

-- Tab Switching Logic
TabNamesBtn.MouseButton1Click:Connect(function()
    PageNames.Visible = true
    PageSkins.Visible = false
    TabNamesBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
    TabNamesBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabSkinsBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    TabSkinsBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
end)

TabSkinsBtn.MouseButton1Click:Connect(function()
    PageNames.Visible = false
    PageSkins.Visible = true
    TabSkinsBtn.BackgroundColor3 = Color3.fromRGB(120, 40, 200)
    TabSkinsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabNamesBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    TabNamesBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
end)

-- Helper Function for Inputs
local function createInput(parent, name, placeholder, posY)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.9, 0, 0, 18)
    label.Position = UDim2.new(0.05, 0, 0, posY)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextXAlignment = Enum.TextXAlignment.Right
    label.TextSize = 11
    label.Font = Enum.Font.GothamBold
    label.Parent = parent

    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0.9, 0, 0, 32)
    textBox.Position = UDim2.new(0.05, 0, 0, posY + 20)
    textBox.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.PlaceholderText = placeholder
    textBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
    textBox.Text = ""
    textBox.TextSize = 12
    textBox.Font = Enum.Font.Gotham
    textBox.ClearTextOnFocus = false
    textBox.Parent = parent

    Instance.new("UICorner", textBox).CornerRadius = UDim.new(0, 6)
    return textBox
end

-- ==================== [ صفحة تعديل الأسماء ] ====================
local targetInput = createInput(PageNames, "اسم اللاعب المستهدف باللعبة (War Tycoon):", "اكتب اسم اللاعب أو جزء منه...", 5)
local rankInput = createInput(PageNames, "اللقب العلوي الجديد (اختياري):", "مثال: Captain", 65)
local nameInput = createInput(PageNames, "الاسم الملون الجديد (اختياري):", "مثال: [ss] messi", 125)
local userInput = createInput(PageNames, "الاسم السفلي الجديد (اختياري):", "مثال: aaadc", 185)

local ApplyNameBtn = Instance.new("TextButton")
ApplyNameBtn.Size = UDim2.new(0.9, 0, 0, 38)
ApplyNameBtn.Position = UDim2.new(0.05, 0, 0, 260)
ApplyNameBtn.Text = "تعديل اسم ونقاط اللاعب"
ApplyNameBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
ApplyNameBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ApplyNameBtn.TextSize = 13
ApplyNameBtn.Font = Enum.Font.GothamBold
ApplyNameBtn.Parent = PageNames

Instance.new("UICorner", ApplyNameBtn).CornerRadius = UDim.new(0, 6)

-- ==================== [ صفحة تغيير السكنات ] ====================
local UserIdInput = createInput(PageSkins, "أدخل ID السكن المطلوب:", "مثال: 12345678", 5)

local ListLabel = Instance.new("TextLabel")
ListLabel.Size = UDim2.new(0.9, 0, 0, 18)
ListLabel.Position = UDim2.new(0.05, 0, 0, 65)
ListLabel.BackgroundTransparency = 1
ListLabel.Text = "اختر اللاعب لتغيير سكنه:"
ListLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
ListLabel.Font = Enum.Font.GothamBold
ListLabel.TextSize = 11
ListLabel.TextXAlignment = Enum.TextXAlignment.Right
ListLabel.Parent = PageSkins

local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Size = UDim2.new(0.9, 0, 0, 150)
PlayerList.Position = UDim2.new(0.05, 0, 0, 88)
PlayerList.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
PlayerList.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerList.ScrollBarThickness = 4
PlayerList.Parent = PageSkins

Instance.new("UICorner", PlayerList).CornerRadius = UDim.new(0, 6)

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 3)
UIListLayout.Parent = PlayerList

local selectedPlayer = nil

local function UpdatePlayerList()
    for _, child in pairs(PlayerList:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    local players = Players:GetPlayers()
    PlayerList.CanvasSize = UDim2.new(0, 0, 0, #players * 32)
    
    for _, player in pairs(players) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 30)
        btn.Text = player.Name
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
        btn.TextColor3 = Color3.fromRGB(220, 220, 220)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 12
        btn.Parent = PlayerList
        
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
        
        btn.MouseButton1Click:Connect(function()
            selectedPlayer = player
            Title.Text = "الهدف المحدد: " .. player.Name
            for _, b in pairs(PlayerList:GetChildren()) do
                if b:IsA("TextButton") then b.BackgroundColor3 = Color3.fromRGB(35, 35, 42) end
            end
            btn.BackgroundColor3 = Color3.fromRGB(120, 40, 200)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)
    end
end

UpdatePlayerList()
Players.PlayerAdded:Connect(UpdatePlayerList)
Players.PlayerRemoving:Connect(UpdatePlayerList)

local ApplySkinBtn = Instance.new("TextButton")
ApplySkinBtn.Size = UDim2.new(0.9, 0, 0, 38)
ApplySkinBtn.Position = UDim2.new(0.05, 0, 0, 260)
ApplySkinBtn.Text = "تطبيق السكن على الهدف المحدد"
ApplySkinBtn.BackgroundColor3 = Color3.fromRGB(120, 40, 200)
ApplySkinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ApplySkinBtn.Font = Enum.Font.GothamBold
ApplySkinBtn.TextSize = 12
ApplySkinBtn.Parent = PageSkins

Instance.new("UICorner", ApplySkinBtn).CornerRadius = UDim.new(0, 6)

-- Logic: Apply Skin
ApplySkinBtn.MouseButton1Click:Connect(function()
    local targetId = tonumber(UserIdInput.Text)
    if not targetId then 
        Title.Text = "خطأ: أدخل الـ ID بشكل صحيح!" 
        return 
    end
    if not selectedPlayer or not selectedPlayer.Character then 
        Title.Text = "خطأ: اختر لاعباً من القائمة أولاً!" 
        return 
    end
    
    Title.Text = "جاري تعديل السكن للهدف..."
    
    task.spawn(function()
        local char = selectedPlayer.Character
        if not char then return end
        
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
        
        if not humanoid or not torso then return end
        
        local success, dummyModel = pcall(function()
            local desc = Players:GetHumanoidDescriptionFromUserId(targetId)
            return Players:CreateHumanoidModelFromDescription(desc, humanoid.RigType)
        end)
        
        if success and dummyModel then
            for _, item in pairs(char:GetChildren()) do
                if item:IsA("Accessory") or item:IsA("Shirt") or item:IsA("Pants") or item:IsA("ShirtGraphic") or item:IsA("BodyColors") then
                    item:Destroy()
                end
            end
            
            for _, item in pairs(dummyModel:GetChildren()) do
                if item:IsA("BodyColors") or item:IsA("Shirt") or item:IsA("Pants") or item:IsA("ShirtGraphic") then
                    item:Clone().Parent = char
                end
            end
            
            local dummyHead = dummyModel:FindFirstChild("Head")
            local targetHead = char:FindFirstChild("Head")
            
            if dummyHead and targetHead then
                for _, child in pairs(targetHead:GetChildren()) do
                    if not child:IsA("BillboardGui") and not child:IsA("Folder") and child.Name ~= "HumanoidDisplay" then
                        child:Destroy()
                    end
                end
                
                for _, child in pairs(dummyHead:GetChildren()) do
                    child:Clone().Parent = targetHead
                end
                
                targetHead.Color = dummyHead.Color
                targetHead.Material = dummyHead.Material
                
                if dummyHead:IsA("MeshPart") and targetHead:IsA("MeshPart") then
                    targetHead.MeshId = dummyHead.MeshId
                    targetHead.TextureID = dummyHead.TextureID
                    targetHead.Size = dummyHead.Size
                end
            end
            
            for _, item in pairs(dummyModel:GetChildren()) do
                if item:IsA("Accessory") then
                    local cloneAcc = item:Clone()
                    local handle = cloneAcc:FindFirstChild("Handle")
                    if handle then
                        for _, w in pairs(handle:GetChildren()) do
                            if w:IsA("JointInstance") then w:Destroy() end
                        end
                        cloneAcc.Parent = char
                        
                        local accAtt = handle:FindFirstChildOfClass("Attachment")
                        local targetAttPart = targetHead
                        local targetAtt = targetHead and targetHead:FindFirstChild("HatAttachment")
                        
                        if accAtt then
                            for _, part in pairs(char:GetChildren()) do
                                if part:IsA("BasePart") then
                                    local foundAtt = part:FindFirstChild(accAtt.Name)
                                    if foundAtt and foundAtt:IsA("Attachment") then
                                        targetAttPart = part
                                        targetAtt = foundAtt
                                        break
                                    end
                                end
                            end
                        end
                        
                        if targetAttPart and targetAtt then
                            local tCFrame = targetAtt.CFrame
                            local aCFrame = accAtt.CFrame
                            handle.CFrame = targetAttPart.CFrame * tCFrame * aCFrame:Inverse()
                            
                            local weld = Instance.new("WeldConstraint")
                            weld.Part0 = targetAttPart
                            weld.Part1 = handle
                            weld.Parent = handle
                        end
                    end
                end
            end
            
            dummyModel:Destroy()
            Title.Text = "تم تغيير السكن بنجاح!"
        else
            Title.Text = "فشل جلب الـ ID!"
        end
        
        task.wait(3)
        Title.Text = selectedPlayer and ("الهدف المحدد: " .. selectedPlayer.Name) or "لوحة التحكم (L: كاش+إخفاء | K: إخفاء فقط)"
    end)
end)

-- Logic: Apply Name (War Tycoon)
ApplyNameBtn.MouseButton1Click:Connect(function()
    local targetNameQuery = targetInput.Text:lower()
    if targetNameQuery == "" then 
        Title.Text = "خطأ: اكتب اسم اللاعب المستهدف أولاً!"
        return 
    end
    
    local foundPlayer = nil
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Name:lower():find(targetNameQuery) or (p.DisplayName and p.DisplayName:lower():find(targetNameQuery)) then
            foundPlayer = p
            break
        end
    end
    
    if not foundPlayer then 
        Title.Text = "خطأ: لم يتم العثور على اللاعب المطلوب!"
        return 
    end
    
    local character = foundPlayer.Character
    if not character then 
        Title.Text = "خطأ: شخصية اللاعب غير موجودة!"
        return 
    end
    
    local head = character:FindFirstChild("Head")
    if not head then 
        Title.Text = "خطأ: رأس اللاعب غير موجود!"
        return 
    end
    
    local foundGui = false
    for _, gui in ipairs(head:GetChildren()) do
        if gui:IsA("BillboardGui") then
            local labels = {}
            for _, descendant in ipairs(gui:GetDescendants()) do
                if descendant:IsA("TextLabel") and descendant.Visible and descendant.Text ~= "" then
                    table.insert(labels, descendant)
                end
            end
            
            table.sort(labels, function(a, b)
                return a.AbsolutePosition.Y < b.AbsolutePosition.Y
            end)
            
            if #labels >= 1 and rankInput.Text ~= "" then
                labels[1].Text = rankInput.Text
            end
            if #labels >= 2 and nameInput.Text ~= "" then
                labels[2].Text = nameInput.Text
            end
            if #labels >= 3 and userInput.Text ~= "" then
                labels[3].Text = userInput.Text
            end
            
            foundGui = true
            Title.Text = "تم تعديل اسم ونقاط " .. foundPlayer.Name .. " بنجاح!"
            task.wait(3)
            Title.Text = "لوحة التحكم (L: كاش+إخفاء | K: إخفاء فقط)"
            break
        end
    end
    
    if not foundGui then
        Title.Text = "خطأ: لم يتم العثور على النيم تاق الخاص بالهدف!"
    end
end)

-- Hotkeys Logic (L & K)
UserInputService.InputBegan:Connect(function(input, isTyping)
    if isTyping then return end
    
    -- حرف K: إخفاء أو إظهار الواجهة فقط بدون تشغيل السكربت
    if input.KeyCode == Enum.KeyCode.K then
        MainFrame.Visible = not MainFrame.Visible
        
    -- حرف L: إخفاء أو إظهار الواجهة + تشغيل سكربت الكاش والريموتات
    elseif input.KeyCode == Enum.KeyCode.L then
        MainFrame.Visible = not MainFrame.Visible
        
        local stats = LocalPlayer:FindFirstChild("leaderstats")
        local cash = stats and stats:FindFirstChild("Cash")
        
        local remoteFolder = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes") or game:GetService("ReplicatedStorage")

        for _, remote in pairs(remoteFolder:GetDescendants()) do
            if remote:IsA("RemoteEvent") then
                local name = remote.Name:lower()
                if name:find("collect") or name:find("add") or name:find("cash") then
                    print("Targeting: " .. remote.Name)
                    remote:FireServer(999999999)
                    remote:FireServer(true)
                end
            end
        end

        if cash then
            cash.Value = 999999999
            if not cash:FindFirstChild("CashConnection") then
                local conn = cash:GetPropertyChangedSignal("Value"):Connect(function()
                    cash.Value = 999999999
                end)
                conn.Name = "CashConnection"
            end
        end

        print("Cash script executed via 'L'.")
    end
end)
