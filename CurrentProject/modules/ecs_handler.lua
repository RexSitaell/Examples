------------------------------------------------ECS HANDLER
------------------------------------------------
--[[
автоматически подгружает сущности компоненты и системы из папок
]]
------------------------------------------------
------------------------------------------------
local current_module = ModuleEnvInit()
------------------------------------------------
local ecs_path = "ecs/";
ECSHandler = class("ECSHandler");
function ECSHandler:initialize()
  if not ECSHandler.INSTANCE then
    ECSHandler.static.INSTANCE = self;
    self.folder = ecs_path
    self.entity_storage = self:GetEntityes()
    self.component_storage = self:GetComponents()
    self.system_storage = self:GetSystems()
    
    self.world = ecs.world()
    self.world:addSystems(unpack(self.system_storage))
    
    --print("ECSHandler Setup.");
  else
    --print("error ECSHandler already exists");
  end;
end;

function ECSHandler:GetEntityes()
  local indexed_entityes_list = love.filesystem.getDirectoryItems( ecs_path.."entityes" )
  local named_entityes_list = {}
  for idx,ent_name in pairs(indexed_entityes_list) do
    local entity_name = ent_name:cut(".lua")
    local entity_path = ecs_path.."entityes/"..entity_name
    named_entityes_list[entity_name] = require(entity_path)
  end;
  return named_entityes_list;
end;

function ECSHandler:GetComponents()
  local components_list = love.filesystem.getDirectoryItems( ecs_path.."components" )
  for idx,comp_name in pairs(components_list) do
    components_list[idx] = require(ecs_path.."components/"..comp_name:cut(".lua"))
  end;
  return components_list;
end;

function ECSHandler:GetSystems()
  local systems_list = love.filesystem.getDirectoryItems( ecs_path.."systems" )
  for idx,sys_name in pairs(systems_list) do
    systems_list[idx] = require(ecs_path.."systems/"..sys_name:cut(".lua"))
  end;
  return systems_list;
end;

return current_module