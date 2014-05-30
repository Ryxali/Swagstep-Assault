require "bullet"
require "wobbleBullet"

triGun = {}

function triGun.fire(this, bullets, x, y)
	bullets.size = bullets.size + 1
	bullets.bullet[bullets.size] = bullet:new(x, y, 96, 0, wobbleBullet)
	bullets.size = bullets.size + 1
	bullets.bullet[bullets.size] = bullet:new(x, y+32, 96, 16, wobbleBullet)
	bullets.size = bullets.size + 1
	bullets.bullet[bullets.size] = bullet:new(x, y-32, 96, -16, wobbleBullet)
end
