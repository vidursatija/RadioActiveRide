LevelSection = {}
LevelSection_mt = { __index = LevelSection }

--- Constructs a new LevelSection object.
function LevelSection:new( parentGroup, definition )

	local self = {}
	
	setmetatable( self, LevelSection_mt )
	
	self._back = display.newImage( parentGroup, definition.back, true )
	
	self._coins = {}
	self._zappers = {}
	self._missiles = {}
	
	if definition.coins then
		for i = 1, #definition.coins, 1 do
			self:createCoin( definition.coins[ i ] )
		end
	end
	
	if definition.zappers then
		for i = 1, #definition.zappers, 1 do
			self:createZapper( definition.zappers[ i ] )
		end
	end
	
	if definition.missiles then
		for i = 1, #definition.missiles, 1 do
			self:createMissile( definition.missiles[ i ] )
		end
	end
	
	return self
	
end

function LevelSection:positionObject( object, params )
	local x = self:getPosition() + self:getWidth() / 2
	object:setPosition( x + params.position[ 1 ], params.position[ 2 ] )
end

function LevelSection:createCoin( params )
	
	local coin = Coin:new( self._back.parent, params )
	
	self:positionObject( coin, params )
	
	self._coins[ #self._coins + 1 ] = coin
	
end

function LevelSection:createZapper( params )
	
	local zapper = Zapper:new( self._back.parent, params )
	
	self:positionObject( zapper, params )
	
	self._zappers[ #self._zappers + 1 ] = zapper
	
end

function LevelSection:createMissile( params )

	params.levelSpeed = self._currentSpeed
	
	local missile = Missile:new( self._back.parent, params )
	
	params.position = { display.contentWidth, params.height }
	self:positionObject( missile, params )
	
	self._missiles[ #self._missiles + 1 ] = missile
	
end

function LevelSection:move( speed )
	
	self._currentSpeed = speed
	
	if not self._back or not self._back.x then
		return 
	end
	
	self._back.x = self._back.x - speed
	
	for i = 1, #self._coins, 1 do
		self._coins[ i ]:move( speed )
	end
	for i = 1, #self._zappers, 1 do
		self._zappers[ i ]:move( speed )
	end
	for i = 1, #self._missiles, 1 do
		self._missiles[ i ]:move( speed )
	end
	
end

function LevelSection:enterFrame()
	for i = 1, #self._coins, 1 do
		self._coins[ i ]:enterFrame()
	end
	for i = 1, #self._zappers, 1 do
		self._zappers[ i ]:enterFrame()
	end
	for i = 1, #self._missiles, 1 do
		self._missiles[ i ]:enterFrame()
	end
end

function LevelSection:getPosition()
	return self:getVisual().x
end

function LevelSection:getWidth()
	return self:getVisual().contentWidth
end

function LevelSection:getVisual()
	return self._back
end

function LevelSection:cleanUp()
	for i = 1, #self._coins, 1 do
		self._coins[ i ]:cleanUp()
	end
	for i = 1, #self._zappers, 1 do
		self._zappers[ i ]:cleanUp()
	end
	for i = 1, #self._missiles, 1 do
		self._missiles[ i ]:cleanUp()
	end
	return self:getVisual():removeSelf()
end