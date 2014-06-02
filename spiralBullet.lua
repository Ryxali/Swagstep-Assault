spiralBullet = {
	shader = love.graphics.newShader [[
		extern number time;
        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
        {	
        	vec2 nCoords = texture_coords - 0.5;
        	float dist = distance(nCoords*2, vec2(0, 0));
        	float fill = 1 - dist;//(1-abs(sin((nCoords.x)*3.14))) * (1-abs((-sin((nCoords.y)*3.14))));
        	fill *= 1-smoothstep(0.2, 0.3, dist) 
        		+ smoothstep(0.2, 0.3, dist) * 
        			step(
        				sin(time*3.14*3.14)/10+0.4,
        				mod((atan(nCoords.x, nCoords.y)
        			 		- distance(nCoords, vec2(0, 0))*8+ time*8), 1.57));
        	clamp(fill, 0, 1);
        	//fill *= smoothstep(0.01, 0.03, abs(nCoords.x)*2)*smoothstep(0.01, 0.03, abs(nCoords.y)*2);// * smoothstep(0.3, 0.6, nCoords.y);
        	return vec4(dist/2, 1-dist, 1-dist/3, fill);//, vec4(0.0, 0.0, 1.0, fill), abs(sin(time*10))/3);
            
        }
	]],
	quad = love.graphics.newQuad(0, 0, 64, 64, 64, 64),
	canvas = love.graphics.newCanvas(64, 64)
}

function spiralBullet:draw(bullet)
	self.shader:send("time", GameData.timeElapsed)
	love.graphics.setShader(self.shader)
	--love.graphics.rectangle("fill", bullet.aX + bullet.oX, bullet.aY + bullet.oY, 64, 64)
	love.graphics.draw(self.canvas, self.quad, bullet.aX + bullet.oX, bullet.aY + bullet.oY)
	love.graphics.setShader()
	--love.graphics.draw(self.img, self.aX + self.oX, self.aY + self.oY)
end