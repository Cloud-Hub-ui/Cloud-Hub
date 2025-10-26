
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- Your Cloudflare Worker URL
local VALIDATION_URL = "https://key-validator.jimmyuso1132.workers.dev"

-- Function to get a unique hardware ID
local function getHWID()
    local success, clientId = pcall(function()
        return game:GetService("RbxAnalyticsService"):GetClientId()
    end)
    
    if success and clientId then
        return clientId
    end
    
    -- Fallback HWID method using player's UserId
    return tostring(Players.LocalPlayer.UserId)
end

-- Function to validate the license key
local function validateKey(key)
    local hwid = getHWID()
    
    local success, response = pcall(function()
        return HttpService:PostAsync(
            VALIDATION_URL,
            HttpService:JSONEncode({
                key = key,
                hwid = hwid
            }),
            Enum.HttpContentType.ApplicationJson
        )
    end)
    
    if success then
        local data = HttpService:JSONDecode(response)
        return data.success, data.message, data.data
    end
    
    return false, "Connection error - Unable to reach validation server", nil
end

-- Function to load your actual script from GitHub
local function loadScript()
    print("✅ Key validated! Loading script...")
    
    -- Replace this URL with your GitHub raw script URL
    local SCRIPT_URL = "https://raw.githubusercontent.com/Cloud-Hub-ui/Cloud-Hub/main/Aj-loader.lua"
    
    local success, result = pcall(function()
        return loadstring(game:HttpGet(SCRIPT_URL))()
    end)
    
    if success then
        print("✅ Script loaded and executed successfully!")
    else
        warn("❌ Failed to load script:", result)
    end
end

-- Create UI
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LicenseKeyUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 400, 0, 250)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Add rounded corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
Title.BorderSizePixel = 0
Title.Text = "🔑 License Verification"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = Title

-- Text Box Container
local TextBoxContainer = Instance.new("Frame")
TextBoxContainer.Size = UDim2.new(0.85, 0, 0, 45)
TextBoxContainer.Position = UDim2.new(0.075, 0, 0, 75)
TextBoxContainer.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
TextBoxContainer.BorderSizePixel = 0
TextBoxContainer.Parent = MainFrame

local TextBoxCorner = Instance.new("UICorner")
TextBoxCorner.CornerRadius = UDim.new(0, 8)
TextBoxCorner.Parent = TextBoxContainer

-- Text Box
local TextBox = Instance.new("TextBox")
TextBox.Name = "KeyInput"
TextBox.Size = UDim2.new(1, -20, 1, 0)
TextBox.Position = UDim2.new(0, 10, 0, 0)
TextBox.BackgroundTransparency = 1
TextBox.PlaceholderText = "Enter License Key (LUA-XXXX-XXXX-XXXX)"
TextBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
TextBox.Text = ""
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.TextSize = 16
TextBox.Font = Enum.Font.Gotham
TextBox.ClearTextOnFocus = false
TextBox.Parent = TextBoxContainer

-- Submit Button
local SubmitButton = Instance.new("TextButton")
SubmitButton.Name = "SubmitButton"
SubmitButton.Size = UDim2.new(0.85, 0, 0, 45)
SubmitButton.Position = UDim2.new(0.075, 0, 0, 140)
SubmitButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
SubmitButton.BorderSizePixel = 0
SubmitButton.Text = "Validate Key"
SubmitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SubmitButton.TextSize = 18
SubmitButton.Font = Enum.Font.GothamBold
SubmitButton.Parent = MainFrame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 8)
ButtonCorner.Parent = SubmitButton

-- Status Label
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Size = UDim2.new(0.85, 0, 0, 30)
StatusLabel.Position = UDim2.new(0.075, 0, 0, 200)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = ""
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.TextSize = 14
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Parent = MainFrame

-- Hover effect for button
SubmitButton.MouseEnter:Connect(function()
    SubmitButton.BackgroundColor3 = Color3.fromRGB(98, 111, 252)
end)

SubmitButton.MouseLeave:Connect(function()
    SubmitButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
end)

-- Button click handler
SubmitButton.MouseButton1Click:Connect(function()
    local userKey = TextBox.Text:upper():gsub("%s+", "")
    
    if userKey == "" then
        StatusLabel.Text = "⚠️ Please enter a key"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
        return
    end
    
    SubmitButton.Text = "Validating..."
    SubmitButton.BackgroundColor3 = Color3.fromRGB(70, 80, 200)
    StatusLabel.Text = "🔄 Checking license..."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    
    local isValid, message, keyData = validateKey(userKey)
    
    if isValid then
        StatusLabel.Text = "✅ Valid! Loading script..."
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        
        wait(1)
        ScreenGui:Destroy()
        loadScript()
    else
        StatusLabel.Text = "❌ " .. message
        StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        SubmitButton.Text = "Validate Key"
        SubmitButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
        TextBox.Text = ""
    end
end)

-- Allow Enter key to submit
TextBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        SubmitButton.MouseButton1Click:Fire()
    end
end)
