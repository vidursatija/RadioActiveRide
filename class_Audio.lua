Audio = {}
Audio_mt = { __index = Audio }

function Audio:new()

	local self = {}
	
	setmetatable( self, Audio_mt )
	
	self._backgroundMusic = nil
	self._backgroundChannel = 1
	self._backgroundMusicTimer = nil

	return self
	
end

function Audio:playMusic( trackOrTracks )

	audio.setVolume( 0.1, { channel = self._backgroundChannel } )
	local loadMusic, stopMusic, playMusic
	
	loadMusic = function( trackOrTracks )
		
		local track = nil 
		
		if type( trackOrTracks ) == "string" then
			track = trackOrTracks
		elseif type( trackOrTracks ) == "table" then
			track = trackOrTracks[ math.random( 1, #trackOrTracks ) ]
		end
		
		if track then
		
			if self._backgroundMusic then
				audio.dispose( self._backgroundMusic )
				self._backgroundMusic = nil
			end
			
			self._backgroundMusic = audio.loadStream( track )
			
		end
		
	end
	
	stopMusic = function()
		if self._backgroundChannel then
			audio.stop( self._backgroundChannel )
		end
		if self._backgroundMusicTimer then
			timer.cancel( self._backgroundMusicTimer )
			self._backgroundMusicTimer = nil
		end
	end
	
	local onMusicFinished = function()
		stopMusic()
		loadMusic( trackOrTracks )
		playMusic()
	end
	
	playMusic = function()
	
		if self._backgroundMusic then
		
			self._backgroundChannel = audio.play( self._backgroundMusic, { channel = 1, loops = 1, fadein = 0 }, true  )
			
			if self._backgroundMusicTimer then
				timer.cancel( self._backgroundMusicTimer )
				self._backgroundMusicTimer = nil
			end
			
			self._backgroundMusicTimer = timer.performWithDelay( audio.getDuration( self._backgroundMusic ), onMusicFinished, 1 )
		
		end
		
	end
	
	loadMusic( trackOrTracks )
	playMusic()

end

_G.Audio = Audio:new()
