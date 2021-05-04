local demonstration = {}


    ------------------------------------------------------------------
    --load in important stuff (libraries, classes, roblox objects)
    ------------------------------------------------------------------

local gameshow_class = require(game:WaitForChild('ReplicatedStorage'):WaitForChild('Classes'):WaitForChild('gameshow'));
local door_class = require(game:WaitForChild('ReplicatedStorage'):WaitForChild('Classes'):WaitForChild('door'));

local tween = require(game:WaitForChild('ReplicatedStorage'):WaitForChild('Libraries'):WaitForChild('tween'));
local audio = require(game:WaitForChild('ReplicatedStorage'):WaitForChild('Libraries'):WaitForChild('audio'))

local doortracker = require(script.Parent:WaitForChild('doortracker'))
local graph = require(script.Parent:WaitForChild('graph'))
local textprompt = require(script.Parent:WaitForChild('textprompt'))


local ui_frames = game.Players.LocalPlayer:WaitForChild('PlayerGui'):WaitForChild('GUI'):WaitForChild('Frame')

local camera = game.Workspace.CurrentCamera;
local cameras = game.Workspace:WaitForChild('Cameras')



demonstration.camera_focus_duration = 0.5;


function demonstration:CameraFocus(camera_name, instant, fov, offset, speed_multiplier)
    fov = fov or 70;
    offset = offset or Vector3.new()
    speed_multiplier = speed_multiplier or 1;

    local focus = cameras:WaitForChild(camera_name).CFrame
    focus = focus + offset;

    if instant then
        camera.CFrame = focus
        camera.FieldOfView = fov;
    else
        tween.tween(camera, 'CFrame', focus, demonstration.camera_focus_duration * speed_multiplier);
        camera.FieldOfView = fov;
        --tween.tween(camera, 'FieldOfView', fov, demonstration.camera_focus_duration);
    end

end

    


function demonstration:RunThroughGameshow(gameshow, is100Doors, more_prompts)

    gameshow:CloseDoors();


    ------------------------------------------------------------------
    --setup fresh gameshow
    ------------------------------------------------------------------
    gameshow:RandomiseWinner();


    local chosen_door = false;
    doortracker:Track(true, gameshow, function(door_class)
    
        doortracker:Track(); --stop tracking
        chosen_door = door_class;

    end)

    local prompt_selectdoor;
    if is100Doors then
        prompt_selectdoor = ui_frames:WaitForChild('prompt_selectdoor_low');
    else
        prompt_selectdoor = ui_frames:WaitForChild('prompt_selectdoor');
    end
    prompt_selectdoor.Visible = true;








    ------------------------------------------------------------------
    --first choice now made
    ------------------------------------------------------------------
    while not chosen_door do wait() end


    prompt_selectdoor.Visible = false;
    chosen_door:Select(true);

    if more_prompts then
        textprompt:Prompt({"Let's see where there are goats.."});
    end
    

    local goat_doors = gameshow:GetNearlyAllGoats(chosen_door);

    for i,DOOR in pairs(goat_doors) do 
        DOOR:Open(nil, i>3);
    end

    wait(1.75)
    for i,DOOR in pairs(goat_doors) do 
        DOOR:Selectable(false)
        DOOR:Close(nil, i>3);
    end









    local chosen_door_2 = false;

    chosen_door:Select(nil, true);

    if more_prompts then
        textprompt:Prompt({"You now have the option to stick with your first choice, or switch to the other door! Please press Return."});
    end

    doortracker:Track(true, gameshow, function(door_class)

        doortracker:Track()
        chosen_door_2 = door_class;
    
    end)

    prompt_selectdoor.Visible = true;




    ------------------------------------------------------------------
    --second choice now made
    ------------------------------------------------------------------
    
    while not chosen_door_2 do wait() end


    prompt_selectdoor.Visible = false;

    local choice = false;

    if chosen_door ~= chosen_door_2 then
        chosen_door:Select(false)
        chosen_door_2:Select(true)

        --print('You switched your choice!')

        choice = 'Switch'
    else

        --print('You stuck with your original choice!')

        choice = 'Stick'
    end

    for _,DOOR in pairs(goat_doors) do 
        DOOR:Selectable(true);
    end

    ------------------------------------------------------------------
    --reveal
    ------------------------------------------------------------------

    if more_prompts then
        textprompt:Prompt({"Let's reveal your prize.."});
    end

    if is100Doors then
        demonstration:Doors100Focus(chosen_door_2)
    end

    wait(0.25)
    chosen_door_2:Open();

    if chosen_door_2 == gameshow.winner.door then
        textprompt:Prompt({'YOU WIN!!!! :) :)'});
    else
        audio:PlaySound('error', 0.1)
        textprompt:Prompt({'you lose :('});
    end
    
    wait(1)
    gameshow:OpenDoors();
    chosen_door_2:Select(false);
    wait(1.25)

    gameshow:CloseDoors();


    ------------------------------------------------------------------
    --return data of if we won and what choice we made
    ------------------------------------------------------------------

    return chosen_door_2 == gameshow.winner.door, choice

    
end


function demonstration:Doors100(gameshow, more_prompts)

    demonstration:CameraFocus('Doors_100', nil, 30)

    local win, choice = demonstration:RunThroughGameshow(gameshow, true, more_prompts);
    demonstration:Doors100Focus()

    return win, choice

end

function demonstration:Doors100Focus(door)

    if door then

        local cam = cameras:WaitForChild('Doors_100');

        local focus = cam.CFrame
        local doorPart = door.model.PrimaryPart;
        focus = focus --+ Vector3.new(doorPart.Position.X - cam.Position.X, -150, doorPart.Position.Z - cam.Position.Z);
    
        tween.tween(camera, 'CFrame', focus, demonstration.camera_focus_duration);
    else
        demonstration:CameraFocus('Doors_100', nil, 30)
    end

end

function demonstration:SetDoors3(gameshow, more_prompts)

    ------------------------------------------------------------------
    -- PLAYS THE 3 DOOR VERSION IN THE STUDIO SET
    ------------------------------------------------------------------

    demonstration:CameraFocus('Set_3')

    return demonstration:RunThroughGameshow(gameshow, nil, more_prompts);

end

function demonstration:SetDoors5(gameshow, more_prompts)


    ------------------------------------------------------------------
    -- PLAYS THE 5 DOOR VERSION IN THE STUDIO SET
    ------------------------------------------------------------------

    demonstration:CameraFocus('Set_5')

    return demonstration:RunThroughGameshow(gameshow, nil, more_prompts);

end






function demonstration:Section1()


    ------------------------------------------------------------------
    --intro
    ------------------------------------------------------------------

    audio:Music(0.1);
    audio:Clapping(0.3);

    textprompt:Prompt({
        'Hello and  welcome to the Monty Hall problem! Please click the button or press Return to continue.';
        "The Monty Hall problem is a brain teaser, in the form of a probability puzzle, loosely based on the American television game show Let's Make a Deal.";
        "It is named after its original host, Monty Hall. The problem was originally posed (and solved) by Steve Selvin in 1975.";
        'The problem begins as follows; there are 3 doors presented to you. One of the doors has a car behind it..';
    })
    demonstration:CameraFocus('Set_wide');
    wait(1)


    ------------------------------------------------------------------
    --start gameshow example
    ------------------------------------------------------------------
    local gameshow = gameshow_class.new();
    gameshow:AddDoor( door_class.new(game.Workspace.SetDoors['2'].Door, 'door1') )
    gameshow:AddDoor( door_class.new(game.Workspace.SetDoors['3'].Door, 'door2') )
    gameshow:AddDoor( door_class.new(game.Workspace.SetDoors['4'].Door, 'door3') )
    local winner = gameshow:RandomiseWinner();


    gameshow:OpenDoor(winner.position);
    wait(1)
    textprompt:Prompt({'And the other 2 doors have goats behind them..'});
    gameshow:OpenDoors();

    wait(2)
    gameshow:CloseDoors();
    wait(1)


    ------------------------------------------------------------------
    --first attempt
    ------------------------------------------------------------------
    textprompt:Prompt({'You must correctly choose the door with a car behind it. Have a go yourself..'});
    wait(0.25)


    demonstration:SetDoors3(gameshow, true)


    ------------------------------------------------------------------
    --first testing (gather some data)
    ------------------------------------------------------------------

    --quick intro
    textprompt:Prompt({
        'After your first choice, you were given the choice to stick with your original door or switch to the other door.';
        'A goat was revealed so there was only 2 unknown doors - 1 car and 1 goat.';
        'The Monty Hall problem is as follows:';
        'Is it better to switch to the other door, or stick with your original choice?';
    });



    ------------------------------------------------------------------
    --animate switch or stick graphic
    ------------------------------------------------------------------
    local problem = ui_frames:WaitForChild('2_problem')
    problem.Visible = true

    tween.tween(problem, 'Size', UDim2.new(0.4, 0, 0.2, 0), 1, Enum.EasingStyle.Elastic)
    wait(1.5)
    tween.tween(problem, 'Size', UDim2.new(0.6, 0, 0.3, 0), 1, Enum.EasingStyle.Elastic)
    wait(2)
    tween.tween(problem, 'Size', UDim2.new(0, 0, 0, 0), 1, Enum.EasingStyle.Elastic)
    wait(1.5)
    problem.Visible = false;



    textprompt:Prompt({
        'Surely it does not matter, it is all chance anyway right? You should go with your instinct!';
        'But you are also shown where a goat is - you now have new information. Does this change the chance of things?';
        'Have a few more attempts, and we will keep track of the winning choice in each round.';
    })

    ------------------------------------------------------------------
    --let the user run through a few games themself
    ------------------------------------------------------------------

    --start 5 games
    graph:Start(5);
    for i = 1,5 do

        local win, choice = demonstration:SetDoors3(gameshow, i==1);

        if win then
            graph:Win(choice)
        else
            graph:Loss(choice)
        end

    end



    textprompt:Prompt({
        'This was a very small sample size; this means anything could happen in such a small amount of rounds.';
        'To truly see which method is best, we need to run this experiment many many times until we start seeing the true answer!';
        "Let's run it, say, 100 times?"
    })


    ------------------------------------------------------------------
    --big boy simulation
    ------------------------------------------------------------------

    graph:Start(100)

    gameshow:CloseDoors()

    local quick = false
    local d = 1;
    for i = 1, 100 do


        if i == 5 and quick == false then
            quick = true;
            textprompt:Prompt({"This is a bit slow.. Shall we speed it up?"})
            d = 0.01;
        end

        wait(d)

        local winner = gameshow:RandomiseWinner();

        local choice = gameshow:GetDoor(math.random(1,3))
        local goat = gameshow:GetRandomGoat(choice);

        choice:Select(true);
        wait(d)
        goat:Open(quick);
        wait(d)
        goat:Selectable(false);
        goat:Close(quick)
        wait(d);
        gameshow:OpenDoors(quick);

        if choice.isCar then
            graph:Win('Stick')
        else
            graph:Win('Switch')
        end

        wait(d)
        choice:Select(false);
        goat:Selectable(true);
        gameshow:CloseDoors(quick);

    end

    wait(3)
    --graph:Hide();

    textprompt:Prompt({
        "Looks like it tends towards switching is the best method.. ";
        'Around every 2 in 3 games, switching is the best method to use.';
        "But maybe it is not clear yet why this is the best method..";
    })

    --graph:Show()
    wait(1)
    graph:Hide()



end




function demonstration:Section2()


    demonstration:CameraFocus('Set_5', nil, nil, nil, 2)

    ------------------------------------------------------------------
    --start gameshow example
    ------------------------------------------------------------------
    local gameshow = gameshow_class.new();
    
    local door1, door5 = door_class.new(game.Workspace.SetDoors['1'].Door, 'door1'), door_class.new(game.Workspace.SetDoors['5'].Door, 'door5');

    gameshow:AddDoor( door1 )
    gameshow:AddDoor( door_class.new(game.Workspace.SetDoors['2'].Door, 'door2') )
    gameshow:AddDoor( door_class.new(game.Workspace.SetDoors['3'].Door, 'door3') )
    gameshow:AddDoor( door_class.new(game.Workspace.SetDoors['4'].Door, 'door4') )
    gameshow:AddDoor( door5 )
    local winner = gameshow:RandomiseWinner();

    
    ------------------------------------------------------------------
    --animate doors down
    ------------------------------------------------------------------
    local h = 50; --height from stage
    local duration = 2.25;


    door1.door.left_position -= Vector3.new(0, h, 0);
    door1.door.right_position -= Vector3.new(0, h, 0);

    door5.door.left_position -= Vector3.new(0, h, 0);
    door5.door.right_position -= Vector3.new(0, h, 0);



    tween.tweenmodel(door1.model, door1.model:GetPrimaryPartCFrame() - Vector3.new(0, h, 0), duration, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out);
    tween.tweenmodel(door5.model, door5.model:GetPrimaryPartCFrame() - Vector3.new(0, h, 0), duration, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out)

    ------------------------------------------------------------------
    --play with 5 doors
    ------------------------------------------------------------------

    textprompt:Prompt({"Let's play with 5 doors this time, where 3 goats will be revealed."});

    for i = 1, 3 do
        demonstration:SetDoors5(gameshow);
    end


    

end



function demonstration:Section3()


    ------------------------------------------------------------------
    --move to new area
    ------------------------------------------------------------------

    textprompt:Prompt({"Ok, let's exaggerate the point here.. How about over 100 doors? (102 to be exact!)"});


    demonstration:CameraFocus('Set_transition')
    wait(2 * demonstration.camera_focus_duration)
    demonstration:CameraFocus('Doors_100_transition', true)
    wait()
    demonstration:CameraFocus('Doors_100', nil, 30, nil, 3)
    wait(4 * demonstration.camera_focus_duration)
    



    ------------------------------------------------------------------
    --start gameshow example
    ------------------------------------------------------------------
    local gameshow = gameshow_class.new();

    for i,DOOR in pairs(game.Workspace.Doors_100:GetChildren()) do 
        local door = door_class.new(DOOR, 'door' .. i)
        door:ClearPrizes();
        gameshow:AddDoor( door );
    end

    local winner = gameshow:RandomiseWinner();




    ------------------------------------------------------------------
    --explain the use of a big example
    ------------------------------------------------------------------
    wait(1)
    textprompt:Prompt({'With these 102 doors, there are 101 goats and 1 car..'});
    gameshow:OpenDoors()
    wait(4)
    gameshow:CloseDoors()
    
    textprompt:Prompt({
        'As with the previous examples, we will open all but 2 doors. In this example, we will be shown 100 goats.';
        'There will then be 2 doors left; one has a goat, and one has a car.';
        'In all of these examples, the car is never revealed to us';
        'From your initial choice, there was a very small chance you would pick the car first time.';
        'You most likely picked a goat; the other unopened door is then very likely to be the car.';
        'Try it yourself a few times.';
    });


    ------------------------------------------------------------------
    --allow play of the big example
    ------------------------------------------------------------------

    for i = 1, 3 do
        local winner = gameshow:RandomiseWinner()
        demonstration:Doors100(gameshow, i==1)
    end

    textprompt:Prompt({'Did you see how switching every time was the best strategy?'});

end




function demonstration:Section4()


    textprompt:Prompt({"Let's go back to the original 3 door version."})



    ------------------------------------------------------------------
    --start gameshow example
    ------------------------------------------------------------------
    local gameshow = gameshow_class.new();

    local door2 = door_class.new(game.Workspace.SetDoors['2'].Door, 'door2')
    local door3 = door_class.new(game.Workspace.SetDoors['3'].Door, 'door3')
    local door4 = door_class.new(game.Workspace.SetDoors['4'].Door, 'door4')

    gameshow:AddDoor( door2 )
    gameshow:AddDoor( door3 )
    gameshow:AddDoor( door4 )
    local winner = gameshow:RandomiseWinner();

    
    ------------------------------------------------------------------
    --clear old doors
    ------------------------------------------------------------------
    game.Workspace.SetDoors['1'].Door:Remove()
    game.Workspace.SetDoors['5'].Door:Remove()


    ------------------------------------------------------------------
    --camera
    ------------------------------------------------------------------

    demonstration:CameraFocus('Doors_100_transition', nil, 30, nil, 2)
    wait(2 * demonstration.camera_focus_duration)
    demonstration:CameraFocus('Set_transition', true)
    wait()
    demonstration:CameraFocus('Set_3', nil, nil, nil)


    ------------------------------------------------------------------
    --here comes the maths
    ------------------------------------------------------------------

    textprompt:Prompt({
        "We are now going to delve into the maths of why switching is best..";
        "This will require a basic understanding of chance - more commonly known as probability.";
        "If you wish to stop the demonstration now, I would appreciate if you could fill out a feedback form!";
        "This game was created as part of my University degree!";
        "In the 'Socials' tab of this ROBLOX game, I have a link to the form in my twitter description.";
        "If you want to learn about the maths and fill out the form later, let's carry on!";
    })

    wait(2)


    local text2 = door2.model.Parent.billboard.BillboardGui.Frame.TextLabel;
    local text3 = door3.model.Parent.billboard.BillboardGui.Frame.TextLabel;
    local text4 = door4.model.Parent.billboard.BillboardGui.Frame.TextLabel;


    textprompt:Prompt({
        "We have 3 doors, so if we were to pick a door at random each door would have a probability of 1/3 of being picked.";
    })

    wait(0.5)

    text2.Text = '1/3';
    text3.Text = '1/3';
    text4.Text = '1/3';

    wait(0.5)

    textprompt:Prompt({
        "Behind these 3 doors, we have 1 car and 2 goats.";
    })
    gameshow:OpenDoors();
    textprompt:Prompt({
        "As each door has a probability of 1/3, this means we have 1/3 chance of picking the car and 2/3 chance of picking a goat.";
    })

    wait(0.5)

    if not door2.isCar then    text2.Text = '2/3'   end
    if not door3.isCar then    text3.Text = '2/3'   end
    if not door4.isCar then    text4.Text = '2/3'   end



    ------------------------------------------------------------------
    --transition back to 100 doors quickly to make a point
    ------------------------------------------------------------------

    textprompt:Prompt({
        "This may be clearer with 102 doors..";
    })
    gameshow:CloseDoors();

    ------------------------------------------------------------------
    --cameraa
    demonstration:CameraFocus('Set_transition')
    wait(2 * demonstration.camera_focus_duration)
    demonstration:CameraFocus('Doors_100_transition', true)
    wait()
    demonstration:CameraFocus('Doors_100', nil, 30, nil, 2)
    wait(2 * demonstration.camera_focus_duration)
    --
    wait(1)

    ------------------------------------------------------------------
    --gameshow for 100
    local gameshow_100 = gameshow_class.new();

    for i,DOOR in pairs(game.Workspace.Doors_100:GetChildren()) do 
        local door = door_class.new(DOOR, 'door' .. i)
        door:ClearPrizes();
        gameshow_100:AddDoor( door );
    end

    local winner = gameshow_100:RandomiseWinner();

    gameshow_100:OpenDoors();


    textprompt:Prompt({
        "There are 101 goats, and 1 car. There is a much higher probability of choosing a goat over choosing the car.";
        "We have a 101/102 probabilty of picking a goat. Only 1/102 probability of picking the car.";
        "In other words, there is less than 1% chance of picking the car on the first choice!";
    })

    gameshow_100:CloseDoors();

    wait(1)


    ------------------------------------------------------------------
    --back to the 3 doors set
    ------------------------------------------------------------------
    text2.Text = '1/3';
    text3.Text = '1/3';
    text4.Text = '1/3';

    demonstration:CameraFocus('Doors_100_transition', nil, 30, nil, 3)
    wait(4 * demonstration.camera_focus_duration)
    demonstration:CameraFocus('Set_transition', true)
    wait()
    demonstration:CameraFocus('Set_3', nil, nil, nil)
    ---

    wait(0.5)

    gameshow:CloseDoors();
    gameshow:RandomiseWinner();
    

    ------------------------------------------------------------------
    --methodical thinking
    ------------------------------------------------------------------

    textprompt:Prompt({
        "From playing the games yourself, you may have noticed a pattern.";
        "When you have the choice to stick or switch, you have the option of 2 doors.";
        "Behind one door is a goat, and behind one door is the car..";
        "Whichever door you selected, if you always switch you will get the opposite of what you originally picked.";
        "An example might help. Let's say you choose the middle door.."
    })

    door3:Select(true);

    local goat = gameshow:GetRandomGoat(door3);

    wait(1)
    goat:Open();
    wait(2)
    goat:Selectable(false)
    goat:Close();

    textprompt:Prompt({
        "After showing the other goat, we have 2 options left as normal. Let's peek what's behind them quickly.."
    })

    local other = door2;
    if other == goat then other = door4 end;

    door3:Open();
    other:Open();

    if door3.isCar then
        textprompt:Prompt({
            "We chose the car to begin with! If we switch, we would choose a goat.";
        })
    else
        textprompt:Prompt({
            "We chose a goat to begin with - if we switch, we would end up choosing the car!";
        })
    end

    textprompt:Prompt({
        "If we switch, we always end up picking the opposite of what we originally chose!";
        "When we pick a goat to start with, if we switch we will end up with the car.";
    })


    ------------------------------------------------------------------
    --proper probability innit
    ------------------------------------------------------------------


    gameshow:OpenDoors()
    if not door2.isCar then    text2.Text = '2/3'   end
    if not door3.isCar then    text3.Text = '2/3'   end
    if not door4.isCar then    text4.Text = '2/3'   end

    textprompt:Prompt({
        "The chance of picking a goat to start with is 2/3.";
        "But if we always switch, the chance of finishing on the car is 2/3!";
        "If we switch, we have 2/3 probability of winning the car and only 1/3 of choosing a goat.";
        "I hope this has explained well why switching is always the best strategy.";
    })
    wait(1)
    textprompt:Prompt({
        "This concludes the end of the demonstration - but before you go..";
        "This game was created as part of my University degree!";
        "I would really appreciate if you could fill out the feedback form found in my twitter description. My twitter is on the game page.";
        "You are welcome to keep playing to test out our theory! Thank you :)";
        "(PS - You can test your understanding on the form!)";
    })


    ------------------------------------------------------------------
    --finish; let user run it themselves
    ------------------------------------------------------------------


    goat:Selectable(true)
    door3:Select(false)
    text2.Text = '';
    text3.Text = '';
    text4.Text = '';

    while wait() do

        local win, choice = demonstration:SetDoors3(gameshow);

    end






end







function demonstration:Run()



    ------------------------------------------------------------------
    --setup camera
    ------------------------------------------------------------------
    camera.CameraType = 'Scriptable';
    camera.CFrame = cameras:WaitForChild('Set_wide').CFrame;


    ------------------------------------------------------------------
    --start prompt
    ------------------------------------------------------------------
    local welcome = ui_frames:WaitForChild('1_welcome');
    welcome.Visible = true;

    local start = false;
    welcome.start.Activated:Connect(function()
        start = true;
    end)

    while not start do wait() end
    welcome.Visible = false;


    ------------------------------------------------------------------
    --start the first section; introduction to the problem, let them try themselves.
    ------------------------------------------------------------------
    demonstration:Section1()

    ------------------------------------------------------------------
    --start the second section; introduce the 5-door version
    ------------------------------------------------------------------
    demonstration:Section2()

    ------------------------------------------------------------------
    --start the third section; move over to the big boi 100 doors
    ------------------------------------------------------------------
    wait(1) --for section 2 to finish animations
    demonstration:Section3()


    ------------------------------------------------------------------
    --4th section..
    ------------------------------------------------------------------
    wait(1)
    demonstration:Section4()


    

end














return demonstration