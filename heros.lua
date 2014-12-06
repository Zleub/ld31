local heros = {}

function heros.sprite_up(img)
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

function heros:move(x, y)
	self.x = self.x + x
	self.y = self.y + y
end

function heros:init(HC, scale)
	self.HC = HC
	self.scale = scale
	self.rate = 40
	self.x = 10
	self.y = 10
	self.r = 0
	self.img = love.graphics.newImage('IMG/heros.png')
	self.img:setFilter('nearest')
	self.sprites = heros.sprite_up(self.img)
	self.orientation = 1
	self.width = 8
	self.height = 8

	self.busy = 5

	self.shape = self.HC:addRectangle(
		(self.x + 2) * self.scale,
		(self.y + 2) * self.scale,
		(self.width - 2) * self.scale,
		(self.height - 2) * self.scale
	)


	-- print(inspect(self.shape._polygon.vertices))
	return self
end

function heros:update(dt, shapes)
	local x_inc = 0
	local y_inc = 0

	if love.keyboard.isDown('w') or love.keyboard.isDown('up') then
		y_inc = - dt * self.rate
		self.orientation = 1
	end
	if love.keyboard.isDown('a') or love.keyboard.isDown('left') then
		x_inc = - dt * self.rate
		self.orientation = 3
	end
	if love.keyboard.isDown('d') or love.keyboard.isDown('right') then
		x_inc =  dt * self.rate
		self.orientation = 2
	end
	if love.keyboard.isDown('s') or love.keyboard.isDown('down') then
		y_inc = dt * self.rate
		self.orientation = 4
	end
	if love.keyboard.isDown(' ') then
		if self.busy == 0 then
			projectile:new(self.x, self.y, self.orientation)
			self.busy = 5
		end
	end
	self.busy = self.busy - dt * 20
	if self.busy < 0 then
		self.busy = 0
	end

	self.shape:moveTo((self.x + x_inc) * self.scale, (self.y + y_inc) * self.scale)

	for k,v in pairs(shapes) do
		if self.shape:collidesWith(v.shape) then
			return ;
		end
	end

	self.x = self.x + x_inc
	self.y = self.y + y_inc

end

function heros:draw()
	-- self.shape:draw()

	love.graphics.scale(self.scale, self.scale)
	love.graphics.draw(self.img, self.sprites[self.orientation], self.x - self.width / 2, self.y - self.height / 2)
	love.graphics.scale(0, 0)
end

function heros:keypressed(key, unicode)
	print(key)
	-- if key == 'w' or key == 'up' then
	-- 	self.
	-- if key == 'a' or key == 'left' then
	-- 	self.r = self.r + 1
	-- end
	-- 	--
	-- elseif key == 'd' or key == 'right' then
	-- 	--
	-- elseif key == 's' or key == 'down' then
	-- 	--
	-- end
end

return heros
