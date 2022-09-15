
--C:\Users\Rex\AppData\Roaming\LOVE\Raveyard\data

function data_init()
  love.filesystem.setIdentity( "clicker" )
  save_path = love.filesystem.getSaveDirectory()
  exe_path =  love.filesystem.getSource( )
  folder_path = love.filesystem.getSourceBaseDirectory( )
  
  
  
  if check_first_session() then
    first_session_init()-- add localizations
  end
    options:Init()
    localization:Init()
    
  
  local init =  love.filesystem.load("data/default_init_data")
  init()
end


function first_session_init() 
  local default_init_data = [[
  first_session = false
  
  
  love.filesystem.createDirectory( "mods" )
  ]]
  
  love.filesystem.write( "data/default_init_data",default_init_data, size )
  
end

function check_first_session() 
  love.filesystem.createDirectory( "data" )
  local exist =  love.filesystem.getInfo(  "data/default_init_data" )    --love.filesystem.exists(  "data/default_init_data" ) 

  if exist  then
    return false
  else
    
    return true
  end

end
