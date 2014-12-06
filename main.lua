inspect = require 'inspect'

function love.center(offx, offy)
	return love.window.getWidth() + offx, love.graphics.getHeight() + offy
end

function love.populate(shapes)
	local nbr = math.abs(love.math.random() + 1) * 15

	for i=1, nbr do
		table.insert(shapes, {
			id = #shapes + 1,
			shape = HC:addCircle((math.abs(love.math.random())) * 234, (math.abs(love.math.random())) * 432, 50),
			callback = function (self) print(inspect(self.id)) shapes[self.id] = nil end
		})
	end

	for i=1, nbr do
		table.insert(shapes, {
			id = #shapes + 1,
			shape = HC:addRectangle((math.abs(love.math.random())) * 234, (math.abs(love.math.random())) * 432, 50, 50),
			callback = function (self) print(inspect(self.id)) shapes[self.id] = nil end
		})
	end

	-- local width = love.window.getWidth()
	-- local height = love.graphics.getHeight()

	-- for i=0, height do
	-- 	for j=0, width do

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
	shapes[1].callback = function ()
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
