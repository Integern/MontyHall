local tween = {}

--[[
    CONSTANTS
]]
tween.service = game:GetService("TweenService")



--[[
    FUNCTIONS
]]
tween.tween = function(object, variable, value, duration, easing_style, easing_direction)
    duration = duration or 1;
    easing_style = easing_style or Enum.EasingStyle.Quad
    easing_direction = easing_direction or Enum.EasingDirection.Out

    local TWEEN_INFO = TweenInfo.new(duration, easing_style, easing_direction);
    local TWEEN_GOAL = { [variable] = value };
    local TWEEN = tween.service:Create(object, TWEEN_INFO, TWEEN_GOAL)

    TWEEN:Play()

    return TWEEN
end






tween.tweenmodel = function(model, CF, duration, easing_style, easing_direction)
    duration = duration or 1;
    easing_style = easing_style or Enum.EasingStyle.Quad
    easing_direction = easing_direction or Enum.EasingDirection.Out

    -- https://devforum.roblox.com/t/brief-introduction-to-tweening-models/178948


    local info = TweenInfo.new(duration, easing_style, easing_direction)

    local function tweenModel(model, CF)
        local CFrameValue = Instance.new("CFrameValue")
        CFrameValue.Value = model:GetPrimaryPartCFrame()

        CFrameValue:GetPropertyChangedSignal("Value"):connect(function()
            model:SetPrimaryPartCFrame(CFrameValue.Value)
        end)
        
        local tween = tween.service:Create(CFrameValue, info, { Value = CF })
        tween:Play()
        
        tween.Completed:connect(function()
            CFrameValue:Destroy()
        end)
    end

    tweenModel(model, CF);



end



return tween