local Elder_pageSystem = Concord.system({
    pool = {"position","drawable","elder_page"}
  })
	
	local pencil = Sound.sound_pack.get("pencil")
	local paper = Sound.sound_pack.get("paper")
	----------------------
	--textColorBlack = {
  --r=colorConvert(10),
  --g=colorConvert(10),
  --b=colorConvert(10),
  --a=1}
	--
	--
	--textColorRed = {
  --r=colorConvert(195),
  --g=colorConvert(20),
  --b=colorConvert(30),
  --a=1}
	
	textColor={
		Red = {
			r=colorConvert(195),
			g=colorConvert(20),
			b=colorConvert(30),
			a=1},
		Black = {
			r=colorConvert(10),
			g=colorConvert(10),
			b=colorConvert(10),
			a=1},
	
	}
	
	local index,init = nil,nil
	
local function test(e)
	--love.graphics.print(e.elder_page.progress.." / "..e.elder_page.max_progress)
end;
-------------------------------------
local test_speed = 0.5--10--0.6
	
	function love.keyreleased(key)
   if key == "q" then
	 test_speed = 15
			
   end
	 if key == "w" then test_speed = 0.5 end
	end
------------------------------------
local function respawn_pic()
			local num = love.math.random(35,154) --номера пикч в папке
			local name = "/dems/output-"..(num <= 99 and "0" or "")..num
			
			if index then obj = Scene:get_object("sprite",index) end
			if obj then obj:destroy() end;
			
			
			index = Scene:Spawn("sprite",{
                x = 85,
                y = 20,
                z = 1,
								scale = 0.3,
								layer = 2,
								opacity = 0,
								animation = {name = name},})
end;

----------------------
local chars = {}

local function destroy_chars()
	for k,v in pairs(chars) do  
				--local obj = Scene:get_object("elder_page_text",chars[v])
				v:destroy()
				chars[k] = nil
				--obj:destroy() 
			--	if obj then obj:destroy() end
				
	end
end
local animate_word = function(e,word,func_end,func_end_final)

	destroy_chars()
	

	local delay =  0.1/test_speed--math.random(2,7)/100 -- 0.1/10
	local animation_time = 0.2/test_speed--math.random(5,18)/100--0.4 --/10
	
	
	
	
	local print_word = function(word,i,animation_time) 
	--if i == 1 then
		 
	--	end;
			local scale = 0.5
		--local scale = 0.5
			local char_font = (word.is_upper and i == 1) and "big_font" or "font"
			local char_color = char_font == "big_font" and "Red" or "Black"
			
			local startpos = word.is_upper and 2 or 1
			local printed =  word.value:sub(startpos,i-1)
			--print(printed)
			local b_offset_x = (word.is_upper and i > 1 ) and 27*G_scale or 0--fonts["font"]:getWidth(word.value:sub(1,1))*scale or 0
		--	print(word.value:sub(1,1))
			local b_offset_y = (word.is_upper and i == 1) and 6*G_scale or 0
			local _char = word.value:sub(i,i)
			
			
			local word_size = i > 1 and fonts["font"]:getWidth(printed) or 0
			local x = word.x  +word_size+b_offset_x
			local y = word.y+b_offset_y
			
			
			
			--love.graphics.scale( scale,scale) 
			local chr = Scene:Spawn("elder_page_text",{x = x*scale,y = y*scale,text = _char, font = char_font, color = char_color})
			
			local chr_obj = Scene:get_object("elder_page_text",chr)
			object_animate(chr_obj,"position.opacity",
				{0,3,0,
				animation_time/4*3.5,3,0.5,
				animation_time,3,1})
			object_animate(chr_obj,"position.x",{
				0,3,word.x*scale,
				animation_time,3, word.x*scale+word_size*scale + b_offset_x*scale
				})
			object_animate(chr_obj,"position.y",{
				0,3,chr_obj.position.y,
				animation_time/4,3,chr_obj.position.y-8,
				animation_time/2,3,chr_obj.position.y+8,
				animation_time,3,chr_obj.position.y,
				})
			--pencil.play()
			table.insert(chars, chr_obj)
			--chr_obj.position.opacity = 0.0
			--love.graphics.scale( 1/scale,1/scale) 
		--	love.graphics.scale( scale,scale) 
		--	print(_char)
		--love.graphics.print( "aaaaa", word.x, word.y+6*G_scale);
	--	love.graphics.scale( 1/scale,1/scale) 
	end
	--print(#word.value)
	for i = 1, #word.value do
		start_timer(delay*(i-1),function() print_word(word,i,animation_time); start_timer(animation_time/4*3.5,pencil.play) end)
		--print("a")
	end;
	
	start_timer(delay*(#word.value-1)+animation_time,function() 
		--for k,v in pairs(chars) do  
		--		--local obj = Scene:get_object("elder_page_text",chars[v])
		--		v:destroy()
		--		chars[k] = nil
		--		--obj:destroy() 
		--	--	if obj then obj:destroy() end
		--		
		--end
		destroy_chars()
		--chars = {}
		func_end();
		func_end_final();
	--	chars = {}
	end)
	
end;

local function get_next_word(e)	
	local cur_string = 1
				local prg = e.elder_page.progress+1
				for k, str in pairs(e.elder_page.strings) do
				
					if  prg > #str then
						prg = prg - #str
					else
						cur_string = k
						break
					end
				end
				local word =  e.elder_page.strings[cur_string][prg]
				--print(word)
				return word
end

local function new_page_anim(func_end)
--destroy_chars()
--{object = "sprite", params = { z = 1, layer = 1, animation = {name = "parchment_alpha"} } },
local idx1 = Scene:Spawn("sprite",{y = 0 ,opacity = 0,z = 2, layer = 3,scale = 1,rot = -1 ,animation = {name = "parchment_alpha"}})

local obj = Scene:get_object("sprite",idx1)
object_animate(obj,"position.opacity",{0,3,0,0.3,3,1},paper.play)
object_animate(obj,"position.scale",{0,3,1.3,0.5,3,1})
object_animate(obj,"position.rot",
	{
	0,3,-1,
	--0.4,3,-0.3,
	0.6,3,0
	},destroy_chars)

local idx2 = Scene:Spawn("sprite",{y = 0 ,opacity = 1,z = 1, layer = 3,scale = 1,color = {r = 0, g = 0, b = 0} ,animation = {name = "parchment_alpha"}})
--local idx3 = Scene:Spawn("sprite",{y = 10 ,opacity = 1,z = 1, layer = 3,scale = 1,color = {r = 0, g = 0, b = 0} ,animation = {name = "parchment_alpha-export"}})
local obj2 = Scene:get_object("sprite",idx2)
--local obj3 = Scene:get_object("sprite",idx3)
object_animate(obj2,"position.opacity",{0,3,0,0.5,3,0.2})
--object_animate(obj2,"position.rot",{0,3,-0.9,0.5,3,0})
--object_animate(obj3,"position.opacity",{0,3,0,0.5,3,0.5})

start_timer(0.6,function() func_end(); obj:destroy(); obj2:destroy() end)
--func_end()
end
----------------------
local function system_update(e,dt)
	if not init then 
		e.elder_page.update_content()
		respawn_pic()
		init = true;
	end

  local strings , obj
	--function love.mousepressed( x, y, button, istouch, presses )
	
			
			--------------------------------------
		if mouse:is_click() then
			local word = get_next_word(e)--e.elder_page.next_progress(respawn_pic)
			if index then local obj = Scene:get_object("sprite",index); obj.position.opacity = ((e.elder_page.progress+1)/(e.elder_page.max_progress+1)) end
			
			local obj = Scene:get_object("sprite",1)
			local i = 2
			local func_end = function()
			mouse:lock(false)
			--local func_end = function() mouse:lock(false)	  end;
			--object_animate(obj,"position.y",{0,i,obj.position.y, 0.6,i,obj.position.y+400, 1,i,obj.position.y},func_end)
			end
			mouse:lock(true)	
			--if rendered_words > e.elder_page.progress then return end;
			if e.elder_page.progress <  e.elder_page.max_progress then 
				animate_word (e,word,function() e.elder_page.next_progress(respawn_pic) end,func_end) 
			else
				destroy_chars()
				
				mouse:lock(true)
				new_page_anim(function() 
					e.elder_page.next_progress(respawn_pic)
					func_end()
					mouse:lock(false) 
				end)
			end
			--object_animate(obj,"position.scale",{
			--	0,i,1, --1
			--	0.5,i,2, --2
			--	1,i,1, --3
			--	4,i,300,
				--5,i,700,

				--3,i,obj.position.x-100, 
			--	5,i,obj.position.x,
				--1,i,obj.position.x,
				--1.5,i,obj.position.x+100, 
				--2,i,obj.position.x,
				--2.5,i,obj.position.x-100, 
				--2.8,i,obj.position.x,
				--})
			--	},func_end)
			--func_end()
			--start_timer(10, function() love.event.quit() end )
		end;
		------------------------------------------------
	--end;
end;

function Elder_pageSystem:update(dt)
	for _, e in ipairs(self.pool) do
		system_update(e,dt)
		--print(dt)
	end;
end;

function Elder_pageSystem.render(e)

	
		
  strings = e.elder_page.strings
	
	local rendered_words = 0
	for k_s,str in pairs(strings) do
	  for k_w, word  in pairs(str) do
			rendered_words = rendered_words+1;
			if rendered_words > e.elder_page.progress then return end;
		
		
		
		  love.graphics.setColor(0,0,0,1 )
			local scale = 0.5
			love.graphics.scale( scale,scale) 
      
			local _char = word.value:sub(1,1)
			local _word = word.value:sub(2)
			if word.is_upper then
			love.graphics.setColor(0.8,0.1,0.1,1 )
				love.graphics.setFont(word.is_upper and e.elder_page.font_big or e.elder_page.font_normal)
				love.graphics.print( _char, word.x, word.y+6*G_scale);
			love.graphics.setColor(0.1,0.1,0.1,1 )
				love.graphics.setFont(e.elder_page.font_normal)
				love.graphics.print( _word, word.x+27*G_scale, word.y);
			else
				love.graphics.setFont(e.elder_page.font_normal)
				love.graphics.print( word.value, word.x, word.y);
			end
			
			
			love.graphics.setColor(1,1,1,1 );
			love.graphics.scale( 1/scale,1/scale);
			
			
		end;
	end;
	test(e)
end

function Elder_pageSystem:draw()
  for _, e in ipairs(self.pool) do
    if e.position.visible then
      
        layers.band[e.drawable.layer].queue(e.position.z,Elder_pageSystem .render,e)
        --print("1")
      end                            
    end
  end
  
  
return Elder_pageSystem 