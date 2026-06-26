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
    part.Anchored = true
    part.Size = Vector3.new(12, 1, 6)
    part.Position = Vector3.new(-394, 503, 6)
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
                    plr.Character.Humanoid:MoveTo(Vector3.new(-400, 189, 6))
                    plr.Character.Humanoid.MoveToFinished:Wait()
                    if env.WinStage == 1 then
                        plr.Character.Humanoid:MoveTo(workspace.Structure.Stage2.WinBlock1.Position)
                        plr.Character.Humanoid.MoveToFinished:Wait()
                        task.wait(1)
                    end
                end)
            end
        end)
    end)

end
