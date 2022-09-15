local sound_pack = {}
sound_pack.packs = {}
local msg_name = "sound_pack: "

local sound_pack_build = function(name,path,files,mode)
	local result = {}
	local mode = mode == "sound" and "static" or "stream"
	local pack_size = 0
	result.info = {}
	result.pack_size = function() return pack_size end;
	
	
	result.sounds = {}
	for key,val in pairs(files) do
		pack_size = pack_size + 1
		result.sounds[key] = love.audio.newSource(path.."/"..val,mode)
	end
	
	result.play = function(idx)
		local idx = (idx and idx > 0 and idx < result.pack_size() ) or love.math.random(1,result.pack_size())
		result.sounds[idx]:play()
	end
	
	sound_pack.packs[name] = result
end


sound_pack.load = function(path,name,mode) --modes: sound, music
	
	if not path  then error(msg_name.."not path to soundpack!",2) end
	if type(path) ~= "string" then error(msg_name.."path to soundpack not in a string type!",2) end
	if mode and (mode ~= "sound" or mode ~= "music") then error(msg_name.."not correct soundpack mode!",2) end
	
	local mode = mode or "sound"
	local name = name or #sound_pack.packs + 1
	local path = "assets/"..path
	local files = love.filesystem.getDirectoryItems( path )
	
	--print(#files)
	sound_pack_build(name,path,files,mode)
	return name -- на случай если имя определено функцией
end

sound_pack.get = function(name)
	return sound_pack.packs[name]
end


--sound_pack.remove

return sound_pack