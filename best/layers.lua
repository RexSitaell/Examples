local layers = {}

layers.current_layer = 1

layers.default = {
  parallax_x = 1, --0-1
  parallax_y = 1, --0-1
  color_a = 1,
  visible = true,
  blocked = false,
  x = 0,
  y = 0,
  }

layers.band = {}

function layers.create(data)
  local layer = {}
  local variables 
  if type(data) == "string" then
    variables = {parallax_x =  layers.default.parallax_x,
      parallax_y =  layers.default.parallax_y,
      color_a =  layers.default.color_a,
      visible = layers.default.visible,
      blocked = layers.default.blocked,
      x =  layers.default.x ,
      y =  layers.default.y ,
      name = data
      }--layers.default
    variables.name = data
  else
    
    local vis = data.visible
    if vis == nil then vis = layers.default.visible end
    local block = data.blocked
    if block == nil then block = layers.default.blocked end
    
    variables = {
      parallax_x = data.parallax_x or layers.default.parallax_x,
      parallax_y = data.parallax_y or layers.default.parallax_y,
      color_a = data.color_a or layers.default.color_a,
      visible = vis,
      blocked = block,
      x = data.x or layers.default.x ,
      y = data.y or layers.default.y ,
      name = data.name or "unnamed"
      }
  end
  
  
  layer.variables = variables
  layer.execQueue = {}
  layer.minIndex = 1
    layer.maxIndex = 1
  
  
  layer.queue = function(i,fun,...)
    
    if type(i) ~= "number" then
    print("Error: deep.queue(): passed index is not a number")
    return nil
  end

  if type(fun) ~= "function" then
    print("Error: deep.queue(): passed action is not a function")
    return nil
  end

    
     
    
    local arg = { ... }
    
     if i < layer.minIndex then
    layer.minIndex = i
  elseif i > layer.maxIndex then
    layer.maxIndex = i
  end
  
  if arg and #arg > 0 then
    local t = function() return fun(unpack(arg)) end
    
    
    
     if layer.execQueue[i] == nil then
      layer.execQueue[i] = { t }
    else
      table.insert(layer.execQueue[i], t)
    end
  else
    if layer.execQueue[i] == nil then
     layer.execQueue[i] = { fun }
    else
      table.insert(layer.execQueue[i], fun)
    end
  end
  
    
    
  --end
  
  
  
  
end

--доработать слои


layer.execute = function()
  
  for i = layer.minIndex, layer.maxIndex do
    if layer.execQueue[i] then
      
      
      for _, fun in pairs(layer.execQueue[i]) do

        fun()
        love.graphics.setColor( 1, 1, 1,1)
      end
      
      
    end
    
    
  end
  
  
  layer.execQueue = {}
  
end
  
  
  return layer
  
end


function layers:add(layer)
  layers.band[calc_len(layers.band)+1] = layers.create(layer)
end
function layers:clear()
   layers.band = {}
end

function layers:get_default() --возвращает индекс верхнего слоя
 -- return 1 --#layers.band
end

function layers:get(var,layer)
  
  local result =   layers.band[layer].variables[var]
  if var == "x" or var == "y" then
    result = layers.band[layer].variables[var]*layers.band[layer].variables["parallax_"..var]
  end

  return result
end

function layers:set(layer,var,val)
  layers.band[layer].variables[var]=val
end


function layers:current(arg) --устанавливает значение, если имеет аргумент, и запрашивает значение, если не имеет аргумента
  if arg then
    layers.current_layer = arg
  else
    return layers.current_layer
  end 
end


function layers:draw()
  
  for i = 1 , #layers.band do
    if  layers:get("visible",i) then
      layers:current(i)
      layers.band[i].execute()  --написать свой zOrder, потому что нынешний = хуета
    end
    
  end
  
  
end


--создаем слой

--делаем слой видимым или невидимым

--сделать компонент?


return layers