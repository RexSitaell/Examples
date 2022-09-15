function object(e,params) --BASE CLASS
  e

  :give("position", params)
  :give("drawable", params)
 -- :give("debug", params)
  
  e.name = "object"
  end

function sprite(e,params)  --BASE CLASS
  local params = params or {}
    e
    :assemble(object,params)
    :give("animation",params.animation,e)
    
    e.name = "sprite"
end

function player(e,params)
  local params = params or {}
    e
    :assemble(sprite,params)
    :give("velocity",params)
    :give("controlled")
    
    e.name = "player"
end

function sceleton(e,params)
  local params = params or {}
  params.animation = {name = "tectonic" }  
  e
    :assemble(sprite,params)

    e.name = "sceleton"
  end
  
  function player(e,params)
  local params = params or {}
  params.animation = {name = "char" }  
  e
    :assemble(sprite,params)

    e.name = "player"
  end
  
  function dj(e,params)
  local params = params or {}
  params.animation = {name = "dj" }  
  e
    :assemble(sprite,params)

    e.name = "dj"
  end
	
	
  
function UC(e,params)
  local params = params or {}
  params.animation = {name = "UnderConstruction"} 
  e
    :assemble(sprite,params)
  e.name = "UC"
end

function WORLDMAP(e,params)
  
  local params = params or {}
  params.animation = {name = "WORLDMAP"} 
  e
    :assemble(sprite,params)
  e.name = "WORLDMAP"
end

function LVLMAP(e,params) --placeholder
  
  local params = params or {}
  --params.folder =
  params.animation = {name = "map1"} 
  e
    :assemble(sprite,params)
  e.name = "LVLMAP"
  
  
end


----------------------------------------------------------
function arrow(e,params)
  local params = params or {}
  
  params.animation = {name = "arrowsingle", tags =  "minor"}  --main or minor
  params.w,params.h = 16 , 16
  params.acceleration = params.acceleration  or 10 
  params.max = params.max   or 10 

  
    e
    :assemble(sprite,params)
    :give("velocity",params)
    :give("arrow",params)
    
    
    e.name = "arrow"
    
end

function beat_area(e,params)
  local params = params or {}
  
  params.x = WW/2-TileSize*1.5
  params.y = LVL_DATA[level].BEAT_SYS.area_y or WH-190
  params.w = 3*TileSize
  params.h = LVL_DATA[level].BEAT_SYS.area_h or 160
  
    e
    :assemble(object,params)
    :give("beat_area",params)
    
    e.name = "beat_area"
  end
  

------------------------------------------------------------------------------
function icon(e,params)
  local params = params or {}
  e
  :give("icon",params,e)
  --params.icon = ""
  e.name = "icon"
end


function tilemap(e,params)--выпили эту хуету отсюда нахуй
  local params = params or {}
  e
  :assemble(object,params)
  :give("map",params.map_name,e)
  
  e.name = "tilemap"
end

function ui_button_1(e,params) 
  local params = params or {}
  params.w = 84
  params.h = 32
  params.centered_text = true
  e
  
  :assemble(nine_patch_button,params)
  :assemble(button,params)
  :give("text",params,e)
  e.name = "ui_button_1"
end

function ui_button_2(e,params) 
  local params = params or {}
  params.w = 128
  params.h = 128
  e

  :assemble(nine_patch_button,params)
  :assemble(button,params)
  :assemble(icon,params)
  --:give("text",params,e)
  e.name = "ui_button_1"
end


function nine_patch_button(e,params) 
  local params = params or {}
  params.w = params.w or 84
  params.h = params.h or 32
  params.asset =  "assets/graphics/ui/button_9_patch.png"
  
  local settings = {corner = {w = 16, h = 16},
                    side_pattern_len = 1}
  params.sectors = settings


  e
  :assemble(object,params)
  :give("nine_patch",params,e)
  
  
end


function button(e,params)  --BASE CLASS V
  local params = params or {}
  e
  :give("mouse_callback",params,e)
  :give("button",params,e)
  
  e.name = "button"
  
end

function checkbox(e,params) --BASE CLASS
  local params = params or {}
  e
  :assemble(object,params)
  
  :give("checkbox",params,e)
  :give("mouse_callback",params,e)
  --:give("button",params,e)
  
  e.name = "checkbox"
  
end


function slider(e,params)  --BASE CLASS
  local params = params or {}
  e
  :assemble(object,params)
  :give("slider",params,e)
  :give("mouse_callback",params,e)
  
  e.name = "slider"
end

function list(e,params)  --BASE CLASS
  local params = params or {}
  e
  :assemble(object,params)
  :give("list",params,e)
  
  e.name = "list"
end

function ui_text(e,params) --BASE CLASS ///
  
  local params = params or {}
  params.independent = true 
  e
  :assemble(object,params)
  :give("text",params,e)
  
  e.name = "ui_text"
  
end

function elder_page_text(e,params)
	local params = params or {}
	e
	:assemble(ui_text,params)
	
	e.name = "elder_page_text"
end;

function elder_page(e,params)
	local params = params or {}
	
	--local font_info = fonts.info 
	--local colors = {normal = "black",big = "red"}
  --params.independent = true 
	params.text = reread_file()
  e
  :assemble(object,params)
	:give("elder_page",params,e)
  --:give("text",params,e)
  
  e.name = "elder_page"

end;




function dialogue_window(e,params)

  e
  :assemble(object,params)
  
  :give("text",params,e)
  :give("dialogue",params,e)
  e.name = "dialogue_window"
  
end
