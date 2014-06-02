bullet = {
}
bullet.__index = bullet

function bullet.new(x, y, xSpeed, ySpeed, behaviour, visual)
	assert(behaviour ~= nil)
	visual = visual or behaviour
	assert(visual.draw ~= nil)
	assert(behaviour.updateMovement ~= nil)
	local b = setmetatable(
		{
			x = x,
			y = y,
			xSpeed = xSpeed,
			ySpeed = ySpeed,
			img = love.graphics.newImage("bullet.png"),
			aX = 0,
			aY = 0, -- anchor
			oX = 0, -- offset
			oY = 0,
			c = 0,
			moving = false,
			speed = 1.5
		},
		bullet
		)
	b.aX = b.x
	b.aY = b.y
	b.behaviour = setmetatable(behaviour, b)
	b.visual = setmetatable(visual, b)
	return b

end

--[[function bullet.__call(x, y, xSpeed, ySpeed, behaviour)
	assert(behaviour ~= nil)
	local b = setmetatable(
		{
			x = x,
			y = y,
			xSpeed = xSpeed,
			ySpeed = ySpeed,
			img = love.graphics.newImage("bullet.png"),
			aX = 0,
			aY = 0, -- anchor
			oX = 0, -- offset
			oY = 0,
			speed = 2,
			c = 0,
			moving = false,
			
		},
		{
			__index = behaviour
		}
		
		)
	b.aX = b.x
	b.aY = b.y
	return b
end]]

function bullet:update(delta)
	if self.moving == false then
		self.x = self.x + self.xSpeed
		self.y = self.y + self.ySpeed
		self.moving = true
	end
	self.behaviour:updateMovement(self, delta)
end

function bullet:draw()
	--love.graphics.draw(self.img, self.aX + self.oX, self.aY + self.oY)
	self.visual:draw(self)
end

setmetatable(bullet, { __call = function(_, ...) return bullet.new(...) end })