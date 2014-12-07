inspect = require 'inspect'

function love.center(offx, offy)
	return love.window.getWidth() + offx, love.graphics.getHeight() + offy
end

function love.circling(width, array, circle)
	local y = -circle.r
	while y <= circle.r do
		local x = -circle.r
		while x <= circle.r do
			if x * x + y * y <= circle.r * circle.r + circle.r * 0.8 then
				array[(circle.x + x) + (circle.y + y) * width] = circle.id
			end
			x = x + 1
		end
		y = y + 1
	end
end

function love.fill(array, winheight, winwidth)
	local j = 0
	while j < winheight do
		local i = 0
		while i < winwidth do
			table.insert(array, 0)
			i = i + 8 * scale
		end
		j = j + 8 * scale
	end
end

function love.populate(shapes)
	local array = {}

	local winwidth = love.window.getWidth()
	local winheight = love.window.getHeight()

	local width = winwidth / (8 * scale)
	local height = winheight / (8 * scale)

	print('width: ', width, '  height: ', height)

	love.fill(array, winheight, winwidth)

	local nbr = love.math.random(math.floor((level / 3) + 1), math.floor((level / 2) + 1))
	print(nbr, 'level: ', level)
	print(nbr..' circles !')
	local circles = {}
	for i=1, nbr do
		table.insert(circles,
		{
			id = #circles + 1,
			x = love.math.random(width),
			y = love.math.random(height),
			r = love.math.random(math.floor((level / 8) + 1), math.floor((level / 6) + 1))
		})
	end

	print(inspect(circles))

	for k,v in pairs(circles) do
		love.circling(width, array, v)
	end

	for j=0,height - 1 do
		for i=1,width do
			-- io.write(array[i + j * width])
			if array[i + j * width] ~= 0 then
				enemies:new(array[i + j * width], i, j)
			end
		end
		-- io.write('\n')
	end
end

function love.button()
	local shape = {}
	shape.img = love.graphics.newImage("IMG/newgame_button.png")
	shape.img:setFilter('nearest')
	shape.shape = HC:addRectangle(450, 450, shape.img:getWidth() * scale, shape.img:getHeight() * scale)
	shape.destroy = function ()
		table.remove(shapes, 1)
		love.populate(shapes)
		minishop = 0
	end
	return shape
end

function love.merchant()
	local shape = {}
	shape.img = love.graphics.newImage("IMG/health.png")
	shape.img:setFilter('nearest')
	shape.shape = HC:addRectangle(250, 450, shape.img:getWidth() * scale, shape.img:getHeight() * scale)
	shape.destroy = function ()
		table.remove(shapes, 1)
		heros.life = 20
		love.populate(shapes)
		minishop = 0
	end
	return shape
end

function love.load()
	scale = 8
	Collider = require 'hardoncollider'
	HC = Collider.new(150)
	heros = require 'heros':init(HC, scale)
	projectile = require 'projectile':init(HC, scale)
	antiprojectile = require 'antiprojectile':init(HC, scale)
	explosions = require 'explosions':init(scale)
	enemies = require 'enemies':init(HC, scale)

	shapes = {love.button()}
	minishop = 1
	level = 1

	instructions = love.graphics.newImage('IMG/instructions.png')
	instructions:setFilter('nearest')
end

function love.update(dt)
	explosions:update(dt)
	projectile:update(dt, {shapes, enemies.list})
	antiprojectile:update(dt, heros)
	enemies:update(dt, heros)
	heros:update(dt, shapes)
	if enemies.count == 0 then
		if minishop == 0 then
			table.insert(shapes, love.merchant())
			level = level + 1
			minishop = 1
		end
	end
end

function love.draw()
	love.graphics.print('FPS: '..love.timer.getFPS())

	if level == 1 then
		love.graphics.setColor(255, 255, 255, 100)
		love.graphics.draw(instructions, love.window.getWidth() / 2 - (instructions:getWidth() / 2 * 4), 150, 0, 4, 4)
		love.graphics.setColor(255, 255, 255, 255)
	end



	for k,v in pairs(shapes) do
		if v.img then
			local point2 = v.shape._polygon.vertices[2]
			love.graphics.draw(v.img, point2.x, point2.y, 0, scale, scale)
		end
		-- v.shape:draw()
	end

	explosions:draw()
	projectile:draw()
	antiprojectile:draw()
	enemies:draw()
	heros:draw()
end

function love.keypressed(key, unicode)
	-- if key == 'w' or key == 'up' then
	-- 	--
	-- elseif key == 'a' or key == 'left' then
	-- 	--
	-- elseif key == 'd' or key == 'right' then
	-- 	--
	-- elseif key == 's' or key == 'down' then
	-- 	--
	-- end
	heros:keypressed(key, unicode)
	-- print(inspect(projectile))
end

function love.mousepressed(x, y, button)
	if button == 'wu' then
		scale = scale + 1
	elseif button == 'wd' then
		scale = scale - 1
	end
end
