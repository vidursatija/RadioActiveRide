Missile = {}
Missile_mt = { __index = Missile }

local alertSound = audio.loadSound( "assets/sounds/alert.wav" )
local alertChannel = 3

local arrowSound = audio.loadSound( "assets/sounds/arrow.wav" )

--- Constructs a new Coin object.
function Missile:new( parentGroup, params )

	local self = {}
	
	setmetatable( self, Missile_mt )

	-- Create the visual
	self._visual = display.newImage( parentGroup, "assets/images/rock.png" )

	-- Create the physics
	physics.addBody( self._visual, "static" )
	self._visual.isSensor = true
	
	-- Set up some collision stuff
	self._visual.type = "missile"
	self._visual.owner = self
	
	self._visual.y = params.height
	self._offset = ( params.offset or 0 )
	
	-- Create the alert image that will popup
	self._alert = display.newImage( parentGroup, "assets/images/alert.png" )
	self._alert.x = display.contentWidth - ( self._alert.contentWidth / 2 )
	self._alert.y = self._visual.y
	
	local alertTimer = nil
	
	-- Function called at the end of the timer to destroy the alert image
	local removeAlert = function()
			
		timer.cancel( alertTimer )
		alertTimer = nil
		
		if self._alert then
			self._alert:removeSelf()
			self._alert = nil
		end
		
	end
	
	-- Play the alert sound
	audio.play( alertSound, { channel = alertChannel } )
	
	-- Create the alert timer based on the offset of the missile and the speed of the level
	local alertTime = ( self._offset * 2 ) / ( params.levelSpeed or 1 )
	alertTimer = timer.performWithDelay( 1000 + alertTime, removeAlert, 1 )
	
	-- Tweak to change the speed of the missile
	self._speedMultiplier = 3
	
	return self
	
end

--- Sets the position of the Missile.
-- @param x The X position.
-- @param x The Y position.
function Missile:setPosition( x, y )
	self._visual.x = ( x + self._offset )
	self._visual.y = y
end

--- Moved the Missile.
-- @param speed The speed of the level.
function Missile:move( speed )
	if self._visual then
		
		if not self._hasPlayedFireSound then
			if self._visual.x - self._visual.contentWidth / 2 < display.contentWidth then
				self._hasPlayedFireSound = true
				audio.play( arrowSound, { channel = audio.findFreeChannel( 4 ) } )
			end
		end

		self._visual.x = self._visual.x - ( speed * self._speedMultiplier )
	end
end

function Missile:enterFrame()
end

--- Called when the player hits the missile.
function Missile:playerHit()
	Runtime:dispatchEvent{ name = "missileHit" }
	self:cleanUp()
end

--- Destroys the Missile
function Missile:cleanUp()

	if self._alert then
		self._alert:removeSelf()
		self._alert = nil
	end
	
	if self._visual then
		self._visual:removeSelf()
		self._visual = nil
	end
	
end