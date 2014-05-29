vector = {}

function vector.create(x, y)
	local vec = {x = x, y = y}
	return vec
end

function vector.normalized(v)
	local length = vector.length(v)
	local vec = {x = 0, y = 0}
	v.x = v.x/length
	v.y = v.y/length
	return v
end

function vector.length(v)
	return math.sqrt(v.x*v.x + v.y*v.y)
end
