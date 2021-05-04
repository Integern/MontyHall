local gameshow_class = require(game:WaitForChild('ReplicatedStorage'):WaitForChild('Classes'):WaitForChild('gameshow'));
local door_class = require(game:WaitForChild('ReplicatedStorage'):WaitForChild('Classes'):WaitForChild('door'));

local doortracker = require(script.Parent:WaitForChild('doortracker'))
local demonstration = require(script.Parent:WaitForChild('demonstration'))




local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:wait();
demonstration:Run()



--[[
--load doors into gameshow
local gameshow = gameshow_class.new();

local count = 0;
for _,OBJ in pairs(game.Workspace:GetChildren()) do
    if OBJ.Name == 'Door' then

        count += 1;
        local door = door_class.new(OBJ, 'door' .. count)
        gameshow:AddDoor( door );
    end
end


doortracker:Track(true, gameshow);



--misc






while wait(2) do
    gameshow:RandomiseWinner();
    

    local goat = gameshow:GetRandomGoat();

    goat:Open()
    wait(1)

    goat:Close()
    wait(1)


    gameshow:OpenDoors();
    wait(2)
    gameshow:CloseDoors();
end
]]
