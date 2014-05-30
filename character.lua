require "gamedata"
require "vector"
require "basicGun"
require "triGun"
Character = {
	x = 0,
	y = 0,
	img = love.graphics.newImage("C_def.png"),
	imgSide = love.graphics.newImage("C_side.png"),
	imgShift = love.graphics.newImage("C_shift.png"),
	imgAX = 0, -- image anchor for animated movement
	imgAY = 0, 
	imgX = 0, 
	imgY = 0,
	imgCX = 0, -- image curve x
	imgCY = 0,
	imgSpeedMul = 1.5,
	imgMovingX = false,
	imgMovingY = false,
	imgSpeed = 100,
	weapon = triGun
}

local function resolveMovement(character, action)
	if action == "right" then
		character.imgMovingX = true
		character.x = character.x + 64
	elseif action == "left" then
		character.imgMovingX = true
		character.x = character.x - 64
	elseif action== "up" then
		character.imgMovingY = true
		character.y = character.y - 64
	elseif action == "down" then
		character.imgMovingY = true
		character.y = character.y + 64
	else -- add "go power rangers"
		GameData:addError("invalid movement input: " .. action, 3.5)
		GameData:addError("Proper usage: 'go ' + 'left'/'right'/'up'/'down' ", 4.5)
	end
end

local function resolveAction(character, action, bullets)
	offset = string.find(action, " ")
	if offset == nil then
		offset = 0
	end
	command = string.sub(action, 0, offset-1)
	if command == "go" then
		resolveMovement(character, string.sub(action, offset+1, -1))
	elseif command == "fire" then
		character.weapon:fire(bullets, character.x, character.y)
	elseif command == "help" then
		GameData:addError("To move type: 'go ' + 'right'/'left'/'up'/'down'", 6)
	else
		GameData:addError("Invalid command. Type 'help' for list of commands", 4)
	end
	

end

function Character.updateMovement(this, delta)
	if this.imgMovingX == true then
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

	end
end

function Character.update(this, delta, bullets)
	for i = 1, GameData.Event.actions.numActions, 1 do
		if GameData.Event.actions.action[i].code == "input" then
			resolveAction(this, GameData.Event.actions.action[i].data, bullets)
		end
	end
	this.updateMovement(this, delta)
end

function Character.draw(this)
	if this.imgMovingX then
		love.graphics.draw(this.imgSide, this.imgAX + this.imgX, this.imgAY + this.imgY)
	elseif this.imgMovingY then
		love.graphics.draw(this.imgShift, this.imgAX + this.imgX, this.imgAY + this.imgY)
	else
		love.graphics.draw(this.img, this.imgAX + this.imgX, this.imgAY + this.imgY)
	end
end

function Character.load(this)
	
end