

Concord.component("position", function(c, params,obj)
		c.scale = params.scale or 1
    c.x = params.x or 0
    c.y = params.y or 0
    c.w = params.w or 0
    c.h = params.h or 0
    c.z = params.z or 1
		
		
    c.opacity = params.opacity or 1
    c.rot = params.rot or  0
    c.visible = params.visible or true
    
    c.orientation = 1
    c.orientated = true

end)





Concord.component("velocity", function(c, params,obj)
    c.x = params.velx or 0
    c.y = params.vely or 0

   
    c.acceleration = params.acceleration or 100
   -- c.acceleration = c.acceleration
    c.deceleration = params.deceleration or 200
    --c.deceleration = c.deceleration*(G_scale/2)
    c.max = params.max or 200
    
    
        c.accelerate = function(obj,speed,dt)
      local result = speed or 0
      
      if result < c.max then result = result+c.acceleration*dt end
        
      return result
      end
      --end

end)

Concord.component("animation", function(c, animation,obj)
    local folder = "assets/graphics/game/" or params.folder
    if not animation then
      animation = {name = "nothing", tags =  "where"}
    end
    if not animation.tags then
      animation.tags = "Tag"
    end
    
    
    function c:set(frame,tag,mode)
      if tag then self.core:setTag (tag) end
      if frame then self.core:setFrame(frame) end
    end
    
    function c:switch(tag)  -- like [set] , but for playing from first frame
      self.core:setTag (tag)
      self.core:setFrame(1)
    end
    
    function c:event(mode)
      if mode then 
         self.core[mode](self.core) 
        
      end
    end
    
    function c:get_data()
      local frameIndex = self.core:getFrame()
      local tagName = self.core.tagName
      return frameIndex,tagName
    end
    
    function c:is_frame(frame)
      if self.core:getFrame() == frame then
        return true
      else
        return false
      end

    end
    
    function c:is_tag(tag)
      if self.core.tagName == tag then
        return true
      else
        return false
      end
    end
    

    c.core = peachy.new(folder..animation.name..".json",
                     love.graphics.newImage(folder..animation.name..".png"),
                     animation.tags)
                   
                   
                   
                   
    c.x_scale = obj.position.scale
    c.y_scale = obj.position.scale
    if obj.position.w == 0 then
      obj.position.w = c.core:getWidth()
    else
      c.x_scale = obj.position.w/c.core:getWidth()
      
    end
    
     if obj.position.h == 0 then
       obj.position.h = c.core:getHeight()
     else
       c.y_scale = obj.position.h/c.core:getHeight()
     end

end)

Concord.component("map",function(c,name,obj)
    c.data = cartographer.load(name)    
  end)


	

Concord.component("text",function(c,params,obj)
    c.content = params.text or ""
    c.font = fonts[params.font] or font
		c.color = params.color or "Black"
    
    c.independent = params.independent or false
    c.centered = params.centered_text or false
    
    

    local font_size_h = 24
    local font_size_w = font_size_h/2+2
    
    c.w_tab  = 0 
    c.h_tab  = 0 
    

    if c.independent then
      c.z =obj.position.z
      obj.position.h =font_size_h/G_scale
      obj.position.w = (font_size_w/G_scale)*unicode_str.len(c.content)
    else
      c.z = obj.position.z+1
      if c.centered then
        c.w_tab  = ((obj.position.w/2) -((font_size_w*(unicode_str.len(c.content)/4))  )  )--/G_scale --+10  --/2  
        c.h_tab  =  obj.position.h/3
      else
        c.w_tab = 12
        c.h_tab = 12
      end
    end
    
  
  function c:set(arg)
    c.content = arg
    
    end
    

end)

Concord.component("icon",function(c,params,obj)
    local folder = "assets/graphics/game/"
    c.asset = params.icon or  "nothing.png"
    c.image = love.graphics.newImage(folder..c.asset)
    c.w,c.h = c.image:getDimensions()
    
    
    end)
		
	Concord.component("elder_page",function(c,name,obj)
    c.data = reread_file()
		c.progress = 0 
		c.max_progress = 1
		c.strings = {}
		c.page_table = {}
		c.font_big = fonts["big_font"] 
		c.font_normal = fonts["font"] 
		
		local w,h = 486,300--512,288-- 486,300
		local font_info = fonts.info 
		local size_big, size_normal = fonts.info.size.big/G_scale,fonts.info.size.normal/G_scale
		local colors = {normal = "black",big = "red"}
		
		
		
		
		----------------------------------interface
		c.next_progress = function(render_func)
			c.progress = c.progress + 1;
			local word = ""
			if c.progress > c.max_progress then
			  c.progress = 0
				render_func()
				c.update_content()
			else
				---------------------------------
			
				---print(c.strings[cur_string][prg].value)
				---------------------------------
			end
			return word
		end;
		
		------------------------------------
		
		
		----------------------------------- таблица слов
	
		
		
		c.word_table_build = function()
		
		c.data = ""
		c.data = reread_file()

		local start_word,words_on_page = 4, 100
		local _,words_count = c.data:gsub("%S+","")
		c.words_count = words_count--reread_file()--c.data:gsub("%S+","")
		
			local counter = 0;
			page_table = {}
			c.strings = {}
			for n in c.data:gmatch("%S+") do
			counter = counter + 1
				if counter >= start_word then
					if counter == words_on_page+start_word then
						--table.insert(result_table,n)
						--result = n
						break
					end
					table.insert(page_table,n)
				end;
				
			end
		end;
		
		
		
		--print(#result_table)
		
		
		c.build_string = function(idx,y,x_offset) 
		  local printed_lenght = 0
		--	local offset = 130
			local printed_y = y*size_normal+(15*G_scale*y)
			local result = ""
			local t_res = {}
			
			local tabulation = 60
			
			for counter = idx or 1, #page_table do
				local word = page_table[counter]
				local first_char = string.sub(word,1,1)
				local is_upper = string.match(first_char,"%u") and true or false;
				
				local first_char_lenght = is_upper and size_big or size_normal/20
				local print_lenght = (first_char_lenght+((#word-1)*size_normal))/ 1.3 
				
				--twid = text width
				local twid =  font:getWidth( result..word.." "..((is_upper and #word == 1  ) and " " or "" )  )
				if twid < w + (-x_offset+230)*2 then
					table.insert(t_res,{value = word, is_upper = is_upper,x = font:getWidth( result ) +((100+x_offset)*G_scale)+ (idx == 1 and  tabulation or  0 ), y = printed_y+60}) ;
					result = result..word.." "..string.rep(" ",(is_upper and #word == 1  ) and 2 or 1 )--.." ";
				else 
					return t_res,result,font:getWidth( result )
				end;
			end;
			return t_res,result
		end;
		
		c.update_content = function()
		
		
			local idx = 1
			local yidx = 1
			c.word_table_build ()
			while idx <  #page_table-1 and yidx <= 15 do
				local offset = yidx < 10  and 230 or 0
				local result_table,str,info =  c.build_string(idx,yidx-1,offset)
				table.insert(c.strings,result_table)
				idx = idx+#result_table
				yidx  = yidx + 1
			end
			c.max_progress = idx-1
		end;
end)

Concord.component("nine_patch",function(c,params,obj) 
    local asset = params.asset -- or default
    
    c.deformated = true --for init form-calculating (with canvas)
    c.canvas = nil
    
    c.image = {}
    c.sectors = params.sectors -- or default
    
    c.image.root = love.graphics.newImage(asset)
    
    local size = {}
    size.w,size.h = c.image.root:getDimensions()
    
    
    
    c.image.left_up = love.graphics.newQuad(0,0,
                                            c.sectors.corner.w,c.sectors.corner.h,
                                            size.w,size.h)
    c.image.right_up = love.graphics.newQuad(size.w-c.sectors.corner.w,0,
                                             c.sectors.corner.w,c.sectors.corner.h,
                                             size.w,size.h)
    c.image.right_down = love.graphics.newQuad(size.w-c.sectors.corner.w,size.h-c.sectors.corner.h,
                                               c.sectors.corner.w,c.sectors.corner.h,
                                               size.w,size.h)
     c.image.left_down = love.graphics.newQuad(0,size.h-c.sectors.corner.h,
                                               c.sectors.corner.w,c.sectors.corner.h,
                                               size.w,size.h)
     c.image.left_side = love.graphics.newQuad(0,c.sectors.corner.h,
                                               c.sectors.corner.w,c.sectors.side_pattern_len,
                                               size.w,size.h)
     c.image.right_side = love.graphics.newQuad(size.w-c.sectors.corner.w,c.sectors.corner.h,
                                               c.sectors.corner.w,c.sectors.side_pattern_len,
                                               size.w,size.h)
     c.image.up_side = love.graphics.newQuad(c.sectors.corner.w,0,
                                             c.sectors.side_pattern_len,c.sectors.corner.h,
                                             size.w,size.h)
     c.image.down_side = love.graphics.newQuad(c.sectors.corner.w,size.h-c.sectors.corner.h,
                                             c.sectors.side_pattern_len,c.sectors.corner.h,
                                             size.w,size.h)
     c.image.center = love.graphics.newQuad(c.sectors.corner.w,c.sectors.corner.h,
                                            c.sectors.side_pattern_len,c.sectors.side_pattern_len,
                                            size.w,size.h)
       
       
  end)


Concord.component("mouse_callback",function(c,params,obj)
    
    c.clicked = function()
      if clicked(obj.position) then
        return true
      else
        return false
      end
    end
    
    c.dragged = function()
      if dragged(obj.position) then
        return true
      else
        return false
      end
    end
    
    c.touched= function()
      if touched(obj.position) then
        return true
      else
        return false
      end
    end
    
    
  end)


Concord.component("button",function(c,params,obj)
    c.event = params.event or nil
    if c.event and not c.event.args then  c.event.args = {} end

  end)

Concord.component("checkbox",function(c,params,obj)
    obj.position.w = 16
    obj.position.h = 16
      
    c.image = {}

      c.image.root = love.graphics.newImage( "assets/graphics/ui/checkbox.png")
      c.image["false"] = love.graphics.newQuad(0,0,16,16,c.image.root:getDimensions())
      c.image["true"]  = love.graphics.newQuad(16,0,16,16,c.image.root:getDimensions())
      
     -- c.w, c.h = 16,16
      
      
      c.var = params.var or nil
      
      c.event = params.event or nil
      if c.event and not c.event.args then  c.event.args = {} end
      
    function c:switch_state()
      c.state = switch_bool(c.state)
      
      
    end
    
    c.state = params.state or false

  end)

Concord.component("slider",function(c,params,obj)
    c.image = {}
    c.image.root = love.graphics.newImage( "assets/graphics/ui/slider.png")
    c.image["left_corner"] = love.graphics.newQuad(0,0,16,16,c.image.root:getDimensions())
    c.image["body"] = love.graphics.newQuad(12,0,16,16,c.image.root:getDimensions())
    c.image["right_corner"] = love.graphics.newQuad(16,0,16,16,c.image.root:getDimensions())
    c.image["slider"] = love.graphics.newQuad(32,0,16,16,c.image.root:getDimensions())
    
  --  c.w, c.h = tonumber(params.w) , params.h or 36,16
    c.dragged = false
    c.len = 7
    
    obj.position.w,obj.position.h = (c.len)*16,16
    c.w,c.h = (c.len)*16,16
    c.cell_w = 16
    
    c.state = params.state or 0.5
    c.var = params.var  or nil
    c.val = c.state
    
  end)

Concord.component("list",function(c,params,obj)
    c.image = {}
    c.image.root = love.graphics.newImage("assets/graphics/ui/list.png")
    c.image["field"] = love.graphics.newQuad(0,0,48,16,c.image.root:getDimensions())
    c.image["btn"] = love.graphics.newQuad(48,0,16,16,c.image.root:getDimensions())
    c.image["btn_2"] = love.graphics.newQuad(48,16,16,16,c.image.root:getDimensions())
    c.image["background"] = love.graphics.newQuad(0,16,48,16,c.image.root:getDimensions())
    
    --c.w,c.h = 64,16
    obj.position.w = 64
    obj.position.h = 16
    
    
    c.event = params.event or nil
    
    c.arr_name = params.list
    c.array = _G[params.list] or {options = {a=true,b=true,c=true}, selected =  "b"}
    --if not c.list then 
     -- c.list = {options = {a=true,b=true,c=true}, selected =  "b"}
    --  end
    
    c.len = calc_len(c.array.options)
    c.indexes = {}
    
    c.open_size = {w = 48, h = c.len*16+obj.position.h}
    c.opened = false
    c.state = c.array.options[c.array.selected ]--c.array.selected 
    
    
    
  end)

----------------------------------------------------------
Concord.component("arrow",function(c,params,obj)
    c.kind = params.kind or 1
    c.status = params.status or "minor"
   
    c.builded = false
    c.overlap = false
    c.collision = nil
    c.h = params.h or 1
    c.condition = params.condition or 0
    c.collider = {
      total_len,
      remainig_len,
      y,
      condition ,
      process,
      startpos
      }
    c.collision_switch = false
    
    function c:collision_call(index,len)
      if not c.collision then
        self.collision = {timer = 0, len = len, index = index}
      else
        self.collision.timer = 0
        
      end
      
    end
    

    
    
    c.succes = false
    c.effect = false
    
    c.area_index = params.area_index or nil
    c.target_index = params.target_index or nil
    c.len =  1


    c.key = params.key or nil
    c.input = false
    c.input_buf = false
    c.input_timer =  0
    c.mistake = false

    c.lock = timer_setup()


  end)

Concord.component("beat_area", function (c,data,obj)
    
    c.builded = false
    c.root_arrows_indexes = {}
    c.pattern = {false,false,false,false}
    c.next_pattern = {false,false,false,false}
    c.song_map = {}
    c.song_beat = 0
    c.delay = 5
    c.input = {
      ["q"] = {index = 1},
      ["w"] = {index = 2},
      ["e"] = {index = 3},
      ["r"] = {index = 4}}
    c.timer = 0
    c.check_beat = false
    c.beat_lock = false
    c.bpm = 0
    
    c.acc = 100  --preset for arrows
    c.max = 100
    
    c.beat = false
    c.beatstarter = audio:newSource( "assets/music/void.mp3","stream")
    c.lvl_music = audio:newSource( "assets/music/lvl.mp3","stream")
    c.playing = false
  
    
    c.beatstarter:onBeat(function()
        c.beat = true
      end)
    
    
    c.music = nil
    
    c.miss_points = 0
    c.succes_points = 0
    
    function c.setup()
      
      c.bpm = LVL_DATA[level].BEAT_SYS.area_bpm
        c.delay = LVL_DATA[level].BEAT_SYS.delay_in_beats  --working with delay in [ 3-5 ]
        c.max = light_speed
        
        local t = 60/c.bpm
        local S = LVL_DATA[level].BEAT_SYS.area_h - (16*2)*2  --64
        local V = S/t
        local a =  ((V/t)/5)*4/(c.delay-(1))
        c.acc = a
    end
    

    function c.mistake(points)
      c.miss_points = c.miss_points+points

    end
    
    function c.succes(points)
      c.succes_points = c.succes_points+points

    end
    
    
  end)
---------------------------------------------------------
Concord.component("dialogue", function(c, params,obj)
    c.asset = "assets/graphics/ui/dialogue.png"
    c.image = love.graphics.newImage(c.asset)
    c.encounter = 0
    c.active = false
     obj.position.w,obj.position.h = c.image:getDimensions()
     obj.position.x = WW/2 - obj.position.w/2
     obj.position.y = WH - obj.position.h-10
     
     function c:activate()
       self.active=true
     end
     
     
     


    
  end)

    
    
    

Concord.component("system", function (c,data,obj)
    

    
    end)
Concord.component("debug", function (c,data,obj)
    
    
    end)


Concord.component("drawable", function (c,params,obj)
    
    c.layer = params.layer or 1  --'main'-- 1-- params.layer or layers:get_top()
		c.color = params.color or {r = 1, g = 1, b = 1}
    c.x = 0
    c.y = 0
   -- c.opacity = params.opacity or 1
    end)


local Controlled = Concord.component("controlled")



