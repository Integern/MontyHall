--[[ GAMESHOW



METHODS

	GAMESHOW.new()
		constructor


VALUES

	class
		the name of the class


TYPES


MISC




--]]


local audio = require(game:WaitForChild('ReplicatedStorage'):WaitForChild('Libraries'):WaitForChild('audio'))


local GAMESHOW = {}
GAMESHOW.__index = GAMESHOW

function GAMESHOW.new()

--///////////////////////////////////////////////////////
	local self = {};
	self.class = "GAMESHOW" -- Class Name
	setmetatable(self, GAMESHOW)
--///////////////////////////////////////////////////////


	self.doors = {};
	self.winner = { position = -1, door = false };


	return self

end




function GAMESHOW:GetDoors()
	return self.doors;
end

function GAMESHOW:GetDoor(door_position)
	return self.doors[door_position]
end

function GAMESHOW:CountDoors()
	return #self.doors;
end

function GAMESHOW:AddDoor(door_class)
	table.insert(self.doors, door_class)
	door_class:ClearPrizes();
end





function GAMESHOW:OpenDoor(door_position)
	self.doors[door_position]:Open()
end

function GAMESHOW:OpenDoors(speedy)
	for i,DOOR in pairs(self.doors) do
		DOOR:Open(speedy, i>3)
	end
end


function GAMESHOW:CloseDoor(door_position)
	self.doors[door_position]:Close()
end

function GAMESHOW:CloseDoors(speedy)
	for i,DOOR in pairs(self.doors) do
		DOOR:Close(speedy, i>3)
	end
end






function GAMESHOW:GetRandomGoat(blacklist_door)

	for i = 1, 1000 do
		local random_position = math.random(1, self:CountDoors())
		local door = self.doors[random_position]

		if not door.isCar and door ~= blacklist_door then
			return door;
		end
	end

	error('No goat probably.')

end

function GAMESHOW:GetNearlyAllGoats(chosen_door)

	local goat_count = self:CountDoors() - 2;



	local blacklist;
	if chosen_door.isCar then
		blacklist = { chosen_door, self:GetRandomGoat(chosen_door) }
	else
		blacklist = { self.winner.door, chosen_door }
	end



	local goat_list = {};
	for _,DOOR in pairs(self.doors) do
		
		local blacklisted = false;
		for _,BLACKITEM in pairs(blacklist) do
			if BLACKITEM == DOOR then
				blacklisted = true;
				break;
			end
		end

		if blacklisted == false then
			table.insert(goat_list, DOOR)
		end
	end


	return goat_list;

end




function GAMESHOW:RandomiseWinner()
	self.winner.position = math.random(1, self:CountDoors())
	self.winner.door = self.doors[self.winner.position]

	for _,DOOR in pairs(self.doors) do 
		if DOOR == self.winner.door then
			DOOR:IsCar()
		else
			DOOR:IsGoat()
		end
	end

	return self.winner
end


return GAMESHOW