inspect = require 'inspect'

function love.center(offx, offy)
	return love.window.getWidth() + offx, love.graphics.getHeight() + offy
end

-- function test(k, circles)
-- 	for key,val in pairs(circles) do
-- 		if k == val.x + val.y * width then
-- 			io.write(" !"..v.."! ")
-- 		else
-- 			io.write("  "..v.."  ")
-- 		end
-- 	end
-- end

function love.populate(shapes)
	local array = {}
	local winwidth = love.window.getWidth()
	local winheight = love.window.getHeight()

	local width = winwidth / (8 * scale)
	local height = winheight / (8 * scale)

	print('width: ', width, '  height: ', height)

	local nbr = love.math.random(3)
	print(nbr..' circles !')
	local circles = {}
	for i=1, nbr do
		table.insert(circles,
		{
			id = #circles + 1,
			x = love.math.random(width),
			y = love.math.random(height),
			r = love.math.random(5, 10)
		})
	end

	print(inspect(circles))

	local j = 0
	while j < winheight do
		local i = 0
		while i < winwidth do
			-- table.insert(shapes, {
			-- 	id = #shapes + 1,
			-- 	shape = HC:addRectangle(i, j, 8 * scale, 8 * scale),
			-- 	destroy = function (self) shapes[self.id] = nil end
			-- })
			table.insert(array, 0)
			i = i + 8 * scale
		end
		j = j + 8 * scale
	end

	for k,v in ipairs(array) do
		-- for key,val in pairs(circles) do
		-- 	if k == val.x + val.y * width then
		-- 		io.write(" !"..v.."! ")
		-- 	else
				io.write("  "..v.."  ")
		-- 	end
		-- end
		if k % width == 0 then
			io.write('\n')
		end
	end

end

function love.load()
	scale = 8
	Collider = require 'hardoncollider'
	HC = Collider.new(150)
	heros = require 'heros':init(HC, scale)
	projectile = require 'projectile':init(HC, scale)
	explosions = require 'explosions':init(scale)

	shapes = {}
	table.insert(shapes, {})
	shapes[1].img = love.graphics.newImage("IMG/newgame_button.png")
	shapes[1].shape = HC:addRectangle(450, 450, shapes[1].img:getDimensions())
	shapes[1].destroy = function ()
		table.remove(shapes, 1)
		love.populate(shapes)
	end

end

function love.update(dt)
	explosions:update(dt)
	projectile:update(dt, shapes)
	heros:update(dt, shapes)
end

function love.draw()
	love.graphics.print('FPS: '..love.timer.getFPS())

	for k,v in pairs(shapes) do
		if v.img then
			love.graphics.draw(v.img, v.shape._polygon.vertices[1].x, v.shape._polygon.vertices[1].x)
		end
		v.shape:draw()
	end

	explosions:draw()
	projectile:draw()
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
