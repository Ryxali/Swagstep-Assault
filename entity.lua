entity = setmetatable( {},
	{
		__call = function(behaviour, visual)
			local e = {
				behaviour = behaviour,
				visual = visual
			}
			e = setmetatable(e, {__index = entity})
			return e
		end
	})

entity.__index = entity

function entity:updateBehaviour(delta)
	if behaviour ~= nil then
		behaviour:update(delta)
	end
end

function entity:draw()
	if visual ~= nil then
		visual:draw()
	end
end