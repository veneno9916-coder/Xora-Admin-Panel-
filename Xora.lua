--========================================================
-- XORA EXECUTOR EDITION v3.4
-- Single File | PC + Mobile | Roblox Luau
--========================================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local GUI_NAME = "XORA_GUI"

if PlayerGui:FindFirstChild(GUI_NAME) then
    PlayerGui[GUI_NAME]:Destroy()
end

local Theme = {
    Background = Color3.fromRGB(13,15,23),
    Panel = Color3.fromRGB(23,26,38),
    Accent = Color3.fromRGB(110,90,255),
    Text = Color3.fromRGB(240,240,250),
    Muted = Color3.fromRGB(145,150,170),
    Green = Color3.fromRGB(65,200,130),
    Red = Color3.fromRGB(210,55,70)
}

local function New(class,props,parent)
    local obj = Instance.new(class)
    for k,v in pairs(props) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

local function Corner(obj,r)
    New("UICorner",{
        CornerRadius = UDim.new(0,r or 8)
    },obj)
end

local function Stroke(obj)
    New("UIStroke",{
        Color = Theme.Accent,
        Thickness = 1
    },obj)
end

--========================================================
-- STATES
--========================================================

local speed = 16
local jump = 50
local flySpeed = 60

local FlyEnabled = false
local NoclipEnabled = false
local InfiniteJumpEnabled = false
local ESPEnabled = false
local InvisibleEnabled = false
local XRayEnabled = false

local flyUp = false
local flyDown = false

local Connections = {}

local function Track(c)
    table.insert(Connections,c)
    return c
end

local function Character()
    return Player.Character
end

local function Humanoid()
    local c = Character()
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function Root()
    local c = Character()
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function ApplyMovement()
    local h = Humanoid()
    if h then
        h.WalkSpeed = speed
        h.UseJumpPower = true
        h.JumpPower = jump
    end
end

--========================================================
-- GUI
--========================================================

local Screen = New("ScreenGui",{
    Name = GUI_NAME,
    ResetOnSpawn = false,
    DisplayOrder = 999
},PlayerGui)

local Loading = New("Frame",{
    Size = UDim2.fromOffset(250,135),
    Position = UDim2.fromScale(.5,.5),
    AnchorPoint = Vector2.new(.5,.5),
    BackgroundColor3 = Theme.Background
},Screen)

Corner(Loading,14)
Stroke(Loading)

New("TextLabel",{
    Size = UDim2.new(1,0,0,55),
    BackgroundTransparency = 1,
    Text = "X O R A",
    TextColor3 = Theme.Text,
    Font = Enum.Font.GothamBlack,
    TextSize = 28
},Loading)

local LoadText = New("TextLabel",{
    Position = UDim2.fromOffset(0,65),
    Size = UDim2.new(1,0,0,25),
    BackgroundTransparency = 1,
    Text = "Initializing XORA...",
    TextColor3 = Theme.Muted,
    Font = Enum.Font.Gotham,
    TextSize = 12
},Loading)

local BarBG = New("Frame",{
    Position = UDim2.fromOffset(20,105),
    Size = UDim2.new(1,-40,0,5),
    BackgroundColor3 = Theme.Panel
},Loading)
Corner(BarBG,5)

local Bar = New("Frame",{
    Size = UDim2.new(0,0,1,0),
    BackgroundColor3 = Theme.Accent
},BarBG)
Corner(Bar,5)

for i = 1,100 do
    Bar.Size = UDim2.new(i/100,0,1,0)
    LoadText.Text = "Loading XORA "..i.."%"
    task.wait(.003)
end

local Main = New("Frame",{
    Size = UDim2.fromOffset(350,390),
    Position = UDim2.new(.5,-175,.5,-195),
    BackgroundColor3 = Theme.Background,
    Visible = false
},Screen)

Corner(Main,13)
Stroke(Main)

local Header = New("Frame",{
    Size = UDim2.new(1,0,0,43),
    BackgroundColor3 = Theme.Panel
},Main)
Corner(Header,12)

New("TextLabel",{
    Position = UDim2.fromOffset(13,0),
    Size = UDim2.new(1,-90,1,0),
    BackgroundTransparency = 1,
    Text = "XORA | EXECUTOR EDITION",
    TextColor3 = Theme.Text,
    Font = Enum.Font.GothamBold,
    TextSize = 13,
    TextXAlignment = Enum.TextXAlignment.Left
},Header)

local Close = New("TextButton",{
    Position = UDim2.new(1,-36,0,7),
    Size = UDim2.fromOffset(27,27),
    BackgroundColor3 = Theme.Red,
    Text = "X",
    TextColor3 = Theme.Text,
    Font = Enum.Font.GothamBold,
    TextSize = 13
},Header)
Corner(Close,7)

-- DRAGGING

local dragging = false
local dragStart
local startPosition

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = Main.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position-dragStart
        Main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset+delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset+delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

--========================================================
-- SIDEBAR
--========================================================

local Sidebar = New("Frame",{
    Position = UDim2.fromOffset(8,52),
    Size = UDim2.fromOffset(95,325),
    BackgroundColor3 = Theme.Panel
},Main)
Corner(Sidebar,9)

New("UIListLayout",{
    Padding = UDim.new(0,7),
    SortOrder = Enum.SortOrder.LayoutOrder
},Sidebar)

local Content = New("ScrollingFrame",{
    Position = UDim2.fromOffset(111,52),
    Size = UDim2.new(1,-119,1,-62),
    BackgroundColor3 = Theme.Panel,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    CanvasSize = UDim2.new(0,0,0,0)
},Main)
Corner(Content,9)

New("UIListLayout",{
    Padding = UDim.new(0,7),
    SortOrder = Enum.SortOrder.LayoutOrder
},Content)

New("UIPadding",{
    PaddingTop = UDim.new(0,9),
    PaddingLeft = UDim.new(0,8),
    PaddingRight = UDim.new(0,8),
    PaddingBottom = UDim.new(0,9)
},Content)

local categories = {
    "General",
    "Movement",
    "Visual",
    "Character",
    "Utilities",
    "Presets"
}

local function ClearContent()
    for _,v in ipairs(Content:GetChildren()) do
        if v:IsA("GuiObject")
        and not v:IsA("UIListLayout")
        and not v:IsA("UIPadding") then
            v:Destroy()
        end
    end
end

local function Heading(name)
    New("TextLabel",{
        Size = UDim2.new(1,0,0,25),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = Theme.Accent,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left
    },Content)
end

local function Message(msg)
    local label = New("TextLabel",{
        Size = UDim2.new(1,0,0,42),
        BackgroundColor3 = Theme.Background,
        Text = msg,
        TextWrapped = true,
        TextColor3 = Theme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 11
    },Content)
    Corner(label,8)
end

local function Button(name,callback)
    local b = New("TextButton",{
        Size = UDim2.new(1,0,0,34),
        BackgroundColor3 = Theme.Background,
        Text = name,
        TextColor3 = Theme.Text,
        Font = Enum.Font.GothamMedium,
        TextSize = 12
    },Content)
    Corner(b,7)
    b.MouseButton1Click:Connect(callback)
    return b
end

local function ToggleButton(name,getter,callback)
    local b

    local function Refresh()
        local enabled = getter()
        b.Text = name..": "..(enabled and "ON" or "OFF")
        b.BackgroundColor3 = enabled and Theme.Green or Theme.Background
    end

    b = Button(name..": OFF",function()
        callback(not getter())
        Refresh()
    end)

    Refresh()
    return b
end

local function SliderSetting(name,minimum,maximum,current,callback)
    local value = current

    local track = New("TextButton",{
        Size = UDim2.new(1,0,0,32),
        BackgroundColor3 = Theme.Background,
        Text = name..": "..value.." (TAP)",
        TextColor3 = Theme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 10
    },Content)
    Corner(track,6)

    track.MouseButton1Click:Connect(function()
        value = value+5
        if value > maximum then value = minimum end
        callback(value)
        track.Text = name..": "..value.." (TAP)"
    end)
end

--========================================================
-- FLY
--========================================================

local FlyVelocity
local FlyGyro
local oldAutoRotate

local FlyControls = New("Frame",{
    Size = UDim2.fromOffset(115,100),
    Position = UDim2.new(1,-130,1,-125),
    BackgroundTransparency = 1,
    Visible = false
},Screen)

local UpButton = New("TextButton",{
    Size = UDim2.fromOffset(48,42),
    Position = UDim2.fromOffset(58,0),
    BackgroundColor3 = Theme.Accent,
    Text = "UP",
    TextColor3 = Theme.Text
},FlyControls)
Corner(UpButton,9)

local DownButton = New("TextButton",{
    Size = UDim2.fromOffset(48,42),
    Position = UDim2.fromOffset(58,48),
    BackgroundColor3 = Theme.Panel,
    Text = "DOWN",
    TextColor3 = Theme.Text
},FlyControls)
Corner(DownButton,9)

local function HoldButton(button,direction)
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
            if direction == "up" then flyUp = true
            else flyDown = true end
        end
    end)

    button.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
            if direction == "up" then flyUp = false
            else flyDown = false end
        end
    end)
end

HoldButton(UpButton,"up")
HoldButton(DownButton,"down")

local function StopFly()
    FlyEnabled = false
    FlyControls.Visible = false
    flyUp = false
    flyDown = false

    if FlyVelocity then
        FlyVelocity:Destroy()
        FlyVelocity = nil
    end

    if FlyGyro then
        FlyGyro:Destroy()
        FlyGyro = nil
    end

    local h = Humanoid()
    if h then h.AutoRotate = oldAutoRotate ~= false end
end

local function StartFly()
    local root = Root()
    local h = Humanoid()

    if not root or not h then return end

    StopFly()
    FlyEnabled = true
    oldAutoRotate = h.AutoRotate
    h.AutoRotate = false

    FlyVelocity = Instance.new("BodyVelocity")
    FlyVelocity.MaxForce = Vector3.new(1e9,1e9,1e9)
    FlyVelocity.Velocity = Vector3.zero
    FlyVelocity.Parent = root

    FlyGyro = Instance.new("BodyGyro")
    FlyGyro.MaxTorque = Vector3.new(1e9,1e9,1e9)
    FlyGyro.P = 10000
    FlyGyro.CFrame = workspace.CurrentCamera.CFrame
    FlyGyro.Parent = root

    FlyControls.Visible = true
end

Track(RunService.RenderStepped:Connect(function()
    if not FlyEnabled then return end

    local root = Root()
    local h = Humanoid()
    local camera = workspace.CurrentCamera

    if not root or not h or not FlyVelocity or not FlyGyro then
        StopFly()
        return
    end

    local vertical = 0

    if UIS:IsKeyDown(Enum.KeyCode.Space) or flyUp then
        vertical = 1
    elseif UIS:IsKeyDown(Enum.KeyCode.LeftControl)
    or UIS:IsKeyDown(Enum.KeyCode.C) or flyDown then
        vertical = -1
    end

    FlyVelocity.Velocity = h.MoveDirection*flySpeed
        + Vector3.new(0,vertical*flySpeed,0)

    FlyGyro.CFrame = camera.CFrame
end))

--========================================================
-- NOCLIP
--========================================================

local noclipOriginals = {}

local function SetNoclip(enabled)
    NoclipEnabled = enabled

    if not enabled then
        for part,original in pairs(noclipOriginals) do
            if part and part.Parent then
                part.CanCollide = original
            end
        end
        table.clear(noclipOriginals)
    end
end

Track(RunService.Stepped:Connect(function()
    if not NoclipEnabled then return end

    local c = Character()
    if not c then return end

    for _,part in ipairs(c:GetDescendants()) do
        if part:IsA("BasePart") then
            if noclipOriginals[part] == nil then
                noclipOriginals[part] = part.CanCollide
            end
            part.CanCollide = false
        end
    end
end))

-- INFINITE JUMP

Track(UIS.JumpRequest:Connect(function()
    if not InfiniteJumpEnabled then return end
    local h = Humanoid()
    if h and h.Health > 0 then
        h:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end))

--========================================================
-- ESP
--========================================================

local ESPObjects = {}
local ESPConnections = {}

local function RemoveESP(plr)
    local data = ESPObjects[plr]
    if data then
        for _,obj in ipairs(data) do
            if obj and obj.Parent then obj:Destroy() end
        end
        ESPObjects[plr] = nil
    end
end

local function CreateESP(plr)
    if not ESPEnabled or plr == Player or ESPObjects[plr] then return end

    local character = plr.Character
    if not character then return end

    local head = character:FindFirstChild("Head")
    if not head then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "XORA_ESP"
    highlight.Adornee = character
    highlight.FillColor = Theme.Accent
    highlight.OutlineColor = Color3.new(1,1,1)
    highlight.FillTransparency = .65
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = workspace

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "XORA_ESP_NAME"
    billboard.Adornee = head
    billboard.Size = UDim2.fromOffset(170,30)
    billboard.StudsOffset = Vector3.new(0,2.5,0)
    billboard.AlwaysOnTop = true
    billboard.Parent = PlayerGui

    local label = Instance.new("TextLabel")
    label.Size = UDim2.fromScale(1,1)
    label.BackgroundTransparency = 1
    label.Text = plr.DisplayName.." (@"..plr.Name..")"
    label.TextColor3 = Color3.new(1,1,1)
    label.TextStrokeTransparency = .2
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.Parent = billboard

    ESPObjects[plr] = {highlight,billboard}
end

local function SetESP(enabled)
    ESPEnabled = enabled

    if enabled then
        for _,plr in ipairs(Players:GetPlayers()) do
            CreateESP(plr)
        end

        if not ESPConnections.add then
            ESPConnections.add = Players.PlayerAdded:Connect(function(plr)
                ESPConnections["char"..plr.UserId] =
                    plr.CharacterAdded:Connect(function()
                        task.wait(1)
                        CreateESP(plr)
                    end)
            end)
        end

        if not ESPConnections.remove then
            ESPConnections.remove = Players.PlayerRemoving:Connect(RemoveESP)
        end
    else
        for plr in pairs(ESPObjects) do
            RemoveESP(plr)
        end

        for _,c in pairs(ESPConnections) do
            c:Disconnect()
        end

        table.clear(ESPConnections)
    end
end

--========================================================
-- INVISIBLE
--========================================================

local invisibleOriginals = {}

local function SetInvisible(enabled)
    InvisibleEnabled = enabled
    local c = Character()

    if enabled and c then
        for _,obj in ipairs(c:GetDescendants()) do
            if obj:IsA("BasePart") then
                if invisibleOriginals[obj] == nil then
                    invisibleOriginals[obj] = obj.LocalTransparencyModifier
                end
                obj.LocalTransparencyModifier = 1

            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                if invisibleOriginals[obj] == nil then
                    invisibleOriginals[obj] = obj.Transparency
                end
                obj.Transparency = 1
            end
        end

    elseif not enabled then
        for obj,original in pairs(invisibleOriginals) do
            if obj and obj.Parent then
                if obj:IsA("BasePart") then
                    obj.LocalTransparencyModifier = original
                else
                    obj.Transparency = original
                end
            end
        end

        table.clear(invisibleOriginals)
    end
end

--========================================================
-- XRAY
--========================================================

local xrayOriginals = {}
local xrayConnection

local function IsCharacterPart(part)
    local model = part:FindFirstAncestorOfClass("Model")
    return model and model:FindFirstChildOfClass("Humanoid") ~= nil
end

local function ApplyXrayToPart(part)
    if not XRayEnabled or not part:IsA("BasePart") then return end
    if IsCharacterPart(part) then return end

    if xrayOriginals[part] == nil then
        xrayOriginals[part] = part.LocalTransparencyModifier
    end

    part.LocalTransparencyModifier = .65
end

local function SetXray(enabled)
    XRayEnabled = enabled

    if enabled then
        for _,obj in ipairs(workspace:GetDescendants()) do
            ApplyXrayToPart(obj)
        end

        if not xrayConnection then
            xrayConnection = workspace.DescendantAdded:Connect(function(obj)
                if obj:IsA("BasePart") then
                    task.defer(ApplyXrayToPart,obj)
                end
            end)
        end

    else
        if xrayConnection then
            xrayConnection:Disconnect()
            xrayConnection = nil
        end

        for part,original in pairs(xrayOriginals) do
            if part and part.Parent then
                part.LocalTransparencyModifier = original
            end
        end

        table.clear(xrayOriginals)
    end
end

--========================================================
-- ENVIRONMENT PRESETS
-- NO POST-PROCESSING OR SHADER EFFECTS
--========================================================

local environmentProperties = {
    "ClockTime",
    "Brightness",
    "ExposureCompensation",
    "Ambient",
    "OutdoorAmbient",
    "ColorShift_Top",
    "ColorShift_Bottom",
    "FogColor",
    "FogStart",
    "FogEnd",
    "GlobalShadows",
    "GeographicLatitude"
}

local originalEnvironment = {}

for _,property in ipairs(environmentProperties) do
    local ok,value = pcall(function()
        return Lighting[property]
    end)

    if ok then
        originalEnvironment[property] = value
    end
end

local originalAtmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
local atmosphereCreated = false

local atmosphereProperties = {
    "Density",
    "Offset",
    "Color",
    "Decay",
    "Glare",
    "Haze"
}

local originalAtmosphereValues = {}

if originalAtmosphere then
    for _,property in ipairs(atmosphereProperties) do
        originalAtmosphereValues[property] =
            originalAtmosphere[property]
    end
end

local function GetAtmosphere()
    local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")

    if not atmosphere then
        atmosphere = Instance.new("Atmosphere")
        atmosphere.Name = "XORA_Atmosphere"
        atmosphere.Parent = Lighting
        atmosphereCreated = true
    end

    return atmosphere
end

local currentPreset = "None"

--========================================================
-- SNOW PARTICLES
--========================================================

local snowParts = {}
local snowConnection
local snowActive = false

local function CreateSnow()
    if snowActive then return end
    snowActive = true

    local folder = Instance.new("Folder")
    folder.Name = "XORA_LocalSnow"
    folder.Parent = workspace

    for i = 1,65 do
        local flake = Instance.new("Part")
        flake.Name = "XORA_Snowflake"
        flake.Shape = Enum.PartType.Ball
        flake.Size = Vector3.new(.12,.12,.12)
        flake.Material = Enum.Material.SmoothPlastic
        flake.Color = Color3.fromRGB(245,250,255)
        flake.Transparency = .15
        flake.Anchored = true
        flake.CanCollide = false
        flake.CanTouch = false
        flake.CanQuery = false
        flake.CastShadow = false
        flake.Parent = folder

        table.insert(snowParts,{
            part = flake,
            x = math.random(-45,45),
            y = math.random(5,65),
            z = math.random(-45,45),
            speed = math.random(5,12)
        })
    end

    snowConnection = RunService.RenderStepped:Connect(function(dt)
        local camera = workspace.CurrentCamera
        if not camera then return end

        for _,data in ipairs(snowParts) do
            local part = data.part

            if part and part.Parent then
                data.y = data.y-data.speed*dt
                data.x = data.x+math.sin(os.clock()+data.z)*dt*1.5

                if data.y < -5 then
                    data.y = math.random(35,65)
                    data.x = math.random(-45,45)
                    data.z = math.random(-45,45)
                end

                part.Position = camera.CFrame:PointToWorldSpace(
                    Vector3.new(data.x,data.y,data.z)
                )
            end
        end
    end)
end

local function StopSnow()
    snowActive = false

    if snowConnection then
        snowConnection:Disconnect()
        snowConnection = nil
    end

    for _,data in ipairs(snowParts) do
        if data.part then
            data.part:Destroy()
        end
    end

    table.clear(snowParts)

    local folder = workspace:FindFirstChild("XORA_LocalSnow")
    if folder then folder:Destroy() end
end

--========================================================
-- RESTORE ENVIRONMENT
--========================================================

local function RestoreEnvironment()
    StopSnow()

    for property,value in pairs(originalEnvironment) do
        pcall(function()
            Lighting[property] = value
        end)
    end

    local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")

    if atmosphere then
        if atmosphereCreated then
            atmosphere:Destroy()
            atmosphereCreated = false

        elseif originalAtmosphere then
            for property,value in pairs(originalAtmosphereValues) do
                pcall(function()
                    atmosphere[property] = value
                end)
            end
        end
    end
    
    --========================================================
-- APPLY PRESETS
--========================================================

local function ApplyPreset(name)
    RestoreEnvironment()

    local atmosphere = GetAtmosphere()

    if name == "Morning" then

        Lighting.ClockTime = 7.2
        Lighting.Brightness = 2.5
        Lighting.ExposureCompensation = .15
        Lighting.Ambient = Color3.fromRGB(120,115,105)
        Lighting.OutdoorAmbient = Color3.fromRGB(170,160,140)
        Lighting.ColorShift_Top = Color3.fromRGB(255,215,170)
        Lighting.ColorShift_Bottom = Color3.fromRGB(180,170,150)
        Lighting.FogColor = Color3.fromRGB(230,205,175)
        Lighting.FogEnd = 1200

        atmosphere.Density = .25
        atmosphere.Offset = .1
        atmosphere.Color = Color3.fromRGB(255,220,180)
        atmosphere.Decay = Color3.fromRGB(180,155,130)
        atmosphere.Glare = .2
        atmosphere.Haze = 1

    elseif name == "Afternoon" then

        Lighting.ClockTime = 14
        Lighting.Brightness = 3
        Lighting.ExposureCompensation = .1
        Lighting.Ambient = Color3.fromRGB(130,130,140)
        Lighting.OutdoorAmbient = Color3.fromRGB(170,170,180)
        Lighting.ColorShift_Top = Color3.fromRGB(255,255,255)
        Lighting.ColorShift_Bottom = Color3.fromRGB(220,225,255)
        Lighting.FogColor = Color3.fromRGB(190,215,245)
        Lighting.FogEnd = 1800

        atmosphere.Density = .12
        atmosphere.Offset = .15
        atmosphere.Color = Color3.fromRGB(205,225,255)
        atmosphere.Decay = Color3.fromRGB(120,140,170)
        atmosphere.Glare = .15
        atmosphere.Haze = .5

    elseif name == "Night" then

        Lighting.ClockTime = 0
        Lighting.Brightness = 1
        Lighting.ExposureCompensation = -.35
        Lighting.Ambient = Color3.fromRGB(35,40,75)
        Lighting.OutdoorAmbient = Color3.fromRGB(25,30,65)
        Lighting.ColorShift_Top = Color3.fromRGB(70,85,160)
        Lighting.ColorShift_Bottom = Color3.fromRGB(20,25,65)
        Lighting.FogColor = Color3.fromRGB(20,25,55)
        Lighting.FogEnd = 850

        atmosphere.Density = .35
        atmosphere.Offset = .1
        atmosphere.Color = Color3.fromRGB(90,105,175)
        atmosphere.Decay = Color3.fromRGB(35,40,90)
        atmosphere.Glare = 0
        atmosphere.Haze = 2

    elseif name == "Snow" then

        Lighting.ClockTime = 12
        Lighting.Brightness = 2.2
        Lighting.ExposureCompensation = .15
        Lighting.Ambient = Color3.fromRGB(170,185,205)
        Lighting.OutdoorAmbient = Color3.fromRGB(180,195,220)
        Lighting.ColorShift_Top = Color3.fromRGB(215,230,255)
        Lighting.ColorShift_Bottom = Color3.fromRGB(195,210,235)
        Lighting.FogColor = Color3.fromRGB(215,230,245)
        Lighting.FogEnd = 450

        atmosphere.Density = .4
        atmosphere.Offset = .1
        atmosphere.Color = Color3.fromRGB(220,235,255)
        atmosphere.Decay = Color3.fromRGB(150,175,205)
        atmosphere.Glare = .1
        atmosphere.Haze = 2

        CreateSnow()
        
        elseif name == "Autumn" then

        Lighting.ClockTime = 16
        Lighting.Brightness = 2
        Lighting.ExposureCompensation = .1
        Lighting.Ambient = Color3.fromRGB(140,95,65)
        Lighting.OutdoorAmbient = Color3.fromRGB(175,115,70)
        Lighting.ColorShift_Top = Color3.fromRGB(255,155,75)
        Lighting.ColorShift_Bottom = Color3.fromRGB(180,90,45)
        Lighting.FogColor = Color3.fromRGB(205,135,85)
        Lighting.FogEnd = 1000

        atmosphere.Density = .28
        atmosphere.Offset = .1
        atmosphere.Color = Color3.fromRGB(255,185,120)
        atmosphere.Decay = Color3.fromRGB(180,95,50)
        atmosphere.Glare = .15
        atmosphere.Haze = 1.5

    elseif name == "Underwater" then

        Lighting.ClockTime = 12
        Lighting.Brightness = 1.5
        Lighting.ExposureCompensation = -.15
        Lighting.Ambient = Color3.fromRGB(20,100,130)
        Lighting.OutdoorAmbient = Color3.fromRGB(15,75,110)
        Lighting.ColorShift_Top = Color3.fromRGB(0,180,220)
        Lighting.ColorShift_Bottom = Color3.fromRGB(0,70,110)
        Lighting.FogColor = Color3.fromRGB(0,100,150)
        Lighting.FogStart = 0
        Lighting.FogEnd = 260
        Lighting.GlobalShadows = false

        atmosphere.Density = .55
        atmosphere.Offset = .15
        atmosphere.Color = Color3.fromRGB(30,170,200)
        atmosphere.Decay = Color3.fromRGB(0,45,90)
        atmosphere.Glare = 0
        atmosphere.Haze = 3

    elseif name == "Volcano / Lava" then

        Lighting.ClockTime = 19
        Lighting.Brightness = 1.5
        Lighting.ExposureCompensation = .1
        Lighting.Ambient = Color3.fromRGB(100,30,15)
        Lighting.OutdoorAmbient = Color3.fromRGB(75,20,10)
        Lighting.ColorShift_Top = Color3.fromRGB(255,75,15)
        Lighting.ColorShift_Bottom = Color3.fromRGB(180,25,0)
        Lighting.FogColor = Color3.fromRGB(110,30,10)
        Lighting.FogStart = 0
        Lighting.FogEnd = 450
        Lighting.GlobalShadows = true

        atmosphere.Density = .45
        atmosphere.Offset = .1
        atmosphere.Color = Color3.fromRGB(200,65,20)
        atmosphere.Decay = Color3.fromRGB(70,15,5)
        atmosphere.Glare = .3
        atmosphere.Haze = 3

    elseif name == "Neon / Cyberpunk" then

        Lighting.ClockTime = 0
        Lighting.Brightness = 2
        Lighting.ExposureCompensation = .2
        Lighting.Ambient = Color3.fromRGB(65,20,110)
        Lighting.OutdoorAmbient = Color3.fromRGB(25,15,75)
        Lighting.ColorShift_Top = Color3.fromRGB(170,0,255)
        Lighting.ColorShift_Bottom = Color3.fromRGB(0,180,255)
        Lighting.FogColor = Color3.fromRGB(35,10,80)
        Lighting.FogStart = 0
        Lighting.FogEnd = 650
        Lighting.GlobalShadows = true
        
        atmosphere.Density = .32
        atmosphere.Offset = .1
        atmosphere.Color = Color3.fromRGB(100,40,190)
        atmosphere.Decay = Color3.fromRGB(15,10,75)
        atmosphere.Glare = .2
        atmosphere.Haze = 2

    elseif name == "Horror / Fog" then

        Lighting.ClockTime = 1
        Lighting.Brightness = .45
        Lighting.ExposureCompensation = -.5
        Lighting.Ambient = Color3.fromRGB(35,40,40)
        Lighting.OutdoorAmbient = Color3.fromRGB(20,25,25)
        Lighting.ColorShift_Top = Color3.fromRGB(70,85,80)
        Lighting.ColorShift_Bottom = Color3.fromRGB(25,30,30)
        Lighting.FogColor = Color3.fromRGB(65,75,70)
        Lighting.FogStart = 0
        Lighting.FogEnd = 120
        Lighting.GlobalShadows = true

        atmosphere.Density = .65
        atmosphere.Offset = .05
        atmosphere.Color = Color3.fromRGB(100,110,105)
        atmosphere.Decay = Color3.fromRGB(30,35,35)
        atmosphere.Glare = 0
        atmosphere.Haze = 5

    elseif name == "Dark / Menacing" then

        Lighting.ClockTime = 0
        Lighting.Brightness = .35
        Lighting.ExposureCompensation = -.8
        Lighting.Ambient = Color3.fromRGB(15,10,25)
        Lighting.OutdoorAmbient = Color3.fromRGB(10,8,18)
        Lighting.ColorShift_Top = Color3.fromRGB(35,20,60)
        Lighting.ColorShift_Bottom = Color3.fromRGB(10,5,20)
        Lighting.FogColor = Color3.fromRGB(15,10,25)
        Lighting.FogStart = 0
        Lighting.FogEnd = 300
        Lighting.GlobalShadows = true

        atmosphere.Density = .5
        atmosphere.Offset = .1
        atmosphere.Color = Color3.fromRGB(40,25,65)
        atmosphere.Decay = Color3.fromRGB(10,5,20)
        atmosphere.Glare = 0
        atmosphere.Haze = 3
    end

    currentPreset = name
end

--========================================================
-- CATEGORY SYSTEM
--========================================================

local function SetCategory(category)
    ClearContent()

    if category == "General" then

        Heading("GENERAL")
        Message("Welcome to XORA v3.4")

        Button("Rejoin Server",function()
            TeleportService:TeleportToPlaceInstance(
                game.PlaceId,game.JobId,Player
            )
        end)

        Button("Reset Character",function()
            local h = Humanoid()
            if h then h.Health = 0 end
        end)

        Button("Refresh Character",function()
            pcall(function()
                Player:LoadCharacter()
            end)
        end)

    elseif category == "Movement" then

        Heading("MOVEMENT")

        ToggleButton("Fly",function()
            return FlyEnabled
        end,function(v)
            if v then StartFly() else StopFly() end
        end)
        
        ToggleButton("Noclip",function()
            return NoclipEnabled
        end,SetNoclip)

        ToggleButton("Infinite Jump",function()
            return InfiniteJumpEnabled
        end,function(v)
            InfiniteJumpEnabled = v
        end)

        SliderSetting("Walk Speed",5,150,speed,function(v)
            speed = v
            ApplyMovement()
        end)

        SliderSetting("Jump Power",10,200,jump,function(v)
            jump = v
            ApplyMovement()
        end)

        SliderSetting("Fly Speed",10,200,flySpeed,function(v)
            flySpeed = v
        end)

        Button("Reset Movement",function()
            speed = 16
            jump = 50
            flySpeed = 60
            ApplyMovement()
            StopFly()
            SetNoclip(false)
        end)

    elseif category == "Visual" then

        Heading("VISUAL")

        ToggleButton("ESP",function()
            return ESPEnabled
        end,SetESP)

        ToggleButton("X-Ray",function()
            return XRayEnabled
        end,SetXray)

    elseif category == "Character" then

        Heading("CHARACTER")

        ToggleButton("Invisible",function()
            return InvisibleEnabled
        end,SetInvisible)

        Button("Reset Character",function()
            local h = Humanoid()
            if h then h.Health = 0 end
        end)

    elseif category == "Utilities" then

        Heading("UTILITIES")

        Button("Rejoin Server",function()
            TeleportService:TeleportToPlaceInstance(
                game.PlaceId,game.JobId,Player
            )
        end)

        Button("Restore Environment",function()
            RestoreEnvironment()
            SetCategory("Utilities")
        end)

        Button("Close XORA",function()
            Screen:Destroy()
        end)

    elseif category == "Presets" then

        Heading("ENVIRONMENT PRESETS")

        Message("Select an atmosphere to change your local environment.")

        local presets = {
            "Morning",
            "Afternoon",
            "Night",
            "Snow",
            "Autumn",
            "Underwater",
            "Volcano / Lava",
            "Neon / Cyberpunk",
            "Horror / Fog",
            "Dark / Menacing"
        }

        for _,name in ipairs(presets) do
            local active = currentPreset == name

            local b = Button(
                name..(active and "  [ACTIVE]" or ""),
                function()
                    ApplyPreset(name)
                    SetCategory("Presets")
                end
            )

            if active then
                b.BackgroundColor3 = Theme.Green
            end
        end
        
        Button("Restore Original Lighting",function()
            RestoreEnvironment()
            SetCategory("Presets")
        end)

        Message("Presets use Lighting and Atmosphere properties. No shader or post-processing effects are created.")
    end
end

--========================================================
-- CATEGORY BUTTONS
--========================================================

for _,category in ipairs(categories) do
    local b = New("TextButton",{
        Size = UDim2.new(1,-10,0,36),
        BackgroundColor3 = Theme.Background,
        Text = category,
        TextColor3 = Theme.Text,
        Font = Enum.Font.GothamMedium,
        TextSize = 11
    },Sidebar)

    Corner(b,7)

    b.MouseButton1Click:Connect(function()
        SetCategory(category)

        for _,other in ipairs(Sidebar:GetChildren()) do
            if other:IsA("TextButton") then
                other.BackgroundColor3 = Theme.Background
            end
        end

        b.BackgroundColor3 = Theme.Accent
    end)
end

--========================================================
-- CHARACTER RESPAWN
--========================================================

Track(Player.CharacterAdded:Connect(function()
    task.wait(1)
    ApplyMovement()

    if InvisibleEnabled then
        SetInvisible(true)
    end
end))

--========================================================
-- OPEN / CLOSE
--========================================================

Close.MouseButton1Click:Connect(function()
    Main.Visible = false
end)

local OpenButton = New("TextButton",{
    Size = UDim2.fromOffset(48,48),
    Position = UDim2.new(0,15,.5,-24),
    BackgroundColor3 = Theme.Accent,
    Text = "X",
    TextColor3 = Theme.Text,
    Font = Enum.Font.GothamBlack,
    TextSize = 20
},Screen)

Corner(OpenButton,24)
Stroke(OpenButton)

OpenButton.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

--========================================================
-- CLEANUP
--========================================================

Screen.Destroying:Connect(function()
    StopFly()
    SetNoclip(false)
    SetESP(false)
    SetInvisible(false)
    SetXray(false)
    RestoreEnvironment()

    for _,connection in ipairs(Connections) do
        pcall(function()
            connection:Disconnect()
        end)
    end
end)

SetCategory("General")
Main.Visible = true
Loading:Destroy()

print("XORA v3.4 loaded successfully.")