module(..., package.seeall)
local self = display.newGroup()
new = function( params )
	 
	
	self._back = display.newImage( self, "assets/images/credits.png",true)
	
	self._back.x = display.contentCenterX
	self._back.y = display.contentCenterY
	
	
	
	
	
	function onTap()
	self._back:removeEventListener("tap",onTap)
	director:changeScene( "screen_MainMenu" )
	end
	self._back:addEventListener("tap",onTap)
	
	return self
	
end