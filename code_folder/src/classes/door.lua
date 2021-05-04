--[[ door



METHODS

	door.new()
		constructor


VALUES

	class
		the name of the class


TYPES


MISC




--]]

local tween = require(game:WaitForChild('ReplicatedStorage'):WaitForChild('Libraries'):WaitForChild('tween'));
local audio = require(game:WaitForChild('ReplicatedStorage'):WaitForChild('Libraries'):WaitForChild('audio'))

local volume = 0.1;


local colors = {
	green = Color3.fromRGB(30, 200, 30);
	light_green = Color3.fromRGB(40, 150, 40);
	red = Color3.fromRGB(200, 30, 30);
}


local door = {}
door.__index = door

function door.new(door_model, door_name)

--///////////////////////////////////////////////////////
	local self = {};
	self.class = "door" -- Class Name
	setmetatable(self, door)
--///////////////////////////////////////////////////////

	self.model = door_model;
	self.name = door_name or self.model.Name;

	self.selectable = true;

	self.isCar = false;
	
	self.open = false;

	self.door = {
		left = self.model.DoorLeft;
		right = self.model.DoorRight;
		hitbox = self.model.DoorHitbox;
		proportions = self.model.DoorLeft.Size;
		left_position = self.model.DoorLeft.Position;
		right_position = self.model.DoorRight.Position;
	};
	self.frame = {
		top = self.model.FrameTop;
		left = self.model.FrameLeft;
		right = self.model.FrameRight;
	};

	self.animation_duration = 0.35;



	self:ClearPrizes();

	return self

end




local function modelVisible(model, visible)
	for _,OBJ in pairs(model:GetDescendants()) do 
		if OBJ:IsA('BasePart') or OBJ:IsA('MeshPart') then
			OBJ.Transparency =  0 and visible or 1;
		end
	end
end

function door:ClearPrizes()
	modelVisible(self.model.Car, false);
	modelVisible(self.model.Goat, false);
end


function door:UseCurrentPosition()
	self.door.left_position = self.door.left.Position;
	self.door.right_position = self.door.right.Position;
end

function door:UsePositions(posL, posR)
	self.door.left_position = posL;
	self.door.right_position = posR;
end



function door:Open(speedy, mute)
	--print('open door', self.name)

	if self.open then return end
	self.open = true;

	modelVisible(self.model.Car, self.isCar);
	modelVisible(self.model.Goat, not self.isCar);


	local duration = self.animation_duration;
	if speedy then duration = 0.05 end
	
	--open animation
	tween.tween(self.door.left, 'Size', Vector3.new(0, self.door.proportions.Y, self.door.proportions.Z), duration);
	tween.tween(self.door.left, 'Position', self.frame.left.Position, duration);

	tween.tween(self.door.right, 'Size', Vector3.new(0, self.door.proportions.Y, self.door.proportions.Z), duration);
	tween.tween(self.door.right, 'Position', self.frame.right.Position, duration);
	

	if not mute then
		audio:PlaySound('woosh_1', volume)
		if self.isCar then
			audio:PlaySound('ding_1', volume)
		end
	end

end


function door:Close(speedy, mute)

	if not self.open then return end
	self.open = false;


	local duration = self.animation_duration;
	if speedy then duration = 0.05 end

	--close animation

	tween.tween(self.door.left, 'Size', Vector3.new(self.door.proportions.X, self.door.proportions.Y, self.door.proportions.Z), duration);
	tween.tween(self.door.left, 'Position', self.door.left_position, duration);

	tween.tween(self.door.right, 'Size', Vector3.new(self.door.proportions.X, self.door.proportions.Y, self.door.proportions.Z), duration);
	tween.tween(self.door.right, 'Position', self.door.right_position, duration);


	coroutine.resume(coroutine.create(function()
		if not speedy then
			wait(duration)
			self:ClearPrizes();
		end
	end))


	if not mute then
		audio:PlaySound('woosh_1', volume)
	end

end




function door:IsCar()
	self.isCar = true;
end

function door:IsGoat()
	self.isCar = false;
end




function door:Highlight(visible)
	self.door.hitbox.selected.Visible = visible;
end

function door:Select(select, select_light)
	if select then
		self:Color(colors.green)
	elseif select_light then
		self:Color(colors.light_green)
	else
		self:Color()
	end

	if select then
		audio:PlaySound('button_click', 0.1)
	end
end

function door:Selectable(selectable)
	if selectable == self.selectable then return end;

	if selectable then
		self:Color()
	else
		self:Color(colors.red)
	end
	self.selectable = selectable;
end

function door:Color(color)
	color = color or Color3.fromRGB(255, 255, 255)

	tween.tween(self.door.left, 'Color', color, self.animation_duration);
	tween.tween(self.door.right, 'Color', color, self.animation_duration);

	for _,OBJ in pairs(self.model:GetChildren()) do 
		if OBJ.Name == 'trim' then
			tween.tween(OBJ, 'Color', color, self.animation_duration);
		end
	end

end


return door