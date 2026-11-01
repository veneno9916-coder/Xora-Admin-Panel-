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
    -- Snow effect
    local snow = Lighting:FindFirstChild("XORA_SnowEffect")
    if snow then snow:Destroy() end

    local atmosphere = Instance.new("Atmosphere")
    atmosphere.Name = "XORA_SnowEffect"
    atmosphere.Density = 0.4
    atmosphere.Haze = 2
    atmosphere.Color = Color3.fromRGB(220, 230, 240)
    atmosphere.Decay = Color3.fromRGB(180, 190, 205)
    atmosphere.Parent = Lighting
end

local function RemoveWeatherEffects()
    for _, name in ipairs({
        "XORA_SnowEffect",
        "XORA_MorningEffect",
        "XORA_NightEffect",
        "XORA_AfternoonEffect",
        "XORA_AutumnEffect"
    }) do
        local effect = Lighting:FindFirstChild(name)
        if effect then
            effect:Destroy()
        end
    end
end

local function CreateMorning()
    RemoveWeatherEffects()
    Lighting.ClockTime = 8
    Lighting.Brightness = 2
    Lighting.Ambient = Color3.fromRGB(180, 170, 140)
end

local function CreateNight()
    RemoveWeatherEffects()
    Lighting.ClockTime = 0
    Lighting.Brightness = 1
    Lighting.Ambient = Color3.fromRGB(60, 70, 110)
end


--========================================================
-- XORA v3.4 FINAL INITIALIZATION - FIXED
--========================================================

local function ShowCategory(category)
    ClearContent()

    if category == "General" then
        Heading("XORA DASHBOARD")
        Message("Welcome to XORA Executor Edition v3.4")
        Message("Status: Successfully initialized")
        Message("Select a category from the sidebar.")

    elseif category == "Movement" then
        Heading("MOVEMENT")

        ToggleButton("Fly",
            function() return FlyEnabled end,
            function(v)
                if v then StartFly() else StopFly() end
            end
        )

        ToggleButton("Noclip",
            function() return NoclipEnabled end,
            SetNoclip
        )

        ToggleButton("Infinite Jump",
            function() return InfiniteJumpEnabled end,
            function(v)
                InfiniteJumpEnabled = v
            end
        )

        SliderSetting("Walk Speed",16,200,speed,function(v)
            speed = v
            ApplyMovement()
        end)

        SliderSetting("Jump Power",50,200,jump,function(v)
            jump = v
            ApplyMovement()
        end)

    elseif category == "Visual" then
        Heading("VISUAL")

        ToggleButton("ESP",
            function() return ESPEnabled end,
            SetESP
        )

        ToggleButton("X-Ray",
            function() return XRayEnabled end,
            SetXray
        )

    elseif category == "Character" then
        Heading("CHARACTER")

        ToggleButton("Invisible",
            function() return InvisibleEnabled end,
            SetInvisible
        )

        Button("Restore Visibility",function()
            SetInvisible(false)
        end)

    elseif category == "Utilities" then
        Heading("UTILITIES")

        Button("Reset Movement",function()
            speed = 16
            jump = 50
            ApplyMovement()
            ShowCategory("Utilities")
        end)

        Button("Restore Environment",function()
            for property,value in pairs(originalEnvironment) do
                pcall(function()
                    Lighting[property] = value
                end)
            end

            RemoveWeatherEffects()
        end)

        Button("Disable All Features",function()
            StopFly()
            SetNoclip(false)
            SetESP(false)
            SetXray(false)
            SetInvisible(false)
            InfiniteJumpEnabled = false
            ShowCategory("Utilities")
        end)

    elseif category == "Presets" then
        Heading("ENVIRONMENT PRESETS")

        Button("Morning",function()
            ApplyWeather("Morning")
        end)

        Button("Afternoon",function()
            ApplyWeather("Afternoon")
        end)

        Button("Night",function()
            ApplyWeather("Night")
        end)

        Button("Snow",function()
            ApplyWeather("Snow")
        end)

        Button("Autumn",function()
            ApplyWeather("Autumn")
        end)

        Button("Default",function()
            ApplyWeather("Default")
        end)
    end
end

--========================================================
-- SIDEBAR INITIALIZATION
--========================================================

for _,category in ipairs(categories) do
    local categoryButton = New("TextButton",{
        Size = UDim2.new(1,-10,0,39),
        BackgroundColor3 = Theme.Background,
        Text = category,
        TextColor3 = Theme.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 10,
        AutoButtonColor = true
    },Sidebar)

    Corner(categoryButton,7)

    categoryButton.MouseButton1Click:Connect(function()
        ShowCategory(category)
    end)
end

--========================================================
-- CLOSE BUTTON
--========================================================

Close.MouseButton1Click:Connect(function()
    StopFly()
    SetNoclip(false)
    SetESP(false)
    SetXray(false)
    SetInvisible(false)

    for _,connection in ipairs(Connections) do
        pcall(function()
            connection:Disconnect()
        end)
    end

    CleanupXORA()
    Screen:Destroy()
end)

--========================================================
-- LOADING COMPLETION
--========================================================

LoadText.Text = "Initializing interface..."

ShowCategory("General")

Main.Visible = true
Loading.Visible = false

task.wait(0.2)

if Loading and Loading.Parent then
    Loading:Destroy()
end

print("XORA v3.4 loaded successfully.")
print("XORA interface initialized successfully.")
