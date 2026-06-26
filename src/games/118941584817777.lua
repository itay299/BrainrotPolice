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
                    -- Walk to first checkpoint
                    plr.Character.Humanoid:MoveTo(Vector3.new(-393, 499.87, 191.03))
                    plr.Character.Humanoid.MoveToFinished:Wait()
                    
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
