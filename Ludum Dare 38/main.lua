--"creator's helper" for ludum dare 38
--the creator wants to make a world with various things in it, and you only have a certain amount of time to satisfy em
--world = 3x3 grid that you build by adding cards: animal, vegetable, mineral, land, sea, air, creative people, preservationist ? people, destructive people
--creator's wishes constitute lines of different elements from placed cards, which have one of each attribute category each 
--gameplay: click world spaces to place or use elements. 
--design: small, stretchable, as few words as possible! just icons for elements & desires. timer, lines for syncs, sets of 3 icons for creator's desires, checkboxes for satisfied ones

--maybes/ideas/todos:
--remove "DEBUG"s for finished product
--window resizing. should be easy, just catch callback & adjust stuff
--hovers with labels for different element names
--stars move both ways? kinda spinny parallax?
--get the newest love!!

--...this should have been a great little game, but lappy died a few hours into it! so much for LD38. might come back to this, but might not.

function love.load()
	math.randomseed(os.time())
	
	--graphical constants. space dimensions, element locations?, animation timers, canvas
	gameCanvasWidth = 300
	gameCanvasHeight = 200
	gameCanvas = love.graphics.newCanvas(gameCanvasWidth, gameCanvasHeight)
	gameCanvasScale = 2
	gameCanvas:setFilter('linear', 'nearest', 0)
	
	love.window.setMode(gameCanvasWidth * gameCanvasScale, gameCanvasHeight * gameCanvasScale)
	
	--load graphics
	
	
	--stars; distance affects tracking speed & birghtness
	stars = {}
	for i = 1, 100 do
		local distance = math.random(1, 200)
		stars[i] = {x = math.random(1, gameCanvasWidth), y = math.random(1, gameCanvasHeight), brightness = 256 - distance, speed = (200 - distance) / 4}
	end
	
	--DEBUG
	circle = {0, 0}
	
	--load sound
	
	
	--timer & other game constants
	stage = 1
	gameOver = false
	-- gameIntro?
	
	--world init
	world = {}
	--1 2 3
	--4 5 6
	--7 8 9
	
	--stage/desires init
	desires = newDesires(2)
	
	--hand init
	hand = {}
	for i = 1, 3 do
		hand[i] = newCard()
	end
end


function love.update(dt)
	if not gameOver then
	--track mouse position & do hovers
	end
	
	moveStars(dt)
end


function love.draw()
	love.graphics.setCanvas(gameCanvas)
	love.graphics.clear()
	
	if gameOver then
		drawGameOver()
	else
		drawGame()
	end
	
	love.graphics.setCanvas()
	love.graphics.draw(gameCanvas, 0, 0, 0, gameCanvasScale)
end

function drawGame()
	--DEBUG
	love.graphics.print("hello small world")
	love.graphics.circle("fill", circle[1], circle[2], 5)
	
	--stars in bg
	for i = 1, 100 do
		love.graphics.setColor(255, 255, 255, stars[i].brightness)
		love.graphics.rectangle("fill", stars[i].x, stars[i].y, 1, 1)
	end
	white()
	
	--prayers queue
	
	--god's desire + countdown
	
	--world grid
	
	--DEBUG
	love.graphics.circle("line", 100, 100, 100)
	
	--each land space
	
end

function drawGameOver()
	-- game in background + overlay - hovers?
	
	-- show score & high score
	
	-- show thanks for playing & credits etc
end


function love.mousepressed(x, y, button)
	--DEBUG
	print(x, y)
	circle = {x/gameCanvasScale, y/gameCanvasScale}
	
	--in a world space?
	
	--another valid action button? (help, pass, etc) do if so
	
	--place card, check if stage won or game over
end

--DEBUG
function love.keypressed(key)
	if key == "escape" then love.event.quit() end
end

function white()
	love.graphics.setColor(255, 255, 255, 255)
end

---------------------------------------------------------------------------------------

function checkIfStageWon()
	--basically, are conditions met? return true or false
end

function stageWon()
	--play sfx? other animations?
	
	--increment score (+=timer*something)
end

function stageLost()
	--game-over stuff... toggle state?
end

function newStage()	
	--change creator's desires
	
	--reset timer
end

function newDesires(numPositive, numNegative)
	--shuffle array of all 9 attributes

	
end

-- function newDesire()
-- 	--choose
-- end

function newCard()
end

function moveStars(dt)
	--move each left by dt * 1/distance
	for i = 1, 100 do
		stars[i].x = stars[i].x - stars[i].speed * dt
		
		if stars[i].x < 0 then
			--reboot
			local distance = math.random(1, 200)
			stars[i] = {x = gameCanvasWidth + 1, y = math.random(1, gameCanvasHeight), brightness = 256 - distance, speed = (200 - distance) / 4}
		end
	end
end