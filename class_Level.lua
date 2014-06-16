Level = {}
Level_mt = { __index = Level }

--- Constructs a new Level object.
function Level:new( parentGroup )

	local self = {}
	
	setmetatable( self, Level_mt )
	
	self._visual = display.newGroup()
	parentGroup:insert( self._visual )
	
	self._sectionDefinitions = Utils:readInJsonFile( "data/levelSections.json", system.ResourceDirectory )
	
	self._sectionA = LevelSection:new( parentGroup, self:getSectionDefinition( 1 ) )
	self._sectionA:getVisual().x = display.contentWidth / 2
	self._sectionB = LevelSection:new( parentGroup, self:getSectionDefinition( 1 ) )
	self._sectionB:getVisual().x = display.contentWidth * 1.5
	
	self:setSpeed( 7 )
	
	self._roof = display.newRect( parentGroup, 0, -30, display.contentWidth, 30 )
	self._roof.isVisible = false
	physics.addBody( self._roof, "static", {} )
	
	self._floor = display.newRect( parentGroup, -display.contentWidth, display.contentHeight - 35, display.contentWidth * 2, 30 )
	self._floor.isVisible = false
	physics.addBody( self._floor, "static", {} )
	physics.setGravity(0,39.6)
	return self
	
end

function Level:getSectionDefinition( index )
	index = index or math.random( 1, #self._sectionDefinitions )
	return self._sectionDefinitions[ index ]
end

function Level:createNewSection()

	self._sectionA:cleanUp()
	self._sectionA = self._sectionB
	self._sectionB = LevelSection:new( self._visual.parent, self:getSectionDefinition() )
	self._sectionB:getVisual().x = self._sectionA:getVisual().x + self._sectionA:getWidth()
	
	Runtime:dispatchEvent{ name = "newLevelSectionCreated" }
	
end

function Level:startMoving()
	self._shouldMove = true
end

function Level:enterFrame( event )
	
	if self._shouldMove then
	
		-- Comment this line back in if you want the level to get progressively faster
		self:increaseSpeed( 0.005 )
		
		self._sectionA:move( self:getSpeed() )
		self._sectionB:move( self:getSpeed() )
		
		self._sectionA:enterFrame()
		self._sectionB:enterFrame()
		
		local x = self._sectionA:getPosition()
		local width = self._sectionA:getWidth()
		
		if x and x < -( display.contentWidth * 0.5 ) then
			self:createNewSection()
		end
	
	end
	
end

function Level:increaseSpeed( amount )
	self._speed = self._speed + ( amount or 1 )
end

function Level:decreaseSpeed( amount )
	self._speed = self._speed - ( amount or 1 )
end

function Level:getSpeed()
	return self._speed
end

function Level:setSpeed( speed )
	self._speed = speed
end

function Level:getSpeed()
	return self._speed
end

function Level:restart()
	local parentGroup = self._visual.parent
	self:cleanUp()
	self = Level:new( parentGroup )
end

function Level:cleanUp()
	if self._sectionA then
		self._sectionA:cleanUp()
	end
	if self._sectionB then
		self._sectionB:cleanUp()
	end
	self._visual:removeSelf()
	self._visual = nil
	self._roof:removeSelf()
	self._roof = nil
	self._floor:removeSelf()
	self._floor = nil
end