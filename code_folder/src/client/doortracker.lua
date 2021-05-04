local doortracker = {}

local mouse = game.Players.LocalPlayer:GetMouse();
local RunService = game:GetService("RunService")


doortracker.listeners = {}
doortracker.gameshow = false;

doortracker.selected = false;

function doortracker:HitDoor(door_class)

    if doortracker.selected ~= door_class then

        if doortracker.selected then
            doortracker.selected:Highlight(false)
        end
        
        doortracker.selected = door_class;
        if door_class then
            door_class:Highlight(true);
        end

    end
end

function doortracker:DoorClicked(door_class, callback)
    callback(door_class);
end

function doortracker:Frame()
    if mouse.Target and mouse.Target.Parent.Name == 'Door' and doortracker.gameshow then --found a possible door

        for _,DOOR_CLASS in pairs(doortracker.gameshow:GetDoors()) do

            if DOOR_CLASS.model == mouse.Target.Parent and DOOR_CLASS.selectable then
                doortracker:HitDoor(DOOR_CLASS)
                return;
            end
        end
    end

    doortracker:HitDoor();
end



function doortracker:Track(do_track, gameshow, click_callback)
    doortracker.gameshow = gameshow;

    if do_track then


        table.insert(doortracker.listeners,
            RunService.RenderStepped:Connect(function(delta_time) doortracker:Frame(delta_time) end)
        )

        table.insert(doortracker.listeners,
            mouse.Button1Down:Connect(function()
                if doortracker.selected then
                    doortracker:DoorClicked(doortracker.selected, click_callback)
                end
            end)
        )


    else
        for _,LISTENER in pairs(doortracker.listeners) do
            LISTENER:Disconnect()
        end
        doortracker.listeners = {};

        doortracker:HitDoor();
    end

end



return doortracker