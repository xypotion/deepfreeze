function love.load()
	math.randomseed(os.time())
	
	love.graphics.setNewFont(16)
	
	colors = {}
	for i = 0, 100 do
		colors[i] = {math.random(256), math.random(256), math.random(256)}
	end
	
	features = {
		"eye", "nose", "ear", "mouth"
	}
	
	bodyVertices = {64, 256, 64, 320, -64, 320, -64, 2000, 320, 2000, 320, 320, 192, 320, 192, 256}
	-- bodies = {}
	-- bodies.you = ...
	
	img = {
		eye = love.graphics.newImage("eye.png"),
		nose = love.graphics.newImage("nose.png"),
		ear = love.graphics.newImage("ear.png"),
		mouth = love.graphics.newImage("mouth.png"),
	}
	
	you = newPerson()
	them = newPerson()
	
	input = ""
	output = {"", true}
	log = {}
end

function love.draw()
	drawPerson(you, 100, 50, "right")
	
	drawPerson(them, 450, 50, "left")
	
	-- white()
	-- love.graphics.polygon("line", bodyVertices)
	
	--print input
	white()
	love.graphics.print("> "..input, 25, 500)
	
	
	for k, l in ipairs(log) do
		white()
		love.graphics.print("> "..l[1], 25, 300 + k * 32)
		
		if l[3] then
			green()
		else
			red()
		end
		love.graphics.print("\n"..l[2], 25, 300 + k * 32)
	end
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	elseif key == "return" then
		submit()
	elseif key == "=" then
		you = them
		them = newPerson()
	end
end

function love.textinput(text)
	input = input..text
end

function drawPerson(person, xOffset, yOffset, direction)
	setColor(person.skinColor)
	love.graphics.rectangle("fill", xOffset, yOffset, 256, 256, 10, 10)
	
	setDarkColor(person.skinColor)
	love.graphics.rectangle("line", xOffset, yOffset, 256, 256, 10, 10)
	love.graphics.line(xOffset + 128, yOffset, xOffset + 128, yOffset + 256)
	love.graphics.line(xOffset, yOffset + 128, xOffset + 256, yOffset + 128)
	
	black()
	if direction == "left" then
		drawFeature(person.face[1], xOffset, yOffset)
		drawFeature(person.face[2], xOffset, yOffset + 128)
		drawFeature(person.face[3], xOffset + 128, yOffset)
		drawFeature(person.face[4], xOffset + 128, yOffset + 128)
	else
		drawReverseFeature(person.face[1], xOffset, yOffset)
		drawReverseFeature(person.face[2], xOffset, yOffset + 128)
		drawReverseFeature(person.face[3], xOffset + 128, yOffset)
		drawReverseFeature(person.face[4], xOffset + 128, yOffset + 128)
	end
end

function drawFeature(f, x, y, c)
	love.graphics.draw(img[f], x, y, 0, 0.5, 0.5)
end	

function drawReverseFeature(f, x, y, c)
	love.graphics.draw(img[f], x + 128, y, 0, -0.5, 0.5)
end	

function setColor(c)
	love.graphics.setColor(colors[c][1], colors[c][2], colors[c][3])
end

function setDarkColor(c)
	love.graphics.setColor(colors[c][1] - 64, colors[c][2] - 64, colors[c][3] - 64)
end

function white()
	love.graphics.setColor(255, 255, 255)
end

function black()
	love.graphics.setColor(0, 0, 0)
end

function red()
	love.graphics.setColor(255, 0, 0)
end

function green()
	love.graphics.setColor(0, 255, 0)
end

function newPerson()
	return {
		face = {features[math.random(4)], features[math.random(4)], features[math.random(4)], features[math.random(4)]},
		skinColor = math.random(100),
		lineColor = math.random(100),
		featuresColor = math.random(100)
	}
end

function has(person, feature)
	local count = 0
	if person.face[1] == feature then count = count + 1 end
	if person.face[2] == feature then count = count + 1 end
	if person.face[3] == feature then count = count + 1 end
	if person.face[4] == feature then count = count + 1 end
	
	return count
end

function submit()
	--process input
	if input == "say" then
		if has(you, "mouth") > 0 then
			if has(them, "ear") > 0 then
				output = {"they heard you.", true}
			else
				output = {"they cannot hear you!", false}
			end
		else
			output = {"you have no mouth!", false}
		end
	elseif input == "sign" then
		if has(them, "eye") > 0 then
			output = {"they understood your sign language.", true}
		else
			output = {"they cannot see you!", false}
		end
	else
		output = {"you don't know how to <"..input..">.", false}
	end
	
	--log io
	table.insert(log, {input, output[1], output[2]})
	
	--clear input
	input = ""
end

function logPos(text)
end

function logNeg(text)
end

function logNeut(text)
end

function log(text, color)
end

function stackPush(t, item, limit)
	--TODO
end