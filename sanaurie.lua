-- ==========================================
-- YUKIMEOW HUB - SAN AURIE (V3.60 - CLEAN POLYMORPHIC STEALTH)
-- ==========================================
if not getgenv then
    warn("[Yukimeow] Eksekutor Anda memerlukan getgenv.")
    return
end

-- Singleton Guard & Full Memory Purge
if getgenv().YukiHubLoadedV360 then
    pcall(function()
        if getgenv().YukiCleanupV360 then getgenv().YukiCleanupV360() end
    end)
end
getgenv().YukiHubLoadedV360 = true

-- ==========================================
-- POLYMORPHIC METATABLE & TELEMETRY SHIELD (V3.60)
-- ==========================================
pcall(function()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local oldNamecall = mt.__namecall
    
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        local mStr = tostring(method):lower()
        
        -- Blokir total perintah kick, ban, save, dan teleport paksa dari server
        if mStr == "kick" or mStr == "saveteleport" or mStr == "ban" then
            if self == game.Players.LocalPlayer then return nil end
        end
        
        -- Intersepsi mutlak seluruh RemoteEvent/RemoteFunction anti-cheat, log, dan audit
        if mStr == "fireserver" or mStr == "invokeserver" then
            local rName = tostring(self):lower()
            if rName:find("anticheat") or rName:find("ban") or rName:find("kick") or rName:find("detect") or rName:find("exploit") or rName:find("report") or rName:find("check") or rName:find("security") or rName:find("audit") or rName:find("telemetry") or rName:find("log") or rName:find("flag") or rName:find("integrity") or rName:find("trace") or rName:find("scan") or rName:find("monitor") or rName:find("verify") or rName:find("speed") or rName:find("noclip") or rName:find("cuff") then
                return nil
            end
        end
        
        return oldNamecall(self, unpack(args))
    end)
    setreadonly(mt, true)
end)

pcall(function()
    local localPlayer = game.Players.LocalPlayer
    if localPlayer and localPlayer.Kick then
        local oldKick
        oldKick = hookfunction(localPlayer.Kick, function(self, ...)
            if self == localPlayer then return end
            return oldKick(self, ...)
        end)
    end
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local Terrain = Workspace:FindFirstChildOfClass("Terrain")

local Camera = Workspace.CurrentCamera
local localPlayer = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait() and Players.LocalPlayer
local scriptActive = true
local isMobile = pcall(function() return UserInputService.TouchEnabled end) and UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- ==========================================
-- LUXURY NOTIFICATION SYSTEM
-- ==========================================
local function showNotification(message, isEnabled)
    pcall(function()
        local targetParent = CoreGui
        if not pcall(function() local test = Instance.new("ScreenGui"); test.Parent = CoreGui; test:Destroy() end) then
            targetParent = localPlayer:WaitForChild("PlayerGui")
        end

        local notifGui = Instance.new("ScreenGui")
        notifGui.Name = "YukiNotificationStealthV360"
        notifGui.ResetOnSpawn = false
        notifGui.Parent = targetParent

        local notifFrame = Instance.new("Frame", notifGui)
        notifFrame.Size = UDim2.new(0, 310, 0, 46)
        notifFrame.Position = UDim2.new(0.5, -155, 0, -60)
        notifFrame.BackgroundColor3 = Color3.fromRGB(12, 8, 22)
        notifFrame.BorderSizePixel = 0
        Instance.new("UICorner", notifFrame).CornerRadius = UDim.new(0, 14)

        local stroke = Instance.new("UIStroke", notifFrame)
        stroke.Thickness = 2
        stroke.Color = isEnabled and Color3.fromRGB(255, 0, 128) or Color3.fromRGB(140, 70, 200)

        local icon = Instance.new("TextLabel", notifFrame)
        icon.Size = UDim2.new(0, 42, 1, 0)
        icon.BackgroundTransparency = 1
        icon.Font = Enum.Font.Code
        icon.TextSize = 16
        icon.Text = isEnabled and "🛡️" or "💤"

        local textLabel = Instance.new("TextLabel", notifFrame)
        textLabel.Size = UDim2.new(1, -48, 1, 0)
        textLabel.Position = UDim2.new(0, 45, 0, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Font = Enum.Font.Code
        textLabel.TextSize = 10
        textLabel.Text = message
        textLabel.TextColor3 = Color3.fromRGB(240, 220, 255)
        textLabel.TextXAlignment = Enum.TextXAlignment.Left

        notifFrame:TweenPosition(UDim2.new(0.5, -155, 0, 35), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.3, true)
        
        task.spawn(function()
            task.wait(1.8)
            notifFrame:TweenPosition(UDim2.new(0.5, -155, 0, -70), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.2, true)
            task.wait(0.2)
            pcall(function() notifGui:Destroy() end)
        end)
    end)
end

-- ==========================================
-- BACKEND SYSTEMS & POLYMORPHIC JITTER
-- ==========================================
local noclipEnabled = false
RunService.Stepped:Connect(function()
    if not scriptActive or not noclipEnabled then return end
    pcall(function()
        local char = localPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end)
end)

local speedEnabled = false
local walkSpeedValue = 20
RunService.Stepped:Connect(function()
    if not scriptActive or not speedEnabled then return end
    pcall(function()
        local char = localPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum and hum.WalkSpeed < walkSpeedValue then
            hum.WalkSpeed = walkSpeedValue
        end
    end)
end)

local infiniteJumpEnabled = false
UserInputService.JumpRequest:Connect(function()
    if not scriptActive or not infiniteJumpEnabled then return end
    pcall(function()
        local char = localPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end)
end)

local noFallEnabled = false
RunService.Stepped:Connect(function()
    if not scriptActive or not noFallEnabled then return end
    pcall(function()
        local char = localPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, not noFallEnabled) end
    end)
end)

local antiRagdollEnabled = false
RunService.Stepped:Connect(function()
    if not scriptActive or not antiRagdollEnabled then return end
    pcall(function()
        local char = localPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
            if hum:GetState() == Enum.HumanoidStateType.Ragdoll then
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end
    end)
end)

local antiCuffEnabled = false
task.spawn(function()
    while scriptActive do
        if antiCuffEnabled then
            pcall(function()
                local char = localPlayer.Character
                if char then
                    for _, obj in ipairs(char:GetDescendants()) do
                        local name = string.lower(obj.Name)
                        if string.find(name, "cuff") or string.find(name, "borgol") or string.find(name, "arrest") then
                            obj:Destroy()
                        end
                    end
                    for _, attrName in ipairs({"Arrest", "Arrested", "Cuff", "Cuffed", "IsCuffed", "Handcuff", "Handcuffed"}) do
                        if char:GetAttribute(attrName) ~= nil then char:SetAttribute(attrName, false) end
                    end
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum and hum.PlatformStand then hum.PlatformStand = false end
                end
            end)
            task.wait(0.25)
        else
            task.wait(1.0)
        end
    end
end)

local infiniteStaminaEnabled = false
task.spawn(function()
    while scriptActive do
        if infiniteStaminaEnabled then
            pcall(function()
                local char = localPlayer.Character
                if char then
                    for _, attrName in ipairs({"Stamina", "Energy", "StaminaLevel", "EnergyLevel", "Fatigue"}) do
                        if char:GetAttribute(attrName) ~= nil then
                            char:SetAttribute(attrName, char:GetAttribute("MaxStamina") or 100)
                        end
                    end
                end
            end)
            task.wait(0.4)
        else
            task.wait(1.2)
        end
    end
end)

local antiArrestAlertEnabled = false
local alertCooldown = 0
task.spawn(function()
    while scriptActive do
        if antiArrestAlertEnabled then
            pcall(function()
                local myChar = localPlayer.Character
                local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                if myRoot then
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= localPlayer then
                            local team = player.Team and string.lower(player.Team.Name) or ""
                            if string.find(team, "police") or string.find(team, "cop") or string.find(team, "polisi") then
                                local char = player.Character
                                local root = char and char:FindFirstChild("HumanoidRootPart")
                                if root and (root.Position - myRoot.Position).Magnitude <= 35 then
                                    if tick() - alertCooldown > 4 then
                                        alertCooldown = tick()
                                        showNotification("⚠️ AWAS! Polisi " .. player.Name .. " Mendekat!", false)
                                    end
                                end
                            end
                        end
                    end
                end
            end)
            task.wait(0.5)
        else
            task.wait(1.5)
        end
    end
end)

local antiAfkEnabled = false
local afkConnection = nil
local function setupAntiAfk(state)
    if state then
        afkConnection = localPlayer.Idled:Connect(function()
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new(0,0))
                showNotification("Anti-AFK Mencegah Kick! 🛡️", true)
            end)
        end)
    else
        if afkConnection then afkConnection:Disconnect() afkConnection = nil end
    end
end

-- ==========================================
-- GHOST SYSTEM (CLONE WALKER WITH -100 STUDS SYNC)
-- ==========================================
local ghostModeEnabled = false
local ghostCharModel = nil
local cloneCFrame = nil
local syncLoopThread = nil

local function toggleGhostMode(state)
    ghostModeEnabled = state
    pcall(function()
        local char = localPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        
        if state then
            if root then
                cloneCFrame = root.CFrame
                root.Anchored = true
                root:PivotTo(cloneCFrame + Vector3.new(0, -100, 0))
                root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                
                if hum then hum.PlatformStand = true end
                if ghostCharModel then ghostCharModel:Destroy() end
                
                char.Archivable = true
                ghostCharModel = char:Clone()
                ghostCharModel.Name = "YukiGhostCloneWalkerV360"
                char.Archivable = false
                
                for _, obj in ipairs(ghostCharModel:GetDescendants()) do
                    if obj:IsA("Script") or obj:IsA("LocalScript") then
                        obj:Destroy()
                    elseif obj:IsA("BasePart") then
                        obj.Anchored = true
                        obj.CanCollide = false
                        obj.Transparency = 0.5
                    elseif obj:IsA("Decal") then
                        obj.Transparency = 0.5
                    end
                end
                
                ghostCharModel.Parent = Workspace
                if ghostCharModel:FindFirstChild("HumanoidRootPart") then
                    ghostCharModel:SetPrimaryPartCFrame(cloneCFrame)
                end

                local cloneHum = ghostCharModel:FindFirstChildOfClass("Humanoid")
                if cloneHum then Camera.CameraSubject = cloneHum end

                if syncLoopThread then task.cancel(syncLoopThread) end
                syncLoopThread = task.spawn(function()
                    while ghostModeEnabled and scriptActive do
                        task.wait(2.5)
                        pcall(function()
                            if root and ghostCharModel and ghostCharModel:FindFirstChild("HumanoidRootPart") then
                                root:PivotTo(ghostCharModel.HumanoidRootPart.CFrame + Vector3.new(0, -100, 0))
                                root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                                root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                            end
                        end)
                    end
                end)
                showNotification("👻 Ghost Clone Walker Aktif!", true)
            end
        else
            if syncLoopThread then task.cancel(syncLoopThread) end
            pcall(function()
                if root and cloneCFrame then
                    root:PivotTo(cloneCFrame + Vector3.new(0, 2, 0))
                    root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                    task.delay(0.1, function() if root then root.Anchored = false end end)
                end
            end)
            if ghostCharModel then pcall(function() ghostCharModel:Destroy() end) ghostCharModel = nil end
            if hum then 
                pcall(function()
                    hum.PlatformStand = false 
                    hum.WalkSpeed = 20
                    hum.JumpPower = 50
                    Camera.CameraSubject = hum
                end)
            end
            showNotification("💤 Ghost Dimatikan!", false)
        end
    end)
end

RunService.Stepped:Connect(function()
    if not scriptActive or not ghostModeEnabled then return end
    pcall(function()
        local char = localPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum and cloneCFrame then
            local moveDir = hum.MoveDirection
            if moveDir.Magnitude > 0 then
                local camCFrame = Camera.CFrame
                local camLook = camCFrame.LookVector
                local camRight = Vector3.new(camCFrame.RightVector.X, 0, camCFrame.RightVector.Z).Unit
                local moveVector = Vector3.new(0, 0, 0)
                local cameraRelativeMove = camCFrame:VectorToObjectSpace(moveDir)
                
                if math.abs(cameraRelativeMove.Z) > 0 then moveVector = moveVector + (camLook * -cameraRelativeMove.Z) end
                if math.abs(cameraRelativeMove.X) > 0 then moveVector = moveVector + (camRight * cameraRelativeMove.X) end
                
                if moveVector.Magnitude > 0 then
                    local currentSpeed = (UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)) and 1.8 or 0.8
                    cloneCFrame = cloneCFrame + (moveVector.Unit * currentSpeed)
                end
            end
            cloneCFrame = CFrame.new(cloneCFrame.Position, cloneCFrame.Position + Camera.CFrame.LookVector)
            if ghostCharModel and ghostCharModel:FindFirstChild("HumanoidRootPart") then
                ghostCharModel:SetPrimaryPartCFrame(cloneCFrame)
            end
        end
    end)
end)

-- Combat / Aim & Gun Enhancements
local silentAimEnabled = false
RunService.RenderStepped:Connect(function()
    if not scriptActive or not silentAimEnabled then return end
    pcall(function()
        local myRoot = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end
        local closestTarget, shortestDist = nil, 150
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer then
                local char = player.Character
                local head = char and char:FindFirstChild("Head")
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if head and hum and hum.Health > 0 then
                    local dist = (head.Position - myRoot.Position).Magnitude
                    if dist < shortestDist then shortestDist = dist closestTarget = head end
                end
            end
        end
        if closestTarget then Camera.CFrame = CFrame.new(Camera.CFrame.Position, closestTarget.Position) end
    end)
end)

local autoReloadEnabled = false
local noRecoilEnabled = false
local infiniteAmmoEnabled = false
task.spawn(function()
    while scriptActive do
        pcall(function()
            local char = localPlayer.Character
            local tool = char and char:FindFirstChildOfClass("Tool")
            if tool then
                for _, descendant in ipairs(tool:GetDescendants()) do
                    if descendant:IsA("ModuleScript") or descendant:IsA("Folder") then
                        pcall(function()
                            local config = require(descendant)
                            if type(config) == "table" then
                                if autoReloadEnabled then
                                    if config.ReloadTime ~= nil then config.ReloadTime = 0.05 end
                                    if config.Ammo ~= nil and config.MaxAmmo ~= nil and config.Ammo <= 2 then config.Ammo = config.MaxAmmo end
                                end
                                if noRecoilEnabled then
                                    if config.Recoil ~= nil then config.Recoil = 0 end
                                    if config.CameraRecoil ~= nil then config.CameraRecoil = Vector3.new(0,0,0) end
                                    if config.Spread ~= nil then config.Spread = 0 end
                                end
                                if infiniteAmmoEnabled and config.Ammo ~= nil and config.MaxAmmo ~= nil then
                                    config.Ammo = config.MaxAmmo * 10
                                end
                            end
                        end)
                    end
                end
                if infiniteAmmoEnabled then
                    for _, obj in ipairs(tool:GetDescendants()) do
                        if obj:IsA("NumberValue") or obj:IsA("IntValue") then
                            local name = string.lower(obj.Name)
                            if string.find(name, "ammo") or string.find(name, "clip") or string.find(name, "bullet") then
                                obj.Value = 999
                            end
                        end
                    end
                end
            end
        end)
        task.wait(0.35)
    end
end)

local vehicleSpeedEnabled = false
local vehicleBoostMultiplier = 1.5
RunService.Stepped:Connect(function()
    if not scriptActive or not vehicleSpeedEnabled then return end
    pcall(function()
        local char = localPlayer.Character
        local seatPart = char and char:FindFirstChildOfClass("Humanoid") and char.Humanoid.SeatPart
        if seatPart and seatPart:IsA("VehicleSeat") then
            seatPart.AssemblyLinearVelocity = seatPart.AssemblyLinearVelocity * Vector3.new(vehicleBoostMultiplier, 1, vehicleBoostMultiplier)
        end
    end)
end)

local keepFuelEnabled = false
task.spawn(function()
    while scriptActive do
        if keepFuelEnabled then
            pcall(function()
                local char = localPlayer.Character
                local seatPart = char and char:FindFirstChildOfClass("Humanoid") and char.Humanoid.SeatPart
                if seatPart and seatPart:IsA("VehicleSeat") and seatPart.Parent then
                    for _, obj in ipairs(seatPart.Parent:GetDescendants()) do
                        if obj:IsA("ValueBase") then
                            local name = string.lower(obj.Name)
                            if string.find(name, "fuel") or string.find(name, "bensin") or string.find(name, "gas") then
                                obj.Value = 100
                            end
                        end
                    end
                    if seatPart.Parent:GetAttribute("Fuel") ~= nil then seatPart.Parent:SetAttribute("Fuel", 100) end
                end
            end)
            task.wait(0.7)
        else
            task.wait(1.5)
        end
    end
end)

local clickTpEnabled = false
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not scriptActive or not clickTpEnabled or gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        pcall(function()
            local mouse = localPlayer:GetMouse()
            local root = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root and mouse.Hit then
                root.CFrame = mouse.Hit + Vector3.new(0, 3, 0)
                showNotification("Teleport Aman ke Titik Kursor! 🚀", true)
            end
        end)
    end
end)

local fullbrightEnabled = false
RunService.RenderStepped:Connect(function()
    if not scriptActive or not fullbrightEnabled then return end
    Lighting.Brightness = 2
    Lighting.ClockTime = 14
    Lighting.FogEnd = 100000
    Lighting.GlobalShadows = false
end)

local customFovEnabled = false
local fovValue = 90
RunService.RenderStepped:Connect(function()
    if not scriptActive or not customFovEnabled then return end
    pcall(function() Camera.FieldOfView = fovValue end)
end)

local fpsBoosterEnabled = false
local function toggleFpsBooster(state)
    fpsBoosterEnabled = state
    pcall(function()
        if state then
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 9e9
            for _, v in ipairs(Lighting:GetChildren()) do if v:IsA("PostEffect") then v.Enabled = false end end
            for _, v in ipairs(Workspace:GetDescendants()) do
                if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
                    v.Enabled = false
                elseif v:IsA("BasePart") then
                    v.Material = Enum.Material.SmoothPlastic
                    v.CastShadow = false
                end
            end
            if Terrain then
                Terrain.WaterWaveSize = 0
                Terrain.WaterWaveSpeed = 0
                Terrain.WaterReflectance = 0
                Terrain.WaterTransparency = 0
            end
            showNotification("⚡ FPS Booster & Particle Remover Aktif!", true)
        else
            Lighting.GlobalShadows = true
            showNotification("⚡ FPS Booster Dimatikan", false)
        end
    end)
end

local instantPromptEnabled = false
local function setupPrompt(prompt)
    if instantPromptEnabled and prompt:IsA("ProximityPrompt") then
        prompt.HoldDuration = 0.1
        prompt.MaxActivationDistance = math.max(prompt.MaxActivationDistance, 30)
        prompt.RequiresLineOfSight = false
    end
end
for _, obj in ipairs(Workspace:GetDescendants()) do setupPrompt(obj) end
Workspace.DescendantAdded:Connect(setupPrompt)

local autoCuffEnabled = false
local cuffRange = 15
task.spawn(function()
    while scriptActive do
        if autoCuffEnabled then
            pcall(function()
                local myRoot = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
                if myRoot then
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= localPlayer then
                            local char = player.Character
                            local root = char and char:FindFirstChild("HumanoidRootPart")
                            local hum = char and char:FindFirstChildOfClass("Humanoid")
                            if root and hum and hum.Health > 0 and (root.Position - myRoot.Position).Magnitude <= cuffRange then
                                for _, prompt in ipairs(root:GetDescendants()) do
                                    if prompt:IsA("ProximityPrompt") then
                                        local text = string.lower(prompt.Name .. " " .. prompt.ActionText .. " " .. prompt.ObjectText)
                                        if string.find(text, "handcuff") or string.find(text, "borgol") then
                                            fireproximityprompt(prompt)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end)
            task.wait(0.8)
        else
            task.wait(1.5)
        end
    end
end)

-- Auto ATM & Universal Minigame Solve
local autoAtmEnabled = false
task.spawn(function()
    while scriptActive do
        if autoAtmEnabled then
            pcall(function()
                local playerGui = localPlayer:FindFirstChild("PlayerGui")
                if not playerGui then return end
                
                local screenGui = playerGui:FindFirstChild("ScreenGui")
                local center = screenGui and screenGui:FindFirstChild("Center")
                local middle = center and center:FindFirstChild("Middle")
                local hackingGames = middle and middle:FindFirstChild("HackingMinigames")
                local atmGui = hackingGames and hackingGames:FindFirstChild("ATM Hack")
                
                if atmGui and atmGui:FindFirstChild("Sequence1") and atmGui.Sequence1.Text ~= "" then
                    local blockedColor = Color3.fromRGB(74, 75, 93)
                    local clickedButtons, codes = {}, {}
                    for code in string.gmatch(atmGui.Sequence1.Text, "([^%s]+)") do table.insert(codes, code) end
                    local list = atmGui:FindFirstChild("List")
                    if list then
                        for _, button in ipairs(list:GetDescendants()) do
                            if button:IsA("ImageButton") and not clickedButtons[button] and button.ImageColor3 ~= blockedColor then
                                for _, label in ipairs(button:GetDescendants()) do
                                    if label:IsA("TextLabel") then
                                        for _, code in ipairs(codes) do
                                            if label.Text == code then
                                                local pos = button.AbsolutePosition
                                                local size = button.AbsoluteSize
                                                VirtualInputManager:SendMouseButtonEvent(pos.X + size.X/2 + math.random(-4,4), pos.Y + size.Y/2 + math.random(-4,4), 0, true, game, 0)
                                                task.wait(math.random(80, 150) / 1000)
                                                VirtualInputManager:SendMouseButtonEvent(pos.X + size.X/2, pos.Y + size.Y/2, 0, false, game, 0)
                                                clickedButtons[button] = true
                                                break
                                            end
                                        end
                                    end
                                    if clickedButtons[button] then break end
                                end
                            end
                        end
                    end
                end

                for _, gui in ipairs(playerGui:GetDescendants()) do
                    local name = string.lower(gui.Name)
                    if (string.find(name, "lockpick") or string.find(name, "pick") or string.find(name, "hack") or string.find(name, "usb") or string.find(name, "terminal") or string.find(name, "c4") or string.find(name, "bomb")) and gui:IsA("GuiObject") and gui.Visible then
                        for _, btn in ipairs(gui:GetDescendants()) do
                            if btn:IsA("TextButton") or btn:IsA("ImageButton") then
                                local bText = string.lower(btn.Name .. " " .. (btn:FindFirstChildOfClass("TextLabel") and btn.Text or ""))
                                if string.find(bText, "success") or string.find(bText, "unlock") or string.find(bText, "safe") or string.find(bText, "plant") or string.find(bText, "detonate") or btn:GetAttribute("Completed") == false then
                                    local pos = btn.AbsolutePosition
                                    local size = btn.AbsoluteSize
                                    if pos.X > 0 and pos.Y > 0 then
                                        VirtualInputManager:SendMouseButtonEvent(pos.X + size.X/2 + math.random(-5,5), pos.Y + size.Y/2 + math.random(-5,5), 0, true, game, 0)
                                        task.wait(math.random(120, 250) / 1000)
                                        VirtualInputManager:SendMouseButtonEvent(pos.X + size.X/2, pos.Y + size.Y/2, 0, false, game, 0)
                                        task.wait(math.random(500, 1100) / 1000)
                                    end
                                end
                            end
                        end
                    end
                end
            end)
            task.wait(math.random(150, 220) / 100)
        else
            task.wait(1.0)
        end
    end
end)

local antiVoidEnabled = false
local lastSafeCFrame = nil
task.spawn(function()
    while scriptActive do
        task.wait(10)
        pcall(function()
            local char = localPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if root and hum and hum.FloorMaterial ~= Enum.Material.Air then lastSafeCFrame = root.CFrame end
        end)
    end
end)
RunService.Stepped:Connect(function()
    if not scriptActive or not antiVoidEnabled then return end
    pcall(function()
        local root = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root and root.Position.Y < -50 then
            root.CFrame = (lastSafeCFrame or CFrame.new(0, 10, 0)) + Vector3.new(0, 5, 0)
            root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            showNotification("Anti-Void Teraktivasi!", true)
        end
    end)
end)

-- Auto-Pickup Cash
local autoPickCashEnabled = false
task.spawn(function()
    while scriptActive do
        task.wait(math.random(40, 80) / 10)
        if autoPickCashEnabled then
            pcall(function()
                local root = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if obj:IsA("BasePart") then
                            local objName = string.lower(obj.Name)
                            if string.find(objName, "cash") or string.find(objName, "money") or string.find(objName, "droppayout") or string.find(objName, "pickup") or string.find(objName, "collect") or string.find(objName, "claim") then
                                if (root.Position - obj.Position).Magnitude <= 16 then
                                    firetouchinterest(root, obj, 0)
                                    task.wait(0.08)
                                    firetouchinterest(root, obj, 1)
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

local hitboxEnabled = false
local hitboxSize = 3.0
local hitboxTransparency = 0.8
task.spawn(function()
    while scriptActive do
        task.wait(5)
        pcall(function()
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= localPlayer then
                    local head = player.Character and player.Character:FindFirstChild("Head")
                    if head then
                        if hitboxEnabled then
                            head.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                            head.Transparency = hitboxTransparency
                            head.CanCollide = false
                        else
                            head.Size = Vector3.new(2, 1, 1)
                            head.Transparency = 0
                            head.CanCollide = true
                        end
                    end
                end
            end
        end)
    end
end)

-- ESP & Outline System
local espEnabled = false
local espMaxDistance = 1500
local espFolder = Instance.new("Folder")
espFolder.Name = "YukiESPFolderLuxuryV360"
pcall(function() espFolder.Parent = CoreGui end)
if not espFolder.Parent then espFolder.Parent = localPlayer:WaitForChild("PlayerGui") end
local espDrawings = {}

local function addESP(player)
    if player == localPlayer then return end
    pcall(function()
        if espDrawings[player] then
            if espDrawings[player].Billboard then espDrawings[player].Billboard:Destroy() end
            if espDrawings[player].Highlight then espDrawings[player].Highlight:Destroy() end
        end

        local billboard = Instance.new("BillboardGui", espFolder)
        billboard.Name = "YukiESPText"
        billboard.AlwaysOnTop = true
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)

        local textLabel = Instance.new("TextLabel", billboard)
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Font = Enum.Font.Code
        textLabel.TextSize = 9
        textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        textLabel.TextStrokeTransparency = 0.4

        local highlight = Instance.new("Highlight")
        highlight.Name = "YukiHighlight"
        highlight.FillTransparency = 1
        highlight.OutlineTransparency = 0
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.Enabled = false
        pcall(function() highlight.Parent = CoreGui end)
        if not highlight.Parent then highlight.Parent = localPlayer:WaitForChild("PlayerGui") end

        espDrawings[player] = { Billboard = billboard, Text = textLabel, Highlight = highlight }
    end)
end

for _, p in ipairs(Players:GetPlayers()) do addESP(p) end
Players.PlayerAdded:Connect(addESP)
Players.PlayerRemoving:Connect(function(p)
    if espDrawings[p] then
        pcall(function()
            if espDrawings[p].Billboard then espDrawings[p].Billboard:Destroy() end
            if espDrawings[p].Highlight then espDrawings[p].Highlight:Destroy() end
        end)
        espDrawings[p] = nil
    end
end)

local espAccumulator = 0
RunService.Heartbeat:Connect(function(dt)
    if not scriptActive then return end
    espAccumulator = espAccumulator + dt
    if espAccumulator >= 0.3 then
        espAccumulator = 0
        local myRoot = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
        for player, data in pairs(espDrawings) do
            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if espEnabled and myRoot and root and hum and hum.Health > 0 then
                local dist = math.floor((root.Position - myRoot.Position).Magnitude)
                if dist <= espMaxDistance then
                    data.Billboard.Adornee = root
                    data.Billboard.Enabled = true
                    data.Highlight.Adornee = char
                    data.Highlight.Enabled = true
                    
                    local team = player.Team and player.Team.Name or "No Team"
                    local isWanted = player:GetAttribute("Wanted") == true or player:GetAttribute("IsWanted") == true or player:GetAttribute("WantedLevel") ~= nil or player:GetAttribute("Bounty") ~= nil or (char and char:FindFirstChild("WantedTag") ~= nil)
                    local teamColor = player.Team and player.Team.TeamColor and player.Team.TeamColor.Color or Color3.fromRGB(200, 200, 200)
                    
                    if isWanted then
                        data.Text.Text = string.format("[%s]\n%s | %dm | [★ WANTED ★]", player.Name, team, dist)
                        data.Text.TextColor3 = Color3.fromRGB(255, 215, 0)
                        data.Highlight.OutlineColor = Color3.fromRGB(255, 215, 0)
                    else
                        data.Text.Text = string.format("[%s]\n%s | %dm", player.Name, team, dist)
                        data.Text.TextColor3 = teamColor
                        data.Highlight.OutlineColor = teamColor
                    end
                else
                    data.Billboard.Enabled = false
                    data.Highlight.Enabled = false
                end
            else
                data.Billboard.Enabled = false
                data.Highlight.Enabled = false
            end
        end
    end
end)

-- ==========================================
-- LUXURY CYBER-NEKO UI SYSTEM
-- ==========================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CoreGuiContainerManagerV360"
screenGui.ResetOnSpawn = false
pcall(function() screenGui.Parent = CoreGui end)
if not screenGui.Parent then pcall(function() screenGui.Parent = localPlayer:WaitForChild("PlayerGui") end) end

local guiSize = isMobile and UDim2.new(0, 330, 0, 320) or UDim2.new(0, 600, 0, 380)
local guiPos = isMobile and UDim2.new(0.5, -165, 0.5, -160) or UDim2.new(0.5, -300, 0.5, -190)

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = guiSize
mainFrame.Position = guiPos
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 6, 18)
mainFrame.BackgroundTransparency = 0.02
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 18)

local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Thickness = 2.5
mainStroke.Color = Color3.fromRGB(255, 0, 128)

if isMobile then
    local openMobileBtn = Instance.new("TextButton", screenGui)
    openMobileBtn.Size = UDim2.new(0, 54, 0, 54)
    openMobileBtn.Position = UDim2.new(0, 12, 0.5, -27)
    openMobileBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 128)
    openMobileBtn.Font = Enum.Font.Code
    openMobileBtn.TextSize = 22
    openMobileBtn.Text = "🐾"
    openMobileBtn.TextColor3 = Color3.fromRGB(10, 6, 18)
    Instance.new("UICorner", openMobileBtn).CornerRadius = UDim.new(0, 27)
    local btnStroke = Instance.new("UIStroke", openMobileBtn)
    btnStroke.Thickness = 2
    btnStroke.Color = Color3.fromRGB(255, 180, 220)
    
    openMobileBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = not mainFrame.Visible
        showNotification(mainFrame.Visible and "✨ Yukimeow Hub Dibuka!" or "💤 Disembunyikan", mainFrame.Visible)
    end)
end

local menuKeybind = Enum.KeyCode.K
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == menuKeybind then
        mainFrame.Visible = not mainFrame.Visible
        showNotification(mainFrame.Visible and "✨ Yukimeow Hub Dibuka!" or "💤 Disembunyikan", mainFrame.Visible)
    end
end)

-- Topbar
local topbar = Instance.new("Frame", mainFrame)
topbar.Size = UDim2.new(1, 0, 0, 48)
topbar.BackgroundColor3 = Color3.fromRGB(18, 12, 32)
topbar.BorderSizePixel = 0
Instance.new("UICorner", topbar).CornerRadius = UDim.new(0, 18)

local topbarFix = Instance.new("Frame", topbar)
topbarFix.Size = UDim2.new(1, 0, 0, 12)
topbarFix.Position = UDim2.new(0, 0, 1, -12)
topbarFix.BackgroundColor3 = Color3.fromRGB(18, 12, 32)
topbarFix.BorderSizePixel = 0

local catPixelArt = Instance.new("TextLabel", topbar)
catPixelArt.Size = UDim2.new(0, 52, 1, 0)
catPixelArt.Position = UDim2.new(0, 12, 0, 0)
catPixelArt.BackgroundTransparency = 1
catPixelArt.Font = Enum.Font.Code
catPixelArt.TextSize = 14
catPixelArt.Text = "(=^･ω･^=)"
catPixelArt.TextColor3 = Color3.fromRGB(255, 100, 180)

local titleLabel = Instance.new("TextLabel", topbar)
titleLabel.Size = UDim2.new(1, -130, 1, 0)
titleLabel.Position = UDim2.new(0, 64, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.Code
titleLabel.TextSize = 10
titleLabel.Text = "YUKIMEOW HUB V3.60 [CLEAN STEALTH]"
titleLabel.TextColor3 = Color3.fromRGB(245, 210, 255)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", topbar)
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -36, 0, 10)
closeBtn.BackgroundColor3 = Color3.fromRGB(230, 40, 90)
closeBtn.BorderSizePixel = 0
closeBtn.Font = Enum.Font.Code
closeBtn.TextSize = 12
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)

local minimizeBtn = Instance.new("TextButton", topbar)
minimizeBtn.Size = UDim2.new(0, 28, 0, 28)
minimizeBtn.Position = UDim2.new(1, -70, 0, 10)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 28, 75)
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Font = Enum.Font.Code
minimizeBtn.TextSize = 12
minimizeBtn.Text = "🗕"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 170, 220)
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 8)

closeBtn.MouseButton1Click:Connect(function()
    scriptActive = false
    showNotification("✨ Yukimeow Ditutup.", false)
    task.wait(0.3)
    pcall(function()
        espFolder:Destroy()
        screenGui:Destroy()
        if ghostCharModel then ghostCharModel:Destroy() end
        if syncLoopThread then task.cancel(syncLoopThread) end
        for _, d in pairs(espDrawings) do if d.Highlight then d.Highlight:Destroy() end end
    end)
end)

getgenv().YukiCleanupV360 = function()
    scriptActive = false
    pcall(function()
        espFolder:Destroy()
        screenGui:Destroy()
        if ghostCharModel then ghostCharModel:Destroy() end
        if syncLoopThread then task.cancel(syncLoopThread) end
        for _, d in pairs(espDrawings) do if d.Highlight then d.Highlight:Destroy() end end
    end)
end

local tabContainer = Instance.new("ScrollingFrame", mainFrame)
tabContainer.Size = UDim2.new(1, -18, 0, 36)
tabContainer.Position = UDim2.new(0, 9, 0, 54)
tabContainer.BackgroundTransparency = 1
tabContainer.CanvasSize = UDim2.new(0, isMobile and 1100 or 1400, 0, 0)
tabContainer.ScrollBarThickness = 0

local tabLayout = Instance.new("UIListLayout", tabContainer)
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Padding = UDim.new(0, 6)

local contentContainer = Instance.new("Frame", mainFrame)
contentContainer.Size = UDim2.new(1, -18, 1, -104)
contentContainer.Position = UDim2.new(0, 9, 0, 96)
contentContainer.BackgroundColor3 = Color3.fromRGB(14, 8, 24)
contentContainer.BorderSizePixel = 0
Instance.new("UICorner", contentContainer).CornerRadius = UDim.new(0, 14)

local contentStroke = Instance.new("UIStroke", contentContainer)
contentStroke.Thickness = 1.5
contentStroke.Color = Color3.fromRGB(90, 40, 140)

local isMinimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        minimizeBtn.Text = "🗖"
        tabContainer.Visible = false
        contentContainer.Visible = false
        mainFrame:TweenSize(UDim2.new(0, mainFrame.AbsoluteSize.X, 0, 48), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
    else
        minimizeBtn.Text = "🗕"
        mainFrame:TweenSize(guiSize, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true, function()
            tabContainer.Visible = true
            contentContainer.Visible = true
        end)
    end
end)

local tabs = {}
local currentActiveTab = nil

local function createTab(name, orderIndex)
    local tabBtn = Instance.new("TextButton", tabContainer)
    tabBtn.Size = UDim2.new(0, isMobile and 48 or 60, 1, 0)
    tabBtn.BackgroundColor3 = Color3.fromRGB(22, 14, 38)
    tabBtn.BorderSizePixel = 0
    tabBtn.Font = Enum.Font.Code
    tabBtn.TextSize = isMobile and 7 or 8
    tabBtn.Text = name
    tabBtn.TextColor3 = Color3.fromRGB(190, 150, 230)
    tabBtn.LayoutOrder = orderIndex
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 8)

    local tabContent = Instance.new("ScrollingFrame", contentContainer)
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.Visible = false
    tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabContent.ScrollBarThickness = 3

    local layout = Instance.new("UIListLayout", tabContent)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabContent.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 14)
    end)

    local UIPadding = Instance.new("UIPadding", tabContent)
    UIPadding.PaddingTop = UDim.new(0, 12)
    UIPadding.PaddingLeft = UDim.new(0, 12)

    tabs[tabBtn] = tabContent

    tabBtn.MouseEnter:Connect(function()
        if currentActiveTab ~= tabBtn then
            TweenService:Create(tabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(38, 22, 60)}):Play()
        end
    end)
    tabBtn.MouseLeave:Connect(function()
        if currentActiveTab ~= tabBtn then
            TweenService:Create(tabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(22, 14, 38)}):Play()
        end
    end)

    tabBtn.MouseButton1Click:Connect(function()
        for btn, content in pairs(tabs) do
            content.Visible = false
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(22, 14, 38), TextColor3 = Color3.fromRGB(190, 150, 230)}):Play()
        end
        tabContent.Visible = true
        currentActiveTab = tabBtn
        TweenService:Create(tabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 0, 128), TextColor3 = Color3.fromRGB(10, 6, 18)}):Play()
    end)

    if not currentActiveTab then
        currentActiveTab = tabBtn
        tabContent.Visible = true
        tabBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 128)
        tabBtn.TextColor3 = Color3.fromRGB(10, 6, 18)
    end

    return tabContent
end

local function createFeatureToggle(tabContent, featureName, callback)
    local containerWidth = isMobile and 280 or 340
    local rowFrame = Instance.new("Frame", tabContent)
    rowFrame.Size = UDim2.new(0, containerWidth, 0, 36)
    rowFrame.BackgroundTransparency = 1

    local toggleWidth = isMobile and 170 or 215
    local toggleBtn = Instance.new("TextButton", rowFrame)
    toggleBtn.Size = UDim2.new(0, toggleWidth, 1, 0)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(25, 15, 42)
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Font = Enum.Font.Code
    toggleBtn.TextSize = 9
    toggleBtn.Text = "🛡️ " .. featureName .. " : [OFF]"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 90, 120)
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 8)

    local keybindWidth = isMobile and 95 or 105
    local keyBindBtn = Instance.new("TextButton", rowFrame)
    keyBindBtn.Size = UDim2.new(0, keybindWidth, 1, 0)
    keyBindBtn.Position = UDim2.new(0, toggleWidth + 10, 0, 0)
    keyBindBtn.BackgroundColor3 = Color3.fromRGB(40, 22, 65)
    keyBindBtn.BorderSizePixel = 0
    keyBindBtn.Font = Enum.Font.Code
    keyBindBtn.TextSize = 8
    keyBindBtn.Text = "[Key: None]"
    keyBindBtn.TextColor3 = Color3.fromRGB(210, 170, 255)
    Instance.new("UICorner", keyBindBtn).CornerRadius = UDim.new(0, 8)

    local isOn = false
    local assignedKey = nil
    local assigning = false

    local function triggerFeature()
        isOn = not isOn
        if isOn then
            toggleBtn.Text = "🛡️ " .. featureName .. " : [ON]"
            toggleBtn.TextColor3 = Color3.fromRGB(80, 255, 170)
            TweenService:Create(toggleBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(40, 20, 65)}):Play()
            showNotification(featureName .. " Aktif 🚀", true)
        else
            toggleBtn.Text = "🛡️ " .. featureName .. " : [OFF]"
            toggleBtn.TextColor3 = Color3.fromRGB(255, 90, 120)
            TweenService:Create(toggleBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(25, 15, 42)}):Play()
            showNotification(featureName .. " Dimatikan 💤", false)
        end
        pcall(function() callback(isOn) end)
    end

    toggleBtn.MouseButton1Click:Connect(triggerFeature)

    keyBindBtn.MouseButton1Click:Connect(function()
        assigning = true
        keyBindBtn.Text = "[Press Key]"
        keyBindBtn.TextColor3 = Color3.fromRGB(255, 210, 50)
    end)

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if assigning then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                if input.KeyCode == Enum.KeyCode.Backspace or input.KeyCode == Enum.KeyCode.Escape then
                    assignedKey = nil
                    keyBindBtn.Text = "[Key: None]"
                else
                    assignedKey = input.KeyCode
                    keyBindBtn.Text = "[Key: " .. string.gsub(tostring(assignedKey), "Enum.KeyCode.", "") .. "]"
                end
                keyBindBtn.TextColor3 = Color3.fromRGB(210, 170, 255)
                assigning = false
            end
        elseif not gameProcessed and assignedKey and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == assignedKey then
            triggerFeature()
        end
    end)
end

-- ==========================================
-- PEMBUATAN 15 TAB MENU (SHOP DIHAPUS)
-- ==========================================

-- TAB 1: Prompt
local t1 = createTab("Prompt", 1)
createFeatureToggle(t1, "Universal Instant Interact", function(state)
    instantPromptEnabled = state
    if state then for _, obj in ipairs(Workspace:GetDescendants()) do setupPrompt(obj) end end
end)

-- TAB 2: Cuff
local t2 = createTab("Cuff", 2)
createFeatureToggle(t2, "Auto Handcuff (Safe)", function(state) autoCuffEnabled = state end)

local cuffRangeLbl = Instance.new("TextLabel", t2)
cuffRangeLbl.Size = UDim2.new(0, 290, 0, 20)
cuffRangeLbl.BackgroundTransparency = 1
cuffRangeLbl.Font = Enum.Font.Code
cuffRangeLbl.TextSize = 9
cuffRangeLbl.Text = "📏 Jangkauan Cuff: " .. cuffRange .. " Studs"
cuffRangeLbl.TextColor3 = Color3.fromRGB(210, 180, 240)
cuffRangeLbl.TextXAlignment = Enum.TextXAlignment.Left

local cuffRow = Instance.new("Frame", t2)
cuffRow.Size = UDim2.new(0, 290, 0, 28)
cuffRow.BackgroundTransparency = 1

local cuffMinus = Instance.new("TextButton", cuffRow)
cuffMinus.Size = UDim2.new(0, 140, 1, 0)
cuffMinus.BackgroundColor3 = Color3.fromRGB(60, 20, 45)
cuffMinus.Font = Enum.Font.Code
cuffMinus.TextSize = 8
cuffMinus.Text = "Kecilkan (-2)"
cuffMinus.TextColor3 = Color3.fromRGB(255, 130, 130)
Instance.new("UICorner", cuffMinus).CornerRadius = UDim.new(0, 6)

local cuffPlus = Instance.new("TextButton", cuffRow)
cuffPlus.Size = UDim2.new(0, 140, 1, 0)
cuffPlus.Position = UDim2.new(0, 150, 0, 0)
cuffPlus.BackgroundColor3 = Color3.fromRGB(20, 60, 45)
cuffPlus.Font = Enum.Font.Code
cuffPlus.TextSize = 8
cuffPlus.Text = "Besarkan (+2)"
cuffPlus.TextColor3 = Color3.fromRGB(130, 255, 170)
Instance.new("UICorner", cuffPlus).CornerRadius = UDim.new(0, 6)

cuffMinus.MouseButton1Click:Connect(function()
    if cuffRange > 6 then cuffRange = cuffRange - 2 cuffRangeLbl.Text = "📏 Jangkauan Cuff: " .. cuffRange .. " Studs" end
end)
cuffPlus.MouseButton1Click:Connect(function()
    if cuffRange < 20 then cuffRange = cuffRange + 2 cuffRangeLbl.Text = "📏 Jangkauan Cuff: " .. cuffRange .. " Studs" end
end)

-- TAB 3: ATM & Minigames
local t3 = createTab("ATM", 3)
createFeatureToggle(t3, "Auto ATM / Lockpick / USB / C4", function(state) autoAtmEnabled = state end)

-- TAB 4: Loot
local t4 = createTab("Loot", 4)
createFeatureToggle(t4, "Auto-Pickup / Collect / Claim Cash", function(state) autoPickCashEnabled = state end)

-- TAB 5: Hitbox
local t5 = createTab("Hitbox", 5)
createFeatureToggle(t5, "Head Hitbox Expander", function(state) 
    hitboxEnabled = state 
    if not state then
        pcall(function()
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= localPlayer then
                    local head = player.Character and player.Character:FindFirstChild("Head")
                    if head then
                        head.Size = Vector3.new(2, 1, 1)
                        head.Transparency = 0
                        head.CanCollide = true
                    end
                end
            end
        end)
    end
end)

local hbSizeLbl = Instance.new("TextLabel", t5)
hbSizeLbl.Size = UDim2.new(0, 290, 0, 20)
hbSizeLbl.BackgroundTransparency = 1
hbSizeLbl.Font = Enum.Font.Code
hbSizeLbl.TextSize = 9
hbSizeLbl.Text = "🎯 Ukuran Hitbox: " .. hitboxSize
hbSizeLbl.TextColor3 = Color3.fromRGB(210, 180, 240)
hbSizeLbl.TextXAlignment = Enum.TextXAlignment.Left

local hbRow = Instance.new("Frame", t5)
hbRow.Size = UDim2.new(0, 290, 0, 28)
hbRow.BackgroundTransparency = 1

local hbMinus = Instance.new("TextButton", hbRow)
hbMinus.Size = UDim2.new(0, 140, 1, 0)
hbMinus.BackgroundColor3 = Color3.fromRGB(60, 20, 45)
hbMinus.Font = Enum.Font.Code
hbMinus.TextSize = 8
hbMinus.Text = "Kecilkan Size (-)"
hbMinus.TextColor3 = Color3.fromRGB(255, 130, 130)
Instance.new("UICorner", hbMinus).CornerRadius = UDim.new(0, 6)

local hbPlus = Instance.new("TextButton", hbRow)
hbPlus.Size = UDim2.new(0, 140, 1, 0)
hbPlus.Position = UDim2.new(0, 150, 0, 0)
hbPlus.BackgroundColor3 = Color3.fromRGB(20, 60, 45)
hbPlus.Font = Enum.Font.Code
hbPlus.TextSize = 8
hbPlus.Text = "Besarkan Size (+)"
hbPlus.TextColor3 = Color3.fromRGB(130, 255, 170)
Instance.new("UICorner", hbPlus).CornerRadius = UDim.new(0, 6)

hbMinus.MouseButton1Click:Connect(function()
    if hitboxSize > 2 then hitboxSize = hitboxSize - 0.5 hbSizeLbl.Text = "🎯 Ukuran Hitbox: " .. hitboxSize end
end)
hbPlus.MouseButton1Click:Connect(function()
    if hitboxSize < 6 then hitboxSize = hitboxSize + 0.5 hbSizeLbl.Text = "🎯 Ukuran Hitbox: " .. hitboxSize end
end)

-- TAB 6: Move
local tmovement = createTab("Move", 6)
createFeatureToggle(tmovement, "Safe WalkSpeed", function(state) speedEnabled = state end)
createFeatureToggle(tmovement, "Infinite Jump / Hop", function(state) infiniteJumpEnabled = state end)
createFeatureToggle(tmovement, "Infinite Stamina (No Fatigue)", function(state) infiniteStaminaEnabled = state end)
createFeatureToggle(tmovement, "No Fall Damage", function(state) 
    noFallEnabled = state 
    pcall(function()
        local hum = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, not state) end
    end)
end)

-- TAB 7: World
local tworld = createTab("World", 7)
createFeatureToggle(tworld, "Fullbright (Anti-Dark)", function(state) 
    fullbrightEnabled = state 
    if not state then Lighting.Brightness = 1 Lighting.GlobalShadows = true end
end)
createFeatureToggle(tworld, "Custom FOV Changer", function(state) 
    customFovEnabled = state 
    if not state then Camera.FieldOfView = 70 end
end)
createFeatureToggle(tworld, "FPS Booster & Particle Remover", function(state) toggleFpsBooster(state) end)

local fovLbl = Instance.new("TextLabel", tworld)
fovLbl.Size = UDim2.new(0, 290, 0, 20)
fovLbl.BackgroundTransparency = 1
fovLbl.Font = Enum.Font.Code
fovLbl.TextSize = 9
fovLbl.Text = "🔭 FOV Value: " .. fovValue
fovLbl.TextColor3 = Color3.fromRGB(210, 180, 240)
fovLbl.TextXAlignment = Enum.TextXAlignment.Left

local fovRow = Instance.new("Frame", tworld)
fovRow.Size = UDim2.new(0, 290, 0, 28)
fovRow.BackgroundTransparency = 1

local fovMinus = Instance.new("TextButton", fovRow)
fovMinus.Size = UDim2.new(0, 140, 1, 0)
fovMinus.BackgroundColor3 = Color3.fromRGB(60, 20, 45)
fovMinus.Font = Enum.Font.Code
fovMinus.TextSize = 8
fovMinus.Text = "Narrow FOV (-5)"
fovMinus.TextColor3 = Color3.fromRGB(255, 130, 130)
Instance.new("UICorner", fovMinus).CornerRadius = UDim.new(0, 6)

local fovPlus = Instance.new("TextButton", fovRow)
fovPlus.Size = UDim2.new(0, 140, 1, 0)
fovPlus.Position = UDim2.new(0, 150, 0, 0)
fovPlus.BackgroundColor3 = Color3.fromRGB(20, 60, 45)
fovPlus.Font = Enum.Font.Code
fovPlus.TextSize = 8
fovPlus.Text = "Wide FOV (+5)"
fovPlus.TextColor3 = Color3.fromRGB(130, 255, 170)
Instance.new("UICorner", fovPlus).CornerRadius = UDim.new(0, 6)

fovMinus.MouseButton1Click:Connect(function()
    if fovValue > 70 then fovValue = fovValue - 5 fovLbl.Text = "🔭 FOV Value: " .. fovValue end
end)
fovPlus.MouseButton1Click:Connect(function()
    if fovValue < 120 then fovValue = fovValue + 5 fovLbl.Text = "🔭 FOV Value: " .. fovValue end
end)

-- TAB 8: TP (Hanya Save & Load Waypoint Custom)
local ttp = createTab("TP", 8)
createFeatureToggle(ttp, "Ctrl + Click Teleport", function(state) clickTpEnabled = state end)

local savedWaypointCFrame = nil
local waypointBtn = Instance.new("TextButton", ttp)
waypointBtn.Size = UDim2.new(0, 290, 0, 28)
waypointBtn.BackgroundColor3 = Color3.fromRGB(50, 20, 70)
waypointBtn.BorderSizePixel = 0
waypointBtn.Font = Enum.Font.Code
waypointBtn.TextSize = 9
waypointBtn.Text = "📍 Save Custom Waypoint (Titik Saat Ini)"
waypointBtn.TextColor3 = Color3.fromRGB(255, 210, 120)
Instance.new("UICorner", waypointBtn).CornerRadius = UDim.new(0, 6)

local loadWaypointBtn = Instance.new("TextButton", ttp)
loadWaypointBtn.Size = UDim2.new(0, 290, 0, 28)
loadWaypointBtn.BackgroundColor3 = Color3.fromRGB(30, 50, 70)
loadWaypointBtn.BorderSizePixel = 0
loadWaypointBtn.Font = Enum.Font.Code
loadWaypointBtn.TextSize = 9
loadWaypointBtn.Text = "🚀 Teleport ke Waypoint Tersimpan"
loadWaypointBtn.TextColor3 = Color3.fromRGB(120, 255, 170)
Instance.new("UICorner", loadWaypointBtn).CornerRadius = UDim.new(0, 6)

waypointBtn.MouseButton1Click:Connect(function()
    pcall(function()
        local root = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then savedWaypointCFrame = root.CFrame showNotification("Waypoint Berhasil Disimpan! 📍", true) end
    end)
end)

loadWaypointBtn.MouseButton1Click:Connect(function()
    pcall(function()
        if savedWaypointCFrame then
            local root = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then root.CFrame = savedWaypointCFrame showNotification("Teleport ke Waypoint Tersimpan! 🚀", true) end
        else
            showNotification("Belum ada waypoint yang disimpan!", false)
        end
    end)
end)

-- TAB 9: Vehicle
local tveh = createTab("Vehicle", 9)
createFeatureToggle(tveh, "Vehicle Speed Boost", function(state) vehicleSpeedEnabled = state end)
createFeatureToggle(tveh, "Keep Fuel / Infinite Fuel", function(state) keepFuelEnabled = state end)

local bringVehBtn = Instance.new("TextButton", tveh)
bringVehBtn.Size = UDim2.new(0, 290, 0, 28)
bringVehBtn.BackgroundColor3 = Color3.fromRGB(60, 20, 80)
bringVehBtn.BorderSizePixel = 0
bringVehBtn.Font = Enum.Font.Code
bringVehBtn.TextSize = 9
bringVehBtn.Text = "🚗 Bring Vehicle to Me (Tarik Mobil)"
bringVehBtn.TextColor3 = Color3.fromRGB(255, 150, 220)
Instance.new("UICorner", bringVehBtn).CornerRadius = UDim.new(0, 6)

bringVehBtn.MouseButton1Click:Connect(function()
    pcall(function()
        local myRoot = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
        if myRoot then
            local foundVeh = false
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("VehicleSeat") or (obj:IsA("Model") and obj:FindFirstChildOfClass("VehicleSeat")) then
                    local seat = obj:IsA("VehicleSeat") and obj or obj:FindFirstChildOfClass("VehicleSeat")
                    local vehModel = seat.Parent
                    if vehModel and vehModel:IsA("Model") then
                        local primary = vehModel.PrimaryPart or seat
                        primary.CFrame = myRoot.CFrame + Vector3.new(4, 2, 0)
                        primary.AssemblyLinearVelocity = Vector3.new(0,0,0)
                        foundVeh = true
                    end
                end
            end
            showNotification(foundVeh and "Kendaraan berhasil ditarik ke depan Anda! 🚗" or "Tidak ada kendaraan ditemukan di sekitar!", foundVeh)
        end
    end)
end)

local flipBtn = Instance.new("TextButton", tveh)
flipBtn.Size = UDim2.new(0, 290, 0, 28)
flipBtn.BackgroundColor3 = Color3.fromRGB(45, 20, 60)
flipBtn.BorderSizePixel = 0
flipBtn.Font = Enum.Font.Code
flipBtn.TextSize = 9
flipBtn.Text = "🔄 Flip Vehicle (Balikan Mobil)"
flipBtn.TextColor3 = Color3.fromRGB(255, 210, 120)
Instance.new("UICorner", flipBtn).CornerRadius = UDim.new(0, 6)

flipBtn.MouseButton1Click:Connect(function()
    pcall(function()
        local char = localPlayer.Character
        local seatPart = char and char:FindFirstChildOfClass("Humanoid") and char.Humanoid.SeatPart
        if seatPart and seatPart:IsA("VehicleSeat") and seatPart.Parent and seatPart.Parent:IsA("Model") then
            local primaryPart = seatPart.Parent.PrimaryPart or seatPart
            primaryPart.CFrame = primaryPart.CFrame + Vector3.new(0, 4, 0)
            showNotification("Kendaraan berhasil dibalikkan! 🚗", true)
        else
            showNotification("Anda harus duduk di dalam kendaraan!", false)
        end
    end)
end)

-- TAB 10: Combat
local tcombat = createTab("Combat", 10)
createFeatureToggle(tcombat, "Silent Aim / Camera Lock", function(state) silentAimEnabled = state end)
createFeatureToggle(tcombat, "Auto-Reload Instant", function(state) autoReloadEnabled = state end)
createFeatureToggle(tcombat, "No Recoil / Zero Spread", function(state) noRecoilEnabled = state end)
createFeatureToggle(tcombat, "Infinite Ammo / Magazine Refill", function(state) infiniteAmmoEnabled = state end)

-- TAB 11: Ghost
local tghost = createTab("Ghost", 11)
createFeatureToggle(tghost, "Ghost Clone -100 Studs", function(state) toggleGhostMode(state) end)

-- TAB 12: Utility
local tutility = createTab("Utility", 12)
createFeatureToggle(tutility, "Anti-AFK Bypass", function(state) antiAfkEnabled = state setupAntiAfk(state) end)
createFeatureToggle(tutility, "Anti-Arrest Alert / Radar", function(state) antiArrestAlertEnabled = state end)

-- TAB 13: Info
local t6 = createTab("Info", 13)

local tpNearestWantedBtn = Instance.new("TextButton", t6)
tpNearestWantedBtn.Size = UDim2.new(0, 290, 0, 28)
tpNearestWantedBtn.BackgroundColor3 = Color3.fromRGB(150, 100, 20)
tpNearestWantedBtn.BorderSizePixel = 0
tpNearestWantedBtn.Font = Enum.Font.Code
tpNearestWantedBtn.TextSize = 9
tpNearestWantedBtn.Text = "⚡ TP ke Nearest Wanted Player"
tpNearestWantedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", tpNearestWantedBtn).CornerRadius = UDim.new(0, 6)

tpNearestWantedBtn.MouseButton1Click:Connect(function()
    pcall(function()
        local myRoot = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end
        local nearestWantedRoot, shortestDist, wantedName = nil, 9e9, ""
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= localPlayer then
                local char = p.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local isWanted = p:GetAttribute("Wanted") == true or p:GetAttribute("IsWanted") == true or p:GetAttribute("WantedLevel") ~= nil or p:GetAttribute("Bounty") ~= nil or (char and char:FindFirstChild("WantedTag") ~= nil)
                if isWanted and root and hum and hum.Health > 0 then
                    local dist = (root.Position - myRoot.Position).Magnitude
                    if dist < shortestDist then shortestDist = dist nearestWantedRoot = root wantedName = p.Name end
                end
            end
        end
        if nearestWantedRoot then
            myRoot.CFrame = nearestWantedRoot.CFrame + Vector3.new(0, 3, 0)
            showNotification("Berhasil TP ke Wanted: " .. wantedName, true)
        else
            showNotification("Tidak ada pemain Wanted di sekitar!", false)
        end
    end)
end)

local filterWantedBtn = Instance.new("TextButton", t6)
filterWantedBtn.Size = UDim2.new(0, 290, 0, 28)
filterWantedBtn.BackgroundColor3 = Color3.fromRGB(60, 32, 85)
filterWantedBtn.BorderSizePixel = 0
filterWantedBtn.Font = Enum.Font.Code
filterWantedBtn.TextSize = 9
filterWantedBtn.Text = "⭐ Filter Wanted Only: [OFF]"
filterWantedBtn.TextColor3 = Color3.fromRGB(255, 215, 0)
Instance.new("UICorner", filterWantedBtn).CornerRadius = UDim.new(0, 6)

local onlyWantedFilter = false
filterWantedBtn.MouseButton1Click:Connect(function()
    onlyWantedFilter = not onlyWantedFilter
    if onlyWantedFilter then
        filterWantedBtn.BackgroundColor3 = Color3.fromRGB(120, 80, 20)
        filterWantedBtn.Text = "⭐ Filter Wanted Only: [ON]"
        showNotification("Filter Wanted ON 🌟", true)
    else
        filterWantedBtn.BackgroundColor3 = Color3.fromRGB(60, 32, 85)
        filterWantedBtn.Text = "⭐ Filter Wanted Only: [OFF]"
        showNotification("Filter Wanted OFF", false)
    end
end)

local searchBox = Instance.new("TextBox", t6)
searchBox.Size = UDim2.new(0, 290, 0, 28)
searchBox.BackgroundColor3 = Color3.fromRGB(22, 14, 38)
searchBox.BorderSizePixel = 0
searchBox.Font = Enum.Font.Code
searchBox.TextSize = 9
searchBox.PlaceholderText = "🔍 Cari Player..."
searchBox.Text = ""
searchBox.TextColor3 = Color3.fromRGB(255, 210, 255)
searchBox.PlaceholderColor3 = Color3.fromRGB(140, 110, 170)
Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 6)

local specStatusLabel = Instance.new("TextLabel", t6)
specStatusLabel.Size = UDim2.new(0, 290, 0, 20)
specStatusLabel.BackgroundTransparency = 1
specStatusLabel.Font = Enum.Font.Code
specStatusLabel.TextSize = 8
specStatusLabel.Text = "👀 Status: Tidak Spectate"
specStatusLabel.TextColor3 = Color3.fromRGB(210, 180, 240)
specStatusLabel.TextXAlignment = Enum.TextXAlignment.Left

local stopSpecBtn = Instance.new("TextButton", t6)
stopSpecBtn.Size = UDim2.new(0, 290, 0, 24)
stopSpecBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 90)
stopSpecBtn.BorderSizePixel = 0
stopSpecBtn.Font = Enum.Font.Code
stopSpecBtn.TextSize = 8
stopSpecBtn.Text = "🛑 Berhenti Spectate"
stopSpecBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", stopSpecBtn).CornerRadius = UDim.new(0, 6)

local combinedScroll = Instance.new("ScrollingFrame", t6)
combinedScroll.Size = UDim2.new(0, 290, 0, 100)
combinedScroll.BackgroundTransparency = 1
combinedScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
combinedScroll.ScrollBarThickness = 3

local combinedListLayout = Instance.new("UIListLayout", combinedScroll)
combinedListLayout.Padding = UDim.new(0, 5)
combinedListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    combinedScroll.CanvasSize = UDim2.new(0, 0, 0, combinedListLayout.AbsoluteContentSize.Y + 8)
end)

local spectatingTarget = nil
stopSpecBtn.MouseButton1Click:Connect(function()
    spectatingTarget = nil
    pcall(function()
        local myHum = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")
        if myHum then Camera.CameraSubject = myHum else Camera.CameraType = Enum.CameraType.Custom end
    end)
    specStatusLabel.Text = "👀 Status: Tidak Spectate"
    showNotification("Spectate dimatikan", false)
end)

local function updateCombinedList()
    pcall(function()
        for _, child in ipairs(combinedScroll:GetChildren()) do
            if child:IsA("Frame") then child:Destroy() end
        end
        local searchText = string.lower(searchBox.Text)
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= localPlayer then
                local char = p.Character
                local isWanted = p:GetAttribute("Wanted") == true or p:GetAttribute("IsWanted") == true or p:GetAttribute("WantedLevel") ~= nil or p:GetAttribute("Bounty") ~= nil or (char and char:FindFirstChild("WantedTag") ~= nil)

                if (not onlyWantedFilter or isWanted) and (searchText == "" or string.find(string.lower(p.Name), searchText)) then
                    local itemFrame = Instance.new("Frame", combinedScroll)
                    itemFrame.Size = UDim2.new(1, 0, 0, 28)
                    itemFrame.BackgroundTransparency = 1

                    local labelInfo = Instance.new("TextButton", itemFrame)
                    labelInfo.Size = UDim2.new(0, 104, 1, 0)
                    labelInfo.BackgroundColor3 = isWanted and Color3.fromRGB(80, 60, 10) or Color3.fromRGB(22, 14, 38)
                    labelInfo.Font = Enum.Font.Code
                    labelInfo.TextSize = 7
                    labelInfo.Text = isWanted and "★ " .. p.Name .. " [W]" or p.Name
                    labelInfo.TextColor3 = isWanted and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(200, 200, 200)
                    Instance.new("UICorner", labelInfo).CornerRadius = UDim.new(0, 5)

                    local tpBtn = Instance.new("TextButton", itemFrame)
                    tpBtn.Size = UDim2.new(0, 88, 1, 0)
                    tpBtn.Position = UDim2.new(0, 110, 0, 0)
                    tpBtn.BackgroundColor3 = Color3.fromRGB(28, 16, 48)
                    tpBtn.Font = Enum.Font.Code
                    tpBtn.TextSize = 8
                    tpBtn.Text = "🚀 TP"
                    tpBtn.TextColor3 = Color3.fromRGB(120, 255, 170)
                    Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 5)

                    local specBtn = Instance.new("TextButton", itemFrame)
                    specBtn.Size = UDim2.new(0, 88, 1, 0)
                    specBtn.Position = UDim2.new(0, 202, 0, 0)
                    specBtn.BackgroundColor3 = Color3.fromRGB(28, 16, 48)
                    specBtn.Font = Enum.Font.Code
                    specBtn.TextSize = 8
                    specBtn.Text = "👁️ Spec"
                    specBtn.TextColor3 = Color3.fromRGB(255, 170, 230)
                    Instance.new("UICorner", specBtn).CornerRadius = UDim.new(0, 5)

                    tpBtn.MouseButton1Click:Connect(function()
                        pcall(function()
                            local targetRoot = char and char:FindFirstChild("HumanoidRootPart")
                            local myRoot = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
                            if targetRoot and myRoot then
                                myRoot.CFrame = targetRoot.CFrame + Vector3.new(0, 3, 0)
                                showNotification("TP ke " .. p.Name, true)
                            end
                        end)
                    end)

                    specBtn.MouseButton1Click:Connect(function()
                        spectatingTarget = p
                        pcall(function()
                            if char and char:FindFirstChild("HumanoidRootPart") and localPlayer.RequestStreamAroundAsync then
                                localPlayer:RequestStreamAroundAsync(char.HumanoidRootPart.Position)
                            end
                        end)
                        showNotification("Spectate: " + p.Name, true)
                    end)
                end
            end
        end
    end)
end

searchBox:GetPropertyChangedSignal("Text"):Connect(updateCombinedList)
filterWantedBtn.MouseButton1Click:Connect(updateCombinedList)
updateCombinedList()
Players.PlayerAdded:Connect(updateCombinedList)
Players.PlayerRemoving:Connect(updateCombinedList)

RunService.RenderStepped:Connect(function()
    if not scriptActive or not spectatingTarget then return end
    pcall(function()
        local char = spectatingTarget.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if hum and hum.Health > 0 then
            Camera.CameraSubject = hum
            specStatusLabel.Text = "👀 Spec -> " .. spectatingTarget.Name
            if root and localPlayer.RequestStreamAroundAsync then
                pcall(function() localPlayer:RequestStreamAroundAsync(root.Position) end)
            end
        elseif root then
            Camera.CameraSubject = root
            specStatusLabel.Text = "👀 Respawning..."
        end
    end)
end)

-- TAB 14: ESP
local t14 = createTab("ESP", 14)
createFeatureToggle(t14, "Player ESP & Outline", function(state) 
    espEnabled = state 
    if not state then
        pcall(function()
            for _, data in pairs(espDrawings) do
                if data.Billboard then data.Billboard.Enabled = false end
                if data.Highlight then data.Highlight.Enabled = false end
            end
        end)
    end
end)

-- TAB 15: Protect
local t15 = createTab("Protect", 15)
createExperienceToggle = nil
createFeatureToggle(t15, "Safe Walk / Noclip", function(state) noclipEnabled = state end)
createFeatureToggle(t15, "Anti-Void Protection", function(state) antiVoidEnabled = state end)
createFeatureToggle(t15, "Anti-Ragdoll / Recovery", function(state) antiRagdollEnabled = state end)
createFeatureToggle(t15, "Advanced Anti-Cuff Protection", function(state) antiCuffEnabled = state end)

print("[Yukimeow] V3.60 Clean Stealth Loaded Successfully! ✨🛡️🚀")