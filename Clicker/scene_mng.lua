

local manager = {}

manager.folder = "layouts/"
manager.pfx    = ".lua"

manager.layouts_list = {
  
  [1] = "lvl",
  [2] = "menu",
  [3] = "map",
  [4] = "options",
  [5] = "terminal",
  [6] = "mods"
  
}



function manager:init()
  manager:init_base()
  manager:init_layouts()
  
end




function manager:init_base()
  self.storage = {}  --хранит ВСЕ лэйауты
  
  self.entity_list = {}             --хранит объекты ТЕКУЩЕГО лэйаута
  
  self.variables = { storage = {} } --хранит переменные ТЕКУЩЕГО лэйаута
  
end



function manager:init_layouts()
  
  for key,val in pairs(self.layouts_list) do
    self:insert_layout(key,val)
  end
  
end

function manager:insert_layout(index,layout)
    
  self.storage[index] = love.filesystem.load( self.folder..layout..self.pfx)
    
end


manager:init()

------------------------------------------------------------- внутренние функции
function manager:get_layout(index) 
  
  return self.storage[index]() --список объектов
  
end

function manager:clear_variables_storage()
  
  self.variables.storage = {}
  
end

function manager:clear_entity_list ()
  
  self.entity_list = {}
  
end

------------------------------------------------------------ интерфейс

function manager:get_variable(var)
  
  return self.variables.storage[var]
  
end

function manager:set_variable(var,val)
  
  self.variables.storage[var] = val
  
end


function manager:Spawn(object,params)
  
  local index = 0
  
  if not self.entity_list[object] then
    self.entity_list[object] = {pool = {},empty_indexes = {}}
  end
  
  for i = 1, #self.entity_list[object].empty_indexes do
    if self.entity_list[object].empty_indexes[i] then
      
      index =  self.entity_list[object].empty_indexes[i]  --extract()
      self.entity_list[object].empty_indexes[i] = nil     --
      
      self.entity_list[object].pool[index] = Concord.entity(world):assemble(_G[object],params) -- create()
      self.entity_list[object].pool[index].index = index                                       --

      
      break
    end
  end
  
  if index == 0 then
    index = #self.entity_list[object].pool+1
    
    self.entity_list[object].pool[index] = Concord.entity(world):assemble(_G[object],params)  -- create()
    self.entity_list[object].pool[index].index = index                                        --
    
  end
  
  return index
  
end






function manager:SceneSort(e) -- корректное удаление объектов
  
  if e.index and e.name then
    self.entity_list[e.name].pool[e.index] = nil
    
    for i = 1, #self.entity_list[e.name].empty_indexes+1 do
      
      if self.entity_list[e.name].empty_indexes[i] == nil then
        self.entity_list[e.name].empty_indexes[i] = e.index
        break
      end 
      
    end
    
    
  end
  
end



function manager:get_object(object,ind)
  
  local index = ind
  if not index then index = 1 end
  
  local result
  if self.entity_list[object] then
    if self.entity_list[object].pool[index]  then
      
      result = self.entity_list[object].pool[index] 
    else
      
     -- print("'"..object.."' in index '"..index.."' is not exist!")
      
    end
    
    
  else
   -- print("object type '"..object.."' is not exist!")
  
  end
  
  
  
  return result  --object or nil
  
end



function manager:SceneLoad(index)
  
  scene = index
  
  last_screenshot = love.graphics.newImage(main_canvas:newImageData( ) ) -- с помошью скриншота и шейдера планируется сделать плавный переход между сценами
  
  
  self:SceneClear()

  local data = self:get_layout(scene)
  
  self:LayersLoad(data)
  self:ScriptLoad()
  self:ObjectsLoad(data)
  
end



function manager:LayersLoad(data)  --connects to Layers
  
  local layers_list = data.layers
  if layers_list == nil or calc_len(layers_list) == 0  then layers_list = {"main"} end
  
  layers:clear()
  for i = 1,#layers_list do

     layers:add(layers_list[i])
  end
  layers:current(1)
  
end

function manager:ScriptLoad() --connects to Event
  
 --   Event:SetEventSheet(scene)  

end

function manager:ObjectsLoad(data)
  local objects_list  = data.result
  
  for i = 1, #objects_list do
    local o = objects_list[i]
    self:Spawn(o.object,o.params)
  end
  
  
end

function manager:SceneClear()
  
  self:clear_variables_storage() 
  
  world:clear()    
  self:clear_entity_list()
  
  interrupt_mouse()
  love.audio.stop()
  
end





return manager