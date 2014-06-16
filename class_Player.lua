Player = {}
Player_mt = { __index = Player }

--- Constructs a new Player object.
function Player:new( parentGroup )

	local self = {}
	
	setmetatable( self, Player_mt )
	
	-- Create the player visual
	self._visual = display.newImage( parentGroup, "assets/images/wizard.png" )

	-- Create the physics, I have given it a circle body for simplicity
	physics.addBody( self._visual, { density = 1, radius = 60 } )
	
	-- Linear damping is essentially air resistance, it allows our player to be a little more floaty. Tweak to taste.
	self._visual.linearDamping = 1
	
	-- We don't want our player rotating as that would probably look weird
	self._visual.isFixedRotation = true
	
	-- Create the jetpack
	self._jetpack = Jetpack:new( parentGroup, self._visual )

	-- Set the player slightly off screen so later on he can "walk" in
	self._visual.startingPoint = 200
	self._visual.x = -100
	self._visual.y = display.contentHeight - self._visual.contentHeight
	
	self._isAlive = true
	
	-- The collision function for the player for when colliding with obstacles and pickups
	local function onCollision( body, event )
		if ( event.phase == "began" ) then
			
			local other = event.other

			-- As the collision bofy is just a visual and not the actual Class it was made in I have given the visual a reference to the Class called "owner"
			local owner = other.owner
			
			-- Check that the object isn't nil and it contains a playerHit function, then call it
			if owner and owner[ "playerHit" ] then
				owner:playerHit()
			end
			
		elseif ( event.phase == "ended" ) then
		
		end
	end
	 
	-- Add the collision listener
	self._visual.collision = onCollision
	self._visual:addEventListener( "collision", self._visual )

	return self
	
end

--- Call on main touch event to enable the jetpack
function Player:touch( event )
	if self._isAlive then
		self._jetpack:touch( event )
	end
end

--- Called on the main enterFrame event, updates the player
function Player:enterFrame( event )
	
	-- The player is initially off screen however I wanted him to slide in like in Jetpack Joyride
	-- If the player hasn't reached the starting point then move it a little bit to the right
	if not self._hasReachedStartingPoint then
		self._visual.x = self._visual.x + 2
	end
	
	-- Check if the player is far enough to the right, if so then set the flag saying he is ready
	if not self._hasReachedStartingPoint and self._visual.x >= self._visual.startingPoint then
		self._hasReachedStartingPoint = true
	end
	
	-- Update the jetpack
	self._jetpack:enterFrame( event )
	
end

--- Checks if the player has reached the starting point
-- @return True if he has, false otherwise.
function Player:hasReachedStartingPoint()
	return self._hasReachedStartingPoint
end

--- Sets the position of the Coin.
-- @return The players visual.
function Player:getVisual()
	return self._visual
end

--- Called when the player has hit something painful
function Player:kill()
	self._jetpack:stopThrustSound()
end

--- Moves the player to the front.
function Player:toFront()
	self:getVisual():toFront()
end

--- Restarts the player.
function Player:restart()
	local parentGroup = self._visual.parent
	self._jetpack:cleanUp()
	self:cleanUp()
	self = Player:new( parentGroup )
end

--- Destroys the player.
function Player:cleanUp()
	self._visual:removeSelf()
end