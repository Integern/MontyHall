local graph = {}


local ui_frames = game.Players.LocalPlayer:WaitForChild('PlayerGui'):WaitForChild('GUI'):WaitForChild('Frame')
local tween = require(game:WaitForChild('ReplicatedStorage'):WaitForChild('Libraries'):WaitForChild('tween'));

local frame = ui_frames:WaitForChild('graph')


graph.settings = {
    cap = 5;
    switch = 0;
    stick = 0;
    animation_duration = 0.2;
}



function graph:Start(cap)

    graph.settings.switch = 0;
    graph.settings.stick = 0;
    graph.settings.cap = cap;


    graph:Update();
    
    frame.Visible = true;

end

function graph:Stop()
    frame.Visible = false;
end


function graph:Show()
    frame.Visible = true;
end

function graph:Hide()
    frame.Visible = false;
end



function graph:Update()

    tween.tween(frame.bar_switch.bar, 'Size', UDim2.new(graph.settings.switch/graph.settings.cap, 0, 1, 0), graph.settings.animation_duration)
    tween.tween(frame.bar_stick.bar, 'Size', UDim2.new(graph.settings.stick/graph.settings.cap, 0, 1, 0), graph.settings.animation_duration)

    frame.bar_switch.num.Text = graph.settings.switch;
    frame.bar_stick.num.Text = graph.settings.stick;

end


function graph:Win(type)
    if type == 'Stick' then
        graph.settings.stick += 1;
    elseif type == 'Switch' then
        graph.settings.switch += 1;
    else
        error('no type', type)
    end

    graph:Update()
end

function graph:Loss(type)
    if type == 'Stick' then
        graph.settings.switch += 1;
    elseif type == 'Switch' then
        graph.settings.stick += 1;
    else
        error('no type', type)
    end

    graph:Update()
end


return graph