-- [[ null0 GUI for Roblox LocalPlayer only (Backdoor scanner coming soon!)]] --
local player = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local InsertService = game:GetService("InsertService")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "null0"
screenGui.Parent = (RunService:IsStudio() and player.PlayerGui or CoreGui)
screenGui.ResetOnSpawn = false

-- [[ FIXED DRAGGABLE LOGIC ]]
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
    -- Fixed the nil index error from the previous version
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

-- [[ MAIN WINDOW ]]
local mainHolder = Instance.new("Frame", screenGui)
mainHolder.Name = "MainHolder"
mainHolder.BackgroundColor3 = Color3.fromRGB(77, 77, 77)
mainHolder.BackgroundTransparency = 0.2
mainHolder.BorderSizePixel = 0
mainHolder.Size = UDim2.fromScale(0.4, 0.5)
mainHolder.Position = UDim2.fromScale(0.5, 0.5)
mainHolder.AnchorPoint = Vector2.new(0.5, 0.5)
makeDraggable(mainHolder)

-- [[ AESTHETICS & TABS ]]
local asethetics = Instance.new("Folder", mainHolder)
asethetics.Name = "Asethetics"

-- Borders (Fixed "Disintegrating" Issue)
local function createBorder(name, anchorX)
    local border = Instance.new("Frame", asethetics)
    border.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    border.BorderSizePixel = 0
    border.Size = UDim2.fromScale(0.08, 1.4)
    border.Position = UDim2.fromScale(anchorX, 0.5)
    border.AnchorPoint = Vector2.new(0.5, 0.5)
    local ratio = Instance.new("UIAspectRatioConstraint", border)
    ratio.AspectRatio = 43/574
end
createBorder("LeftBorder", -0.05)
createBorder("RightBorder", 1.05)

-- Tabs Header (Matches image_5af52c.png)
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

local function createArrow(img, xPos)
    local arrow = Instance.new("ImageButton", tabs)
    arrow.Image = "rbxassetid://" .. img
    arrow.Size = UDim2.fromScale(0.1, 0.8)
    arrow.Position = UDim2.fromScale(xPos, 0.5)
    arrow.AnchorPoint = Vector2.new(0.5, 0.5)
    arrow.BackgroundTransparency = 1
    Instance.new("UIAspectRatioConstraint", arrow).AspectRatio = 1
end
createArrow("16848361091", 0.1) -- Left
createArrow("16848361091", 0.9) -- Right

-- [[ BUTTON SYSTEM ]]
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
    Instance.new("UIAspectRatioConstraint", btn).AspectRatio = 77/38 --
    btn.MouseButton1Click:Connect(callback)
end

-- Fixed Button Order
createBtn("+", Color3.new(0,0,0), Color3.new(1,1,1), 1, function() print("Menu") end)
createBtn("Inf-Jump", Color3.new(0,0,0), Color3.new(1,1,1), 2, function() print("Jump") end)
createBtn("Fling-GUI", Color3.new(0,0,0), Color3.new(1,1,1), 3, function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/null0-GUI/null0-Roblox/refs/heads/main/Main.lua?token=GHSAT0AAAAAADTABDZW7LWILHWOAG4JNKC62LEGBBQ"))()
end)
createBtn("Fly", Color3.new(0,0,0), Color3.new(1,1,1), 4, function() print("Fly") end)
createBtn("John Doe", Color3.fromRGB(248, 217, 109), Color3.new(0,0,0), 999, function()
    pcall(function()
        local model = InsertService:LoadAsset(21070012)
        local accessory = model:FindFirstChildOfClass("Accessory")
        if accessory then player.Character.Humanoid:AddAccessory(accessory:Clone()) end
    end)
end)

-- [[ CONSOLE LOG SYSTEM (F9 + 9) ]]
local consoleFrame = Instance.new("Frame", screenGui)
consoleFrame.BackgroundColor3 = Color3.fromRGB(77, 77, 77)
consoleFrame.BackgroundTransparency = 0.2
consoleFrame.Size = UDim2.fromScale(0.35, 0.45)
consoleFrame.Position = UDim2.fromScale(0.05, 0.05)
consoleFrame.BorderSizePixel = 0
consoleFrame.Visible = false
makeDraggable(consoleFrame)

local logList = Instance.new("ScrollingFrame", consoleFrame)
logList.Size = UDim2.fromScale(0.95, 0.9)
logList.Position = UDim2.fromScale(0.025, 0.05)
logList.BackgroundTransparency = 1
logList.AutomaticCanvasSize = Enum.AutomaticSize.Y
logList.CanvasSize = UDim2.new(0,0,0,0)
logList.ScrollBarThickness = 2
Instance.new("UIListLayout", logList)

game:GetService("LogService").MessageOut:Connect(function(msg, msgType)
    local label = Instance.new("TextLabel", logList)
    label.Size = UDim2.new(1, 0, 0, 18)
    label.BackgroundTransparency = 1
    label.Text = "[" .. os.date("%X") .. "] " .. msg
    label.TextColor3 = (msgType == Enum.MessageType.MessageError and Color3.new(1,0,0)) or Color3.new(1,1,1)
    label.Font = Enum.Font.Code
    label.TextScaled = true
    label.TextXAlignment = Enum.TextXAlignment.Left
end)

local f9Down = false
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F9 then f9Down = true
    elseif input.KeyCode == Enum.KeyCode.Nine and f9Down then
        consoleFrame.Visible = not consoleFrame.Visible
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F9 then f9Down = false end
end)
