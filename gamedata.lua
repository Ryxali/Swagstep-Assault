GameData = {
	status = {
		isFocused = true,
		errorMsg = nil
	},
	Event = {
		keysPressed = {
			key = {},
			numKeys = 0
		},
		keysReleased = {
			key = {},
			numKeys = 0
		},
		actions = {
			action = {
				code = "",
				data = ""
			},
			numActions = 0
		}
	},
	WINDOW_SIZE = {
		x = 800,
		y = 600
	},
	flags = {
		fullscreen = false,
		fullscreentype = "normal",
		vsync = true,
		fsaa = 0, -- antialias samples
		resizable = false,
		borderless = false,
		centered = true,
		display = 1,
		minwidth = 1,
		minheight = 1,
		highdpi = false,
		srgb = false

	},
	timeElapsed = 0
}

-- Clear event history
function GameData.clean(this)
	this.Event.keysPressed.numKeys = 0
	this.Event.keysReleased.numKeys = 0
	this.Event.actions.numActions = 0
end

function GameData.setKeyPressedStatus(this, key, status)
	this.Event.keysPressed.numKeys = this.Event.keysPressed.numKeys + 1
	this.Event.keysPressed.key[this.Event.keysPressed.numKeys] = key
end

function GameData.setKeyReleasedStatus(this, key, status)
	this.Event.keysReleased.numKeys = this.Event.keysReleased.numKeys + 1
	this.Event.keysReleased.key[this.Event.keysReleased.numKeys] = key
end

function GameData.checkKeyPressedEvent(this, key)
	for i = 1, this.Event.keysPressed.numKeys, 1 do
		if this.Event.keysPressed.key[i] == key then
			return true
		end
	end
	return false
end

function GameData.checkKeyReleasedEvent(this, key)
	for i = 1, this.Event.keysReleased.numKeys, 1 do
		if this.Event.keysReleased.key[i] == key then
			return true
		end
	end
	return false
end

function GameData.addAction(this, code, data)
	this.Event.actions.numActions = this.Event.actions.numActions + 1
	tmp = {
		t_code = code,
		t_data = data
	}
	this.Event.actions.action[this.Event.actions.numActions] = {
		code = code,
		data = data
	}
	print("Foo")
	print(this.Event.actions.action[this.Event.actions.numActions].code)
	print(this.Event.actions.action[this.Event.actions.numActions].data)
end

function GameData.addError(this, msg, time)
	if(this.status.errorMsg == nil) then
		this.status.errorMsg = {
			nextMsg = nil,
			line = msg,
			endTime = this.timeElapsed + time
		}
	else
		local endMsg = this.status.errorMsg
		while endMsg.nextMsg ~= nil do
			endMsg = endMsg.nextMsg
		end
		endMsg.nextMsg = {
			nextMsg = nil,
			line = msg,
			endTime = this.timeElapsed + time
		}
	end
end



function GameData.update(this, delta)
	this.timeElapsed = this.timeElapsed + delta
	local l = this.status.errorMsg
	local lp = nil
	while l do
		if l.endTime < this.timeElapsed then
			if lp ~= nil then
				lp.nextMsg = l.nextMsg
			else
				if this.status.errorMsg.nextMsg ~= nil then
					this.status.errorMsg = this.status.errorMsg.nextMsg
				else
					this.status.errorMsg = nil
				end
			end
		end
		lp = l
		l = l.nextMsg
	end
end

function GameData.draw(this)
	local l = this.status.errorMsg
	local y = 250 
	while l do
		love.graphics.print(l.line, 96, y)
		y = y + 16
		l = l.nextMsg
	end
end