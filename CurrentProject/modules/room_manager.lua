------------------------------------------------ROOM SYSTEM
--[[
Описание системы.
Если в room_data прописана default_room, если в current_room ничего не прописано - будет запущена комната default_room
Если и в default_room и в current_room ничего не прописано, или не удалось найти current_room - будет запущена null_room
TODO
1.сделать передачу параметров в null_room, чтобы можно было понять, из-за чего мы в ней попали
2.на данный момент RoomManager сохраняет все комнаты в roomManager.roomList, возможно стоит сохранять только текущую комнату?
3. ̶в̶ы̶н̶е̶с̶т̶и̶ ̶m̶o̶d̶u̶l̶e̶_̶e̶n̶v̶_̶i̶n̶i̶t̶
4.функция spawn - должна работать с хранилищем объектов в комнате
]]
local current_module = ModuleEnvInit()  --работает только в пределах текущего файла
------------------------------------------------RoomData
--[[
осуществляет парсинг данных из локальной таблицы или xml файлв
]]
------------------------------------------------
--local roomsData = {
--  info = {
--    default_room = "main_menu"
--    },
--  rooms =  {
--    --["main_menu"] = { objects = {} , scripts = {},},
--    --["options"] = { objects = {} , scripts = {},},
--    --["extra"] = { 
--    --  objects  = {
--    --    {object = "entity", params = {x = 200, y = 100, velocity_y = 20,velocity_x =15}},
--    --    {object = "entity", params = {x = 700, y = 40, velocity_y = 10,velocity_x =-70}},
--    --  },
--    --  scripts = {
--    --  },
--    --},
--  },
--};

local null_room = {objects = {} , scripts = {},}
local layouts_path = "assets/layouts"
local info_file = "_info.lua"

RoomData = class("RoomData");
function RoomData:initialize(data)
  if not RoomData.INSTANCE then
    RoomData.static.INSTANCE = self;
    local arg_data = self:ParseRoomData(data)
    self.room_list  = arg_data.rooms --and arg_data.rooms or self.default_data.rooms;
    self.data_info  = arg_data.info --and arg_data.info or self.default_data.info;
    self.null_room  = "null_room"   -- имя комнаты , если искомой комнаты не существует
    self.room_list[self.null_room] = null_room --таблица комнаты , если искомой комнаты не существует
  else
    print("error RoomData already exists");
  end;
end;

local function ParseXMLFile()
end;

local function ParseDefaultLayotsFolder()
  local folder = layouts_path
  local info_file_name = info_file
  local indexed_layouts_list = love.filesystem.getDirectoryItems( folder )
  local named_layouts_list = {}
  
  for idx,layout_name in pairs(indexed_layouts_list) do
    local layout_cutname = layout_name:cut(".lua")
    local layout_path = folder.."/"..layout_cutname
    named_layouts_list[layout_cutname] = require(layout_path)
  end;
  
  local result = {}
  local info_cutname = info_file_name:cut(".lua")
  
  result.info = utils.DeepCopy(named_layouts_list[info_cutname]) --трушно копируем инфо 
  named_layouts_list[info_cutname] = nil --выпиливаем инфо из списка комнат
  result.rooms = utils.DeepCopy(named_layouts_list) --трушно копируем список комнат
  return result
end;

function RoomData:ParseRoomData(data)
  if data then
    if type(data) == "table" then
      return data
    else
      --xml
    end
  else
    return ParseDefaultLayotsFolder()
  end;
end;
------------------------------------------------RoomManager 
--[[
осуществляет переход между комнатами
]]
------------------------------------------------
RoomManager = class("RoomManager");

local function RMMethodsInit(self) --ненаследуемые методы, вызываются раньше публичных , если в параметры не передается self -  значит приватные
  self.AddRoom = function(room)
    local room_name = room.info.name
    self.current_room = room_name
    self.room_list[room_name] = room;
  end;
  
  self.PrintRoomList = function(self)
    for key,room in pairs( self.room_list ) do
      local info = room:GetInfo()
      print(key,info.name)
    end;
  end;
  
  self.SetRoomName = function(self,room_name) --просто устанавливает значение
    self.currentRoom = room_name;
  end;
  
  self.GetTargetRoomName = function(self) 
    local room_list= self.data_manager.room_list--self.roomData
    local target_room = self.currentRoom  or (self.data_manager.data_info and self.data_manager.data_info.default_room ) or self.data_manager.null_room 
    local result = room_list[target_room] and target_room or nil
    if not result then 
      result = self.data_manager.null_room--utils.GetFirstIndex(data)
    end;
    return result ;
  end;
  self.SearchRoom = function(self)
    return self.currentRoom ~= nil;
  end;
end;

function RoomManager:initialize(data_manager)
  if not RoomManager.INSTANCE then
    RoomManager.static.INSTANCE = self;
    self.data_manager = data_manager
    self.room_list = {};
    self.currentRoom = nil
    RMMethodsInit(self);
  else
    print("error RoomManager already exists");
  end;
end;

function RoomManager:ParseObjectsLua(data)
  ecsHandler.world:clear()
  local roomData = self.data_manager.room_list
  local room_name; 
  room_name = self:GetTargetRoomName();
  
  if type(roomData[room_name])  ~= "table"  then --проверка на корректность комнаты
    print("Room '"..room_name.."' is exist, but corrupted. ")
    room_name = self.data_manager.null_room
  end
  print("Room '"..room_name.."' loaded.")
  local room = Room:new( room_name);
end;

function RoomManager:ParseObjectsXML()
end;

function RoomManager:GotoRoom(room_name)
  --self.room_list[self.currentRoom or 1] = nil
  
  self:SetRoomName(room_name)
  self:ParseObjectsLua()
  print(#self.room_list)
end

function RoomManager:GetCurrentRoomObject()
  return self.data_manager.room_list[roomManager.current_room]
end;


function RoomManager:GotoDefaultRoom()
  --self.room_list = {}
  self:SetRoomName()
  self:ParseObjectsLua()
end
------------------------------------------------Room
--[[
комната с объектами
]]
------------------------------------------------
local default_layers_list = {[1] = { name =  "default", parralax = {x = 1, y = 1}  }}   --parallax [[ 0 - 1 ]] 
local default_objects_list = {}

local function default_layers_check(table)
  local result = table and #table > 0 or default_layers_list
  return result
end;

local function default_objects_check(table)
  local result = table or default_objects_list
  return result 
end;

Room = class("Room");
function Room:initialize(name )
  local function room_setup_info()
    self.info = {name = name};
    self.room_manager = RoomManager.INSTANCE;
    self.room_manager.AddRoom(self);
  end;
  local function room_setup_data()
    local layers_table = self.room_manager:GetCurrentRoomObject().layers --self.room_manager.data_manager.room_list[name].layers --or {[1] = "default"}
    local objects_table = self.room_manager:GetCurrentRoomObject().objects; --objects data before spawn
    self.layers = default_layers_check(layers_table)
    print(#objects_table)
    self.objectsList = default_objects_check(objects_table)
    self:ParseObjectsLua()
  end;
  room_setup_info()
  room_setup_data()
end;

function Room:GetInfo()
  return self.info
end;

function Room:Spawn(object,params)
  local world = ecsHandler.world
  local obj_list = self.entityList
  obj_list[#obj_list+1] = ecs.entity(world):assemble(ecsHandler.entity_storage[object],params)
end;

function Room:ParseObjectsLua() --загружает список объектов из таблицы lua
  
  self.entityList = {} --entity list
  for key, val in pairs(self.objectsList) do
    local object_name = val.object
    local object_params = val.params
    self:Spawn(object_name,object_params)
  end
  --if save, load save
end;

function Room:ParseObjectsXML()
end;
------------------------------------------------
------------------------------------------------
return current_module

