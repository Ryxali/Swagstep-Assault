movePatterns = {
	
}


function movePatterns.wobbleFunction(object, delta)
	if object.moving == true then
		object.c = object.c + delta*object.speed
		local length = math.sqrt((object.x-object.aX)^2+(object.y-object.aY)^2)
		local xN = (object.x-object.aX) / length
		local yN = (object.y-object.aY) / length -- directional vector
		

		local factor = (4*object.c^2*((1-object.c)/2)^2 + object.c) ---(object.c^2 - 2*object.c)
		object.oX = xN * factor*length
		object.oY = yN * (factor )*length - math.cos(object.c*math.pi*2-math.pi/2)*8-- - math.cos(object.c*math.pi*2-math.pi/2)*8--math.cos(object.c*math.pi*2-math.pi/2) * length


		if object.c > 1 then
			object.c = 0
			object.moving = false
			object.aX = object.x
			object.aY = object.y
			object.oX = 0
			object.oY = 0
		end
	end
end

function movePatterns.smoothFunction(object, delta)
	if object.moving == true then
		object.c = object.c + delta*object.speed
		local length = math.sqrt((object.x-object.aX)^2+(object.y-object.aY)^2)
		local xN = (object.x-object.aX) / length
		local yN = (object.y-object.aY) / length -- directional vector
		

		local factor = -math.cos(math.cos((1-object.c)/2*math.pi)*math.pi)/2 + 0.5 ---(object.c^2 - 2*object.c)
		object.oX = xN * factor*length
		object.oY = yN * factor*length-- - math.cos(object.c*math.pi*2-math.pi/2)*8--math.cos(object.c*math.pi*2-math.pi/2) * length


		if object.c > 1 then
			object.c = 0
			object.moving = false
			object.aX = object.x
			object.aY = object.y
			object.oX = 0
			object.oY = 0
		end
	end
end

function movePatterns.surgeFunction(object, delta)
	if object.moving == true then
		object.c = object.c + delta*object.speed
		local length = math.sqrt((object.x-object.aX)^2+(object.y-object.aY)^2)
		local xN = (object.x-object.aX) / length
		local yN = (object.y-object.aY) / length -- directional vector
		

		local factor = -math.cos(math.cos((1-math.sqrt(object.c))/2*math.pi)*math.pi)/2 + 0.5 ---(object.c^2 - 2*object.c)
		object.oX = xN * factor*length
		object.oY = yN * factor*length-- - math.cos(object.c*math.pi*2-math.pi/2)*8--math.cos(object.c*math.pi*2-math.pi/2) * length


		if object.c > 1 then
			object.c = 0
			object.moving = false
			object.aX = object.x
			object.aY = object.y
			object.oX = 0
			object.oY = 0
		end
	end
end

function movePatterns.randomFunction()
	local i = math.random(3)
	if i == 1 then
		return movePatterns.wobbleFunction
	elseif i == 2 then
		return movePatterns.smoothFunction
	elseif i == 3 then
		return movePatterns.surgeFunction
	end
	return nil
end