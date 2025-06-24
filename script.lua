local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Matty's Pls Donate Auto Farm Script 💰",
   Icon = 0,
   LoadingTitle = "UI is loading. Give it some time!",
   LoadingSubtitle = "by Mattyyy",
   ShowText = "Rayfield",
   Theme = "Default",
   ToggleUIKeybind = "v",
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "Matty's pls doante auto farm script"
   },
   KeySystem = false,
   KeySettings = {
      Title = "Pls donate 💰",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"PLSDONATE!"}
   }
})

local Tab = Window:CreateTab("Main", 4483362458)

-- Example button
Tab:CreateButton({
   Name = "Button Example",
   Callback = function()
      print("Button pressed!")
   end,
})

-- Server hop delay variable and slider
local serverHopDelay = 15 -- default in minutes

Tab:CreateSlider({
   Name = "Server Hop Delay",
   Range = {1, 20},
   Increment = 1,
   Suffix = "minutes",
   CurrentValue = serverHopDelay,
   Flag = "ServerhopSlider",
   Callback = function(v)
      serverHopDelay = v
      print("Server hop delay set to: " .. v .. " minutes")
   end,
})

-- Server hop logic
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

function ServerHop()
   local PlaceId = game.PlaceId
   local JobId = game.JobId
   local servers = {}
   local cursor = ""

   -- Queue the script for execution after teleport
if queue_on_teleport then
    queue_on_teleport(game:HttpGet('https://raw.githubusercontent.com/Comet21212/yourscript/main/script.lua'))
end

   while true do
      local url = "https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=2&limit=100"..(cursor ~= "" and "&cursor="..cursor or "")
      local response = HttpService:JSONDecode(game:HttpGet(url))
      for _, server in ipairs(response.data) do
         if server.playing < server.maxPlayers and server.id ~= JobId then
            table.insert(servers, server.id)
         end
      end
      if response.nextPageCursor then
         cursor = response.nextPageCursor
      else
         break
      end
   end

   if #servers > 0 then
      TeleportService:TeleportToPlaceInstance(PlaceId, servers[math.random(1, #servers)], Players.LocalPlayer)
   else
      warn("No available servers found to hop to!")
   end
end

-- Server Hop button
Tab:CreateButton({
   Name = "Server Hop",
   Callback = function()
      ServerHop()
   end,
})

-- Optional: Auto server hop loop (uncomment to use)
--[[
spawn(function()
   while true do
      task.wait(serverHopDelay * 60)
      ServerHop()
   end
end)
]]


-- Astronaut animation IDs
local astronautIds = {
    idle = 891621366,
    walk = 891667138,
    run = 891636393,
    jump = 891627522,
    fall = 891617961,
    climb = 891609353,
    sit = 891623209,
    toolnone = 891633237
}

local function setAstronautAnimsAndFreeze()
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    -- Replace Animate script's animation IDs
    local animate = character:FindFirstChild("Animate")
    if animate then
        if animate:FindFirstChild("idle") and animate.idle:FindFirstChild("Animation1") then
            animate.idle.Animation1.AnimationId = "rbxassetid://"..astronautIds.idle
        end
        if animate:FindFirstChild("idle") and animate.idle:FindFirstChild("Animation2") then
            animate.idle.Animation2.AnimationId = "rbxassetid://"..astronautIds.idle
        end
        if animate:FindFirstChild("walk") and animate.walk:FindFirstChild("WalkAnim") then
            animate.walk.WalkAnim.AnimationId = "rbxassetid://"..astronautIds.walk
        end
        if animate:FindFirstChild("run") and animate.run:FindFirstChild("RunAnim") then
            animate.run.RunAnim.AnimationId = "rbxassetid://"..astronautIds.run
        end
        if animate:FindFirstChild("jump") and animate.jump:FindFirstChild("JumpAnim") then
            animate.jump.JumpAnim.AnimationId = "rbxassetid://"..astronautIds.jump
        end
        if animate:FindFirstChild("fall") and animate.fall:FindFirstChild("FallAnim") then
            animate.fall.FallAnim.AnimationId = "rbxassetid://"..astronautIds.fall
        end
        if animate:FindFirstChild("climb") and animate.climb:FindFirstChild("ClimbAnim") then
            animate.climb.ClimbAnim.AnimationId = "rbxassetid://"..astronautIds.climb
        end
        if animate:FindFirstChild("sit") and animate.sit:FindFirstChild("SitAnim") then
            animate.sit.SitAnim.AnimationId = "rbxassetid://"..astronautIds.sit
        end
        if animate:FindFirstChild("toolnone") and animate.toolnone:FindFirstChild("ToolNoneAnim") then
            animate.toolnone.ToolNoneAnim.AnimationId = "rbxassetid://"..astronautIds.toolnone
        end
    end

    -- Freeze all animations
    humanoid.AnimationPlayed:Connect(function(track)
        track:AdjustSpeed(0)
    end)
    for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
        track:AdjustSpeed(0)
    end
end

-- Character spin at speed 5
local spinSpeed = 5 -- degrees per frame
local spinning = false

local function startSpin()
    if spinning then return end
    spinning = true
    task.spawn(function()
        while spinning do
            local character = Players.LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                character.HumanoidRootPart.CFrame = character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0)
            end
            task.wait()
        end
    end)
end

local function onCharacterAdded()
    task.wait(1)
    setAstronautAnimsAndFreeze()
    startSpin()
end

Players.LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
if Players.LocalPlayer.Character then
    onCharacterAdded()
end