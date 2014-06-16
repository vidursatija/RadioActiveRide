Coin = {}
Coin_mt = { __index = Coin }

local collectSound = audio.loadSound( "assets/sounds/star.wav" )

--- Constructs a new Coin object.
function Coin:new( parentGroup, params )

	local self = {}
	
	setmetatable( self, Coin_mt )

	-- Create the visual
	self._visual = display.newImage( parentGroup, "assets/images/star.png" )
	
	-- Create the physics
	physics.addBody( self._visual, "static", { radius = 10 } )
	self._visual.isSensor = true
	
	-- Set up some stuff for the collision detection
	self._visual.type = "coin"
	self._visual.owner = self
	
	return self
	
end

--- Sets the position of the Coin.
-- @param x The X position.
-- @param x The Y position.
function Coin:setPosition( x, y )
	self._visual.x = x
	self._visual.y = y
end

--- Moves the coin.
-- @param speed The speed of the level.
function Coin:move( speed )
	if self._visual then
		self._visual.x = self._visual.x - speed
	end
end

function Coin:enterFrame()
end

--- Called when the player collides with the coin.
function Coin:playerHit()
	audio.play( collectSound, { channel = audio.findFreeChannel( 4 ) } )
	Runtime:dispatchEvent{ name = "coinHit" }
	self:cleanUp()
end

--- Destroys the coin.
function Coin:cleanUp()
	if self._visual then
		self._visual:removeSelf()
		self._visual = nil
	end
end