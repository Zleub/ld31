local enemies = {}

function enemies.sprite_up(img)
	local imgwidth = img:getWidth()
	local imgheight = img:getHeight()
	local Quadlist = {}

	local x = 0
	local y = 0
	for i=1,4 do
		table.insert(Quadlist, love.graphics.newQuad(x, y, 8, 8, imgwidth, imgheight))
		x = x + 8
	end
	return Quadlist
end

function enemies.delay()
	return love.math.random(3, 10)
end

function enemies:new(nbr, x, y)
	nbr = love.math.random(0, nbr % 2 + 1)
	if nbr == 0 then
		table.insert(self.list, {
			type = 'small',
			id = #self.list + 1,
			delay = self.delay(),
			x = (x - 1) * 8, -- * 64,
			y = y * 8, -- * 64,
			d = 2,
			orientation = love.math.random(1, 4),
			shape = self.HC:addRectangle(
				(x - 1) * self.scale * 8,
				y * self.scale * 8,
				8 * self.scale / 2, -- self.d
				8 * self.scale / 2), -- self.d
			destroy = function (self)
				enemies.list[self.id] = nil
			end
		})
	elseif nbr == 1 then
		table.insert(self.list, {
			type = 'large',
			id = #self.list + 1,
			delay = self.delay(),
			x = (x - 1) * 8, -- * 64,
			y = y * 8, -- * 64,
			d = 1,
			orientation = love.math.random(1, 4),
			shape = self.HC:addRectangle(
				(x - 1) * self.scale * 8,
				y * self.scale * 8,
				8 * self.scale / 1, -- self.d
				8 * self.scale / 1), -- self.d
			destroy = function (self)
				enemies.list[self.id] = nil
			end
		})
	elseif nbr == 2 then
		table.insert(self.list, {
			type = 'medium',
			id = #self.list + 1,
			delay = self.delay(),
			x = (x - 1) * 8, -- * 64,
			y = y * 8, -- * 64,
			d = 1.5,
			orientation = love.math.random(1, 4),
			shape = self.HC:addRectangle(
				(x - 1) * self.scale * 8,
				y * self.scale * 8,
				8 * self.scale / 1.5, -- self.d
				8 * self.scale / 1.5), -- self.d
			destroy = function (self)
				enemies.list[self.id] = nil
			end
		})
	end
end

function enemies:init(HC, scale)
	self.HC = HC
	self.scale = scale
	self.img = love.graphics.newImage('IMG/enemies.png')
	self.img:setFilter('nearest')
	self.width = 8
	self.height = 8
	self.sprite = enemies.sprite_up(self.img)
	self.list = {}
	self.count = 0
	return self
end

function enemies:update(dt, heros)
	self.count = 0
	for k,v in pairs(self.list) do

		local x_raw
		local x_inc
		local y_raw
		local y_inc

		if v.type == 'small' then
			x_raw = (heros.x - v.x) * self.scale
			x_inc = x_raw * dt / 80
			y_raw = (heros.y - v.y) * self.scale
			y_inc = y_raw * dt / 80
		elseif v.type == 'medium' then
			x_raw = (heros.x - v.x) * self.scale
			x_inc = x_raw * dt / 100
			y_raw = (heros.y - v.y) * self.scale
			y_inc = y_raw * dt / 100
		elseif v.type == 'large' then
			x_raw = (heros.x - v.x) * self.scale
			x_inc = x_raw * dt / 120
			y_raw = (heros.y - v.y) * self.scale
			y_inc = y_raw * dt / 120
		end

		if math.abs(x_inc) > math.abs(y_inc) and x_inc > 0 then
			v.orientation = 2
		end

		if math.abs(x_inc) > math.abs(y_inc) and x_inc < 0 then
			v.orientation = 3
		end

		if math.abs(y_inc) > math.abs(x_inc) and y_inc > 0 then
			v.orientation = 4
		end

		if math.abs(y_inc) > math.abs(x_inc) and y_inc < 0 then
			v.orientation = 1
		end

		if v.delay < 0 then
			if (math.floor(x_raw) < 10 and math.floor(x_raw) > -10) or (math.floor(y_raw) < 10 and math.floor(y_raw) > -10) then
				antiprojectile:new(v.x, v.y, v.orientation)
				v.delay = self.delay()
			end
		else
			v.delay = v.delay - dt
		end

		v.shape:moveTo((v.x + x_inc) * self.scale, (v.y + y_inc) * self.scale)
		for key,val in pairs(self.list) do
			if v.shape:collidesWith(val.shape) then

				local x_vector = v.shape._polygon.centroid.x - val.shape._polygon.centroid.x
				local y_vector = v.shape._polygon.centroid.y - val.shape._polygon.centroid.y

				if x_vector > 0 then

					v.x = v.x + 1
				end
				if y_vector > 0 then
					v.y = v.y + 1
				end

				if x_vector < 0 then
					v.x = v.x - 1
				end
				if y_vector < 0 then
					v.y = v.y - 1
				end
			end
		end
		v.x = v.x + x_inc
		v.y = v.y + y_inc
		self.count = self.count + 1
	end
	if self.count == 0 then self.list = {} end
end

function enemies:draw()
	love.graphics.print("enemies: "..self.count, 0, 60)
	for k,v in pairs(self.list) do
		-- v.shape:draw()
		love.graphics.draw(
			self.img,
			self.sprite[v.orientation],
			(v.x - self.width / (2 * v.d)) * self.scale,
			(v.y - self.height / (2 * v.d)) * self.scale,
			0,
			self.scale / v.d,
			self.scale / v.d
		)
	end
end

return enemies
