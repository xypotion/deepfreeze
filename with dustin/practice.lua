function love.load()
	x = -100
end

function love.update(t)
	x += t
end

function love.draw()
	love.graphics.rectangle(x, 100)
end