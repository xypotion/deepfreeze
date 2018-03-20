--Copyright Max Wunderlich, August 22, 2016

function love.load()
	math.randomseed(os.time())
	
	screenHeight = 600
	screenWidth = 800
	horizPadding = screenHeight / 10
	vertPadding = screenWidth / 10
	
	love.window.setMode(screenWidth, screenHeight)
	
	minLineDistance = 4 --TODO make this slightly random when applied? min 2?
	
	love.window.setTitle("Find the square!")
	love.graphics.setFont(love.graphics.newFont(18)) -- apparently 21px high with 1px line spacing. weird, huh?
		
	rights = 0
	-- score = 0
	wrongs = 0
	wrongsThisStage = 0
	message = "Find the square!\nClick two opposite corners of a rectangle to select it."
	wrongSquares = {}

	difficulty = 1
	difficultyInflater = 2
	currentLevel = setUpLevel(difficulty + difficultyInflater)
	
	hoveredPoint = {x=-10, y=-10}
	selectedPoint = nil
	blink = 0
	-- levelTransition = 0 --TODO maybe later
	paused = false
end

function love.draw()
	--draw bg
	love.graphics.setColor(currentLevel.bgColor.r, currentLevel.bgColor.g, currentLevel.bgColor.b)
	love.graphics.rectangle("fill", 0, 0, screenWidth, screenHeight)
	
	--draw "wrong squares"
	for i = 1, #wrongSquares do
		local ws = wrongSquares[i]
		love.graphics.setColor(ws.color.r, ws.color.g, ws.color.b, ws.color.a)
		love.graphics.rectangle("fill", ws.x, ws.y, ws.w, ws.h)
	end
	
	--draw vertical & horizontal lines
	love.graphics.setColor(0, 0, 0)
	for i=1, #currentLevel.vert, 1 do
		love.graphics.rectangle("fill", currentLevel.vert[i], 0, 1, screenHeight)
	end
	
	for i=1, #currentLevel.horiz do
		love.graphics.rectangle("fill", 0, currentLevel.horiz[i], screenWidth, 1)
	end
	
	--draw hovered & selected vertex circles
	love.graphics.setColor(255,0,0,127)
	love.graphics.circle("fill", hoveredPoint.x, hoveredPoint.y, 6)
	
	if selectedPoint and (blink > 0.125 or paused) then
		love.graphics.circle("fill", selectedPoint.x, selectedPoint.y, 6)
	end
	
	--draw preview square
	if selectedPoint then
		love.graphics.setColor(255,0,0,127)
		love.graphics.rectangle("fill", selectedPoint.x, selectedPoint.y, hoveredPoint.x - selectedPoint.x + 1, hoveredPoint.y - selectedPoint.y + 1)
	end
	
	--draw message & scores
	love.graphics.setColor(0,0,0)
	love.graphics.print(message, 10, screenHeight - 53)
	
	if rights > 0 or wrongs > 0 then
		love.graphics.print("Right: "..rights.."\nWrong: "..wrongs.." (this stage: "..wrongsThisStage..")", 10, 10)
	end
	
	--draw pause overlay
	if paused then
		love.graphics.setColor(0,0,0,127)
		love.graphics.rectangle("fill", 0, 0, screenWidth, screenHeight)
		
		love.graphics.setColor(255,255,255)
		love.graphics.printf(
			"GAME PAUSED\n\n\n\nPress ESC to quit, or any other key to resume.\n\n\n\nMade with LÖVE\nby Max Wunderlich\n@xypotion", 
			0, screenHeight / 2 - 125, screenWidth, "center"
		)
	end
end

function love.keypressed(key)
	if paused then
		if key == "escape" then
			love.event.quit()
		else
			paused = false
		end
	else
	  paused = true
	
		-- debug ~~
		-- if key == "space" then
		-- 	difficulty = difficulty + 1
		-- 	currentLevel = setUpLevel(difficulty)
		-- end
	end
end

function love.update(dt)
	if paused then return end
	
	--find mouse pos
	local x, y = love.mouse.getPosition()
	
	--then find nearest intersection to "snap" hover-point to. x component first...
	local min = screenWidth + screenHeight
	local mindex = 0
	for i = 1, #currentLevel.vert do
		if math.abs(min) > math.abs(x - currentLevel.vert[i]) then
			min = x - currentLevel.vert[i]
			mindex = i
		end
	end
	hoveredPoint["x"] = currentLevel.vert[mindex]
	
	--...then y component
	min = screenWidth + screenHeight
	mindex = 0
	for i = 1, #currentLevel.horiz do
		if math.abs(min) > math.abs(y - currentLevel.horiz[i]) then
			min = y - currentLevel.horiz[i]
			mindex = i
		end
	end	
	hoveredPoint["y"] = currentLevel.horiz[mindex]
	
	--u_u o_o u_u o_o
	blink = (blink + dt) % 0.25
end

function love.mousepressed(x, y)
	if selectedPoint then
		if selectedPoint.x == hoveredPoint.x and selectedPoint.y == hoveredPoint.y then
			--you're clicking the same spot, so undo it
			selectedPoint = nil--{x = -10, y = -10}
		elseif selectedPoint.x ~= hoveredPoint.x and selectedPoint.y ~= hoveredPoint.y then --BOTH different
			--you have a point selected already and now you're clicking a different one, so that means you're making a guess!
			guess()
		else
			--you're only making a line since the x or y distance is 0; do nothing
		end
	else
		--set new selected point
		selectedPoint = {x = hoveredPoint.x, y = hoveredPoint.y}
	end
end

---------------------------------------------------------------------------------------------------------------------------------------------------------

function setUpLevel(difficulty)
	local level = {
		horiz = {}, 
		vert = {},
		bgColor = randomPastel()
	}
	
	--fill it with lines
	for i = 1, difficulty do
		level.vert[i] = math.random(screenWidth - horizPadding * 2) + horizPadding
	end
	table.sort(level.vert)
	
	for i = 1, difficulty do
		level.horiz[i] = math.random(screenHeight - vertPadding * 2) + vertPadding
	end
	table.sort(level.horiz)
	--"why loop twice instead of once?" a: because i wanted there to be different numbers of horizontal and vertical lines at one point. harmless to leave as-is
	
	--alternate method that snaps all lines to a bigger grid, if you want to make the game easier
	-- local cap = (screenWidth - horizPadding * 2) / minLineDistance
	-- for i = 1, difficulty do
	-- 	level.vert[i] = math.random(cap) * minLineDistance + horizPadding
	-- end
	-- table.sort(level.vert)
	--
	-- cap = (screenHeight - vertPadding * 2) / minLineDistance
	-- for i = 1, difficulty do
	-- 	level.horiz[i] = math.random(cap) * minLineDistance + vertPadding
	-- end
	-- table.sort(level.horiz)
	
	--adjust lines that were spawned too near each other. also eliminate dupes!
	nudgeDuplicates(level)
	
	--any squares? if not, make one
	findOrMakeASquare(level)
	
	return level
end

--makes line arrangements a little neater by forcing them to respect minLineDistance if they were spawned too close together
function nudgeDuplicates(level)
	--verts first
	local imperfect = true --(what's elegant code? who cares?)
	while imperfect do
		imperfect = false
		for i = 1, #level.vert - 1 do
			if level.vert[i + 1] - level.vert[i] < minLineDistance then
				--two lines found UNACCEPTABLY close together
				imperfect = true
				level.vert[i + 1] = level.vert[i] + minLineDistance
			end
		end
	end
	
	--repeat for horiz
	imperfect = true --(guilty until proven innocent)
	while imperfect do
		imperfect = false
		for i = 1, #level.horiz - 1 do
			if level.horiz[i + 1] - level.horiz[i] < minLineDistance + 1 then
				imperfect = true
				level.horiz[i + 1] = level.horiz[i] + minLineDistance + 1
			end
		end
	end
end

--first looks to see if there's already a square somewhere by comparing ALL horizontal differences to ALL vertical distances
--if no square was generated naturally, then turn an almost-square into a square by moving one vertical line to the left or right
--note: this surprisingly never undoes the neat-spacing work of nudgeDuplicates, as far as i've seen. not sure how that's possible, but yay!	
function findOrMakeASquare(level)
	--find and store all the distances between all pairs of VERTICAL lines
	local vDiffs = {}
	for i = 1, #level.vert do
		for j = i + 1, #level.vert do
			--store the distance between vertical lines i and j, as well as those indices (for making an adjustment later, if necessary)
			table.insert(vDiffs, {level.vert[j] - level.vert[i], i, j})
		end
	end
	
	-- now compare all the distances between all pairs of HORIZONTAL lines to the previously stored VERTICAL distances
	local minDiff = {screenWidth + screenHeight}
	for i = 1, #level.horiz do
		for j = i + 1, #level.horiz do
			for k = 1, #vDiffs do
				--is the distance between horizonal lines i and j the same as previously found distance k?
				if vDiffs[k][1] == level.horiz[j] - level.horiz[i] then
					--yes, we found a square! and we're done here.
					return
				else
					--no, but how close are we to having a square? store that value for later, in case we don't find any squares!
					if math.abs(minDiff[1]) > math.abs((level.horiz[j] - level.horiz[i]) - vDiffs[k][1]) then
						minDiff = {level.horiz[j] - level.horiz[i] - vDiffs[k][1], vDiffs[k]}
					end
				end
			end
		end
	end
	--...this probably could have been done in a quadruple for-loop, but it was making my head spin. TODO maybe try again? might be more efficient?
	
	--adjust that special vertical line by subtracting the min diff
	level.vert[minDiff[2][2]] = level.vert[minDiff[2][2]] - minDiff[1]
end

function guess()
	--get dimensions of your guess
	local width = selectedPoint.x - hoveredPoint.x
	local height = selectedPoint.y - hoveredPoint.y
	
	--is it a square?	
	if math.abs(width) == math.abs(height) then
		--winner! on to the next stage
		-- score = math.ceil(score + difficulty * 100 / (wrongsThisStage + 1))
		-- print("Score: "..score)

		rights = rights + 1
		wrongSquares = {}
		wrongsThisStage = 0

		difficulty = difficulty + 1
		currentLevel = setUpLevel(difficulty + difficultyInflater)
		
		message = "Found it!\nCurrent stage: "..(difficulty)
		
		--TODO transitions?
	else
		--nope, guess again
		wrongs = wrongs + 1
		wrongsThisStage = wrongsThisStage + 1

		if math.abs(width) > math.abs(height) then
			message = "Too wide.\nThat rectangle was "..math.abs(width).." x "..math.abs(height).." pixels."
		else
			message = "Too tall.\nThat rectangle was "..math.abs(width).." x "..math.abs(height).." pixels."
		end
		
		table.insert(wrongSquares, {
			color = randomPastel(192),
			x = selectedPoint.x, 
			y = selectedPoint.y, 
			w = hoveredPoint.x - selectedPoint.x + 1,
			h = hoveredPoint.y - selectedPoint.y + 1
		})
		
		--TODO error message? buzzer?
	end
	
	--either way,
	selectedPoint = nil
end

function randomPastel(alpha)
	if not alpha then alpha = 255 end
	
	return {
		r = 192 + math.random(64),
		g = 192 + math.random(64),
		b = 192 + math.random(64),
		a = alpha
	}
end