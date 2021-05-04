local textprompt = {}

local audio = require(game:WaitForChild('ReplicatedStorage'):WaitForChild('Libraries'):WaitForChild('audio'))


local ui_frames = game.Players.LocalPlayer:WaitForChild('PlayerGui'):WaitForChild('GUI'):WaitForChild('Frame')

local frame = ui_frames:WaitForChild('textprompt')


local queue = {};


local waiting = false; --if true, waiting to continue

frame.interact.Activated:Connect(function()
    waiting = false;
end)

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.Return then
        waiting = false;
    end
end)



function textprompt:Prompt(texts)

    for _,TEXT in pairs(texts) do
        table.insert(queue, { text = TEXT });
    end

    textprompt:Run()

end


local running = false;
function textprompt:Run()

    if running then return end
    running = true
    frame.Visible = true;

    while #queue > 0 do

        local info = queue[1];
        frame.body1.Text = info.text;

        
        waiting = true;
        while waiting do wait() end
        
        audio:PlaySound('button_click', 0.15)

        table.remove(queue, 1);

    end

    running = false;
    frame.Visible = false;

end








return textprompt