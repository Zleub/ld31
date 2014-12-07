local merchant = {}

function merchant.health(x, y)
	local shape = {}
	shape.img = love.graphics.newImage("IMG/health.png")
	shape.img:setFilter('nearest')
	shape.text = 'MAX ++'

	shape.shape = HC:addRectangle(x, y, shape.img:getWidth() * scale, shape.img:getHeight() * scale)
	shape.destroy = function ()
		shapes = {}
		heros.max_life = heros.max_life + 10
		love.populate(shapes)
		minishop = 0
	end
	return shape
end

function merchant.health50(x, y)
	local shape = {}
	shape.id = #shapes + 1
	shape.img = love.graphics.newImage("IMG/health.png")
	shape.img:setFilter('nearest')
	shape.text = '50 %'
	shape.shape = HC:addRectangle(x, y, shape.img:getWidth() * scale, shape.img:getHeight() * scale)
	shape.destroy = function (self)
		shapes = {}
		heros.life = heros.life + heros.max_life / 2
		if heros.life > heros.max_life then heros.life = heros.max_life end
		love.populate(shapes)
		minishop = 0
	end
	return shape
end

function merchant.health75(x, y)
	local shape = {}
	shape.id = #shapes + 1
	shape.img = love.graphics.newImage("IMG/health.png")
	shape.img:setFilter('nearest')
	shape.text = '75 %'
	shape.shape = HC:addRectangle(x, y, shape.img:getWidth() * scale, shape.img:getHeight() * scale)
	shape.destroy = function (self)
		shapes = {}
		heros.life = heros.life + math.floor(heros.max_life / 1.5)
		if heros.life > heros.max_life then heros.life = heros.max_life end
		love.populate(shapes)
		minishop = 0
	end
	return shape
end

function merchant.size(x, y)
	local shape = {}
	shape.id = #shapes + 1
	shape.img = love.graphics.newImage("IMG/size.png")
	shape.img:setFilter('nearest')
	shape.text = 'SIZE ++'
	shape.shape = HC:addRectangle(x, y, shape.img:getWidth() * scale, shape.img:getHeight() * scale)
	shape.destroy = function (self)
		shapes = {}
		projectile.size = projectile.size + 1
		love.populate(shapes)
		minishop = 0
	end
	return shape
end

function merchant.strife(x, y)
	local shape = {}
	shape.id = #shapes + 1
	shape.img = love.graphics.newImage("IMG/strife.png")
	shape.img:setFilter('nearest')
	shape.text = 'SHIFT ++'
	shape.shape = HC:addRectangle(x, y, shape.img:getWidth() * scale, shape.img:getHeight() * scale)
	shape.destroy = function (self)
		shapes = {}
		heros.strife_rate = heros.strife_rate - 1
		love.populate(shapes)
		minishop = 0
	end
	return shape
end

function merchant.delay(x, y)
	local shape = {}
	shape.id = #shapes + 1
	shape.img = love.graphics.newImage("IMG/size.png")
	shape.img:setFilter('nearest')
	shape.text = 'DELAY --'
	shape.shape = HC:addRectangle(x, y, shape.img:getWidth() * scale, shape.img:getHeight() * scale)
	shape.destroy = function (self)
		shapes = {}
		heros.projectile_delay = heros.projectile_delay - 1
		love.populate(shapes)
		minishop = 0
	end
	return shape
end

function merchant.speed(x, y)
	local shape = {}
	shape.id = #shapes + 1
	shape.img = love.graphics.newImage("IMG/strife.png")
	shape.img:setFilter('nearest')
	shape.text = 'SPEED ++'
	shape.shape = HC:addRectangle(x, y, shape.img:getWidth() * scale, shape.img:getHeight() * scale)
	shape.destroy = function (self)
		shapes = {}
		heros.rate = heros.rate - 2
		love.populate(shapes)
		minishop = 0
	end
	return shape
end

return merchant
