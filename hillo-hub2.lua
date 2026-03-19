--[[
 _    _ _____ _      _      ____  
| |  | |_   _| |    | |    |  _ \ 
| |__| | | | | |    | |    | | | |
|  __  | | | | |    | |    | | | |
| |  | |_| |_| |____| |____| |/ / 
|_|  |_|_____|______|______|___/  

        » Premium Hub Mobile Version «
]]--

local v0=loadstring(game:HttpGet("https://sirius.menu/rayfield"))();
local v1=game:GetService("Players");
local v2=game:GetService("UserInputService");
local v3=game:GetService("RunService");
local v4=game:GetService("TeleportService");
local v5=game:GetService("HttpService");
local v6=game:GetService("VirtualUser");
local v7=game:GetService("VirtualInputManager");
local v8=v1.LocalPlayer;
local v9=v8:GetMouse();

local v10=v0:CreateWindow({
    Name="Hillo Hub",
    LoadingTitle="Hillo Hub",
    LoadingSubtitle="everythings perfect",
    ConfigurationSaving={Enabled=true,FolderName="HilloHub",FileName="Config"}
});

local v11=v10:CreateTab("Main",4483362458);

-- WalkSpeed
local v12=16;
local v13;

local function v14()
    local c=v8.Character
    if not c then return end
    local h=c:FindFirstChildOfClass("Humanoid")
    if not h then return end

    if v13 then v13:Disconnect() end
    h.WalkSpeed=v12
    v13=h:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        if h.WalkSpeed~=v12 then
            h.WalkSpeed=v12
        end
    end)
end

v8.CharacterAdded:Connect(function()
    task.wait(0.5)
    v14()
end)

v11:CreateSlider({
    Name="WalkSpeed",
    Range={16,150},
    Increment=1,
    CurrentValue=16,
    Callback=function(v)
        v12=v
        v14()
    end
})

-- Infinite Jump
local v15=false;
v11:CreateToggle({
    Name="Infinite Jump",
    CurrentValue=false,
    Callback=function(v) v15=v end
})

v2.JumpRequest:Connect(function()
    if v15 then
        local h=v8.Character and v8.Character:FindFirstChildOfClass("Humanoid")
        if h then h:ChangeState("Jumping") end
    end
end)

-- Freeze
local v16=false;
v11:CreateToggle({
    Name="Freeze Position",
    CurrentValue=false,
    Callback=function(v) v16=v end
})

v3.RenderStepped:Connect(function()
    if v16 then
        local hrp=v8.Character and v8.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Velocity=Vector3.zero
            hrp.AssemblyLinearVelocity=Vector3.zero
        end
    end
end)

-- Auto systems
local v17=false; local v18=false; local v19=false;

local function v20()
    return {
        package=workspace:FindFirstChild("Merchants") and workspace.Merchants.QuestFishMerchant.Clickable.Retum,
        compass=game.ReplicatedStorage.Connections:FindFirstChild("Claim_Sam"),
        expertise=workspace.Merchants.ExpertiseMerchant.Clicked.Retum
    }
end

task.spawn(function()
    while true do task.wait(0.3)
        local v=v20()
        if v17 and v.package then pcall(function() v.package:FireServer("Package") end) end
    end
end)

task.spawn(function()
    while true do task.wait(10)
        local v=v20()
        if v18 and v.compass then pcall(function() v.compass:FireServer("Claim1") end) end
    end
end)

task.spawn(function()
    while true do task.wait(5)
        local v=v20()
        if v19 and v.expertise then pcall(function() v.expertise:FireServer() end) end
    end
end)

v11:CreateToggle({Name="Auto Package",CurrentValue=false,Callback=function(v) v17=v end})
v11:CreateToggle({Name="Auto Sam",CurrentValue=false,Callback=function(v) v18=v end})
v11:CreateToggle({Name="Auto Expertise",CurrentValue=false,Callback=function(v) v19=v end})

-- 🔥 AUTOFISH FIXED
local fishingUI=v8.PlayerGui:WaitForChild("Fishing"):WaitForChild("Frame")
local autoFish=false
local tracked={}

local function clickGui(gui)
    local pos=gui.AbsolutePosition
    local size=gui.AbsoluteSize

    local x=pos.X + size.X/2
    local y=pos.Y + size.Y/2

    local inset=game:GetService("GuiService"):GetGuiInset()
    x=x+inset.X
    y=y+inset.Y

    local cam=workspace.CurrentCamera
    local screen=cam.ViewportSize

    local scaleX=screen.X/1920
    local scaleY=screen.Y/1080

    x=x*scaleX
    y=y*scaleY

    v7:SendMouseButtonEvent(x,y,0,true,game,0)
    v7:SendMouseButtonEvent(x,y,0,false,game,0)
end

local function handleBar(bar)
    if tracked[bar] then return end
    tracked[bar]=true

    local frame=bar:WaitForChild("Frame")
    local last=nil
    local done=false

    local conn
    conn=v3.RenderStepped:Connect(function()
        if not autoFish then conn:Disconnect() return end
        if done then conn:Disconnect() return end
        if not bar.Parent then conn:Disconnect() return end

        local diff=frame.AbsoluteSize.X - bar.AbsoluteSize.X

        if last and last>0 and diff<=0 then
            done=true
            task.wait()
            clickGui(bar)
        end

        last=diff
    end)
end

fishingUI.ChildAdded:Connect(function(c)
    if autoFish and c.Name=="Template" then
        handleBar(c)
    end
end)

v11:CreateToggle({
    Name="Auto Fish",
    CurrentValue=false,
    Callback=function(v) autoFish=v end
})

-- Reel
task.spawn(function()
    local clicked=false
    while true do
        if autoFish then
            local char=v8.Character
            if char then
                for _,tool in pairs(char:GetChildren()) do
                    if tool:FindFirstChild("Cast") then
                        local bob=tool.Cast:FindFirstChild("Bobber")
                        if bob then
                            local effect=bob:FindFirstChild("Effect")
                            if effect and effect.Enabled and not clicked then
                                local m=v8:GetMouse()
                                v7:SendMouseButtonEvent(m.X,m.Y,0,true,game,0)
                                v7:SendMouseButtonEvent(m.X,m.Y,0,false,game,0)
                                clicked=true
                            end
                        else
                            clicked=false
                        end
                    end
                end
            end
        end
        task.wait(0.01)
    end
end)

-- ESP
local v39=v10:CreateTab("ESP",4483362458);
local esp=false
local drawings={}

v39:CreateToggle({
    Name="Player ESP",
    CurrentValue=false,
    Callback=function(v)
        esp=v
        if not v then
            for _,d in pairs(drawings) do d:Destroy() end
            drawings={}
        end
    end
})

v3.RenderStepped:Connect(function()
    if not esp then return end

    for _,p in pairs(v1:GetPlayers()) do
        if p~=v8 and p.Character and p.Character:FindFirstChild("Head") then
            if not drawings[p] then
                local gui=Instance.new("BillboardGui",p.Character.Head)
                gui.Size=UDim2.new(0,120,0,30)
                gui.AlwaysOnTop=true

                local txt=Instance.new("TextLabel",gui)
                txt.Size=UDim2.new(1,0,1,0)
                txt.BackgroundTransparency=1
                txt.TextScaled=true
                txt.TextColor3=Color3.new(1,1,1)

                drawings[p]=gui
            end
        end
    end
end)

-- Misc
local misc=v10:CreateTab("Misc",4483362458)

misc:CreateToggle({
    Name="Anti Idle",
    CurrentValue=false,
    Callback=function(v)
        if v then
            v8.Idled:Connect(function()
                v6:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
                task.wait(1)
                v6:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
            end)
        end
    end
})

misc:CreateButton({
    Name="Rejoin",
    Callback=function()
        v4:Teleport(game.PlaceId,v8)
    end
})

v0:Notify({
    Title="Hillo Hub",
    Content="FULL Mobile Optimized + Autofish Fixed",
    Duration=6
})

print("Hillo Hub FULL Loaded")
```
