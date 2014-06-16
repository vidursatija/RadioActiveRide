Jetpack = {}
Jetpack_mt = { __index = Jetpack }

-- Localise the random function
local random = math.random

-- Load up the thrust sound and set a channel for it
local thrustSound = audio.loadSound( "assets/sounds/thrust.wav" )
local thrustChannel = 2

--- Constructs a new Jetpack object.
function Jetpack:new( parentGroup, player )

	local self = {}
	
	setmetatable( self, Jetpack_mt )
	
	-- Assign the player variable
	self._player = player
	
	-- This is the power of the jetpack, tweak it for different speeds
	self._power = 3000
	
	self._parentGroup = parentGroup
	
	return self
	
end

-- Called from the player class, sets a flag to state if the jetpack is active or not i.e. if the user is actually touching the screen
function Jetpack:touch( event )
	self._isActive = event.phase == "began" or event.phase == "moved"
end

-- Called from the player class, does most of the work
function Jetpack:enterFrame( event )
	
	if self._isActive then
	
		-- If the thrust sound isn't already playing then start it and set it to loop indefinately
		if not self._playingThrustSound then
			audio.play( thrustSound, { channel = thrustChannel, loops = -1 } )
			self._playingThrustSound = true
		end
		
		-- Apply a force to the player object to act as a jetpack and create some sparkle objects
		self._player:applyForce( 0, -self._power, self._player.x, self._player.y )
		self:createSparkle()
		
		-- To ensure the particle seems to come from inside the jetpack force the player image to the front
		self._player:toFront()
		
	else
	
		-- If the jetpack isn't active then stop playing the sound
		if self._playingThrustSound then
			self:stopThrustSound()
		end
		
	end
	
end

-- Create a sparkly particle
function Jetpack:createSparkle()
	
	local params = {}
	
	-- We want the particle to start under the jetpack image
	params.x = self._player.x - self._player.contentWidth / 6

	-- But with a bit of randomness to it
	params.x = params.x + random( -10, 10 )
	
	-- We also want the particle to be behind the jetpack so it looks like its coming from inside it
	params.y = self._player.y + self._player.contentHeight / 4
	
	-- Give the particle a random lifetime
	params.lifetime = random( 100, 500 )
	
	-- Now create the actual particle
	Sparkle:new( self._parentGroup, params )
	
end

function Jetpack:stopThrustSound()
	audio.stop( thrustChannel )
	self._playingThrustSound = false
end

function Jetpack:cleanUp()
	self._player = nil
end