

    textBox.Position = UDim2.new(0.05, 0, 0, posY + 20)
    textBox.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.PlaceholderText = placeholder
    textBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
    textBox.Text = ""
    textBox.TextSize = 12
    textBox.Font = Enum.Font.Gotham
    textBox.ClearTextOnFocus 
ListLabel.TextXAlignment = Enum.TextXAlignment.Right
ListLabel.Parent = PageSkins

local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Size = UDim2.new(.9, 0, 0, 150)
PlayerList.Position = UDim2.new(0.05, 0, 0
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
