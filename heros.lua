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

function heros:take_hit(nbr)
	self.life = self.life - nbr
	if self.life <= 0 then
		death = 1
		old_level = level
		enemies.list = {}
		shapes = {love.button()}
		minishop = 1
		level = 1
		heros.life = 20
		projectile.size = 1
		heros.strife_rate = 8
		heros.max_life = 20
		heros.rate = 40
	end
end

function heros:move(x, y)
	self.x = self.x + x
	self.y = self.y + y
end

function heros:init(HC, scale)
	self.HC = HC
	self.scale = scale
	self.rate = 40
	self.x = 25
	self.y = 25
	self.r = 0
	self.img = love.graphics.newImage('IMG/heros.png')
	self.img:setFilter('nearest')
	self.sprites = heros.sprite_up(self.img)
	self.orientation = 1
	self.width = 8
	self.height = 8

	self.busy = 5

	self.life = 20

	self.shape = self.HC:addRectangle(
		(self.x + 2) * self.scale,
		(self.y + 2) * self.scale,
		(self.width - 2) * self.scale,
		(self.height - 2) * self.scale
	)

	self.strife_rate = 8
	self.max_life = 20
	self.projectile_delay = 20
	return self
end

function heros:update(dt, shapes)
	local x_inc = 0
	local y_inc = 0

	if love.keyboard.isDown('a') or love.keyboard.isDown('left') then
		if love.keyboard.isDown('lshift') then
			if self.orientation == 1 then
				x_inc = - dt * self.rate / self.strife_rate
			elseif self.orientation == 2 then
				y_inc = - dt * self.rate / self.strife_rate
			elseif self.orientation == 3 then
				y_inc = dt * self.rate / self.strife_rate
			else
				x_inc = dt * self.rate / self.strife_rate
			end
		else
			x_inc = - dt * self.rate
			self.orientation = 3
		end
	end
	if love.keyboard.isDown('d') or love.keyboard.isDown('right') then
		if love.keyboard.isDown('lshift') then
			if self.orientation == 1 then
				x_inc = dt * self.rate / 8
			elseif self.orientation == 2 then
				y_inc = dt * self.rate / 8
			elseif self.orientation == 3 then
				y_inc = - dt * self.rate / 8
			else
				x_inc = - dt * self.rate / 8
			end
		else
			x_inc =  dt * self.rate
			self.orientation = 2
		end
	end
	if love.keyboard.isDown('w') or love.keyboard.isDown('up') then
		y_inc = - dt * self.rate
		self.orientation = 1
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
	self.busy = self.busy - dt * self.projectile_delay
	if self.busy < 0 then
		self.busy = 0
	end

	self.shape:moveTo((self.x + x_inc) * self.scale, (self.y + y_inc) * self.scale)


	if (self.x + x_inc) * self.scale > love.window.getWidth() or (self.y + y_inc) * self.scale > love.window.getHeight() then
		return
	end

	if self.x + x_inc < 0 or self.y + y_inc < 0 then
		self.shape:moveTo(self.x * self.scale, self.y * self.scale)
		return
	end
	self.x = (self.x + x_inc)
	self.y = (self.y + y_inc)

end

function heros:draw()
	love.graphics.setColor(255, 0, 0)
	love.graphics.rectangle('fill', 14, 14, self.life * 10 - 8, 20 - 8)
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(self.img, self.sprites[self.orientation], (self.x - self.width / 2) * self.scale, (self.y - self.height / 2) * self.scale, 0, self.scale, self.scale)
end

function heros:keypressed(key, unicode)
end

return heros
