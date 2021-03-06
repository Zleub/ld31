local projectile = {}

function projectile:new(x, y, orientation)
	table.insert(self.list, {
		shape = self.HC:addCircle(x * self.scale, y * self.scale, self.size),
		orientation = orientation
	})
end

function projectile:init(HC, scale)
	self.HC = HC
	self.scale = scale
	self.winwidth = love.window.getWidth() / self.scale
	self.winheight = love.window.getHeight() / self.scale
	self.list = {}
	self.size = 1
	return self
end

function projectile:remove(shape, k)
	explosions:new(shape._center.x, shape._center.y)
	self.HC:remove(shape)
	table.remove(self.list, k)
end

function projectile:update(dt, table)
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

		for _, shapes in pairs(table) do
			for key,val in pairs(shapes) do
				if v.shape:collidesWith(val.shape) then
					val:destroy()
					self:remove(v.shape, k)
					break ;
				end
			end
		end
	end
end

function projectile:draw()
	-- love.graphics.print('Projectiles: '..#self.list, 0, 20)
	for k,v in pairs(self.list) do
		v.shape:draw('fill')
	end
end

return projectile
