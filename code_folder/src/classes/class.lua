--[[ CLASS



METHODS

	CLASS.new()
		constructor


VALUES

	class
		the name of the class


TYPES


MISC




--]]


local CLASS = {}
CLASS.__index = CLASS

function CLASS.new()

--///////////////////////////////////////////////////////
	local inherit_class = CLASS;
	local self = {}; --inherit_class.new();
	self.class = "CLASS" -- Class Name
	setmetatable(CLASS, inherit_class)
	--setmetatable(self, CLASS)
--///////////////////////////////////////////////////////




	return self

end


return CLASS