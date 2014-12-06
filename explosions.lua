local explosions = {}

function explosions:new(x, y)
	number = math.floor((math.abs(love.math.random()) + 1) * 5)
	for i=1,number do
		table.insert(self.list,
		{
			time = 0,
			x = x,
			y = y,
			orientation = math.floor((math.abs(love.math.random()) + 1) * 10) % 8,
			vitesse = math.floor((math.abs(love.math.random()) + 1) * 10) % 8
		})
	end
end

function explosions:init(scale)
	self.scale = scale
	self.list = {}
	return self
end

function explosions:update(dt)
	for k,v in pairs(self.list) do
		if v.orientation == 0 then
			v.y = v.y - dt * 100 * (v.vitesse + 1)
			v.x = v.x - dt * 100 * (v.vitesse + 1)
		elseif v.orientation == 1 then
			v.y = v.y - dt * 100 * (v.vitesse + 1)
		elseif v.orientation == 2 then
			v.y = v.y - dt * 100 * (v.vitesse + 1)
			v.x = v.x + dt * 100 * (v.vitesse + 1)
		elseif v.orientation == 3 then
			v.x = v.x + dt * 100 * (v.vitesse + 1)
		elseif v.orientation == 4 then
			v.y = v.y + dt * 100 * (v.vitesse + 1)
			v.x = v.x + dt * 100 * (v.vitesse + 1)
		elseif v.orientation == 5 then
			v.y = v.y + dt * 100 * (v.vitesse + 1)
		elseif v.orientation == 6 then
			v.y = v.y + dt * 100 * (v.vitesse + 1)
			v.x = v.x - dt * 100 * (v.vitesse + 1)
		else
			v.x = v.x - dt * 100 * (v.vitesse + 1)
		end
		v.time = v.time + dt
		if v.time > 0.1 then
			table.remove(self.list, k)
		end
	end
end

function explosions:draw()
	love.graphics.print('explosions: '..#self.list, 0, 40)
	for k,v in pairs(self.list) do
		love.graphics.circle('fill', v.x, v.y, 2)
	end
end

return explosions
