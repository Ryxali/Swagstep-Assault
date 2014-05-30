require("bullet")
wobbleBullet = {
	speed = 2
}
--setmetatable(bullet, wobbleBullet)

--[[function wobbleBullet:new(x, y, xSpeed, ySpeed)
	local obj = setmetatable({}, {__index = bullet:new()})
	setmetatable(obj, bullet:new(x, y, xSpeed, ySpeed))
	-- self.__index = self
	return obj
end]]

function wobbleBullet:update(delta)
	if this.moving == false then
		this.x = this.x + this.xSpeed
		this.y = this.y + this.ySpeed
		this.moving = true
	end
	self.updateMovement(this, delta)
end

function wobbleBullet:draw()
	love.graphics.draw(self.img, self.aX + self.oX, self.aY + self.oY)
end

function wobbleBullet:updateMovement(delta)
	if self.moving == true then
		self.c = self.c + delta*self.speed
		local length = math.sqrt((self.x-self.aX)^2+(self.y-self.aY)^2)
		local xN = (self.x-self.aX) / length
		local yN = (self.y-self.aY) / length -- directional vector
		

		local factor = -(4*self.c^2*((1-self.c)/2)^2 - self.c) ---(self.c^2 - 2*self.c)
		self.oX = xN * factor*length
		self.oY = yN * (factor )*length  - math.cos(self.c*math.pi*2-math.pi/2)*8--math.cos(self.c*math.pi*2-math.pi/2) * length


		if self.c > 1 then
			self.c = 0
			self.moving = false
			self.aX = self.x
			self.aY = self.y
			self.oX = 0
			self.oY = 0
		end
	end

	--[[if this.imgMovingX == true then
		this.imgCX = this.imgCX + delta*this.imgSpeedMul
		this.imgX = -(this.imgCX^2-this.imgCX*2)*(this.x-this.imgAX)
		if this.imgCX  > 1 then
			this.imgCX = 0
			this.imgMovingX = false
			this.imgX = 0
			this.imgAX = this.x
		end

	end
	if this.imgMovingY == true then
		this.imgCY = this.imgCY + delta*this.imgSpeedMul
		--this.imgY = -(this.imgCY^3-this.imgCY*2)*(this.y-this.imgAY)
		local exp = (this.y-this.imgAY)
		--this.imgY = -((math.cos(this.imgCY)*exp))
		this.imgY = -(((math.cos(this.imgCY*math.pi*2)/2-1/2)-this.imgCY)*exp)
		if this.imgCY > 1 then
			this.imgCY = 0
			this.imgMovingY = false
			this.imgY = 0
			this.imgAY = this.y
		end

	end]]
end