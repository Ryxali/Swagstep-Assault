require "GameData"
require "hitbox"

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
			visual = visual,
			hitbox = hitbox(x, y, 32),
			dying = false
		},
		bullet
		)
	b.aX = b.x
	b.aY = b.y
	return b

end

function bullet:update(delta, foes)
	if self.moving == false then
		if self.x < 0-100 or GameData.WINDOW_SIZE.x+100 < self.x or self.y < 0-100 or GameData.WINDOW_SIZE.y+100 < self.y then
			self.dying = true
			return
		end
		self.x = self.x + self.xSpeed
		self.y = self.y + self.ySpeed
		self.moving = true
	end
	self.move(self, delta)
	self.hitbox.pos.x = self.aX + self.oX
	self.hitbox.pos.y = self.aY + self.oY
	while foes:next() do
		if foes.iterator.hitbox:intersects(self.hitbox) then
			foes.iterator.dying = true
			self.dying = true
		end
	end
end

function bullet:draw()
	self.visual:draw(self)
end

setmetatable(bullet, { __call = function(_, ...) return bullet.new(...) end })