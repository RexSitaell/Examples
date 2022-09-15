------------------------------------------------
------------------------------------------------
--[[
TODO
]]
------------------------------------------------
------------------------------------------------
class = require 'libs/middleclass/middleclass';
ecs  = require 'libs/concord';
------------------------------------------------Modules Init
utils = require 'modules/utils'
local room_manager = require 'modules/room_manager'
local ecs_handler = require 'modules/ecs_handler'
local debug_module = require 'modules/debug'
------------------------------------------------MAIN

ecsHandler  = ecs_handler.ECSHandler:new()
local roomData = room_manager.RoomData:new();
roomManager = room_manager.RoomManager:new(roomData);
debug = debug_module.Debug:new()

--roomManager:GotoDefaultRoom()
roomManager:GotoRoom("extra")

function love.load()
  
end;

local time = 0
local timer = 5

function love.update(dt)

  
  ecsHandler.world:emit("update", dt)
  time = time+10*dt
  if time >= timer then
    time = 0
    roomManager:GotoRoom("extra")
  end;
end;

function love.draw()
  ecsHandler.world:emit("draw")
  debug:Draw()
end;
