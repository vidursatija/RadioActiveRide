module(..., package.seeall)

local self = display.newGroup()
local floor = math.floor

new = function( params )
	if(math.random(0,10)==2) then
	randno = 7000
	else
	randno = 0
	end
	print(randno.." "..math.random(0,10))
	physics.start( true )
	--physics.setDrawMode( "hybrid" )
	
	self._level = Level:new( self )
	self._player = Player:new( self )
	self._hud = Hud:new( self )
	
	Runtime:addEventListener( "tap", self )
	Runtime:addEventListener( "touch", self )
	Runtime:addEventListener( "enterFrame", self )
	Runtime:addEventListener( "newLevelSectionCreated", self )
	Runtime:addEventListener( "zapperHit", self )
	Runtime:addEventListener( "coinHit", self )
	Runtime:addEventListener( "laserHit", self )
	Runtime:addEventListener( "missileHit", self )
	Runtime:addEventListener( "playerFalling", self )
	Runtime:addEventListener( "playerDead", self )
	
	self._distance = 0
	self._collectedStars = 0
	self._hitZappers = 0
	self._hitMissiles = 0
	self._hitLasers = 0
	self._totalFrames = 0
	
	self._hud:setBestDistanceText( records:retrieve( "bestDistance" ) )
	
	self:pause()
	
	return self
	
end

function self:tap( event )
	if self._isPaused then
		self:resume()
	end
end

function self:touch( event )
	if not self._isPaused then
		if self._player then self._player:touch( event ) end
	end
end

function self:enterFrame( event )

	if not self._isPaused then
	
		self._totalFrames = self._totalFrames + 1
		
		if self._player and self._level then 
			
			self._player:enterFrame( event ) 

			if self._player:hasReachedStartingPoint() then
				self._level:startMoving()
			end
			
			self._level:enterFrame( event ) 
		
			self._distance  = randno + floor( ( ( self._level:getSpeed() / 2 ) * self._totalFrames ) / 100 )
			self._hud:setDistanceText( self._distance  )
			
		end
		
	end
end

function self:newLevelSectionCreated( event )
	self._player:toFront()
end
local saveValue = function( strFilename, strValue )
		-- will save specified value to specified file
		local theFile = strFilename
		local theValue = strValue
		
		local path = system.pathForFile( theFile, system.DocumentsDirectory )
		
		-- io.open opens a file at path. returns nil if no file found
		local file = io.open( path, "w+" )
		if file then
		   -- write game score to the text file
		   file:write( theValue )
		   io.close( file )
		end
	end
	
	--***************************************************

	-- loadValue() --> load saved value from file (returns loaded value as string)
	
	--***************************************************
	local loadValue = function( strFilename )
		-- will load specified file, or create new file if it doesn't exist
		
		local theFile = strFilename
		
		local path = system.pathForFile( theFile, system.DocumentsDirectory )
		
		-- io.open opens a file at path. returns nil if no file found
		local file = io.open( path, "r" )
		if file then
		   -- read all contents of file into a string
		   local contents = file:read( "*a" )
		   io.close( file )
		   return contents
		else
		   -- create file b/c it doesn't exist yet
		   file = io.open( path, "w" )
		   file:write( "0" )
		   io.close( file )
		   return "0"
		end
	end
function self:endGame()
	
	
	
	records:store( "lastGame", { stars = self._collectedStars, distance = self._distance } )
	records:storeIfHigher( "bestCoins", self._collectedStars )
	records:storeIfHigher( "bestDistance", self._distance )
	records:save()
	totalCoinsInGame = loadValue("coins")
	totalCoinsInGame = totalCoinsInGame + self._collectedStars
	saveValue("coins",totalCoinsInGame)
	--[[local anim = movieclip.newAnim("poof-f1.png", "poof-f1.png", "poof-f2.png", "poof-f2.png", "poof-f3.png", "poof-f3.png", "poof-f4.png", "poof-f4.png", "poof-f5.png", "poof-f5.png" )
	self:insert(anim)
	anim.x = poofx
	anim.y = poofy]]
	
	self._player:kill()
	
	self._player:getVisual().isVisible = false
	self:cleanUp()
	--self:pause()
	director:changeScene( "screen_MainMenu" )
	
	--anim:play{ startFrame=1, endFrame=10, loop=1, remove=true }
	
end

function self:zapperHit()
	self:endGame()
end

function self:coinHit()
	self._collectedStars = self._collectedStars + 2
	self._hud:setScoreText( self._collectedStars )
end

function self:laserHit()
	self:endGame()
end

function self:missileHit()
	
	self:endGame()
end

function self:playerFalling()
	self._level:playerFalling()
end

function self:playerDead()
	self:endGame()
end

function self:restart()

	self._level:restart()
	self._player:restart()
	self._hud:restart()
	
	self._distance = 0
	self._collectedStars = 0
	self._hitZappers = 0
	self._hitMissiles = 0
	self._hitLasers = 0
	self._totalFrames = 0
	
	self:resume()
	
end

function self:pause()
	physics.pause()
	self._isPaused = true
	self._hud:gamePaused()
end

function self:resume()
	physics.start( true )
	self._isPaused = false
	self._hud:gameResumed()
end

function self:cleanUp()
	Runtime:removeEventListener( "tap", self )
	Runtime:removeEventListener( "touch", self )
	Runtime:removeEventListener( "enterFrame", self )
	Runtime:removeEventListener( "newLevelSectionCreated", self )
	Runtime:removeEventListener( "zapperHit", self )
	Runtime:removeEventListener( "coinHit", self )
	Runtime:removeEventListener( "laserHit", self )
	Runtime:removeEventListener( "missileHit", self )
	Runtime:removeEventListener( "playerFalling", self )
	Runtime:removeEventListener( "playerDead", self )
	self._level:cleanUp()
	self._player:cleanUp()
	self._hud:cleanUp()
end