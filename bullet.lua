bullet = {
	--[[x = 0,
	y = 0,
	xSpeed = 0,
	ySpeed = 0,
	img = love.graphics.newImage("bullet.png"),
	aX = 0,
	aY = 0,
	oX = 0,
	oY = 0,
	speed = 2,
	moving = false]]
}

function bullet.create(x, y, xSpeed, ySpeed)
	local b = {
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
		moving = false
	}
	b.aX = b.x
	b.aY = b.y
	return b
end
function bullet:new(x, y, xSpeed, ySpeed, behaviour)
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

end

function bullet.update(this, delta)
	if this.moving == false then
		this.x = this.x + this.xSpeed
		this.y = this.y + this.ySpeed
		this.moving = true
	end
	bullet.updateMovement(this, delta)
end

function bullet.draw(this)
	love.graphics.draw(this.img, this.aX + this.oX, this.aY + this.oY)
end

function bullet.updateMovement(this, delta)
	if this.moving == true then
		this.c = this.c + delta*this.speed
		local length = math.sqrt((this.x-this.aX)^2+(this.y-this.aY)^2)
		local xN = (this.x-this.aX) / length
		local yN = (this.y-this.aY) / length -- directional vector
		

		local factor = -(4*this.c^2*((1-this.c)/2)^2 - this.c) ---(this.c^2 - 2*this.c)
		this.oX = xN * factor*length
		this.oY = yN * (factor )*length  - math.cos(this.c*math.pi*2-math.pi/2)*8--math.cos(this.c*math.pi*2-math.pi/2) * length


		if this.c > 1 then
			this.c = 0
			this.moving = false
			this.aX = this.x
			this.aY = this.y
			this.oX = 0
			this.oY = 0
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