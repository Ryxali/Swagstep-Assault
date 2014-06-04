require "bullet"
require "movementPatterns"

basicGun = {
	
}

function basicGun.fire(this, bullets, x, y)
	bullets.size = bullets.size + 1
	bullets.bullet[bullets.size] = bullet:new(x, y, 128, 0, bullet)
end
