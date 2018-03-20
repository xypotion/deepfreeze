function love.load()
	score = 0
	speed = 50
	gameOver = false
	
	initSquare()
end

function love.update(dt)
	-- move square
	x = x + dt * speed
	fps = 1/dt
	
	-- check collision
	local mx, my = love.mouse.getPosition()
	if x < mx and mx < x + 50 and y < my and my < y + 50 then
		initSquare()
		score = score + 1
		speed = speed + 10
	end
	
	-- check lose state
	if x > 750 then
		gameOver = true
	end
end

function love.draw()
	love.graphics.rectangle("fill", x, y, 50, 50)
	
	love.graphics.print("Score: "..score, 10, 5)

	-- FPS
	love.graphics.print("FPS:", 10, 20)
	love.graphics.rectangle("fill", 40, 20, fps, 10)
	
	if gameOver then
		love.graphics.print("GAME OVER!", 350, 300)
	end
end

------------------------------------------------------------------------------------------------------------------------

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
end

-- makes new square outside of screen
function initSquare()
	x = -100
	y = math.random(20, 500)
end