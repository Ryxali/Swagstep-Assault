stretchingBullet = {
	shader = love.graphics.newShader [[
		extern number cFact;
		extern number xSpeed;
		extern number ySpeed;
        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
        {	
        	vec2 nCoords = (texture_coords - 0.5)*2;
        	vec2 stretch = abs(normalize(vec2(xSpeed, ySpeed))*(1-cFact)); //vec2(smoothstep(xSpeed, 0, abs(xDir)), smoothstep(ySpeed, 0, abs(yDir)));
        	nCoords /= 0.5 + stretch/2;
        	float dist = clamp(distance(nCoords, vec2(0, 0)), 0, 1);
        	float fill = smoothstep(0.8, 0.5, dist);//(1-abs(sin((nCoords.x)*3.14))) * (1-abs((-sin((nCoords.y)*3.14))));
        	clamp(fill, 0, 1);
        	return mix(vec4(1.0, 1.0, 1.0, fill), vec4(0.4, 0.6, 0.9, fill), cFact/2+0.5);//, vec4(0.0, 0.0, 1.0, fill), abs(sin(time*10))/3);
            
        }
	]],
	quad = love.graphics.newQuad(0, 0, 64, 64, 64, 64),
	canvas = love.graphics.newCanvas(64, 64)
}

function stretchingBullet:draw(bullet)
	self.shader:send("cFact", bullet.c)
	self.shader:send("xSpeed", bullet.xSpeed)
	self.shader:send("ySpeed", bullet.ySpeed)
	love.graphics.setShader(self.shader)
	--love.graphics.rectangle("fill", bullet.aX + bullet.oX, bullet.aY + bullet.oY, 64, 64)
	love.graphics.draw(self.canvas, self.quad, bullet.aX + bullet.oX, bullet.aY + bullet.oY)
	love.graphics.setShader()
	--love.graphics.draw(self.img, self.aX + self.oX, self.aY + self.oY)
end