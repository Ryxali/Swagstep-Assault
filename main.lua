require "gamedata"
require "world"
require "vector"

cmdLine = {
	line = "",
	active = false,
	curKey = ""
}

function love.load()
	canvas = love.graphics.newCanvas(800, 600)
	love.graphics.setCanvas(canvas)
	effect = love.graphics.newShader [[
        extern number time;
        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
        {	
        	vec4 c = Texel(texture, texture_coords);
        	c = mix(c, vec4(abs(sin(time*time*1.2/100)), abs(cos(time*time/100)), abs(sin(time*time/100)), 1.0), 0.2);
        	//c = vec4(texture_coords.x, 0.0, time-time, 1.0);
        	return c;
            
        }
    ]]
    
	World:load()
	cmdLine.active = true
end

function love.draw()
	love.graphics.setCanvas(canvas)
	canvas:clear()
	love.graphics.setBlendMode('alpha')
	World:draw()
	if cmdLine.active then
		love.graphics.print(tostring(cmdLine.line), 400, 350)
		
	end
	love.graphics.print(tostring(cmdLine.curKey), 400, 400)	GameData:draw()
	--love.graphics.setShader(effect)
	love.graphics.setCanvas()
	love.graphics.setBlendMode('premultiplied')
	love.graphics.draw(canvas)
	love.graphics.setShader()
	
end


function love.update(delta)
	effect:send("time", GameData.timeElapsed)
	GameData:update(delta)
	if cmdLine.active then
		for i = 1, GameData.Event.keysPressed.numKeys, 1 do
			if string.len(GameData.Event.keysPressed.key[i]) == 1 then
				if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then
					cmdLine.line = cmdLine.line .. string.upper(GameData.Event.keysPressed.key[i])
				else
					cmdLine.line = cmdLine.line .. string.lower(GameData.Event.keysPressed.key[i])
				end
			elseif GameData.Event.keysPressed.key[i] == "backspace" then
				cmdLine.line = string.sub(cmdLine.line, 1, -2)

			end
		end
	end

	if GameData:checkKeyPressedEvent("return") or GameData:checkKeyPressedEvent("kpenter") then
		--cmdLine.active = not cmdLine.active
		--if not cmdLine.active then
		GameData:addAction("input", cmdLine.line)
		cmdLine.line = ""
		--end
		
	end

	World:update(delta)

	


	GameData:clean()
end

function love.mousepressed(x, y, button)

end

function love.mousereleased(x, y, button)

end

function love.keypressed(key)
	cmdLine.curKey = key
	GameData:setKeyPressedStatus(key, true)
end

function love.keyreleased(key)
	GameData:setKeyReleasedStatus(key, true)
end

function love.focus(status)
	GameData.status.isFocused = status
end

function love.quit()
	print("BAI")
end