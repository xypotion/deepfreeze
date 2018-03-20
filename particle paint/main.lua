--this is now Particle Paint! i'm hacking my homebrew particle engine into a painting program as a birthday present for a friend. :)
--TODO better undoing
--TODO   starting animation (present) -> reveal tools, music, canvas/art, maybe some pixels
--TODO   spinning particles
--TODO   brahne's face changing *as particles are added*

require 'modules/particleTEST'
require 'modules/homebrewParticles'

require 'scripts/spellAnimations'
require 'scripts/metaParticles'

function love.load()
	--math always comes first
	ONE_THIRD = 1/3
	TWO_THIRDS = ONE_THIRD * 2

	math.randomseed(os.time())
	
	--basics
	minW, minH = 946, 600
	love.graphics.setBackgroundColor(31,63,31)
	love.graphics.setNewFont(16)
	
	love.window.setTitle("Picking You Aparticle")
	
	--music
	theme = love.audio.newSource("07.mp3", "static")
	love.audio.play(theme)
		
	--canvas setup
	paintCanvasWidth = 800
	paintCanvasHeight = 600
	paintCanvas = love.graphics.newCanvas(canvasWidth, canvasHeight)

	toolCanvasWidth = 146
	toolCanvasHeight = 600
	toolCanvas = love.graphics.newCanvas(toolCanvasWidth, toolCanvasHeight)
	
	resizeWindowToScale(paintCanvasWidth + toolCanvasWidth, paintCanvasHeight)
	
	--images
	toolbar = love.graphics.newImage("img/UI.png")
	colors = love.graphics.newImage("img/colors.png")
	lightness = love.graphics.newImage("img/lightness.png")

	brahnes = {
		love.graphics.newImage("img/aroused.png"),
		love.graphics.newImage("img/elated.png"),
		love.graphics.newImage("img/enraged.png"),
		love.graphics.newImage("img/excited.png"),
		love.graphics.newImage("img/impatient.png"),
		love.graphics.newImage("img/offended.png"),
		love.graphics.newImage("img/pleased.png"),
		love.graphics.newImage("img/upset.png"),
	}
	-- randomizeBrahne()
	brahne = brahnes[8]
	
	stamps = {
		blood = love.graphics.newImage("img/blood.png"),
		cake = love.graphics.newImage("img/cake.png"),
		candle = love.graphics.newImage("img/candle.png"),
		corn = love.graphics.newImage("img/corn.png"),
		crow = love.graphics.newImage("img/crow.png"),
		dildo = love.graphics.newImage("img/dildo.png"),
		egg = love.graphics.newImage("img/egg.png"),
		eye = love.graphics.newImage("img/eye.png"),
		fan = love.graphics.newImage("img/fan.png"),
		fish = love.graphics.newImage("img/fish.png"),
		gardevoir = love.graphics.newImage("img/gardevoir.png"),
		gem = love.graphics.newImage("img/gem.png"),
		horse = love.graphics.newImage("img/horse.png"),
		kitten = love.graphics.newImage("img/kitten.png"),
		meat = love.graphics.newImage("img/meat.png"),
		sailormoon = love.graphics.newImage("img/sailormoon.png"),
		skull = love.graphics.newImage("img/skull.png"),
		snowflake = love.graphics.newImage("img/snow.png"),
		sparkle = love.graphics.newImage("img/sparkle.png"),
		spider = love.graphics.newImage("img/spider.png"),
		soap = love.graphics.newImage("img/soap.png"),
		sudowoodo = love.graphics.newImage("img/sudowoodo.png"),
		sword = love.graphics.newImage("img/sword.png"),
		sushi = love.graphics.newImage("img/sushi.png"),
		tooth = love.graphics.newImage("img/tooth.png"),
		udon = love.graphics.newImage("img/udon.png"),
		hadouken = love.graphics.newImage("img/hadouken.png"),
	}
	--...i realize how dumb and ineffecient this is. don't judge me. #hacking

	arts = {}
	intro = love.graphics.newImage("img/intro.png")

	local files = love.filesystem.getDirectoryItems("img/smallarts")
	for i, file in ipairs(files) do
		print(file)
		arts[i] = love.graphics.newImage("img/smallarts/"..file)
	end

	--other drawing stuff
	-- bgColor = {r=255, g=255, b=255, a=255}
	bgImage = intro
	brushColor = {r=255, g=255, b=255, a=255}
	
	--animation/misc
	paused = false
	
	INTERVAL = 0.01
	counter = 0
	
	musicTimer = 0
	
	--some tool UI stuff
	-- toolMode = "brushes" --"color"
	toolHighlightBox = {x=98, y=260}
	-- colorBrightness = {r=255, g=255, b=255, a=255}
	colorPickerOverlay = {rgb = 0, a = 0}
	
	initParticleTEST()
	
	initParticleSystem()

	
	started = true
		-- newParticleLayer()
		brush = makeMetaParticle("random tame")
end

function love.update(dt)
	musicTimer = musicTimer + dt
	if musicTimer >= 113 then
		theme:rewind()	
		love.audio.play(theme)
		musicTimer = musicTimer % 113
	end
	
	if paused then
		return
	elseif started then
		mouseX, mouseY = love.mouse.getPosition()
		
		--add particles ~
		counter = counter + dt
		if mouseX > 146 and love.mouse.isDown(1) and counter > INTERVAL then
			addParticle(mouseX - toolCanvasWidth, mouseY, brush)
			counter = counter % INTERVAL
		end
	
		--update & remove dead particles
		updateParticles(dt)
	end
end

function love.draw()
	--switch to paint canvas
  love.graphics.setCanvas(paintCanvas)
	love.graphics.clear()
	
	--bg rectangle
	love.graphics.draw(bgImage, 0, 0)
	
	--particles
	drawParticles()
	
	--draw it
	love.graphics.setColor(255, 255, 255, 255)
  love.graphics.setCanvas()
  love.graphics.draw(paintCanvas, toolCanvasWidth, 0, 0)
	
	------------------------------------------
	
	--switch to tool canvas
  love.graphics.setCanvas(toolCanvas)
	love.graphics.clear()
	
	--bg rectangle
	love.graphics.setColor(0, 0, 0, 255)
	love.graphics.rectangle("fill", 0, 0, toolCanvasWidth, toolCanvasHeight)
	
	--toolbox
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(toolbar, 0, 0)
	
	--TODO draw white box outline on current tool
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.rectangle("line", toolHighlightBox.x, toolHighlightBox.y, 48, 34)

	--current color
	love.graphics.setColor(brushColor.r, brushColor.g, brushColor.b, 255)
	love.graphics.rectangle("fill", 0, 0, 146, 142)
	love.graphics.setColor(255, 255, 255, 255)
	
	--her majesty's face
	love.graphics.draw(brahne, 9, 5)
	--draw it
  love.graphics.setCanvas()
  love.graphics.draw(toolCanvas, 0, 0, 0)
	
	------------------------------------------
	
	--draw pause overlay
	if paused then
		love.graphics.setColor(0, 0, 0, 127)
		love.graphics.rectangle("fill", 0, 0, paintCanvasWidth + toolCanvasWidth, paintCanvasHeight)

		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.printf("Particles: "..#particles, 0, paintCanvasHeight * ONE_THIRD, paintCanvasWidth, "center")
	end
	
	--file announcement
	if announcement then
		love.graphics.setColor(31, 31, 191, 255)
		love.graphics.rectangle("fill", 146, 0, 800, 150)
		
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.rectangle("line", 146, 0, 800, 150)
		
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.printf(announcement, 156, 10, 580 + 146)
	end
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
end

function love.mousepressed(x, y, button)	
	announcement = false
	
	if started then
		if x <= 146 then
			randomizeBrahne()
			-- removeLayer()
			
			if y <= 146 then
				--brahne.
				print("brahne")
				-- randomizeBackground()
				
			elseif y > 146 and y < 225 then
				--colors.
				brushColor = getPaintColor(x, y)
				setBrushColor()
			elseif y > 226 then
				--tools!
				tool = getTool(x, y)
				print(tool)
				
				toolHighlightBox = {
					x = math.floor(x/49) * 49, 
					y = math.floor((y - 226)/34) * 34 + 226,
				}
			end
		-- else
		-- 	if tool == "paint bucket" then
		-- 		toolMode = "colors"
		-- 	end
		
		-- else
		-- 	newParticleLayer()
		end
	else
		--opening present
		started = true
		print("started!")
		-- newParticleLayer()
		brush = makeMetaParticle("random tame")
	end
end

function love.mousereleased(x, y, button)
	if started and x > 146 then
		--freeze current layer & add another
		newParticleLayer()
		print("new layer added")
	end
end

function setBrushColor()			
	brush.variable.r = {min = brushColor.r, var = 0}
	brush.variable.g = {min = brushColor.g, var = 0}
	brush.variable.b = {min = brushColor.b, var = 0}
	brush.variable.a = {min = brushColor.a, var = 0}
end

function resizeWindowToScale(w, h)
	love.window.setMode(w, h, {
		resizable = false,
		minwidth = minW,
		minheight = minH
	})
end

--save image!
function saveImage()
	local pic = paintCanvas:newImageData()
	
	local filename = "pic"..os.time()..".png"
	-- local file = love.filesystem.newFile(filename)
  local filedata = pic:encode("png", filename)
	
	local success = love.filesystem.write(filename, filedata)
	
	print(love.filesystem.getSaveDirectory().."/"..filename, success)
	
	announcing = true
	announcement = "Image saved as "..filename.."\n\nLocation: "..love.filesystem.getSaveDirectory()
	if brahne == brahnes[1] or brahne == brahnes[2] or brahne == brahnes[4] or brahne == brahnes[7] then
		announcement = announcement.."\n\nQueen Brahne was impressed."
	else
		announcement = announcement.."\n\nQueen Brahne was not impressed."
	end
end

------------------------------------------------------------------------------------------------------------------------------------
--UI stuff

function getTool(x, y)
	local tool = ""
	
	toolW = 49
	toolH = 34
	toolTop = 226
	
	if x < toolW * 1 then
		if y < toolTop + toolH * 1 then
			tool = "pencil"
			brush = makeMetaParticle("pencil")
		elseif y < toolTop + toolH * 2 then
			tool = "eraser"
			undo()
		elseif y < toolTop + toolH * 3 then
			tool = "corn"
		elseif y < toolTop + toolH * 4 then
			tool = "egg"
		elseif y < toolTop + toolH * 5 then
			tool = "gardevoir"
		elseif y < toolTop + toolH * 6 then
			tool = "gem"
		elseif y < toolTop + toolH * 7 then
			tool = "horse"
		elseif y < toolTop + toolH * 8 then
			tool = "skull"
		elseif y < toolTop + toolH * 9 then
			tool = "spider"
		elseif y < toolTop + toolH * 10 then
			tool = "cake"
		elseif y < toolTop + toolH * 11 then
			tool = "sword"
		end
	elseif x < toolW * 2 then
		if y < toolTop + toolH * 1 then
			tool = "disk"
			saveImage()
		elseif y < toolTop + toolH * 2 then
			tool = "easel"
			clearAll()
		elseif y < toolTop + toolH * 3 then
			tool = "candle"
		elseif y < toolTop + toolH * 4 then
			tool = "dildo"
		elseif y < toolTop + toolH * 5 then
			tool = "fan"
		elseif y < toolTop + toolH * 6 then
			tool = "eye"
		elseif y < toolTop + toolH * 7 then
			tool = "kitten"
		elseif y < toolTop + toolH * 8 then
			tool = "snowflake"
		elseif y < toolTop + toolH * 9 then
			tool = "sudowoodo"
		elseif y < toolTop + toolH * 10 then
			tool = "soap"
		elseif y < toolTop + toolH * 11 then
			tool = "sushi"
		end
	elseif x < toolW * 3 then
		if y < toolTop + toolH * 1 then
			tool = "random tame"
		elseif y < toolTop + toolH * 2 then
			tool = "painting"
			randomizeBackground()
		elseif y < toolTop + toolH * 3 then
			tool = "blood"
		elseif y < toolTop + toolH * 4 then
			tool = "tooth"
		elseif y < toolTop + toolH * 5 then
			tool = "sparkle"
		elseif y < toolTop + toolH * 6 then
			tool = "fish"
		elseif y < toolTop + toolH * 7 then
			tool = "hadouken"
		elseif y < toolTop + toolH * 8 then
			tool = "sailormoon"
		elseif y < toolTop + toolH * 9 then
			tool = "crow"
		elseif y < toolTop + toolH * 10 then
			tool = "meat"
		elseif y < toolTop + toolH * 11 then
			tool = "udon"
		end
	end
	
	--now what?
	if tool == "eraser" or tool == "disk" or tool == "easel" or tool == "painting" then
		--no op
	else
		--make stamp brush!
			brush = makeMetaParticle(tool)
				setBrushColor()
	end
	
	return tool
end

function getPaintColor(x, y)
	local c = {r=0, g=0, b=0, a=0}
	local iData = toolCanvas:newImageData()
	
	c.r, c.g, c.b, c.a = iData:getPixel(x, y)
	
	return c
end

function setColorPickerLightness(x)
	if x > 0 and x <= 73 then
		colorPickerOverlay = {rgb = 0, a = (73 - x) / 73}
		print("dark")
	else
		colorPickerOverlay = {rgb = 255, a = (146 - x) / 73}
		print("light")
	end
end

function randomizeBackground()
	--pick random image
	bgImage = arts[math.random(#arts)]
	
	-- bgColor = {r=math.random(256), g=math.random(256), b=math.random(256), a=255}
end

function randomizeBrahne()
	brahne = brahnes[math.random(#brahnes)]
end

function removeLayer()
	undo()
end

function undo()
	print("undoing")
	table.remove(allParticles)
	print(#allParticles)
end

function clearAll()
	allParticles = {}
	newParticleLayer()
end