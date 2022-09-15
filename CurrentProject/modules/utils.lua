------------------------------------------------Utils
--[[]]
------------------------------------------------Utils Global
function ModuleEnvInit()
  local module_table = {}
  setmetatable(module_table,{__index = _G,})
  setfenv(1, module_table) --работает только в пределах модуля, в котором вызывается функция
  
  return module_table
end;

function string:cut(reference)
  return self:gsub(reference, "")
end;

------------------------------------------------Utils Module
local current_module = ModuleEnvInit()

GetFirstIndex = function(table)
  for idx,_ in pairs(table) do 
      return idx;
  end;
end

RequireFolderToTable = function(table,path_to_folder)
end;

function DeepCopy(orig, copies)
    copies = copies or {}
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        if copies[orig] then
            copy = copies[orig]
        else
            copy = {}
            copies[orig] = copy
            for orig_key, orig_value in next, orig, nil do
                copy[DeepCopy(orig_key, copies)] = DeepCopy(orig_value, copies)
            end
            setmetatable(copy, DeepCopy(getmetatable(orig), copies))
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end  

function TestSpawn(objects_table,dummy_count)
  
  local x_diapozone = {min = 0, max = 800}
  local y_diapozone = {min = 0, max = 600}
  local velocity_y_diapozone = {min = 50, max = 150}
  local velocity_x_diapozone = {min = 50, max = 150}
  for i = 1, dummy_count do
    local dummy = {object = "entity", params = {x = 0, y = 0, velocity_y = 0,velocity_x =0}}
    
    
    
    dummy.params.x = love.math.random(x_diapozone.min,x_diapozone.max)*(love.math.random(-1,1) > 0 and 1 or 0 )
    dummy.params.y = love.math.random(y_diapozone.min,y_diapozone.max)*(love.math.random(-1,1) > 0 and 1 or 0 )
    dummy.params.velocity_y = love.math.random(velocity_y_diapozone.min,velocity_y_diapozone.max)
    dummy.params.velocity_x = love.math.random(velocity_x_diapozone.min,velocity_x_diapozone.max)

    table.insert(objects_table,dummy)
  end;
  
end;

return current_module