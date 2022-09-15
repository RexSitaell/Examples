--newImage должен фигурировать только в этом месте
--[[
TODO реальная адаптивность функции set sprite под любые возможные таблицы параметров
TODO реализовать в сущностях конструкторы такой таблицы
]]

local default_drawable_path = "assets/sprites/not_sprite.png"
local default_drawable = love.graphics.newImage(default_drawable_path) 

local function SetSprite(c,sprite_path)
  --проходим по таблице параметров и собираем из этого финальный спрайт, который отрисовываем
  
  local result = nil
  local params = c.sprite_draw_params
  for key, param in pairs(params) do
    --magic
  end;
  c.sprite = result or default_drawable
end;

local drawable = ecs.component("drawable", function(c,params,e) 
    local owner = e
    local params = params or {}
   -- c.default_sprite --default _ param
    c.sprite = default_drawable
    c.sprite_draw_params = {}
    c.SetSprite = SetSprite
end)


return drawable