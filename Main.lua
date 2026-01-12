-- [[ null0 FE - Final Design Correction ]]
local player = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local Debris = game:GetService("Debris")

-- 1. ROOT SETUP
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "null0_FE_Final"
screenGui.Parent = (RunService:IsStudio() and player.PlayerGui or CoreGui)
screenGui.ResetOnSpawn = false

-- Draggable Helper
local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging, dragStart, startPos = true, input.Position, frame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

-- 2. MAIN HOLDER
local mainHolder = Instance.new("Frame", screenGui)
mainHolder.Name = "MainHolder"
mainHolder.BackgroundColor3 = Color3.fromRGB(77, 77, 77)
mainHolder.BackgroundTransparency = 0.2
mainHolder.Size = UDim2.fromScale(0.45, 0.55)
mainHolder.Position = UDim2.fromScale(0.5, 0.5)
mainHolder.AnchorPoint = Vector2.new(0.5, 0.5)
mainHolder.BorderSizePixel = 2
mainHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
makeDraggable(mainHolder)

-- 3. AESTHETICS FOLDER (Hierarchy: MainHolder > Aesthetics)
local aesthetics = Instance.new("Folder", mainHolder)
aesthetics.Name = "Aesthetics"

local null0Title = Instance.new("TextLabel", mainHolder)
null0Title.Name = "null0"
null0Title.Text = "null0"
null0Title.Size = UDim2.new(1, 0, 0.1, 0)
null0Title.Position = UDim2.new(0, 0, -0.12, 0)
null0Title.BackgroundTransparency = 1
null0Title.TextColor3 = Color3.new(1, 1, 1)
null0Title.TextScaled = true
null0Title.Font = Enum.Font.SourceSansBold
null0Title.Parent = aesthetics

-- 4. TABS (Grayed out as requested)
local tabs = Instance.new("Frame", mainHolder)
tabs.Name = "Tabs"
tabs.Size = UDim2.new(1, 0, 0.15, 0)
tabs.BackgroundColor3 = Color3.fromRGB(45, 45, 45) -- Grayed out
tabs.BorderSizePixel = 0

local title = Instance.new("TextLabel", tabs)
title.Name = "Title"
title.Text = "Built in Buttons"
title.Size = UDim2.fromScale(0.5, 0.8)
title.Position = UDim2.fromScale(0.5, 0.5)
title.AnchorPoint = Vector2.new(0.5, 0.5)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1, 1, 1)
title.TextScaled = true
title.Font = Enum.Font.SourceSansBold

-- 5. IMAGEBUTTON ARROWS (Left/Right)
local leftArrow = Instance.new("ImageButton", tabs)
leftArrow.Name = "LeftArrow"
leftArrow.Size = UDim2.new(0.1, 0, 0.8, 0)
leftArrow.Position = UDim2.new(0.05, 0, 0.1, 0)
leftArrow.Image = "rbxassetid://2500573769" -- Generic Arrow Image
leftArrow.BackgroundTransparency = 1

local rightArrow = Instance.new("ImageButton", tabs)
rightArrow.Name = "RightArrow"
rightArrow.Size = UDim2.new(0.1, 0, 0.8, 0)
rightArrow.Position = UDim2.new(0.85, 0, 0.1, 0)
rightArrow.Image = "rbxassetid://2500573769"
rightArrow.Rotation = 180
rightArrow.BackgroundTransparency = 1

-- 6. BUTTON HOLDER (Strict Grid + LayoutOrder)
local buttonHolder = Instance.new("ScrollingFrame", mainHolder)
buttonHolder.Name = "ButtonHolder"
buttonHolder.Size = UDim2.fromScale(0.9, 0.75)
buttonHolder.Position = UDim2.fromScale(0.05, 0.2)
buttonHolder.BackgroundTransparency = 1
buttonHolder.ScrollBarThickness = 0
buttonHolder.AutomaticCanvasSize = Enum.AutomaticSize.Y

local layout = Instance.new("UIGridLayout", buttonHolder)
layout.CellPadding = UDim2.new(0, 10, 0, 10)
layout.CellSize = UDim2.new(0, 77, 0, 38)
layout.SortOrder = Enum.SortOrder.LayoutOrder -- FIXED: Uses LayoutOrder property

-- 7. FUNCTIONAL ADD MENU (+ Button Setup)
local addMenu = Instance.new("Frame", screenGui)
addMenu.Name = "AddMenu"
addMenu.Size = UDim2.fromScale(0.3, 0.3)
addMenu.Position = UDim2.fromScale(0.5, 0.5)
addMenu.AnchorPoint = Vector2.new(0.5, 0.5)
addMenu.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
addMenu.BorderSizePixel = 2
addMenu.Visible = false
makeDraggable(addMenu)

local nameBox = Instance.new("TextBox", addMenu)
nameBox.PlaceholderText = "Button Name"
nameBox.Size = UDim2.new(0.8, 0, 0, 30)
nameBox.Position = UDim2.new(0.1, 0, 0.2, 0)

local scriptBox = Instance.new("TextBox", addMenu)
scriptBox.PlaceholderText = "Loadstring URL"
scriptBox.Size = UDim2.new(0.8, 0, 0, 30)
scriptBox.Position = UDim2.new(0.1, 0, 0.5, 0)

-- Button Creation Factory
local function createBtn(name, color, order, callback)
    local btn = Instance.new("TextButton", buttonHolder)
    btn.Name = name
    btn.Text = name
    btn.BackgroundColor3 = color
    btn.TextColor3 = (color == Color3.new(0,0,0)) and Color3.new(1,1,1) or Color3.new(0,0,0)
    btn.LayoutOrder = order -- STRICT NUMERICAL ORDER
    btn.BorderSizePixel = 2
    btn.BorderColor3 = Color3.new(0,0,0)
    btn.TextScaled = true
    btn.Font = Enum.Font.SourceSansBold
    btn.MouseButton1Click:Connect(callback)
end

local addBtnOrder = 10
local createFinal = Instance.new("TextButton", addMenu)
createFinal.Text = "Create"
createFinal.Size = UDim2.new(0.6, 0, 0, 30)
createFinal.Position = UDim2.new(0.2, 0, 0.8, 0)
createFinal.MouseButton1Click:Connect(function()
    if nameBox.Text ~= "" and scriptBox.Text ~= "" then
        createBtn(nameBox.Text, Color3.new(0,0,0), addBtnOrder, function()
            loadstring(game:HttpGet(scriptBox.Text))()
        end)
        addBtnOrder = addBtnOrder + 1
        addMenu.Visible = false
    end
end)

-- 8. LOAD BUTTONS (STRICT ORDER)
createBtn("+", Color3.new(0,0,0), 1, function() addMenu.Visible = not addMenu.Visible end)
createBtn("Fly", Color3.new(0,0,0), 2, function() 
    loadstring(game:HttpGet("https://raw.githubusercontent.com/null0-GUI/null0-Roblox/refs/heads/main/Fly.lua"))() 
end)
createBtn("Inf-Jump", Color3.new(0,0,0), 3, function() 
    UserInputService.JumpRequest:Connect(function()
        player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end)
end)
createBtn("Fling-GUI", Color3.new(0,0,0), 4, function() 
    loadstring(game:HttpGet("https://raw.githubusercontent.com/null0-GUI/null0-Roblox/refs/heads/main/Main.lua"))()
end)

-- PATCHED JOHN DOE (Logic from c00lClan!.txt)
createBtn("John Doe", Color3.fromRGB(248, 217, 109), 5, function()
    -- Atmosphere [cite: 16]
    local sky = Lighting:FindFirstChildOfClass("Sky") or Instance.new("Sky", Lighting)
    sky.SkyboxBk, sky.SkyboxDn, sky.SkyboxFt = "rbxassetid://1012887", "rbxassetid://1012887", "rbxassetid://1012887"
    
    -- Sound [cite: 17]
    local s = Instance.new("Sound", SoundService)
    s.SoundId = "rbxassetid://19094700"; s.Volume = 1; s.Looped = true; s:Play()

    -- Neon Steps [cite: 20]
    RunService.Heartbeat:Connect(function()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") and char.HumanoidRootPart.Velocity.Magnitude > 2 then
            local p = Instance.new("Part", workspace)
            p.Size, p.Anchored, p.CanCollide = Vector3.new(4,0.2,4), true, false
            p.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(0,-3,0)
            p.Material, p.Color = Enum.Material.Neon, Color3.new(0,0,0)
            Debris:AddItem(p, 0.5)
        end
    end)
end)
