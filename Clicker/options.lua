local options = {}

options.array = {}


function options:Init()
  options:checkSaved()
  options:read()
end

function options:checkSaved()
  local exist = love.filesystem.getInfo(  "data/options" )
  if not exist then
    options:setDefaults()
  end
  
 
  
end

function options:read()
  local data =  love.filesystem.load("data/options")
  options.array = data()
  --print(options.array.lang)
  
end
function options:set(item,val)
  options.array[item] = val
  options:save()
end

function options:get(item)
  return options.array[item]
  
  end

function options:save()
  local data = 'local options = {} '..
  '\noptions.music = ' .. options:get("music")..
  '\noptions.lang = "' .. options:get("lang").. '"'..
  '\noptions.default_lang = "ru"'..
  '\nreturn options'
  
  
  love.filesystem.write( "data/options" ,data)
  
  end

function options:setDefaults()
  local defaults = [[
  local options = {}
  options.music = 0.6
  options.lang = "ru"
  options.default_lang = "ru"
  
  return options
  ]]
  
  love.filesystem.write( "data/options" ,defaults,size)
  
end





return options