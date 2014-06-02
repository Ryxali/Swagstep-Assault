require "gamedata"
require "vector"
require "basicGun"
require "triGun"
Character = 
	setmetatable({},
 	{
 		__call = function()
 			local c = {
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
 			c = setmetatable(c, {__index = Character})
 			return c
 		end
 	})
 
Character.__index = Character

function Character:resolveMovement(action)
	if action == "right" then
		self.imgMovingX = true
		self.x = self.x + 64
	elseif action == "left" then
		self.imgMovingX = true
		self.x = self.x - 64
	elseif action== "up" then
		self.imgMovingY = true
		self.y = self.y - 64
	elseif action == "down" then
		self.imgMovingY = true
		self.y = self.y + 64
	else -- add "go power rangers"
		GameData:addError("invalid movement input: " .. action, 3.5)
		GameData:addError("Proper usage: 'go ' + 'left'/'right'/'up'/'down' ", 4.5)
	end
end

function Character:resolveAction(action, bullets)
	offset = string.find(action, " ")
	if offset == nil then
		offset = 0
	end
	command = string.sub(action, 0, offset-1)
	if command == "go" then
		self:resolveMovement(string.sub(action, offset+1, -1))
	elseif command == "fire" then
		self.weapon:fire(bullets, self.x, self.y)
	elseif command == "help" then
		GameData:addError("To move type: 'go ' + 'right'/'left'/'up'/'down'", 6)
	else
		GameData:addError("Invalid command. Type 'help' for list of commands", 4)
	end
	

end

function Character:updateMovement(delta)
	if self.imgMovingX == true then
		self.imgCX = self.imgCX + delta*self.imgSpeedMul
		self.imgX = -(self.imgCX^2-self.imgCX*2)*(self.x-self.imgAX)
		if self.imgCX  > 1 then
			self.imgCX = 0
			self.imgMovingX = false
			self.imgX = 0
			self.imgAX = self.x
		end

	end
	if self.imgMovingY == true then
		self.imgCY = self.imgCY + delta*self.imgSpeedMul
		--self.imgY = -(self.imgCY^3-self.imgCY*2)*(self.y-self.imgAY)
		local exp = (self.y-self.imgAY)
		--self.imgY = -((math.cos(self.imgCY)*exp))
		self.imgY = -(((math.cos(self.imgCY*math.pi*2)/2-1/2)-self.imgCY)*exp)
		if self.imgCY > 1 then
			self.imgCY = 0
			self.imgMovingY = false
			self.imgY = 0
			self.imgAY = self.y
		end

	end
end

function Character:update(delta, bullets)
	for i = 1, GameData.Event.actions.numActions, 1 do
		if GameData.Event.actions.action[i].code == "input" then
			self:resolveAction(GameData.Event.actions.action[i].data, bullets)
		end
	end
	self.updateMovement(self, delta)
end

function Character:draw()
	if self.imgMovingX then
		love.graphics.draw(self.imgSide, self.imgAX + self.imgX, self.imgAY + self.imgY)
	elseif self.imgMovingY then
		love.graphics.draw(self.imgShift, self.imgAX + self.imgX, self.imgAY + self.imgY)
	else
		love.graphics.draw(self.img, self.imgAX + self.imgX, self.imgAY + self.imgY)
	end
end

function Character:load()
	
end