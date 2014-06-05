require "hitbox"
enemy = {
	
}
enemy.__index = enemy

function enemy.new(x, y)
	local e = 
		setmetatable(
		{
			x = x,
			y = y,
			img = love.graphics.newImage("enemy.png"),
			hitbox = hitbox(x, y, 32),
			dying = false
		},
		enemy)
	return e
end

function enemy:update(delta)
	self.x = self.x - 100*delta
	self.hitbox.pos.x = self.x
	self.hitbox.pos.y = self.y
end

function enemy:draw()
	love.graphics.draw(self.img, self.x, self.y)
end

setmetatable(enemy, { __call = function(_, ...) return enemy.new(...) end })