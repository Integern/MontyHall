local audio = {}


local musicID = 'rbxassetid://6734905640';
local clappingID = 'rbxassetid://6734904847';


local library = {
    win = 'rbxassetid://1508146270';
    thruster = 'rbxassetid://557573666';
    firework_bang = 'rbxassetid://4583102108';
    firework_launch_1 = 'rbxassetid://3114115697';
    firework_launch_2 = 'rbxassetid://3114115656';
    firework_launch_3 = 'rbxassetid://3114114700';
    panel_remove = 'rbxassetid://1418336775';
    level_up_long = 'rbxassetid://3122540968';
    level_up = 'rbxassetid://1418337269';
    positive = 'rbxassetid://3114117950';
    equip_simple = 'rbxassetid://3114117052';
    grenade_pin = 'rbxassetid://3114116999';
    rocket_launch = 'rbxassetid://2977770410';
    fuse = 'rbxassetid://2977769970';
    beep = 'rbxassetid://2977764987';
    error = 'rbxassetid://1388726556';
    coins = 'rbxassetid://1418337414';
    oof = 'rbxassetid://1611430326';

    bricks_1 = 'rbxassetid://3114117924';
    bricks_2 = 'rbxassetid://3114117862';
    bricks_3 = 'rbxassetid://3114117163';
    bricks_4 = 'rbxassetid://3114117085';
    bricks_5 = 'rbxassetid://3114116009';
    lego_1 = 'rbxassetid://2978402881';
    lego_2 = 'rbxassetid://2978402672';
    bricks_rolling = 'rbxassetid://3114117128';

    explosion_long = 'rbxassetid://3114115916';
    explosion_boom = 'rbxassetid://3114114575';
    explosion_claymore = 'rbxassetid://3114114537';
    explosion = 'rbxassetid://2977769727';
    explosion_big = 'rbxassetid://2977764823';

    mouse_1 = 'rbxassetid://2977770146';
    mouse_click_1 = 'rbxassetid://2977769526';
    mouse_click_2 = 'rbxassetid://1418325575';

    button_click = 'rbxassetid://1418336775';
    button_hover = 'rbxassetid://1418336934';

    song_jerry_five = 'rbxassetid://2383364201';

    woosh_portal = 'rbxassetid://2769872789';
    woosh_cartoon = 'rbxassetid://2588287795';
    woosh_1 = 'rbxassetid://4255432837';
    woosh_2 = 'rbxassetid://3076211681';
    woosh_3 = 'rbxassetid://138097048';

    slam_1 = 'rbxassetid://1843191047';

    impact_1 = 'rbxassetid://390913541';

    ding_1 = 'rbxassetid://138222365';
    
    
}




local function createSound(id, name)
    local sound = Instance.new('Sound')
    sound.Parent = game.Workspace;
    sound.SoundId = id;
    sound.Name = name or 'unnamed_sound'

    return sound;
end



function audio:PlaySound(sound_name, volume) --from library
    volume = volume or 0.2;

    if not library[sound_name] then error('No sound stored under name ' .. sound_name) end

    local sound = createSound(library[sound_name], sound_name);
    sound.Volume = volume;

    coroutine.resume(coroutine.create(function()
    
        sound:Play()

        while sound.IsPlaying do wait() end

        wait() sound:Remove()
    
    end))

end


function audio:Music(volume)

    local sound = createSound(musicID);
    sound.Volume = volume;
    sound.Looped = true;
    sound.Name = 'music'

    sound:Play()

end

function audio:Clapping(volume)

    local sound = createSound(clappingID);
    sound.Name = 'clapping'
    sound.Volume = volume;

    local length = 4;
    local fade_length = 2;
    


    coroutine.resume(coroutine.create(function()

        sound:Play()
        wait(length)

        local T = tick()
        local T_END = T + fade_length;
        while wait() do
            local T_NOW = tick();

            local ratio = 1 - (T_NOW - T)/(T_END - T);

            if ratio < 0 then
                break
            else
                sound.Volume = volume * ratio;
            end
        end

        wait()
        sound:Remove();

    end))



end








return audio