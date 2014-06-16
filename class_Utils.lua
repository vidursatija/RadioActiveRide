Utils = {}
Utils_mt = { __index = Utils }

local json = require( "json" )

--- Constructs a new Utils object.
function Utils:new()

	local self = {}
	
	setmetatable( self, Utils_mt )

	return self
	
end

function Utils:readInFile( filename, baseDir )

	local path = system.pathForFile( filename, baseDir or system.DocumentsDirectory )
	local file = io.open( path, "r" )
	
	if file then
	   return file:read( "*a" )
	end

end

function Utils:readInJsonFile( filename, baseDir )
	
	local contents = self:readInFile( filename, baseDir )
	
	if contents then
		return json.decode( contents )
	end
	
end

_G.Utils = Utils:new()