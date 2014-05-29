require "gamedata"
require "world"
require "vector"

cmdLine = {
	line = "",
	active = false,
	curKey = ""
}

function love.load()
	World:load()
	cmdLine.active = true
end

function love.draw()
	World:draw()
	if cmdLine.active then
		love.graphics.print(tostring(cmdLine.line), 400, 350)
		
	end
	love.graphics.print(tostring(cmdLine.curKey), 400, 400)
	GameData:draw()
end

function love.update(delta)
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