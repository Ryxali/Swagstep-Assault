require "bullet"
require "Vector"
require "movementPatterns"

require "spiralBullet"
require "stretchingBullet"

triGun = {}

function triGun.fire(this, bullets, x, y)
	local v0 = Vector(96, 16)
	local v1 = Vector(96, -16)
	v0:normalize()
	v1:normalize()
	v0 = v0 * 96
	v1 = v1 * 96
	bullets.size = bullets.size + 1
	bullets.bullet[bullets.size] = bullet(x, y+32, v0.x, v0.y, movePatterns.surgeFunction, stretchingBullet)
	bullets.size = bullets.size + 1
	bullets.bullet[bullets.size] = bullet(x, y, 96, 0, movePatterns.wobbleFunction, spiralBullet)
	bullets.size = bullets.size + 1
	bullets.bullet[bullets.size] = bullet(x, y-32, v1.x, v1.y, movePatterns.smoothFunction, stretchingBullet)
end
