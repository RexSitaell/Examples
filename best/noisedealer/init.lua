local PATH = (...):gsub('%.init$', '')

local Noisedealer = {}
Noisedealer.sound_pack = require(PATH..".sound_pack")
return Noisedealer