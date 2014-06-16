module(..., package.seeall)

local self = display.newGroup()
require("facebook")
new = function( params )
local lastGame = records:retrieve( "lastGame" ) or {}
local distance = ( lastGame.distance or 0 )
	function connectHandler( event )
	
		local post = "Playin' TechRide - Gone Mad!"
		local gameScore = distance
		--gameScore = comma_value(gameScore)
		
		local session = event.sender
		if ( session:isLoggedIn() ) then
	
			print( "fbStatus " .. session.sessionKey )
			
			local scoreStatusMessage = "just scored a " .. tostring(gameScore) .. " on TechRide."
			
			local attachment = {
				name="Download TechRide To Compete With Me",
				caption="Think you can beat my score of " .. tostring(gameScore) .. "? I know you cant!!!",
				href="http://---LINK-TO-YOUR-ITUNES-APP",
				media= { { type="image", src="http://---LINK-TO-YOUR-90x90-ICON", href="---LINK-TO-YOUR-ITUNES-APP" } }
			}
	
			local action_links = {
				{ text="Download TechRide", href="http://beebegamesonline.appspot.com/tiltmonster-itunes.html" }
			}
	
			local response = session:call{
				message = scoreStatusMessage,
				method ="stream.publish",
				attachment = json.encode(attachment),
				action_links = json.encode(action_links),
			}
	
			if "table" == type(response ) then
				-- print contents of response upon failure
				printTable( response, "fbStatus response:", 5 )
			end
			
			local onComplete = function ( event )
				if "clicked" == event.action then
					local i = event.index
					if 1 == i then
						-- Player click 'Ok'; do nothing, just exit the dialog
					end
				end
			end
			
			-- Show alert with two buttons
			local alert = native.showAlert( "TechRide", "Your score has been posted to Facebook.", 
													{ "Ok" }, onComplete )
		end
	end
	facebookListener = function( event )
					if ( "session" == event.type ) then
						-- upon successful login, update their status
						if ( "login" == event.phase ) then
							
							local gameScore = distance
							
							
							local theMessage
							
								
								theMessage = "just scored a " .. gameScore .. " on TechRide."
							
								
							
							facebook.request( "me/feed", "POST", {
								message=theMessage,
								name="Download TechRide to Compete with Me!",
								caption="Think you can beat my score of " .. gameScore .. "? I dare you to try!",
								link="---LINK-TO-YOUR-ITUNES-APP",
								picture="---LINK-TO-YOUR-90x90-ICON" } )
						end
					end
				end
				
				-- replace "---" below with your Facebook App ID
	
	self._back = display.newImage( self, "assets/images/levelSections/1.png", true )
	self._back.x = display.contentCenterX
	self._back.y = display.contentCenterY
	
	self._scroll = display.newImage( self, "assets/images/scroll.png", true )
	self._scroll.x = display.contentCenterX
	self._scroll.y = display.contentCenterY
	
	
	
	local stars = ( lastGame.stars or 0 )
	self._scoreText = display.newText( self, "You collected " .. stars .. " stars!", 0, 0, "Deutsch Gothic", 48 )
	self._scoreText:setTextColor( 0, 0, 0 )
	self._scoreText.x = display.contentCenterX
	self._scoreText.y = 170
	
	
	self._distanceText = display.newText( self, "You traveled " .. distance .. " metres!", 0, 0, "Deutsch Gothic", 48 )
	self._distanceText:setTextColor( 0, 0, 0 )
	self._distanceText.x = display.contentCenterX
	self._distanceText.y = 250
	
	local bestDistance = ( records:retrieve( "bestDistance" ) or 0 )
	self._bestDistanceText = display.newText( self, "Your best distance is " .. bestDistance .. " metres!", 0, 0, "Deutsch Gothic", 48 )
	self._bestDistanceText:setTextColor( 0, 0, 0 )
	self._bestDistanceText.x = display.contentCenterX
	self._bestDistanceText.y = display.contentHeight - self._bestDistanceText.contentHeight * 2

	self._playText = display.newText( self, "Play Again", 0, 0, "Deutsch Gothic", 80 )
	self._playText:setTextColor( 0, 0, 0 )
	self._playText.x = display.contentCenterX
	self._playText.y = display.contentCenterY + 50
	
	self._repoBtn = display.newImage(self,"assets/images/Repo_Button.png",true)
	self._repoBtn.x = display.contentCenterX+200
	self._repoBtn.y = display.contentCenterY+150
	
	self._fbBtn = display.newImage(self,"assets/images/facebook.png",true)
	self._fbBtn.x = display.contentCenterX-200
	self._fbBtn.y = display.contentCenterY+150
	
	self._crtBtn = display.newImage(self,"assets/images/creditsbtn.png",true)
	self._crtBtn.x = display.contentCenterX+400
	self._crtBtn.y = display.contentCenterY+350
	function onTap()	
		self._playText:removeEventListener( "tap", onTap )
		self._repoBtn:removeEventListener("tap",onTapRepo)
		self._fbBtn:removeEventListener("tap",onTapFB)
		self._crtBtn:removeEventListener("tap",onTapCrt)
		director:changeScene( "screen_Game" )
	end
	function onTapRepo()
	    self._repoBtn:removeEventListener("tap",onTapRepo)
		self._playText:removeEventListener( "tap", onTap )
		self._fbBtn:removeEventListener("tap",onTapFB)
		self._crtBtn:removeEventListener("tap",onTapCrt)
		director:changeScene( "screen_Repo" )
	end
	function onTapCrt()
	    self._repoBtn:removeEventListener("tap",onTapRepo)
		self._playText:removeEventListener( "tap", onTap )
		self._fbBtn:removeEventListener("tap",onTapFB)
		self._crtBtn:removeEventListener("tap",onTapCrt)
		director:changeScene( "screen_Credits" )
	end
	function onTapFB()
		facebook.login( "310268242428748", facebookListener, { "publish_stream" } )
	end
	function eveListen()
	self._playText:addEventListener( "tap", onTap )
	self._repoBtn:addEventListener("tap",onTapRepo)
	self._fbBtn:addEventListener("tap",onTapFB)
	self._crtBtn:addEventListener("tap",onTapCrt)
	end
	timer.performWithDelay(1000,eveListen,1)
	return self
	
end