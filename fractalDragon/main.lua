edit_mode = false
local edit_pos = 1
edit_add = 0.1

keyboard_smooth = false
interrupt = false
preview = false

_time = 0
add_mult = 1
add = 0.1 --edit_add --* add_mult
mult = 16
t = 0 
a1,a2 = 1,5
addit = 21

local render = false
local fract_canvas = love.graphics.newCanvas(800,800)

x1,y1,x2,y2 = 200, 120, 200, 280
	
	--local dt = love.timer.getDelta()
	--a2 = a2+math.random(-dt,dt)
ang1,ang2,ang3,ang4 = nil,nil,nil,nil
angles = {ang1,ang2,ang3,ang4}
iterations = 15

local function recurs(angles,position,n,x0,y0,x1,y1)
	if n == 0 then 
		return position 
	else
		if not position[n] then 
			position[n] = 1	
		end
		local xx = math.cos(angles[position[n]])*((x1-x0)*math.cos(angles[position[n]])-(y1-y0)*math.sin(angles[position[n]]))+x0;
		local yy = math.cos(angles[position[n]])*((x1-x0)*math.sin(angles[position[n]])+(y1-y0)*math.cos(angles[position[n]]))+y0;
		love.graphics.points(x0,y0,x1,y1)
		position[n] = position[n]+1
		if position[n] == #angles then 
			position[n] = 1
		end
		position=recurs( angles, position, n-1, x0, y0, xx, yy);
		position=recurs( angles, position, n-1, x1, y1, xx, yy);  --!!!
		return position
	end
end

function love.load()
	love.graphics.setPointSize( 2 )
	render = true
end

local function fract_update()
	t = _time/mult
	ang1,ang2,ang3,ang4 = a1*t,-a1*t*4-addit,-a2*t,a2*t*2
	angles = {ang1,ang2,ang3,ang4}
	render = true
end

local function time_step(in_future,dt)
	add = math.abs(add)
	if not in_future then add = -math.abs(add)  end
	_time = _time + (dt and 1*dt or add)
	fract_update()
end
time_step(true)
time_step(false)

-------UI
local border = string.rep("|\n",70)
local ui_strings
------------
local function update_var (pos,add_)
	local var_val = _G[ui_strings[pos].var]
	local vartype = type(var_val)
	if vartype == "boolean"   then
		if  keyboard_smooth then
			interrupt = true
		end
	if var_val then 
		var_val = false 
	else 
		var_val = true 
	end 
	_G[ui_strings[pos].var] = var_val 

	end
	if vartype == "number"  then
		if ui_strings[pos].var ~= "edit_add" then
			local a = edit_add ~= 0 and edit_add or 0.1* ( add_ and 1 or - 1)
			local add = (add_ and math.abs(a) or -math.abs(a)) --* add_mult
			local var_val = _G[ui_strings[pos].var]
			_G[ui_strings[pos].var] = var_val + add
		else
			local t = {-100,-10,-1,-0.1,-0.03,-0.005,0.005,0.03,0.1,1,10,100}
			local var_val = _G[ui_strings[pos].var]
			local function find_idx() 
				for i = 1, #t do
					if var_val == t[i] then return i end
				end
			end
			local idx = find_idx()
			
			local old_var = t[idx]
			local var_val = t[idx+( add_ and 1 or -1 )] or old_var-- _G[ui_strings[pos].var]
			_G[ui_strings[pos].var] = var_val 
		end
	end
	fract_update()
end

local function var_reset(idx)
	if not idx then
		for i = 1, #ui_strings do
			_G[ui_strings[i].var] = ui_strings[i].default
		end	
	else
		_G[ui_strings[idx].var] = ui_strings[idx].default
	end
	fract_update()
end

love.keyreleased = function(key)
	if not interrupt then 
		if key == "e" then if edit_mode then edit_mode = false else edit_mode = true end end
		if edit_mode and key == "up" and edit_pos > 1 then edit_pos = edit_pos - 1 end
		if edit_mode and key == "down" and edit_pos < #ui_strings then edit_pos = edit_pos + 1 end
		if edit_mode and key == "left"  then update_var (edit_pos,false) end
		if edit_mode and key == "right"  then update_var (edit_pos,true) end
		
		if edit_mode and key == "r" then
		 local sh = love.keyboard.isDown( "lshift" ) 
		 if sh then var_reset() else var_reset(edit_pos) end
		end
		
		if  not keyboard_smooth then
			if key == "space" then preview = (not preview  ) and true or false   end
			if key == "q" then time_step(false) end--_time = _time - 0.1 end
			if key == "w" then time_step(true) end--_time = _time + 0.1 end
		end;
	else
		interrupt = false
	end;
end;

local function new_ui_string(str,var,default)
	table.insert(ui_strings,{str = str, var = var,default = default  })
end

function love.update(dt)
	if keyboard_smooth and not interrupt then
		local q,w,left,right,space
		q = love.keyboard.isDown( "q" ) and not w
		w = love.keyboard.isDown( "w" ) and not q
		left  = love.keyboard.isDown( "left" ) and not right
		right = love.keyboard.isDown( "right" ) and not left
		space = love.keyboard.isDown( "space" ) 
		
		if q then time_step(false) end
		if w then time_step(true) end	
		
		if left and edit_mode  then update_var (edit_pos,false) end
	  if right and edit_mode then update_var (edit_pos,true) end
		if space then preview = (not preview  ) and true or false interrupt = true  end
	end
	if preview then time_step(true,dt)  end
	iterations = math.floor(iterations+0.5)
	_time = _time/mult>= math.pi and 0 or _time
	ui_strings = {}
	new_ui_string("iterations: "..iterations.." recommended < 20\t(FPS: = "..love.timer.getFPS()..")"				,"iterations",15)
	new_ui_string("time: ".._time.. " / multiplier".."\treal_time: ".. t       			,"_time",0)
	new_ui_string("\tmultiplier: "..mult 	,"mult",16)
	new_ui_string("\ttime_step: "..add 	,"add",0.1)
	
	new_ui_string("start_pos_x: "..x1		,"x1",200)
	new_ui_string("start_pos_y: "..y1	  ,"y1",120)
	new_ui_string("end_pos_x:   "..x2		,"x2",200)
	new_ui_string("end_pos_y:   "..y2	  ,"y2",280)
	
	new_ui_string("edit_mode:   "..tostring(edit_mode)	  ,"edit_mode",false)
	new_ui_string("\tedit_step:   "..edit_add	  ,"edit_add",0.1)
	
	new_ui_string("smooth_play:   "..tostring(keyboard_smooth)	  ,"keyboard_smooth",false)
	new_ui_string("preview:   "..tostring(preview)	  ,"preview",false)
	
	new_ui_string("ang1: "..a1		,"a1",1)
	new_ui_string("ang2: "..a2		,"a2",5)
	new_ui_string("seed: "..addit		,"addit",21)
	
end

function fract_render()
	love.graphics.setCanvas(fract_canvas)
	love.graphics.clear()
	love.graphics.scale (2)
	p = recurs(angles,{}, iterations,x1,y1,x2,y2 );
	love.graphics.scale (0.5)
	love.graphics.setCanvas()
end

function love.draw()
	if render then
		fract_render()
		render = false
	end
	love.graphics.draw(fract_canvas)
	love.graphics.print(border,800)
	if edit_mode then love.graphics.print(">>",810,edit_pos*16)  end
	for i = 1, #ui_strings do
		love.graphics.print(ui_strings[i].str,840, (i)*16)
	end
	local str = "'q'/'w' for timestep (last_frame,next_frame)\n'e' for edit mode ('up'/'down' to navigate, 'left'/'right' to edit) \n'r' to reset field 'r+lshift' to reset all\n'space' to start/pause preview"
	love.graphics.print(str,810, (45)*16)
end