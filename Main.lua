-- [[ null0 FE Script - Final Integrated ]]
local player = game.Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local InsertService = game:GetService("InsertService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local SAVE_FILE = "null0_scripts_v2.json"

-- 1. UI Root Structure
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "null0"
screenGui.Parent = (RunService:IsStudio() and player.PlayerGui or CoreGui)
screenGui.ResetOnSpawn = false

-- 2. MainHolder (77, 77, 77 | 0.2 Transparency)
local mainHolder = Instance.new("Frame")
mainHolder.Name = "MainHolder"
mainHolder.Size = UDim2.fromScale(0.4, 0.5)
mainHolder.Position = UDim2.fromScale(0.5, 0.5)
mainHolder.AnchorPoint = Vector2.new(0.5, 0.5)
mainHolder.BackgroundColor3 = Color3.fromRGB(77, 77, 77)
mainHolder.BackgroundTransparency = 0.2
mainHolder.BorderSizePixel = 0
mainHolder.Active = true
mainHolder.Draggable = true -- Added for convenience
mainHolder.Parent = screenGui

-- 3. Borders (50, 50, 50 | Using requested size offsets)
local function createBorder(anchor)
    local border = Instance.new("Frame")
    border.Name = "Border"
    border.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    border.Size = UDim2.new(0, 43, 0, 574) -- Requested offset size
    border.Position = anchor
    border.BorderSizePixel = 0
    border.Parent = mainHolder
end
createBorder(UDim2.fromScale(-0.05, -0.1)) -- Adjusted to flank the box

-- 4. ButtonHolder & Grid
local buttonHolder = Instance.new("ScrollingFrame")
buttonHolder.Name = "ButtonHolder"
buttonHolder.Size = UDim2.fromScale(0.85, 0.7)
buttonHolder.Position = UDim2.fromScale(0.075, 0.2)
buttonHolder.BackgroundTransparency = 1
buttonHolder.ScrollBarThickness = 0
buttonHolder.Parent = mainHolder

local layout = Instance.new("UIGridLayout")
layout.CellPadding = UDim2.fromScale(0.02, 0.02)
layout.CellSize = UDim2.fromScale(0.2, 0.1) -- Scaled from 77x38
layout.Parent = buttonHolder

-- 5. Logic Modules
local function saveConfig(data)
    if writefile then writefile(SAVE_FILE, HttpService:JSONEncode(data)) end
end

local function loadConfig()
    if isfile and isfile(SAVE_FILE) then return HttpService:JSONDecode(readfile(SAVE_FILE)) end
    return {}
end

local function giveVoidStar()
    pcall(function()
        local model = InsertService:LoadAsset(21070012)
        local crown = model:FindFirstChildOfClass("Accessory")
        if crown then crown.Parent = player.Character end
    end)
end

local function executeFling()
    -- Loadstring trigger
    task.spawn(function()
        pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Example/Fling/main.lua"))() end)
    end)
    -- Mechanical Fixed Fling
    local mouse = player:GetMouse()
    local target = mouse.Target
    if target and target.Parent:FindFirstChild("Humanoid") then
        local hrp = target.Parent:FindFirstChild("HumanoidRootPart")
        if hrp then
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bv.Velocity = Vector3.new(9e5, 9e5, 9e5)
            bv.Parent = hrp
            task.wait(0.1)
            bv:Destroy()
        end
    end
end

-- 6. Add Menu (Mini null0 GUI)
local addMenu = Instance.new("Frame")
addMenu.Size = UDim2.fromScale(0.25, 0.3)
addMenu.Position = UDim2.fromScale(0.5, 0.5)
addMenu.AnchorPoint = Vector2.new(0.5, 0.5)
addMenu.BackgroundColor3 = Color3.fromRGB(77, 77, 77)
addMenu.BackgroundTransparency = 0.2
addMenu.Visible = false
addMenu.Parent = screenGui

local nameIn = Instance.new("TextBox")
nameIn.PlaceholderText = "Button Name"
nameIn.Size = UDim2.fromScale(0.8, 0.25)
nameIn.Position = UDim2.fromScale(0.1, 0.1)
nameIn.Parent = addMenu

local urlIn = Instance.new("TextBox")
urlIn.PlaceholderText = "Loadstring URL"
urlIn.Size = UDim2.fromScale(0.8, 0.25)
urlIn.Position = UDim2.fromScale(0.1, 0.4)
urlIn.Parent = addMenu

local createBtn = Instance.new("TextButton")
createBtn.Text = "Create"
createBtn.Size = UDim2.fromScale(0.4, 0.2)
createBtn.Position = UDim2.fromScale(0.3, 0.75)
createBtn.Parent = addMenu

-- 7. Button Generator
local currentOrder = 4
local savedData = loadConfig()

local function createBtnObj(name, color, txtColor, order, callback, isCustom)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Text = name
    btn.BackgroundColor3 = color
    btn.TextColor3 = txtColor
    btn.LayoutOrder = order
    btn.BorderSizePixel = 0
    btn.Parent = buttonHolder
    
    btn.MouseButton1Click:Connect(callback)
    
    if isCustom then
        -- DELETE FEATURE: Right-click to remove
        btn.MouseButton2Click:Connect(function()
            savedData[name] = nil
            saveConfig(savedData)
            btn:Destroy()
        end)
    end
    return btn
end

-- Default Buttons
createBtnObj("John Doe", Color3.fromRGB(248, 217, 109), Color3.fromRGB(0,0,0), 1, function()
    giveVoidStar()
    print("John Doe Activated")
end)

createBtnObj("Fling-GUI", Color3.fromRGB(0,0,0), Color3.fromRGB(255,255,255), 2, executeFling)
createBtnObj("Fly", Color3.fromRGB(0,0,0), Color3.fromRGB(255,255,255), 3, function() print("Fly") end)

-- Add Button (+)
local plusBtn = createBtnObj("+", Color3.fromRGB(0,0,0), Color3.fromRGB(255,255,255), 123, function()
    addMenu.Visible = not addMenu.Visible
end)

-- Custom Button Logic
local function spawnCustom(name, url, save)
    createBtnObj(name, Color3.fromRGB(0,0,0), Color3.fromRGB(255,255,255), currentOrder, function()
        loadstring(game:HttpGet(url))()
    end, true)
    currentOrder = currentOrder + 1
    if save then
        savedData[name] = url
        saveConfig(savedData)
    end
end

createBtn.MouseButton1Click:Connect(function()
    if nameIn.Text ~= "" and urlIn.Text ~= "" then
        spawnCustom(nameIn.Text, urlIn.Text, true)
        addMenu.Visible = false
    end
end)

-- Initialize Saved Scripts
for name, url in pairs(savedData) do
    spawnCustom(name, url, false)
end