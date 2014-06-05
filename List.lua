List = {
	
}
List.__index = List

function List.new()
	return setmetatable({items = {}, size = 0, iterator = nil, iteratorAt = 0}, List)
end

function List:add(item)
	self.size = self.size + 1
	self.items[self.size] = item
end

function List:remove(index)
	assert(index ~= nil)
	assert(index > 0 and index <= self.size)
	local function float_down(index)
		if index >= self.size then
			return self.items[index]
		end
		local t = self.items[index]
		self.items[index] = float_down(index+1)
		return t
	end
	float_down(index)
	if self.iteratorAt >= index then
		self.iteratorAt = self.iteratorAt - 1
	end

	self.size = self.size - 1
end

function List:get(index)
	return self.items[index]
end

function List:next()
	self.iteratorAt = self.iteratorAt + 1
	self.iterator = self.items[self.iteratorAt]
	if self.iteratorAt <= self.size then
		return true
	else
		self.iteratorAt = 0
		return false
	end
end

function List:resetIteration()
	self.iteratorAt = 0
end

setmetatable(List, { __call = function(_, ...) return List.new(...) end })