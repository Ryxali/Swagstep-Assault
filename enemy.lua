require "entity"

enemy = setmetatable({},
	{
		__call = function(x, y)
			local e = setmetatable({}, entity())
		end
	})
function enemy.create(x, y)
	local e = {
		x = x,
		y = y,
		img = love.graphics.newImage("enemy.png")
	}
	return e
end

function enemy.update(this, delta)
	this.x = this.x - 100*delta
end

function enemy.draw(this)
	love.graphics.draw(this.img, this.x, this.y)
end