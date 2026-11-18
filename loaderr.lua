-- ==========================================
-- YUKIMEOW GITHUB LOADER (NANAO STYLE)
-- ==========================================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local localPlayer = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait() and Players.LocalPlayer

-- Daftar file script yang tersimpan di GitHub Anda
local ScriptRegistry = {
    {
        Name = "San Aurie Hub",
        Category = "Roleplay / Action",
        Url = "https://raw.githubusercontent.com/Yaziii-coder/meowhub/main/san-aurie.lua"
    },
    {
        Name = "Universal Script",
        Category = "General",
        Url = "https://raw.githubusercontent.com/Yaziii-coder/meowhub/main/universal.lua"
    }
}

-- Fungsi aman pengunduh & eksekutor script dari GitHub
local function secureLoadAndRun(url, statusLabel)
    statusLabel.Text = "🐾 Status: Menghubungkan ke GitHub..."
    
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)

    if not success or not response or response == "" or string.find(string.lower(response), "404: not found") then
        statusLabel.Text = "🐾 Error: Gagal mengunduh (404 Not Found)!"
        warn("[Yukimeow Loader] HTTP Get Failed for URL:", url)
        return
    end

    statusLabel.Text = "🐾 Status: Memverifikasi & Menjalankan..."
    
    local runSuccess, runError = pcall(function()
        local compiledFunction, loadErr = loadstring(response)
        if compiledFunction then
            return compiledFunction()
        else
            error(loadErr)
        end
    end)

    if runSuccess then
        statusLabel.Text = "🐾 Berhasil! Memuat fitur..."
        task.wait(0.4)
    else
        statusLabel.Text = "🐾 Error: Script gagal dieksekusi!"
        warn("[Yukimeow Loader] Execution Error:", runError)
    end
end

-- ==========================================
-- INISIALISASI TAMPILAN UI (KUCING HITAM PUTIH)
-- ==========================================
local guiParent = CoreGui
local testSuccess, _ = pcall(function()
    return CoreGui.Name
end)
if not testSuccess then
    guiParent = localPlayer:WaitForChild("PlayerGui")
end

for _, child in ipairs(guiParent:GetChildren()) do
    if child.Name == "YukimeowGitHubLoader" then
        child:Destroy()
    end
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "YukimeowGitHubLoader"
screenGui.ResetOnSpawn = false
screenGui.Parent = guiParent

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 360, 0, 280)
mainFrame.Position = UDim2.new(0.5, -180, 0.5, -140)
mainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Thickness = 2
mainStroke.Color = Color3.fromRGB(255, 255, 255)
mainStroke.Parent = mainFrame

-- Dekorasi Telinga Kucing
local leftEar = Instance.new("TextLabel")
leftEar.Size = UDim2.new(0, 30, 0, 20)
leftEar.Position = UDim2.new(0, 16, 0, -16)
leftEar.BackgroundTransparency = 1
leftEar.Font = Enum.Font.Code
leftEar.TextSize = 18
leftEar.Text = "▲"
leftEar.TextColor3 = Color3.fromRGB(255, 255, 255)
leftEar.Parent = mainFrame

local rightEar = Instance.new("TextLabel")
rightEar.Size = UDim2.new(0, 30, 0, 20)
rightEar.Position = UDim2.new(0, 48, 0, -16)
rightEar.BackgroundTransparency = 1
rightEar.Font = Enum.Font.Code
rightEar.TextSize = 18
rightEar.Text = "▲"
rightEar.TextColor3 = Color3.fromRGB(255, 255, 255)
rightEar.Parent = mainFrame

-- Topbar
local topbar = Instance.new("Frame")
topbar.Size = UDim2.new(1, 0, 0, 44)
topbar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
topbar.BorderSizePixel = 0
topbar.Parent = mainFrame

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 10)
topCorner.Parent = topbar

local topFix = Instance.new("Frame")
topFix.Size = UDim2.new(1, 0, 0, 10)
topFix.Position = UDim2.new(0, 0, 1, -10)
topFix.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
topFix.BorderSizePixel = 0
topFix.Parent = topbar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -50, 1, 0)
titleLabel.Position = UDim2.new(0, 14, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.Code
titleLabel.TextSize = 12
titleLabel.Text = "(=^･ω･^=) YUKIMEOW GITHUB LOADER"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = topbar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 26, 0, 26)
closeBtn.Position = UDim2.new(1, -34, 0, 9)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.BorderSizePixel = 0
closeBtn.Font = Enum.Font.Code
closeBtn.TextSize = 11
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(12, 12, 12)
closeBtn.Parent = topbar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Container Menu
local listContainer = Instance.new("ScrollingFrame")
listContainer.Size = UDim2.new(1, -24, 1, -96)
listContainer.Position = UDim2.new(0, 12, 0, 52)
listContainer.BackgroundTransparency = 1
listContainer.ScrollBarThickness = 2
listContainer.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
listContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
listContainer.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 8)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = listContainer

listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    listContainer.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 8)
end)

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -24, 0, 24)
statusLabel.Position = UDim2.new(0, 12, 1, -32)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.Code
statusLabel.TextSize = 11
statusLabel.Text = "🐾 Status: Siap memilih script..."
statusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = mainFrame

for _, item in ipairs(ScriptRegistry) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 46)
    btn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Text = ""
    btn.Parent = listContainer

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Thickness = 1
    btnStroke.Color = Color3.fromRGB(60, 60, 60)
    btnStroke.Parent = btn

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(1, -16, 0, 20)
    nameLbl.Position = UDim2.new(0, 10, 0, 5)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Font = Enum.Font.Code
    nameLbl.TextSize = 12
    nameLbl.Text = "🐾 " .. item.Name
    nameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.Parent = btn

    local catLbl = Instance.new("TextLabel")
    catLbl.Size = UDim2.new(1, -16, 0, 16)
    catLbl.Position = UDim2.new(0, 10, 0, 24)
    catLbl.BackgroundTransparency = 1
    catLbl.Font = Enum.Font.Code
    catLbl.TextSize = 10
    catLbl.Text = "Kategori: " .. item.Category
    catLbl.TextColor3 = Color3.fromRGB(150, 150, 150)
    catLbl.TextXAlignment = Enum.TextXAlignment.Left
    catLbl.Parent = btn

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(255, 255, 255) }):Play()
        TweenService:Create(nameLbl, TweenInfo.new(0.15), { TextColor3 = Color3.fromRGB(12, 12, 12) }):Play()
        TweenService:Create(catLbl, TweenInfo.new(0.15), { TextColor3 = Color3.fromRGB(80, 80, 80) }):Play()
        TweenService:Create(btnStroke, TweenInfo.new(0.15), { Color = Color3.fromRGB(12, 12, 12) }):Play()
    end)

    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(22, 22, 22) }):Play()
        TweenService:Create(nameLbl, TweenInfo.new(0.15), { TextColor3 = Color3.fromRGB(255, 255, 255) }):Play()
        TweenService:Create(catLbl, TweenInfo.new(0.15), { TextColor3 = Color3.fromRGB(150, 150, 150) }):Play()
        TweenService:Create(btnStroke, TweenInfo.new(0.15), { Color = Color3.fromRGB(60, 60, 60) }):Play()
    end)

    btn.MouseButton1Click:Connect(function()
        task.spawn(function()
            secureLoadAndRun(item.Url, statusLabel)
            task.wait(1)
            if screenGui then
                screenGui:Destroy()
            end
        end)
    end)
end