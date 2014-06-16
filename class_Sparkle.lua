Sparkle = {}
Sparkle_mt = { __index = Sparkle }

local random = math.random

--- Constructs a new Sparkle object.
function Sparkle:new( parentGroup, params )

	local self = {}
	
	setmetatable( self, Sparkle_mt )

	self._visual = display.newImage( parentGroup, "assets/images/spinkle.png" )
	self._visual:setFillColor( random( 1, 255 ), random( 1, 255 ), random( 1, 255 ) )
	
	self._visual.x = params.x
	self._visual.y = params.y

	local finalX = self._visual.x + random( -20, 20 )
	local finalY = self._visual.y + random( 40, 60 )
	
	local onTransitionComplete = function( event )
		self:cleanUp()
	end
	
	self._transition = transition.to( self._visual, { time = params.lifetime, alpha = 0, x = finalX, y = finalY, onComplete = onTransitionComplete } )
	
	return self
	
end

function Sparkle:cleanUp()

	if self._transition then
		transition.cancel( self._transition )
	end
	
	if self._visual and self._visual[ "removeSelf" ] then
		self._visual:removeSelf()
		self._visual = nil
	end
	
end