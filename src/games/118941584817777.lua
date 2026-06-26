-- World 2: +1 speed keyboard escape

return function(section, data)
    print("reached")
    local elements = loadstring(game:HttpGet(getgitpath("src").."elements.lua"))()
    local env = getgenv()
    local plr = game:GetService("Players").LocalPlayer

    env.Farming = false
    env.WinStage = 1

    local setdata = data[tostring(game.PlaceId)] or {}
    setdata.farming = setdata.farming or false
    setdata.winstage = setdata.winstage or 1
    data[tostring(game.PlaceId)] = setdata
    writefile("BrainrotPolice/Config.json", game:GetService("HttpService"):JSONEncode(data))

    print("yeah")

    elements:Label("Currently supports up to 1 stage.", section)

    elements:Textbox("Win Stage", section, tostring(env.WinStage), function(v)
        env.WinStage = tonumber(v)
        getgenv().setconfig("winstage", tonumber(v))
    end)

    local part = Instance.new("Part")
    part.Position = Vector3.new(-394, 501, 6)
    part.Size = Vector3.new(12, 1, 350)
    part.Anchored = true
    part.Parent = workspace

    elements:Toggle("Autofarm", section, env.Farming, function(v)
        env.Farming = v
        getgenv().setconfig("farming", v)

        if not v then return end

        spawn(function()
            while env.Farming do
                local args = {
                    "Walking"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("UpdateSpeed"):FireServer(unpack(args))
                task.wait()
            end
        end)

        spawn(function()
            while env.Farming do
                pcall(function()
                    -- Check if player is standing on SpawnLocation
                    local spawnLocation = workspace:FindFirstChild("WORLD 2") and workspace["WORLD 2"]:FindFirstChild("Lobby") and workspace["WORLD 2"].Lobby:FindFirstChild("SpawnLocation")
                    local isOnSpawn = false
                    
                    if spawnLocation and plr.Character:FindFirstChild("HumanoidRootPart") then
                        local humanoidPos = plr.Character.HumanoidRootPart.Position
                        local spawnPos = spawnLocation.Position
                        local spawnSize = spawnLocation.Size
                        
                        -- Check if player is within spawn location bounds
                        if math.abs(humanoidPos.X - spawnPos.X) <= spawnSize.X/2 and
                           math.abs(humanoidPos.Y - spawnPos.Y) <= spawnSize.Y/2 and
                           math.abs(humanoidPos.Z - spawnPos.Z) <= spawnSize.Z/2 then
                            isOnSpawn = true
                        end
                    end
                    
                    -- If not on spawn, go to middle of spawn location
                    if not isOnSpawn and spawnLocation then
                        plr.Character.Humanoid:MoveTo(spawnLocation.Position)
                        plr.Character.Humanoid.MoveToFinished:Wait()
                    end
                    
                    local checkpoint = Vector3.new(-393, 499.87, 191.03)
                    
                    -- Walk to first checkpoint
                    plr.Character.Humanoid:MoveTo(checkpoint)
                    
                    -- Wait until 5 studs away from checkpoint
                    while (plr.Character.HumanoidRootPart.Position - checkpoint).Magnitude > 5 do
                        task.wait(0.01)
                    end
                    
                    -- Stop momentum by setting velocity to 0
                    if plr.Character:FindFirstChild("HumanoidRootPart") then
                        plr.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                        task.wait(0.1)
                    end
                    
                    -- Walk to win block
                    if env.WinStage == 1 then
                        plr.Character.Humanoid:MoveTo(workspace.Winblocks.WinBlock16.Position)
                        plr.Character.Humanoid.MoveToFinished:Wait()
                        task.wait(1)
                    end
                end)
            end
        end)
    end)

end
