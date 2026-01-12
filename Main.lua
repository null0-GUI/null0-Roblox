-- [[ null0 GUI for Roblox Exploiting ]] --
local player = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local InsertService = game:GetService("InsertService")

-- 1. Root Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "null0"
screenGui.Parent = (RunService:IsStudio() and player.PlayerGui or CoreGui)
screenGui.ResetOnSpawn = false

-- Helper: Draggable Logic
local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
end

-- 2. Main Window (MainHolder)
local mainHolder = Instance.new("Frame")
mainHolder.Name = "MainHolder"
mainHolder.BackgroundColor3 = Color3.fromRGB(77, 77, 77)
mainHolder.BackgroundTransparency = 0.2
mainHolder.Size = UDim2.fromScale(0.4, 0.5)
mainHolder.Position = UDim2.fromScale(0.5, 0.5)
mainHolder.AnchorPoint = Vector2.new(0.5, 0.5)
mainHolder.BorderSizePixel = 0
mainHolder.Parent = screenGui
makeDraggable(mainHolder)

-- 3. The Console Window (F9 + 9 Toggle)
local consoleFrame = Instance.new("Frame")
consoleFrame.Name = "ConsoleFrame"
consoleFrame.BackgroundColor3 = Color3.fromRGB(77, 77, 77)
consoleFrame.BackgroundTransparency = 0.2
consoleFrame.Size = UDim2.fromScale(0.35, 0.45)
consoleFrame.Position = UDim2.fromScale(0.1, 0.1) -- Starts at top left
consoleFrame.BorderSizePixel = 0
consoleFrame.Visible = false
consoleFrame.Parent = screenGui
makeDraggable(consoleFrame)

local logList = Instance.new("ScrollingFrame")
logList.Name = "LogList"
logList.Size = UDim2.fromScale(0.95, 0.9)
logList.Position = UDim2.fromScale(0.025, 0.05)
logList.BackgroundTransparency = 1
logList.CanvasSize = UDim2.new(0,0,0,0)
logList.AutomaticCanvasSize = Enum.AutomaticSize.Y
logList.ScrollBarThickness = 2
logList.Parent = consoleFrame

local logLayout = Instance.new("UIListLayout")
logLayout.Parent = logList

-- Function to Log to GUI
local function logToGui(msg, color)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = "[" .. os.date("%X") .. "] " .. tostring(msg)
    label.TextColor3 = color or Color3.new(1,1,1)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Code
    label.TextScaled = true
    label.Parent = logList
end

-- Intercept Prints
game:GetService("LogService").MessageOut:Connect(function(msg, msgType)
    local col = Color3.new(1,1,1)
    if msgType == Enum.MessageType.MessageWarning then col = Color3.new(1, 0.8, 0)
    elseif msgType == Enum.MessageType.MessageError then col = Color3.new(1, 0.2, 0) end
    logToGui(msg, col)
end)

-- 4. Toggle Logic (F9 and 9)
local f9Pressed = false
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.F9 then f9Pressed = true
    elseif input.KeyCode == Enum.KeyCode.Nine and f9Pressed then
        consoleFrame.Visible = not consoleFrame.Visible
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F9 then f9Pressed = false end
end)

-- 5. Aesthetics & Tabs (Inside MainHolder)
local asethetics = Instance.new("Folder", mainHolder)
asethetics.Name = "Asethetics"

-- Borders (43x574 look via Aspect Ratio)
local function createBorder(name, anchorX)
    local border = Instance.new("Frame")
    border.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    border.Size = UDim2.fromScale(0.08, 1.4)
    border.Position = UDim2.fromScale(anchorX, 0.5)
    border.AnchorPoint = Vector2.new(0.5, 0.5)
    border.BorderSizePixel = 0
    border.Parent = asethetics
    Instance.new("UIAspectRatioConstraint", border).AspectRatio = 43/574
end
createBorder("LeftBorder", -0.05)
createBorder("RightBorder", 1.05)

-- Tab Header
local tabs = Instance.new("Frame", asethetics)
tabs.Name = "Tabs"
tabs.Size = UDim2.fromScale(1, 0.15)
tabs.BackgroundTransparency = 1

local title = Instance.new("TextLabel", tabs)
title.Text = "Built in Buttons"
title.Size = UDim2.fromScale(0.6, 0.8)
title.Position = UDim2.fromScale(0.5, 0.5)
title.AnchorPoint = Vector2.new(0.5, 0.5)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1, 1, 1)
title.TextScaled = true
title.Font = Enum.Font.SourceSansBold

-- 6. Buttons
local buttonHolder = Instance.new("ScrollingFrame", mainHolder)
buttonHolder.Name = "ButtonHolder"
buttonHolder.Size = UDim2.fromScale(0.9, 0.75)
buttonHolder.Position = UDim2.fromScale(0.05, 0.2)
buttonHolder.BackgroundTransparency = 1
buttonHolder.ScrollBarThickness = 0

local layout = Instance.new("UIGridLayout", buttonHolder)
layout.CellPadding = UDim2.fromScale(0.02, 0.02)
layout.CellSize = UDim2.fromScale(0.2, 0.12)
layout.SortOrder = Enum.SortOrder.LayoutOrder

local function createBtn(name, color, txtCol, order, callback)
    local btn = Instance.new("TextButton", buttonHolder)
    btn.Text = name
    btn.BackgroundColor3 = color
    btn.TextColor3 = txtCol
    btn.LayoutOrder = order
    btn.BorderSizePixel = 0
    btn.TextScaled = true
    Instance.new("UIAspectRatioConstraint", btn).AspectRatio = 77/38
    btn.MouseButton1Click:Connect(callback)
end

createBtn("+", Color3.new(0,0,0), Color3.new(1,1,1), 1, function() print("Add Menu Clicked") end)
createBtn("Fling-GUI", Color3.new(0,0,0), Color3.new(1,1,1), 2, function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/null0-GUI/null0-Roblox/refs/heads/main/Main.lua"))()
end)

createBtn("John Doe", Color3.fromRGB(248, 217, 109), Color3.new(0,0,0), 999, function()
    pcall(function()
        local model = InsertService:LoadAsset(21070012)
        local accessory = model:FindFirstChildOfClass("Accessory")
        if accessory then player.Character.Humanoid:AddAccessory(accessory:Clone()) end
    end)
end)
