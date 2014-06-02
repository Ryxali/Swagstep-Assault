surgeBullet = {
}

function surgeBullet:updateMovement(bullet, delta)

	if bullet.moving == true then
		bullet.c = bullet.c + delta*bullet.speed
		local length = math.sqrt((bullet.x-bullet.aX)^2+(bullet.y-bullet.aY)^2)
		local xN = (bullet.x-bullet.aX) / length
		local yN = (bullet.y-bullet.aY) / length -- directional vector
		

		local factor = -math.cos(math.cos((1-math.sqrt(bullet.c))/2*math.pi)*math.pi)/2 + 0.5 ---(bullet.c^2 - 2*bullet.c)
		bullet.oX = xN * factor*length
		bullet.oY = yN * factor*length-- - math.cos(bullet.c*math.pi*2-math.pi/2)*8--math.cos(bullet.c*math.pi*2-math.pi/2) * length


		if bullet.c > 1 then
			bullet.c = 0
			bullet.moving = false
			bullet.aX = bullet.x
			bullet.aY = bullet.y
			bullet.oX = 0
			bullet.oY = 0
		end
	end
end