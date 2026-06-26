-- World 2: +1 speed keyboard escape (hard respawn fix)

return function(section, data)
    print("reached")

    local elements = loadstring(game:HttpGet(getgitpath("src").."elements.lua"))()
    local env = getgenv()
    local plr = game:GetService("Players").LocalPlayer
    local HttpService = game:GetService("HttpService")

    env.Farming = false
    env.WinStage = 1

    local char, hrp, hum

    local function bindCharacter(c)
        char = c
        hrp = nil
        hum = nil

        if c then
            hrp = c:WaitForChild("HumanoidRootPart", 10)
            hum = c:WaitForChild("Humanoid", 10)
        end
    end

    bindCharacter(plr.Character or plr.CharacterAdded:Wait())
    plr.CharacterAdded:Connect(bindCharacter)

    local setdata = data[tostring(game.PlaceId)] or {}
    setdata.farming = setdata.farming or false
    setdata.winstage = setdata.winstage or 1
    data[tostring(game.PlaceId)] = setdata

    writefile("BrainrotPolice/Config.json", HttpService:JSONEncode(data))

    elements:Label("Currently supports up to 1 stage.", section)

    elements:Textbox("Win Stage", section, tostring(env.WinStage), function(v)
        env.WinStage = tonumber(v)
        getgenv().setconfig("winstage", tonumber(v))
    end)

    local function getSpawn()
        local w2 = workspace:FindFirstChild("WORLD 2")
        local lobby = w2 and w2:FindFirstChild("Lobby")
        return lobby and lobby:FindFirstChild("SpawnLocation")
    end

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

        -- main loop (respawn safe)
        task.spawn(function()
            while env.Farming do
                pcall(function()

                    -- HARD WAIT for character after respawn
                    if not plr.Character then
                        plr.CharacterAdded:Wait()
                        return
                    end

                    if not char or not hrp or not hum or hum.Health <= 0 then
                        bindCharacter(plr.Character)
                        return
                    end

                    local spawn = getSpawn()
                    if not spawn then return end

                    -- force spawn first
                    if (hrp.Position - spawn.Position).Magnitude > 6 then
                        hum:MoveTo(spawn.Position)
                        task.wait(0.15)
                        return
                    end

                    hrp.Velocity = Vector3.zero

                    local checkpoint = Vector3.new(-393, 499.87, 191.03)

                    hum:MoveTo(checkpoint)

                    while env.Farming
                        and hrp
                        and (hrp.Position - checkpoint).Magnitude > 7 do
                        task.wait(0.05)
                    end

                    if hrp then
                        hrp.Velocity = Vector3.zero
                    end

                    if env.WinStage == 1 then
                        local win = workspace:WaitForChild("Winblocks"):WaitForChild("WinBlock16")
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
