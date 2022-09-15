local current_module = ModuleEnvInit()

Debug = class("Debug")
function Debug:initialize()
  if not Debug.INSTANCE then
    Debug.static.INSTANCE = self;
  else
    print("error Debug already exists");
  end;
end;

function Debug:Draw()
  love.graphics.print(love.timer.getFPS().." FPS")
  
  local mem_usage_kb = collectgarbage("count")
  love.graphics.print((math.floor(mem_usage_kb*1000/1024)/1000) .." MB memory",0,20)
 
  local current_room_name = roomManager.current_room or roomManager.data_manager.null_room
  
  --for k,v in pairs()
  --print(current_room_name)
  love.graphics.print( #roomManager.room_list[current_room_name].entityList .." objects spawned",0,40)
end;


return current_module