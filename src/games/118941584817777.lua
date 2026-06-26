-- World 2: +1 speed keyboard escape

return function(section, data)
    print("reached")

    local elements = loadstring(game:HttpGet(getgitpath("src").."elements.lua"))()
    local env = getgenv()
    local plr = game:GetService("Players").LocalPlayer
    local HttpService = game:GetService("HttpService")
    local Workspace = game:GetService("Workspace")

    env.Farming = false
    env.WinStage = 1

    -- config
    local setdata = data[tostring(game.PlaceId)] or {}
    setdata.farming = setdata.farming or false
    setdata.winstage = setdata.winstage or 1
    data[tostring(game.PlaceId)] = setdata

    writefile("BrainrotPolice/Config.json", HttpService:JSONEncode(data))

    print("yeah")

    elements:Label("Currently supports up to 1 stage.", section)

    elements:Textbox("Win Stage", section, tostring(env.WinStage), function(v)
        env.WinStage = tonumber(v)
        getgenv().setconfig("winstage", tonumber(v))
    end)

    ----------------------------------------------------------------
    -- PART (guaranteed spawn test object)
    ----------------------------------------------------------------
    local part = Instance.new("Part")
    part.Name = "DebugPart"
    part.Position = Vector3.new(-394, 501, 6)
    part.Size = Vector3.new(12, 1, 350)
    part.Anchored = true
    part.CanCollide = true
    part.Color = Color3.fromRGB(255, 0, 0)
    part.Parent = Workspace

    print("Part created:", part:GetFullName())

    ----------------------------------------------------------------
    -- SPAWN CHECKPOINT FARM LOGIC
    ----------------------------------------------------------------
    elements:Toggle("Autofarm", section, env.Farming, function(v)
        env.Farming = v
        getgenv().setconfig("farming", v)

        if not v then return end

        -- speed loop
        task.spawn(function()
            while env.Farming do
                game:GetService("ReplicatedStorage")
                    :WaitForChild("Remotes")
                    :WaitForChild("UpdateSpeed")
                    :FireServer("Walking")

                task.wait()
            end
        end)

        -- main loop
        task.spawn(function()
            while env.Farming do
                pcall(function()
                    local char = plr.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    local hum = char and char:FindFirstChild("Humanoid")

                    local spawnLocation =
                        Workspace:FindFirstChild("WORLD 2")
                        and Workspace["WORLD 2"]:FindFirstChild("Lobby")
                        and Workspace["WORLD 2"].Lobby:FindFirstChild("SpawnLocation")

                    if not char or not hrp or not hum or not spawnLocation then return end

                    -- force spawn first
                    if (hrp.Position - spawnLocation.Position).Magnitude > 6 then
                        hum:MoveTo(spawnLocation.Position)
                        task.wait(0.15)
                        return
                    end

                    hrp.Velocity = Vector3.zero

                    local checkpoint = Vector3.new(-393, 499.87, 191.03)

                    hum:MoveTo(checkpoint)

                    while env.Farming and hrp and (hrp.Position - checkpoint).Magnitude > 5 do
                        task.wait(0.05)
                    end

                    if hrp then
                        hrp.Velocity = Vector3.zero
                    end

                    if env.WinStage == 1 then
                        local win = Workspace:WaitForChild("Winblocks"):WaitForChild("WinBlock16")
                        hum:MoveTo(win.Position)
                        hum.MoveToFinished:Wait()
                        task.wait(1)
                    end
                end)

                task.wait(0.1)
            end
        end)
    end)
end
