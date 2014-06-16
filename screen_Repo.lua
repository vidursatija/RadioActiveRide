module(..., package.seeall)
local self = display.newGroup()
new = function( params )
	 
	self._back = display.newImage(self,"assets/images/repo_back.png",true)
	self._jet = display.newImage(self,"assets/images/btn_jetpack.png",true)
	self._jet.y = 300
	self._jet.x = 230
	
	self._backg = display.newImage(self,"assets/images/btn_back.png",true)
	self._backg.y = 600
	self._backg.x = 484 
	
	self._getcoins = display.newImage(self,"assets/images/btn_getcoins.png",true)
	self._getcoins.y = 300
	self._getcoins.x = (1024-230)
	
	self._go = display.newImage(self,"assets/images/btn_goback.png",true)
	self._go.y = 300
	self._go.x = 484
	
	function onTapback()
		self._go:removeEventListener("tap",onTapback)
		director:changeScene( "screen_MainMenu" )
	end
	self._go:addEventListener("tap",onTapback)
	
	return self
	
end