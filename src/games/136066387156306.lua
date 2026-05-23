-- Be Flash for Brainrots

return function(section)
    local elements = loadstring(game:HttpGet(getgitpath("src").."elements.lua"))()

    local repstorage = game:GetService("ReplicatedStorage")
    local runservice = game:GetService("RunService")
    local eventsFold = repstorage.Events
    local dashev = repstorage.DashEvent
    local traintreadev = eventsFold.TrainTreadmillEvent
    local sendtreadfu = eventsFold.SendTreadmillEvent
    local vfxev = repstorage.Remotes.VFXEvent

    local speedWalls = workspace.Gameplay.SpeedWalls
    
    local plr = game:GetService("Players").LocalPlayer
    local stamamt = plr.StaminaLevel

    getgenv().FarmBrainrots = false
    getgenv().FarmTread = false

    elements:Toggle("Farm Brainrots", section, function(bool)
        if bool then
            getgenv().FarmBrainrots = true

            local con
            con = runservice.RenderStepped:Connect(function()
                local pp = plr.Character.PrimaryPart
                pp.Position = Vector3.new(0, pp.Position.Y, pp.Position.Z)
                if not getgenv().FarmBrainrots then
                    con:Disconnect()
                end
            end)

            while getgenv().FarmBrainrots do
                local char = plr.Character
                char:MoveTo(Vector3.new(-0, 3, 21))

                task.wait(0.1)

                keypress(0xA0)
                task.wait(3)
                keyrelease(0xA0)

                wait(10)

                local canFinish = false
                local vfxlistener = vfxev.OnClientEvent:Connect(function(bleh, blah, yes)
                    if yes == "StopCharge" then
                        canFinish = traintreadev
                    end
                end)

                repeat task.wait(0.5) until canFinish
                vfxlistener:Disconnect()

                wait(3)
            end
        else
            getgenv().FarmBrainrots = false
        end
    end)

    elements:Toggle("Auto Boost (Treadmill)", section, function(bool)
        if bool then
            getgenv().FarmTread = true

            while getgenv().FarmTread do
                traintreadev:FireServer(true)
                task.wait()
            end
        else
            getgenv().FarmTread = false
        end
    end)

    
end
