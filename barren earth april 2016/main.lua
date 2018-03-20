function love.load()
	math.randomseed(os.time())
	
	noMatchChar = " "
	wildChar = "*"
	balanceChar = "&"
	
	materials = {"A", "V", "M", wildChar}
	domains = {"L", "S", "I", wildChar}
	modes = {"C", "P", "D", wildChar}
	
	cardSize = 65
	previewOn = true
	
	love.graphics.setFont(love.graphics.newFont(20))
	
	-- testRecursion()
	
	--test cases
	compareAttributes("a", "b", "c") -- balance
	compareAttributes("a", "a", "b") -- no match
	compareAttributes("a", "b", "a") -- no match
	compareAttributes("b", "a", "a") -- no match
	compareAttributes("a", "a", "a") -- a
	compareAttributes("a", "a", "*") -- a
	compareAttributes("a", "b", "*") -- balance
	compareAttributes("a", "b", "c", "a", "b", "c") -- balance
	compareAttributes("a", "b", "c", "a", "b") -- balance
	compareAttributes("a", "*", "*") -- a
	compareAttributes("*", "*", "*") -- wild
	compareAttributes("*", "*", "b") -- b
	
	matchLines = {
		-- row1 = {point1 = {x=1, y=1}, point2 ={x=3, y=1}, magnitude = 0},
		-- row2 = {point1 = {x=1, y=2}, point2 ={x=3, y=2}, magnitude = 0},
		-- row3 = {point1 = {x=1, y=3}, point2 ={x=3, y=3}, magnitude = 0},
		-- col1 = {point1 = {x=1, y=1}, point2 ={x=1, y=3}, magnitude = 0},
		-- col2 = {point1 = {x=2, y=1}, point2 ={x=2, y=3}, magnitude = 0},
		-- col3 = {point1 = {x=3, y=1}, point2 ={x=3, y=3}, magnitude = 0},
		-- diag1 = {point1 = {x=1, y=1}, point2 ={x=3, y=3}, magnitude = 0}, -- \
		-- diag2 = {point1 = {x=1, y=3}, point2 ={x=3, y=1}, magnitude = 0}	-- /
		
		-- {point1 = {x=1, y=1}, point2 = {x=3, y=1}, magnitude = 0},
		-- {point1 = {x=1, y=2}, point2 = {x=3, y=2}, magnitude = 0},
		-- {point1 = {x=1, y=3}, point2 = {x=3, y=3}, magnitude = 0},
		-- {point1 = {x=1, y=1}, point2 = {x=1, y=3}, magnitude = 0},
		-- {point1 = {x=2, y=1}, point2 = {x=2, y=3}, magnitude = 0},
		-- {point1 = {x=3, y=1}, point2 = {x=3, y=3}, magnitude = 0},
		-- {point1 = {x=1, y=1}, point2 = {x=3, y=3}, magnitude = 0}, -- \
		-- {point1 = {x=1, y=3}, point2 = {x=3, y=1}, magnitude = 0}	-- /
		
		{point1 = {x=1 * cardSize, y=1 * cardSize}, point2 = {x=3 * cardSize, y=1 * cardSize}, magnitude = 0},
		{point1 = {x=1 * cardSize, y=2 * cardSize}, point2 = {x=3 * cardSize, y=2 * cardSize}, magnitude = 0},
		{point1 = {x=1 * cardSize, y=3 * cardSize}, point2 = {x=3 * cardSize, y=3 * cardSize}, magnitude = 0},
		{point1 = {x=1 * cardSize, y=1 * cardSize}, point2 = {x=1 * cardSize, y=3 * cardSize}, magnitude = 0},
		{point1 = {x=2 * cardSize, y=1 * cardSize}, point2 = {x=2 * cardSize, y=3 * cardSize}, magnitude = 0},
		{point1 = {x=3 * cardSize, y=1 * cardSize}, point2 = {x=3 * cardSize, y=3 * cardSize}, magnitude = 0},
		{point1 = {x=1 * cardSize, y=1 * cardSize}, point2 = {x=3 * cardSize, y=3 * cardSize}, magnitude = 0}, -- \
		{point1 = {x=1 * cardSize, y=3 * cardSize}, point2 = {x=3 * cardSize, y=1 * cardSize}, magnitude = 0},	-- /
		
		-- row1 = initLine(0, 0, 3, 0,  1, 1, 1, 2, 1, 3),
		-- row2 = initLine(0, 1, 3, 1,  1, 1, 1, 2, 1, 3),
		-- row3 = initLine(0, 2, 3, 2,  1, 1, 1, 2, 1, 3), -- make x and y order consistent, for gods' sakes
		--ugh, data entry. metacontent. move to a file or what?
	}
	
	-- print(matchLines[8].point1.y)
	
	-- hand = {}
	-- cardsInHand = 0
	-- for i = 1, 9 do
	-- 	hand[i] = makeCard()
	-- 	-- print("card #"..i..": "..hand[i].material.." "..hand[i].domain.." "..hand[i].mode)
	-- 	cardsInHand = cardsInHand + 1
	-- end
	
	grid = {}
	for i = 1, 3 do
		grid[i] = {}
		for j = 1, 3 do
			grid[i][j] = makeCard()
		end
	end
end

function love.update(dt)
	mx, my = love.mouse.getPosition()
	mx = math.floor(mx / cardSize)
	my = math.floor(my / cardSize)
end

function love.draw()
	-- for i = 1, cardsInHand do
	-- 	drawCard(hand[i], i * 65, 65 * (i % 3))
	-- end

	for i = 1, 3 do
		for j = 1, 3 do
			--is mouse over this card?
			if my == i and mx == j then
				love.graphics.setColor(255, 255, 255)
			else
				love.graphics.setColor(128, 128, 128)
			end
			
			drawCard(grid[i][j], j * 65, i * 65)
		end
	end
	
	-- love.graphics.setColor(255, 255, 0)
	if previewOn then
		for i = 1, table.getn(matchLines) do
			local l = matchLines[i]
			love.graphics.setColor(255, 255, 0, l.magnitude * 255)
			love.graphics.line(
				l.point1.x + cardSize / 2, l.point1.y + cardSize / 2, 
				l.point2.x + cardSize / 2, l.point2.y + cardSize / 2) --TODO math elsewhere
		end
	end
	
	love.graphics.setColor(255, 255, 0, 255)
	love.graphics.print("Press SPACE to calculate matches. Press P to toggle preview.", 30, 400)
	-- love.graphics.print("mx = "..mx.." my = "..my, 30, 500) -- DEBUG
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
	
	if key == "space" then
		find3x3Matches()
	end
	
	if key == "p" then
		previewOn = not previewOn
	end
end

---------------------------------------------------------------------------------------------------------

function makeCard()
	local card = {}
	card.material = materials[math.ceil(math.random(10) / 3)]
	card.domain = domains[math.ceil(math.random(10) / 3)]
	card.mode = modes[math.ceil(math.random(10) / 3)]
	
	return card
end

function drawCard(card, x, y)
	love.graphics.rectangle("line", x, y, 55, 55)
	love.graphics.print(card.mode, x + 20, y + 5)
	love.graphics.print(card.material, x + 5, y + 30)
	love.graphics.print(card.domain, x + 35, y + 30)
end

function find3x3Matches()
	-- a, b, c = findModeMaterialDomainForThreeCards(grid[1][1], grid[1][2], grid[1][3]); print(a.." "..b.." "..c)
	
	print("top row: ",findModeMaterialDomainForThreeCards(grid[1][1], grid[1][2], grid[1][3]))
	print("mid row: ",findModeMaterialDomainForThreeCards(grid[2][1], grid[2][2], grid[2][3]))
	print("btm row: ",findModeMaterialDomainForThreeCards(grid[3][1], grid[3][2], grid[3][3]))
	print()
	print("left col:  ",findModeMaterialDomainForThreeCards(grid[1][1], grid[2][1], grid[3][1]))
	print("mid col:   ",findModeMaterialDomainForThreeCards(grid[1][2], grid[2][2], grid[3][2]))
	print("right col: ",findModeMaterialDomainForThreeCards(grid[1][3], grid[2][3], grid[3][3]))
	print()
	print("diag \\: ",findModeMaterialDomainForThreeCards(grid[1][1], grid[2][2], grid[3][3]))
	print("diag /: ",findModeMaterialDomainForThreeCards(grid[1][3], grid[2][2], grid[3][1]))
	
	-- change line magnitudes
	-- print("top row: ",findModeMaterialDomainForThreeCards(grid[1][1], grid[1][2], grid[1][3])) -- put these cards in the line data themselves
	-- print("mid row: ",findModeMaterialDomainForThreeCards(grid[2][1], grid[2][2], grid[2][3]))
	-- print("btm row: ",findModeMaterialDomainForThreeCards(grid[3][1], grid[3][2], grid[3][3]))
	-- print()
	-- print("left col:  ",findModeMaterialDomainForThreeCards(grid[1][1], grid[2][1], grid[3][1]))
	-- print("mid col:   ",findModeMaterialDomainForThreeCards(grid[1][2], grid[2][2], grid[3][2]))
	-- print("right col: ",findModeMaterialDomainForThreeCards(grid[1][3], grid[2][3], grid[3][3]))
	-- print()
	-- print("diag \\: ",findModeMaterialDomainForThreeCards(grid[1][1], grid[2][2], grid[3][3]))
	-- print("diag /: ",findModeMaterialDomainForThreeCards(grid[1][3], grid[2][2], grid[3][1]))
end

function findModeMaterialDomainForThreeCards(card1, card2, card3)
	
	local mode = compareAttributes(card1.mode, card2.mode, card3.mode)
	-- local mode = card1.mode
	-- if mode ~= card2.mode or mode ~= card3.mode then
	-- 	mode = noMatchChar
	-- end
	--
	local material = compareAttributes(card1.material, card2.material, card3.material)
	-- local material = card1.material
	-- if material ~= card2.material or material ~= card3.material then
	-- 	material = noMatchChar
	-- end
	--
	local domain = compareAttributes(card1.domain, card2.domain, card3.domain)
	-- local domain = card1.domain
	-- if domain ~= card2.domain or domain ~= card3.domain then
	-- 	domain = noMatchChar
	-- end
	
	-- print(mode, material, domain)
	
	return mode, material, domain
end

-- somewhat inelegant, and doesn't allow for true wild behavior. correct way is to replace wilds with all possible values, then take the best
function compareAttributes(...)
	local nonWilds = {}
	local counts = {}
	local result = wildChar
	
	-- weed out wilds; if ALL wild, result will stay as wildChar
	for k, v in pairs{...} do
		if v ~= wildChar then
			table.insert(nonWilds, v)
			result = v
			
			--keep count of how many of each type you found, for checking balance later
			if counts[v] then
				counts[v] = counts[v] + 1
			else
				counts[v] = 1
			end
		end
	end
	
	-- result is now equal to the last non-wild attribute in ...; are they all the same?
	for i = 1, table.getn(nonWilds) - 1 do
		if result ~= nonWilds[i] then
			result = noMatchChar
		end
	end
	
	-- if no match, maybe eligible for a "balance" match
	if result == noMatchChar then
		local watermark = counts[nonWilds[1]]
		local balanceEligible = true
		
		for k, v in pairs(counts) do
			if balanceEligible and v ~= watermark then
				balanceEligible = false
			end
		end
		
		if balanceEligible then
			result = balanceChar
		end
	end
	
	-- print("returning "..result)
	
	return result
end

-- match testcases
--[[

aaa = a
aab = .
aa* = a
ab* = .
a** = a
*** = *

result = .

if a == * and b == * and c == * then
  result = *
end

if a == b and a == c then
	result = a
end

]]

function testRecursion()
	-- compareAttributesWithRecursion()
	-- compareAttributesWithRecursion(0)
	-- compareAttributesWithRecursion(0,0)
	
	look = "asfdfssdfggsr"
	print(look:sub(4,4))
	
	compareAttributesWithRecursion({"a", "a", "a"})
	compareAttributesWithRecursion({"a", "a", "abc"})
end

function compareAttributesWithRecursion(attributes)--, start, results)
	start = start or 1
	results = results or {}
	-- print(start)
	
	-- for i = start, table.getn(att) do
		--lol, what am i doing?
		--stop and pseudocode this, it's more complex than you thought
	-- end
	
	candidates = {}
	insertCandidate(candidates, attributes, 1)
end

function insertCandidate(candidates, raw, pos)
	-- local current = split(raw[pos])
	for i = 1, string.len(raw[pos]) do
		table.insert(candidates, {raw[pos]:sub(i,i)..insertCandidate(candidates, raw, pos + 1)})
	end
end

--you still don't know what the fuck you're doing with recursion. above is good enough, look again later.

--...ok, you don't actually need to use recursion unless there are multiple wilds. it's like: construct each potential result piece by piece, when you hit a wild, ... ugh. would an example be clearer?
--[[

given: 
	potential evaluations: a, v, m, avme
	ranks: e = 2, a = 1, v = 1, m = 1, balance = 0
input: aav

]]

-- way to lose interest, smart boy