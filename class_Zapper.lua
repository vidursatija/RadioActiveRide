Zapper = {}
Zapper_mt = { __index = Zapper }

--- Constructs a new Zapper object.
function Zapper:new( parentGroup, params )

	local self = {}
	
	setmetatable( self, Zapper_mt )

	-- Create the visual
	self._visual = display.newImage( parentGroup, "assets/images/zapper.png" )
	
	-- Create the physics
	physics.addBody( self._visual, "static", {} )
	self._visual.isSensor = true
	
	self._visual.rotation = params.rotation or 0
	self._rotationSpeed = params.rotationSpeed
	
	self._visual.type = "zapper"
	self._visual.owner = self
	
	return self
	
end

function Zapper:setPosition( x, y )
	self._visual.x = x
	self._visual.y = y
end

function Zapper:move( speed )
	if self._visual then
		self._visual.x = self._visual.x - speed
	end
end

function Zapper:enterFrame()
	if self._visual and self._rotationSpeed then
		self._visual.rotation = self._visual.rotation + self._rotationSpeed
	end
end

function Zapper:playerHit()
	Runtime:dispatchEvent{ name = "zapperHit" }
end

function Zapper:cleanUp()
	if self._visual then
		self._visual:removeSelf()
		self._visual = nil
	end
end