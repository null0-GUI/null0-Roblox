-- [[ null0 FE - Final Stable Version ]]
local player = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local InsertService = game:GetService("InsertService")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")

-- 1. ROOT SETUP
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "null0"
screenGui.Parent = (RunService:IsStudio() and player.PlayerGui or CoreGui)
screenGui.ResetOnSpawn = false

-- FIXED DRAGGABLE LOGIC
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
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

-- 2. MAIN HOLDER (Color: 77, 77, 77 | Transparency: 0.2)
local mainHolder = Instance.new("Frame", screenGui)
mainHolder.Name = "MainHolder"
mainHolder.BackgroundColor3 = Color3.fromRGB(77, 77, 77)
mainHolder.BackgroundTransparency = 0.2
mainHolder.BorderSizePixel = 0
mainHolder.Size = UDim2.fromScale(0.45, 0.55)
mainHolder.Position = UDim2.fromScale(0.5, 0.5)
mainHolder.AnchorPoint = Vector2.new(0.5, 0.5)
makeDraggable(mainHolder)

-- 3. AESTHETICS (Hierarchy: MainHolder > Asethetics)
local asethetics = Instance.new("Folder", mainHolder)
asethetics.Name = "Asethetics"

-- Fixed Borders (Color: 50, 50, 50 | Scaled for 43x574 look)
local function createBorder(name, side)
    local border = Instance.new("Frame", asethetics)
    border.Name = name
    border.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    border.BorderSizePixel = 0
    border.Size = UDim2.fromScale(0.08, 1.3)
    border.Position = (side == "Left") and UDim2.fromScale(0, 0.5) or UDim2.fromScale(1, 0.5)
    border.AnchorPoint = (side == "Left") and Vector2.new(1, 0.5) or Vector2.new(0, 0.5)
    Instance.new("UIAspectRatioConstraint", border).AspectRatio = 43/574 --
end
createBorder("LeftBorder", "Left")
createBorder("RightBorder", "Right")

-- Tabs (Title & Arrows)
local tabs = Instance.new("Frame", asethetics)
tabs.Name = "Tabs"
tabs.Size = UDim2.fromScale(1, 0.15)
tabs.BackgroundTransparency = 1

local title = Instance.new("TextLabel", tabs)
title.Name = "Title"
title.Text = "Built in Buttons"
title.Size = UDim2.fromScale(0.6, 0.8)
title.Position = UDim2.fromScale(0.5, 0.5)
title.AnchorPoint = Vector2.new(0.5, 0.5)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1, 1, 1)
title.TextScaled = true
title.Font = Enum.Font.SourceSansBold --

local function createArrow(name, xPos, rotation)
    local arrow = Instance.new("ImageButton", tabs)
    arrow.Name = name
    arrow.Image = "rbxassetid://16848361091"
    arrow.Size = UDim2.fromScale(0.1, 0.8)
    arrow.Position = UDim2.fromScale(xPos, 0.5)
    arrow.AnchorPoint = Vector2.new(0.5, 0.5)
    arrow.Rotation = rotation
    arrow.BackgroundTransparency = 1
    Instance.new("UIAspectRatioConstraint", arrow).AspectRatio = 1
end
createArrow("Left", 0.1, 0)
createArrow("Right", 0.9, 180)

-- 4. BUTTON HOLDER (Matching image_5af8ec.png properties)
local buttonHolder = Instance.new("ScrollingFrame", mainHolder)
buttonHolder.Name = "ButtonHolder"
buttonHolder.Size = UDim2.fromScale(0.95, 0.75)
buttonHolder.Position = UDim2.fromScale(0.025, 0.2)
buttonHolder.BackgroundTransparency = 1
buttonHolder.ScrollBarThickness = 0
buttonHolder.CanvasSize = UDim2.new(0,0,0,0)
buttonHolder.AutomaticCanvasSize = Enum.AutomaticSize.Y

local layout = Instance.new("UIGridLayout", buttonHolder)
layout.CellPadding = UDim2.new(0, 10, 0, 5) --
layout.CellSize = UDim2.new(0, 77, 0, 38)    --
layout.SortOrder = Enum.SortOrder.LayoutOrder

local function createBtn(name, color, txtCol, order, callback)
    local btn = Instance.new("TextButton", buttonHolder)
    btn.Text = name
    btn.BackgroundColor3 = color
    btn.TextColor3 = txtCol
    btn.LayoutOrder = order
    btn.BorderSizePixel = 0
    btn.TextScaled = true
    btn.Font = Enum.Font.SourceSansBold
    btn.MouseButton1Click:Connect(callback)
end

-- 5. BUTTONS SETUP
createBtn("+", Color3.new(0,0,0), Color3.new(1,1,1), 1, function() print("Add Menu") end)

createBtn("Inf-Jump", Color3.new(0,0,0), Color3.new(1,1,1), 2, function()
    local conn = UserInputService.JumpRequest:Connect(function()
        player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end)
    print("Inf-Jump Loaded")
end)

createBtn("Fling-GUI", Color3.new(0,0,0), Color3.new(1,1,1), 3, function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/null0-GUI/null0-Roblox/refs/heads/main/Main.lua?token=GHSAT0AAAAAADTABDZW7LWILHWOAG4JNKC62LEGBBQ"))()
end)

createBtn("Fly", Color3.new(0,0,0), Color3.new(1,1,1), 4, function() 
    print("Fly Feature Pending (Using code from c00lClan!.txt)") 
end)

-- PATCHED JOHN DOE (Using Logic from uploaded .txt)
createBtn("John Doe", Color3.fromRGB(248, 217, 109), Color3.new(0,0,0), 999, function()
    pcall(function()
        -- Sound Patch
        local s = Instance.new("Sound", SoundService)
        s.SoundId = "rbxassetid://19094700"
        s.Volume = 1
        s.Looped = true
        s:Play()
        
        -- Appearance Patch
        local sky = Lighting:FindFirstChildOfClass("Sky") or Instance.new("Sky", Lighting)
        sky.SkyboxBk = "rbxassetid://1012887"
        sky.SkyboxDn = "rbxassetid://1012887"
        
        -- Accessory Patch
        local model = InsertService:LoadAsset(21070012)
        local acc = model:FindFirstChildOfClass("Accessory")
        if acc then player.Character.Humanoid:AddAccessory(acc:Clone()) end
        print("John Doe Patched & Loaded")
    end)
end)

-- 6. CONSOLE FRAME (F9 + 9 Toggle)
local consoleFrame = Instance.new("Frame", screenGui)
consoleFrame.BackgroundColor3 = Color3.fromRGB(77, 77, 77)
consoleFrame.BackgroundTransparency = 0.2
consoleFrame.Size = UDim2.fromScale(0.4, 0.4)
consoleFrame.Position = UDim2.fromScale(0.05, 0.05)
consoleFrame.Visible = false
makeDraggable(consoleFrame)

local logList = Instance.new("ScrollingFrame", consoleFrame)
logList.Size = UDim2.fromScale(0.9, 0.9)
logList.Position = UDim2.fromScale(0.05, 0.05)
logList.BackgroundTransparency = 1
logList.AutomaticCanvasSize = Enum.AutomaticSize.Y
logList.CanvasSize = UDim2.new(0,0,0,0)
Instance.new("UIListLayout", logList)

game:GetService("LogService").MessageOut:Connect(function(msg)
    local l = Instance.new("TextLabel", logList)
    l.Size = UDim2.new(1, 0, 0, 20)
    l.BackgroundTransparency = 1
    l.Text = "[" .. os.date("%X") .. "] " .. msg
    l.TextColor3 = Color3.new(1,1,1)
    l.TextScaled = true
    l.TextXAlignment = Enum.TextXAlignment.Left
end)

local f9Down = false
UserInputService.InputBegan:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.F9 then f9Down = true
    elseif i.KeyCode == Enum.KeyCode.Nine and f9Down then
        consoleFrame.Visible = not consoleFrame.Visible
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.F9 then f9Down = false end
end)
