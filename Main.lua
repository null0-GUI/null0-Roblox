-- [[ null0 FE - Layout & John Doe Final Patch ]]
local player = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local Debris = game:GetService("Debris")

-- 1. ROOT SETUP
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "null0_Final"
screenGui.Parent = (RunService:IsStudio() and player.PlayerGui or CoreGui)
screenGui.ResetOnSpawn = false

-- DRAGGABLE LOGIC
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
mainHolder.BackgroundColor3 = Color3.fromRGB(77, 77, 77)
mainHolder.BackgroundTransparency = 0.2
mainHolder.Size = UDim2.fromScale(0.45, 0.55)
mainHolder.Position = UDim2.fromScale(0.5, 0.5)
mainHolder.AnchorPoint = Vector2.new(0.5, 0.5)
makeDraggable(mainHolder)

-- 3. AESTHETICS & TABS
local asethetics = Instance.new("Folder", mainHolder)
asethetics.Name = "Asethetics"

local tabs = Instance.new("Frame", mainHolder)
tabs.Name = "Tabs"
tabs.Size = UDim2.fromScale(1, 0.15)
tabs.BackgroundTransparency = 1

local title = Instance.new("TextLabel", tabs)
title.Text = "Built in Buttons"
title.Size = UDim2.fromScale(1, 1)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1, 1, 1)
title.TextScaled = true
title.Font = Enum.Font.SourceSansBold

-- 4. BUTTON HOLDER (FIXED LAYOUT ORDER)
local buttonHolder = Instance.new("ScrollingFrame", mainHolder)
buttonHolder.Name = "ButtonHolder"
buttonHolder.Size = UDim2.fromScale(0.95, 0.75)
buttonHolder.Position = UDim2.fromScale(0.025, 0.2)
buttonHolder.BackgroundTransparency = 1
buttonHolder.ScrollBarThickness = 0
buttonHolder.CanvasSize = UDim2.new(0,0,0,0)
buttonHolder.AutomaticCanvasSize = Enum.AutomaticSize.Y

local layout = Instance.new("UIGridLayout", buttonHolder)
layout.CellPadding = UDim2.new(0, 10, 0, 10)
layout.CellSize = UDim2.new(0, 85, 0, 40)
layout.SortOrder = Enum.SortOrder.LayoutOrder -- ENSURES BUTTONS FOLLOW THE NUMBERS BELOW

local function createBtn(name, color, order, callback)
    local btn = Instance.new("TextButton", buttonHolder)
    btn.Name = name
    btn.Text = name
    btn.BackgroundColor3 = color
    btn.TextColor3 = (color == Color3.new(0,0,0)) and Color3.new(1,1,1) or Color3.new(0,0,0)
    btn.LayoutOrder = order -- THIS FIXES THE FLIPPED LAYOUT
    btn.BorderSizePixel = 0
    btn.TextScaled = true
    btn.Font = Enum.Font.SourceSansBold
    btn.MouseButton1Click:Connect(callback)
end

-- 5. BUTTON LIST (ORDERED AS REQUESTED)
createBtn("+", Color3.new(0,0,0), 1, function() print("Add") end)
createBtn("Fly", Color3.new(0,0,0), 2, function() print("Fly") end)
createBtn("Inf-Jump", Color3.new(0,0,0), 3, function() 
    UserInputService.JumpRequest:Connect(function()
        player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end)
end)
createBtn("Fling-GUI", Color3.new(0,0,0), 4, function() 
    loadstring(game:HttpGet("https://raw.githubusercontent.com/null0-GUI/null0-Roblox/refs/heads/main/Main.lua"))()
end)

-- FULLY PATCHED JOHN DOE
createBtn("John Doe", Color3.fromRGB(248, 217, 109), 5, function()
    -- Skybox Patch
    local sky = Lighting:FindFirstChildOfClass("Sky") or Instance.new("Sky", Lighting)
    sky.SkyboxBk = "rbxassetid://1012887"
    sky.SkyboxDn = "rbxassetid://1012887"
    sky.SkyboxFt = "rbxassetid://1012887"
    sky.SkyboxLf = "rbxassetid://1012887"
    sky.SkyboxRt = "rbxassetid://1012887"
    sky.SkyboxUp = "rbxassetid://1012887"

    -- Character Logic Setup
    local function applyJohnDoe(char)
        local head = char:WaitForChild("Head")
        local hrp = char:WaitForChild("HumanoidRootPart")

        -- Name Tag Shaker
        local bgui = Instance.new("BillboardGui", char)
        bgui.Size = UDim2.new(0, 150, 0, 50)
        bgui.StudsOffset = Vector3.new(0, 3, 0)
        bgui.Adornee = head
        
        local label = Instance.new("TextLabel", bgui)
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, 0, 1, 0)
        label.Font = Enum.Font.Fantasy
        label.TextColor3 = Color3.new(0,0,0)
        label.TextStrokeTransparency = 0
        label.TextScaled = true

        task.spawn(function()
            local phrases = {"ROBLOXIA'S DEATH IS HERE", "YOUR DEAD ASSHOLE", "BURN IN HELL FAGGOT", "NULL"}
            while char:IsDescendantOf(workspace) do
                label.Text = phrases[math.random(1, #phrases)]
                bgui.StudsOffset = Vector3.new(math.random(-1,1), 3 + math.random(-1,1), math.random(-1,1))
                task.wait(0.2)
            end
        end)

        -- Neon Footsteps
        RunService.Heartbeat:Connect(function()
            if char:IsDescendantOf(workspace) and hrp.Velocity.Magnitude > 2 then
                local p = Instance.new("Part", workspace)
                p.Size = Vector3.new(4, 0.2, 4)
                p.CFrame = hrp.CFrame * CFrame.new(0, -3, 0)
                p.Anchored, p.CanCollide = true, false
                p.Material, p.Color = Enum.Material.Neon, Color3.new(0,0,0)
                Debris:AddItem(p, 1)
            end
        end)
    end

    if player.Character then applyJohnDoe(player.Character) end
    player.CharacterAdded:Connect(applyJohnDoe)
end)
