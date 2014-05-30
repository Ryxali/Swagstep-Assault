require "gamedata"
require "character"
require "enemy"
World = {
	background = love.graphics.newImage("world_bg.jpg"),
	character = Character,
	bullets = {
		bullet = {},
		size = 0
	},
	enemies = {
		enemy = {},
		size = 0,
		enemyTimer = 3

	}
}

function World.draw(this)
	love.graphics.draw(this.background, 0, 0)
	this.character:draw()
	for i = 1, this.bullets.size, 1 do
		if this.bullets.bullet[i] ~= nil then
			bullet.draw(this.bullets.bullet[i])
		end
	end
	for i = 1, this.enemies.size, 1 do
		if this.enemies.enemy[i] ~= nil then
			enemy.draw(this.enemies.enemy[i])
		end
	end
end

function World.update(this, delta)
	this.character:update(delta, this.bullets)
	for i = 1, this.bullets.size, 1 do
		if this.bullets.bullet[i] ~= nil then
			bullet.update(this.bullets.bullet[i], delta)
		end
	end
	for i = 1, this.enemies.size, 1 do
		if this.enemies.enemy[i] ~= nil then
			enemy.update(this.enemies.enemy[i], delta)
		end
	end
	if this.enemies.enemyTimer < GameData.timeElapsed then
		this.enemies.enemyTimer = this.enemies.enemyTimer + 1.4
		this.enemies.size = this.enemies.size + 1
		this.enemies.enemy[this.enemies.size] = enemy.create(300, 100)
	end
end

function World.load(this)
	this.character:load()
end