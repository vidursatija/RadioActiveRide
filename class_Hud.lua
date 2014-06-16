Hud = {}
Hud_mt = { __index = Hud }

--- Constructs a new Hud object.
function Hud:new( parentGroup )

	local self = {}
	
	setmetatable( self, Hud_mt )

	self._parentGroup = parentGroup
	
	self._scoreText = display.newText( parentGroup, "", 0, 0, "Deutsch Gothic", 30 )
	self._scoreText:setTextColor( 255, 255, 255 )
	self._scoreText.y = display.contentHeight - 20
	self:setScoreText( 0 )
	
	self._bestDistanceText = display.newText( parentGroup, "", 0, 0, "Deutsch Gothic", 30 )
	self._bestDistanceText:setTextColor( 255, 255, 255 )
	self._bestDistanceText.y = display.contentHeight - 20
	self:setBestDistanceText( 0 )
	
	self._distanceText = display.newText( parentGroup, "", 0, 0, "Deutsch Gothic", 30 )
	self._distanceText:setTextColor( 255, 255, 255 )
	self._distanceText.y = display.contentHeight - 20
	self:setDistanceText( 0 )
	
	self._pausedText = display.newText( parentGroup, "Tap to Play", 0, 0, "Deutsch Gothic", 100 )
	self._pausedText:setTextColor( 0, 0, 0 )
	self._pausedText.x = display.contentCenterX
	self._pausedText.y = display.contentCenterY
	self._pausedText.isVisible = false
	
	Runtime:addEventListener( "newLevelSectionCreated", self )
	
	return self
	
end

function Hud:setScoreText( score )

	if not self._scoreText then
		return
	end
	
	self._scoreText.text = "Stars: " .. score
	self._scoreText.x = math.floor( self._scoreText.contentWidth / 2 ) + 10
end

function Hud:setDistanceText( distance )

	if not self._distanceText then
		return
	end
	
	self._distanceText.text = "Distance: " .. distance .. "Ms"
	self._distanceText.x = display.contentWidth - math.floor( self._distanceText.contentWidth / 2 ) - 10
end

function Hud:setBestDistanceText( distance )
	
	if not self._bestDistanceText then
		return
	end
	
	self._bestDistanceText.text = "Best Distance: " .. ( distance or 0 ) .. "Ms"
	self._bestDistanceText.x = display.contentCenterX
end

function Hud:newLevelSectionCreated()

	if self._scoreText then
		self._scoreText:toFront()
	end
	
	if self._bestDistanceText and self._bestDistanceText[ "toFront" ] then
		self._bestDistanceText:toFront()
	end
	
	if self._distanceText then
		self._distanceText:toFront()
	end
	
end

function Hud:gamePaused()
	self._pausedText.isVisible = true
end

function Hud:gameResumed()
	self._pausedText.isVisible = false
end

function Hud:restart()
	local parentGroup = self._parentGroup
	self:cleanUp()
	self = Hud:new( parentGroup )
end

function Hud:cleanUp()
	self._scoreText:removeSelf()
	self._scoreText = nil
	self._distanceText:removeSelf()
	self._distanceText = nil
end