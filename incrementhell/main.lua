function love.load()
	food = 0
	water = 0
	wood = 0
	stone = 0
	metal = 0
	cloth = 0
	money = 0
	reagents = 0
	culture = 0
	magic = 0
	energy = 0
	piety = 0
	knowledge = 0
	
	-- list = {10, 30, 50, "hello"}
	-- print(list[1])
	--
	-- list[5] = 1000
	-- list[5] = "wait no"
	-- print(list[5])
	--
	-- list["index"] = "some value"
	--  	print(list["index"])
	--
	-- print(list["haha"])
	--
	-- myKey = "index"
	--
	-- testLoop("load")
	--
	--
	-- initSquare()
end

function love.update(dt)
-- 	-- move square
-- 	x = x + dt * speed
-- 	fps = 1/dt
	
	-- check collision
	-- local mx, my = love.mouse.getPosition()
	-- if x < mx and mx < x + 50 and y < my and my < y + 50 then
	-- 	initSquare()
	-- 	score = score + 1
	-- 	speed = speed + 10
	-- end
	--
	-- -- check lose state
	-- if x > 750 then
	-- 	gameOver = true
	-- end
end

function love.draw()
	-- love.graphics.rectangle("fill", x, y, 50, 50)

	-- love.graphics.print("Score: "..score, 10, 5)

	-- FPS
	-- love.graphics.print("FPS:", 10, 20)
	-- love.graphics.rectangle("fill", 40, 20, FPS, 10)
	
	love.graphics.setColor(255, 255, 255)
	love.graphics.print("Food:"..food, 10, 10)
	love.graphics.print("Water:"..water, 10, 20)
	love.graphics.print("Wood:"..wood, 10, 30)
	love.graphics.print("Stone:"..stone, 10, 40)
	love.graphics.print("Metal:"..metal, 10, 50)
	love.graphics.print("Cloth:"..cloth, 10, 60)
	
	love.graphics.rectangle("fill", 150,150,60,60)
	love.graphics.rectangle("fill", 280,150,60,60)
	love.graphics.rectangle("fill", 150,280,60,60)
	love.graphics.rectangle("fill", 280,280,60,60)
	
	love.graphics.setColor(200, 0, 0)
	love.graphics.print("Get 1 Food", 150,220)
	
	love.graphics.setColor(0, 0, 200)
	love.graphics.print("Get 1 Water", 280,220)
	
	love.graphics.setColor(0, 200, 0)
	love.graphics.print("Get 1 Wood", 150,350)
	
	love.graphics.setColor(200, 200, 0)
	love.graphics.print("Get 1 Stone", 280,350)
	
	if gameOver then
		love.graphics.print("GAME OVER!", 350, 300)
	end
end

------------------------------------------------------------------------------------------------------------------------


function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	-- else
		-- other stuff
	end
	
	if key == "f" then
		food = food + 1
	end

	-- if (key == "h" or key == "z") then
	-- 	testLoop(key)
	-- end
end

-- function love.keypressed(foo)
-- 	--forgotten
-- 	print("WHAT "..foo)
-- end

-- makes new square outside of screen
-- function initSquare()
-- 	pos = {}
-- 	-- pos["x"] = -100
--
-- 	x = -100
-- 	y = math.random(20, 500)
-- end
--
-- function testLoop(text)
-- 	-- while true dosNdbzskdj
-- -- 		print("hi "..text)
-- -- 	end
--
-- 	for index = 1, 10 do
-- 		print(index.." "..text)
-- 	end
-- end

-- function 