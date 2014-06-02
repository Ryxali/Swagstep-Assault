require "Vector"
hitbox = {
}
hitbox.__index = hitbox
function hitbox:new(x, y, radius)
	assert(radius ~! nil)
	assert(radius > 0)
	return setmetatable({pos = Vector(x, y), radius = radius }, hitbox)
end

function hitbox.intersects(box0, box1)
	local dist = Vector.distance(box0.pos, box1.pos)
	return dist <= box0.radius or dist <= box1.radius
end
 
function hitbox:contains(box)
	local dist = Vector.distance(this.pos, box.pos)
	return dist+box.radius <= this.radius
end

setmetatable(hitbox, { __call = function(_, ...) return hitbox.new(...) end })