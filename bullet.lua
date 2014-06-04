bullet = {
}
bullet.__index = bullet

function bullet.new(x, y, xSpeed, ySpeed, move, visual)
	assert(move ~= nil)
	assert(visual.draw ~= nil)
	local b = setmetatable(
		{
			x = x,
			y = y,
			xSpeed = xSpeed,
			ySpeed = ySpeed,
			aX = 0,
			aY = 0, -- anchor
			oX = 0, -- offset
			oY = 0,
			c = 0,
			moving = false,
			speed = 1.5,
			move = move,
			visual = visual
		},
		bullet
		)
	b.aX = b.x
	b.aY = b.y
	return b

end

function bullet:update(delta)
	if self.moving == false then
		self.x = self.x + self.xSpeed
		self.y = self.y + self.ySpeed
		self.moving = true
	end
	self.move(self, delta)
end

function bullet:draw()
	self.visual:draw(self)
end

setmetatable(bullet, { __call = function(_, ...) return bullet.new(...) end })