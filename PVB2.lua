Buttons[9].MouseButton1Click:Connect(function()
       local apiUrl = "https://games.roblox.com/v1/games/"
       local placeId, jobId = game.PlaceId, tostring(game.JobId)
       local isSearching = false
       local visitedServers = {}
       
       local hasIsFile = type(isfile) == "function"
       local hasWriteFile = type(writefile) == "function"
       local hasReadFile = type(readfile) == "function"
       local hasMakeFolder = type(makefolder) == "function"
       
       local folderName = "Joined_jack827"
       local fileName = string.format("%s/joined_%d.json", folderName, placeId)
       
       if hasMakeFolder then
           pcall(function()
               makefolder(folderName)
           end)
       end
       
       local function fileExists(path)
           if hasIsFile then
               local success, result = pcall(isfile, path)
               return success and result
           end
           return false
       end
       
       local function notify(title, text, duration)
           pcall(function()
               StarterGui:SetCore("SendNotification", {
                   Title = title or "Notification",
                   Text = text or "",
                   Duration = duration or 5
               })
           end)
       end
       
       local function saveVisitedServers()
           if not hasWriteFile then return end
           
           local success, err = pcall(function()
               local json = HttpService:JSONEncode(visitedServers)
               writefile(fileName, json)
           end)
       end
       
       local function loadVisitedServers()
           if hasReadFile and fileExists(fileName) then
               local success, content = pcall(readfile, fileName)
               if success and content then
                   local decodeSuccess, data = pcall(HttpService.JSONDecode, HttpService, content)
                   if decodeSuccess and type(data) == "table" then
                       visitedServers = data
                   end
               end
           else
               visitedServers = {}
           end
           
           if not table.find(visitedServers, jobId) then
               table.insert(visitedServers, jobId)
               saveVisitedServers()
           end
       end
       
       local function markServerVisited(serverId)
           if not table.find(visitedServers, serverId) then
               table.insert(visitedServers, serverId)
               saveVisitedServers()
           end
       end
       
       local function hasVisited(serverId)
           return table.find(visitedServers, serverId) ~= nil
       end
       
       local function getServers(sortOrder)
           local success, response = pcall(function()
               return game:HttpGet(apiUrl .. placeId .. "/servers/Public?sortOrder=" .. sortOrder .. "&limit=10")
           end)
           
           if not success then
               return {data = {}}
           end
           
           local decodeSuccess, data = pcall(HttpService.JSONDecode, HttpService, response)
           if not decodeSuccess then
               return {data = {}}
           end
           
           return data
       end
       
       local function togglePetFinder()
           if isSearching then
               isSearching = false
               Buttons[9].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
               notify("Pet Finder", "Stopped", 3)
               return
           end
           
           isSearching = true
           Buttons[9].BackgroundColor3 = Color3.fromRGB(0, 255, 0)
           notify("Pet Finder", "Started - re-New every 3s", 3)
           
           task.spawn(function()
               while isSearching do
                   local sortOrder = math.random(1, 2) == 1 and "Asc" or "Desc"
                   local servers = getServers(sortOrder)
                   
                   if servers and servers.data and #servers.data > 0 then
                       local unvisitedServers = {}
                       
                       for _, server in ipairs(servers.data) do
                           if server.id ~= jobId and not hasVisited(server.id) then
                               table.insert(unvisitedServers, server)
                           end
                       end
                       
                       if #unvisitedServers > 0 then
                           local randomServer = unvisitedServers[math.random(1, #unvisitedServers)]
                           markServerVisited(randomServer.id)
                           
                           pcall(function()
                               TeleportService:TeleportToPlaceInstance(placeId, randomServer.id, Player)
                           end)
                       end
                   end
                   
                   task.wait(3)
               end
           end)
       end
       
       loadVisitedServers()
       togglePetFinder()
   end)
