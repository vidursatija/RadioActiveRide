display.setStatusBar( display.HiddenStatusBar )

require( "class_Coin" )
require( "class_Level" )
require( "class_LevelSection" )
require( "class_Missile" )
require( "class_Player" )
require( "class_Zapper" )
require( "class_Jetpack" )
require( "class_Sparkle" )
require( "class_Hud" )
require( "class_Utils" )
require( "class_Audio" )

local physics = require( "physics" )
require( "ice" )
require( "director" )
local movieclip = require("movieclip")
--physics.setGravity(0,1)
records = ice:loadBox( "records" )

local mainGroup = display.newGroup()
mainGroup:insert( director.directorView )

director:changeScene( "screen_Game" )

local tracks = {}
tracks[ 1 ] = "assets/music/Pulses.mp3"
tracks[ 2 ] = "assets/music/Repercussions.mp3"
tracks[ 3 ] = "assets/music/Softer_Sides.mp3"
tracks[ 4 ] = "assets/music/Split_Between.mp3"
tracks[ 5 ] = "assets/music/Teen_Time.mp3"
tracks[ 6 ] = "assets/music/Time_Changes_Everything.mp3"

Audio:playMusic( tracks )