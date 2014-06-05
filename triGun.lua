require "bullet"
require "Vector"
require "movementPatterns"

require "shaderImage"

triGun = {}

function triGun.fire(this, bullets, x, y)
	local v0 = Vector(96, 16)
	local v1 = Vector(96, -16)
	v0:normalize()
	v1:normalize()
	v0 = v0 * 96
	v1 = v1 * 96
	bullets:add(bullet(x, y+32, v0.x, v0.y, movePatterns.randomFunction(), shaderImage.spiralShader))
	bullets:add(bullet(x, y, 96, 0, movePatterns.randomFunction(), shaderImage.stretchingShader))
	bullets:add(bullet(x, y-32, v1.x, v1.y, movePatterns.randomFunction(), shaderImage.spiralShader))
end
