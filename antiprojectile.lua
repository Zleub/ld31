local antiprojectile = {}

function antiprojectile:new(type, x, y, orientation)
	if type ~= 'large' then
		table.insert(self.list, {
			shape = self.HC:addCircle(x * self.scale, y * self.scale, 1),
			orientation = orientation
		})
	else
		if orientation == 1 or orientation == 4 then
			table.insert(self.list, {
				shape = self.HC:addCircle(x * self.scale - 10, y * self.scale, 1),
				orientation = orientation
			})
			table.insert(self.list, {
				shape = self.HC:addCircle(x * self.scale + 10, y * self.scale, 1),
				orientation = orientation
			})
		elseif orientation == 2 or orientation == 3 then
			table.insert(self.list, {
				shape = self.HC:addCircle(x * self.scale, y * self.scale - 10, 1),
				orientation = orientation
			})
			table.insert(self.list, {
				shape = self.HC:addCircle(x * self.scale, y * self.scale + 10, 1),
				orientation = orientation
			})
		end
	end
end

function antiprojectile:init(HC, scale)
	self.HC = HC
	self.scale = scale
	self.winwidth = love.window.getWidth() / self.scale
	self.winheight = love.window.getHeight() / self.scale
	self.list = {}
	return self
end

function antiprojectile:remove(shape, k)
	explosions:new(shape._center.x, shape._center.y)
	self.HC:remove(shape)
	table.remove(self.list, k)
end

function antiprojectile:update(dt, heros)
	for k,v in pairs(self.list) do
		if v.orientation == 1 then
			v.shape:move(0, - dt * 1000)
		elseif v.orientation == 2 then
			v.shape:move(dt * 1000, 0)
		elseif v.orientation == 3 then
			v.shape:move(- dt * 1000, 0)
		else
			v.shape:move(0, dt * 1000)
		end

		if v.shape._center.x < 0 or v.shape._center.x > self.winwidth * self.scale then
			self:remove(v.shape, k)
		elseif v.shape._center.y < 0 or v.shape._center.y > self.winheight * self.scale then
			self:remove(v.shape, k)
		end

		if v.shape:collidesWith(heros.shape) then
			heros:take_hit(1)
			self:remove(v.shape, k)
		end
	end
end

function antiprojectile:draw()
	for k,v in pairs(self.list) do
		v.shape:draw()
	end
end

return antiprojectile
