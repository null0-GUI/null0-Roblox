-- [[ null0 FE - Final Integrated Loadstring Version ]]
local player = game:GetService("Players").LocalPlayer
local HttpService = game:GetService("HttpService")
local InsertService = game:GetService("InsertService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local SAVE_FILE = "null0_customs.json"

-- 1. ScreenGui Root
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "null0"
screenGui.Parent = (RunService:IsStudio() and player.PlayerGui or CoreGui)
screenGui.ResetOnSpawn = false

-- 2. MainHolder (Color: 77, 77, 77 | Transparency: 0.2)
local mainHolder = Instance.new("Frame")
mainHolder.Name = "MainHolder"
mainHolder.BackgroundColor3 = Color3.fromRGB(77, 77, 77)
mainHolder.BackgroundTransparency = 0.2
mainHolder.BorderSizePixel = 0
mainHolder.Size = UDim2.fromScale(0.45, 0.55)
mainHolder.Position = UDim2.fromScale(0.5, 0.5)
mainHolder.AnchorPoint = Vector2.new(0.5, 0.5)
mainHolder.Active = true
mainHolder.Draggable = true 
mainHolder.Parent = screenGui

-- 3. Aesthetics Folder (Borders & Tabs)
local asethetics = Instance.new("Folder")
asethetics.Name = "Asethetics"
asethetics.Parent = mainHolder

-- Borders (Color: 50, 50, 50 | Size Offset: 43x574)
local function createBorder(pos)
    local border = Instance.new("Frame")
    border.Name = "Borders"
    border.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    border.Size = UDim2.new(0, 43, 0, 574)
    border.Position = pos
    border.BorderSizePixel = 0
    border.Parent = asethetics
end
createBorder(UDim2.new(0, -45, 0.5, -287))
createBorder(UDim2.new(1, 2, 0.5, -287))

-- Tabs & Title (Image ID: 16848361091 | Size Scale: 0.026, 0.04)
local tabs = Instance.new("Frame")
tabs.Name = "Tabs"
tabs.Size = UDim2.fromScale(1, 0.1)
tabs.BackgroundTransparency = 1
tabs.Parent = asethetics

local function createArrow(name, img, pos)
    local arrow = Instance.new("ImageButton")
    arrow.Name = name
    arrow.Image = "rbxassetid://" .. img
    arrow.Size = UDim2.fromScale(0.026, 0.04)
    arrow.Position = pos
    arrow.BackgroundTransparency = 1
    arrow.Parent = tabs
end
createArrow("Left", "16848361091", UDim2.fromScale(0.05, 0.3))
createArrow("Right", "16848361091", UDim2.fromScale(0.9, 0.3))

-- 4. ButtonHolder & UIGridLayout (Scale conversion from your Properties)
local buttonHolder = Instance.new("ScrollingFrame")
buttonHolder.Name = "ButtonHolder"
buttonHolder.Size = UDim2.fromScale(0.85, 0.75)
buttonHolder.Position = UDim2.fromScale(0.075, 0.2)
buttonHolder.BackgroundTransparency = 1
buttonHolder.ScrollBarThickness = 0
buttonHolder.Parent = mainHolder

local layout = Instance.new("UIGridLayout")
layout.CellPadding = UDim2.fromScale(0.02, 0.01) -- Scaled from {0, 10}, {0, 5}
layout.CellSize = UDim2.fromScale(0.18, 0.1)    -- Scaled from {0, 77}, {0, 38}
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = buttonHolder

-- 5. Helper Functions
local function saveScripts(data)
    if writefile then writefile(SAVE_FILE, HttpService:JSONEncode(data)) end
end

local function loadScripts()
    if isfile and isfile(SAVE_FILE) then return HttpService:JSONDecode(readfile(SAVE_FILE)) end
    return {}
end

local function giveVoidStar()
    pcall(function()
        local asset = InsertService:LoadAsset(21070012)
        local crown = asset:FindFirstChildOfClass("Accessory")
        if crown then crown.Parent = player.Character end
    end)
end

-- 6. Button Factory
local currentLayout = 4
local savedData = loadScripts()

local function createBtn(name, color, txtCol, order, callback, isCustom)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Text = name
    btn.BackgroundColor3 = color
    btn.TextColor3 = txtCol
    btn.LayoutOrder = order
    btn.BorderSizePixel = 0
    btn.Parent = buttonHolder
    
    btn.MouseButton1Click:Connect(callback)
    
    if isCustom then
        btn.MouseButton2Click:Connect(function() -- Right Click to Delete
            savedData[name] = nil
            saveScripts(savedData)
            btn:Destroy()
        end)
    end
end

-- 7. Built-in Buttons
createBtn("JohnDoe", Color3.fromRGB(248, 217, 109), Color3.fromRGB(0,0,0), 1, function()
    giveVoidStar()
    print("John Doe: Void Star Awarded")
end)

createBtn("Fling-GUI", Color3.fromRGB(0,0,0), Color3.fromRGB(255,255,255), 2, function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/null0-GUI/null0-Roblox/refs/heads/main/Main.lua?token=GHSAT0AAAAAADTABDZW7LWILHWOAG4JNKC62LEGBBQ"))()
end)

createBtn("Fly", Color3.fromRGB(0,0,0), Color3.fromRGB(255,255,255), 3, function() print("Fly Enabled") end)

-- 8. Custom "+" Menu & Logic
local addMenu = Instance.new("Frame")
addMenu.Size = UDim2.fromScale(0.3, 0.35)
addMenu.Position = UDim2.fromScale(0.5, 0.5)
addMenu.AnchorPoint = Vector2.new(0.5, 0.5)
addMenu.BackgroundColor3 = Color3.fromRGB(77, 77, 77)
addMenu.BackgroundTransparency = 0.1
addMenu.Visible = false
addMenu.Parent = screenGui

local nameIn = Instance.new("TextBox")
nameIn.PlaceholderText = "Name"
nameIn.Size = UDim2.fromScale(0.8, 0.2)
nameIn.Position = UDim2.fromScale(0.1, 0.15)
nameIn.Parent = addMenu

local urlIn = Instance.new("TextBox")
urlIn.PlaceholderText = "Loadstring URL"
urlIn.Size = UDim2.fromScale(0.8, 0.2)
urlIn.Position = UDim2.fromScale(0.1, 0.45)
urlIn.Parent = addMenu

local finishBtn = Instance.new("TextButton")
finishBtn.Text = "Create Button"
finishBtn.Size = UDim2.fromScale(0.6, 0.2)
finishBtn.Position = UDim2.fromScale(0.2, 0.75)
finishBtn.Parent = addMenu

createBtn("+", Color3.fromRGB(0,0,0), Color3.fromRGB(255,255,255), 123, function()
    addMenu.Visible = not addMenu.Visible
end)

local function spawnCustom(name, url, save)
    createBtn(name, Color3.fromRGB(0,0,0), Color3.fromRGB(255,255,255), currentLayout, function()
        loadstring(game:HttpGet(url))()
    end, true)
    currentLayout = currentLayout + 1
    if save then
        savedData[name] = url
        saveScripts(savedData)
    end
end

finishBtn.MouseButton1Click:Connect(function()
    if nameIn.Text ~= "" and urlIn.Text ~= "" then
        spawnCustom(nameIn.Text, urlIn.Text, true)
        addMenu.Visible = false
        nameIn.Text = ""
        urlIn.Text = ""
    end
end)

-- Load existing customs
for n, u in pairs(savedData) do spawnCustom(n, u, false) end
