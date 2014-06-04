shaderImage = {
	spiralShader = {
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
		]]
	},
	stretchingShader = {
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
		]]
	},
	quad64 = love.graphics.newQuad(0, 0, 64, 64, 64, 64),
	canvas64 = love.graphics.newCanvas(64, 64)
}


function shaderImage.spiralShader:draw(object)
	self.shader:send("time", GameData.timeElapsed)
	love.graphics.setShader(self.shader)
	love.graphics.draw(shaderImage.canvas64, shaderImage.quad64, object.aX + object.oX, object.aY + object.oY)
	love.graphics.setShader()
end

function shaderImage.stretchingShader:draw(object)
	self.shader:send("cFact", object.c)
	self.shader:send("xSpeed", object.xSpeed)
	self.shader:send("ySpeed", object.ySpeed)
	love.graphics.setShader(self.shader)
	love.graphics.draw(shaderImage.canvas64, shaderImage.quad64, object.aX + object.oX, object.aY + object.oY)
	love.graphics.setShader()
end