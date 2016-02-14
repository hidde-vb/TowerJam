--[[
	This class holds the main loop of the game
]]--

State_Game = {}

function State_Game:create()
	local new = {}
	setmetatable(new,self)
	self.__index = self
	--this holds the bindings and name of the keys or buttons
	--						NAME		KEY		BUTTON		TYPE
	State_Game.bindings =  {--[[{"sample",	"",			3,		true },]]--
					   			{"Menu",	"escape",	10,		false},
					   			{"Attack",	"space",	10,		true },
					   			{"Enter",	"return",	10,		true },
					   			{"Test",	"q",    	10,		true }}

	-- Images
	background 	= love.graphics.newImage("Media/level.png")
	guiImage	= love.graphics.newImage("Media/gui.png")
	healthImage = love.graphics.newImage("Media/health.png")
	damageImage = love.graphics.newImage("Media/damage.png")

	-- Sounds
	flailSound  = love.sound.newSoundData("media/flail.wav",static)
	hitSound    = love.sound.newSoundData("media/hit.wav",static)
	damageSound = love.sound.newSoundData("media/damage.wav",static)
	killSound   = love.sound.newSoundData("media/kill.wav",static)

	-- Rooms
	room = {love.image.newImageData("Media/rooms/room1.png"),
			love.image.newImageData("Media/rooms/room2.png"),
			love.image.newImageData("Media/rooms/room3.png"),
			love.image.newImageData("Media/rooms/room4.png"),
			love.image.newImageData("Media/rooms/room5.png")}

	

	Upgrade:load()

	-- In game variables
	Door:init()
	pixelSize = 2
	tileSize = 16
	resx = love.graphics.getWidth()  / pixelSize
	resy = love.graphics.getHeight() / pixelSize
	canvas = love.graphics.newCanvas(resx, resy)

	self:reset()
	return new
end

function State_Game:update(dt)
	mouseX = math.floor(love.mouse.getX( )/pixelSize)
	mouseY = math.floor(love.mouse.getY( )/pixelSize)
	level:update(dt)
	if player.hp <= 0 then
		stateIndex = 4
		states[stateIndex]:reset()
	end
end

function State_Game:draw()
	-- Draw level
	love.graphics.setCanvas(canvas)
	love.graphics.clear( )
	love.graphics.draw(background)
	level:draw()
	love.graphics.draw(guiImage, 1, 250)
	for i=1, maxHealth do
		if i <= player.hp then
			love.graphics.draw(healthImage, i*5+1, 274)
		else
			love.graphics.draw(damageImage, i*5+1, 274)
		end
	end
	love.graphics.setColor(0,0,0)
	-- Draw GUI
	love.graphics.setFont(font_gui)
	love.graphics.print("Lvl: "..30-levelIndex, 4, 254)

	love.graphics.setCanvas()
	love.graphics.setColor(255,255,255)
	love.graphics.draw(canvas, 0, 0, 0, pixelSize)
	
end

function State_Game.nextLevel()
	levelIndex = levelIndex + 1
	print("ascending to level "..levelIndex..".")
	level = Level:create(levelIndex)
end
--input handling--
function State_Game:key(name, set)
	if 		name == "Menu" then
		stateIndex = 3
		states[stateIndex]:reset()
	elseif	name == "Attack" then
		flail:attack()
	-- DEBUG functions
	elseif	name == "Enter" then
		transition:go(self.nextLevel)
	elseif  name == "Test" then
		uSpeed:nextLevel()
	end
end

function State_Game:reset()
	levelIndex = -1;
	factory = Entity_Factory:create()
	player = factory:player(194, 32)
	maxHealth = player.hp
	timer_swirl = 0
	flail:create()
	effects:create()
--TODO intro animation
	self:nextLevel()
end

--unused input handling
function State_Game:movement(x,y)

end

function State_Game:mouse(x, y, mouseButton, pressed)

end
