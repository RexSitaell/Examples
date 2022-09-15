
--local manager = {}
--manager.pfx = ".lua"
--manager.folder = "event_sheets/"
--
--manager.event_sheets_list = {
--  [1] = "lvl_event_sheet"
--  
--  }
--
--function manager:init()
--  self.scripts = {}
--  self.variables = {}
--  self.subscripts = {}
--  self.current_script = nil
--  self.script_lifetime = 0
--  
--  self:EventSheetsLoad()
--end
--
--function manager:EventSheetsLoad()
--  
--  for key,val in pairs(self.event_sheets_list) do
--    
--    self:init_event_sheet(key,val)
--  end
--  
--end
--
--function manager:init_event_sheet(i,script) -- индекс, имя скрипта
--  
-- self.scripts[i] =  love.filesystem.load( self.folder..script..self.pfx )--script from event_sheet file
-- 
--end
--
--
--
--manager:init()
--
--function manager:update(dt) 
--  
--  local script = self.current_script
--
--  if script then
--    if self.script_lifetime == 1 then self:is_started() end
--    
--    script(dt)
--    self.script_lifetime = self.script_lifetime+1 
--  end
--  
--end
--
--
--
--function manager:SetEventSheet(index)
--  self:script_reset()
--
--  self:is_ended()
--  self.script_lifetime = 0
--  self.current_script = self.scripts[index]
--  
--end
--
--function manager:script_reset()
--  self.variables = {}
--  self.subscripts = {}
--  self.current_script = nil
--  end
--
--function manager:init_var(var,val) 
--  self.variables[var] = val
--end
--
--function manager:get_var(var)
--  local result 
--  result =  self.variables[var]
--  return result
--end
--
--function manager:set_var(var,val)
--  --local result 
--  self.variables[var] = val
-- -- return result
--end
--
--function manager:get_system_var(var)
--end
--
--function manager:do_fun(name,...)
--  self.subscripts[name](...)
--  --local result 
-- -- result =  self.variables[name]
-- -- return result
--end
--
--
--
--function manager:init_fun(name,fun)
--  self.subscripts[name] = fun
--end
--
--
--
--function manager:is_started()
-- -- if self.script_lifetime == 1 then return true end
--  
--end
--
--function manager:is_ended()
--  
--end

local _manager = {}
_manager.queue = {}

function _manager:get_queue()
	return self.queue;
end;

function _manager:push(data)
	--data
			--func
			--func_end
			--conditions
	local func = function() 
		if data.conditions() then 
			data.func()
		else 
			return true 
		end 
	end
	
	local result = {
		main = func,
		func_end = data.func_end
	}
	local queue = self:get_queue()
	
	table.insert (queue,result)	
end

function _manager:update(dt)
	local queue = self:get_queue()
	for key,event in pairs(queue) do
		local done = event.main();
		if done then 
			event.func_end() 
			table.remove (queue,key)
		end;
	end
end;

--------------------------------вынести отюсда

function object_set_field(obj,param,val)
	local param_table = string.divide(param)
	local result = obj
	for i = 1, #param_table-1 do
		result = result[param_table[i]]
	end;
	result[param_table[#param_table]] = val
end

function object_get_field(obj,param)
	local param_table = string.divide(param)
	local result = obj
	for i = 1, #param_table do
		result = result[param_table[i]]
	end;
	
	return result
end;

-- i = 0 - линейное движение
-- i = 1 - плавное ускорение в начале 
-- i = 2 - плавное замедление в конце
-- i = 3 - плавное ускорение в начале и плавное замедление в конце

local function normalize(val,_min_target,_max_target,_min_val, _max_val)
	local _min_target = _min_target or 0
	local _max_target = _max_target or 1
	local _min_val = _min_val or 0
	local _max_val = _max_val or 1
	
	local normalized_proportion = val*(1/_max_val)-- приводит к диапозону 0-1
	local abstract_proportion =  (math.abs(_min_target)+math.abs(_max_target))*normalized_proportion
	
	local result = _min_target+abstract_proportion
	--print (result)
	return result
	
end;

local interpolate_patterns = {}

interpolate_patterns[0] = function(proportion,theta)  --proportion
	return proportion
end

interpolate_patterns[1] = function(proportion,theta)
	local result = math.sin(theta)/2 + 0.5
	if proportion > 0.5 then result = proportion end
	return result
end

interpolate_patterns[2] = function(proportion,theta)
	--local theta = theta < 0 and 0 or theta
	local theta = theta
	--if  proportion < 0.5 then theta = proportion end
	local result = math.sin(theta)/2 + 0.5
	
	--if  proportion < 0.8  then  result = normalize(result,0,1,-math.pi/2, math.pi/2)  else result = result end
	return result
end

interpolate_patterns[3] = function(proportion,theta) --math.sin(theta)/2 + 0.5 
	return math.sin(theta)/2 + 0.5 
end

local function interpolate(proportion,val1,val2,i) 
	local theta =  normalize(proportion, -math.pi/2,math.pi/2) 
	proportion = interpolate_patterns[i](proportion,theta )
	local val_rel = proportion * val1 +  (1 - proportion) * val2

  return val_rel
end;

--local function animator_get_frame_by_time(frames,time)
--	
--	local frame_for_check
--	local frame_result
--	
--	--print(time, #frames)
--	for i = 1 , #frames/3 do
--		local f_i = i*3-2
--		local frame = {
--			time 					= frames[f_i],
--			interpolation = frames[f_i+1],
--			val 					= frames[f_i+2],
--			last_time = frame_for_check and frame_for_check.time or 0
--		}
--		
--		if time >= frame.time then
--			frame_for_check = frame
--		else 
--			frame_result = frame_for_check
--			return frame_result
--		end
--		
--		
--	end
--	
--	return frame_for_check
--end

--local function get_target(frames,_time)
--	local result
--	for i = 1, #frames/3 do
--		local f_i = i*3-2
--		local l_f_i =  (i-1)*3-2
--		local frame = {
--			_time 					= frames[f_i],
--			interpolation = frames[f_i+1],
--			val 					= frames[f_i+2],
--			last_time = frames[l_f_i] or 0
--		}
--		
--		result = frame
--		if _time < frame._time then
--		--	print(i)
--			break
--		end
--		
--	end;
	
--	return result
--end;

function object_animate(obj,string_param,frames,func_end)
	local frames = frames
	local _time = 0
	local string_param= string_param
	local func_end = func_end
	
	local start_val = frames[3]
	local final_val = frames[#frames]
	local cur_frame_idx, new_frame_idx = 0,0
	local last_timecode = 0
	--local last_val = 0
	local target_val = frames[3]
	--print(string_param,object_get_field(obj,string_param))
	object_set_field(obj,string_param,start_val)
	local func = function()
		--print(_time)
		
		local function get_frame_timecodes(frames)
			local result = {}
			for i = 1, #frames/3 do
				local time_code = frames[i*3-2] 
				table.insert(result, time_code)
			end
			return result;
		end
		----------------------
		local frame_timecodes =  get_frame_timecodes(frames) --{frames[1],frames[4],frames[7]} --get frame_timecodes()
		
		
		----------------------
		--print(frame_timecodes[1],frame_timecodes[2],frame_timecodes[3])
		
		---------------------get_frame()
		local frame = 1
		for i = 1, #frames/3 do
			if _time <= frame_timecodes[i] then
			--print(_time ,  i) --дает время и реальный кадр
				frame = i; break;
			end
		end
		--------------------
		new_frame_idx = frame
		
		--------------------new_frame
		if new_frame_idx > cur_frame_idx  then
			
			--print("new_frame",cur_frame_idx," -> ", new_frame_idx)
			cur_frame_idx = new_frame_idx
			--------------------
			object_set_field(obj,string_param,target_val)
			--------------------
		end
		
		local last_val =  frame-1 > 0 and frames[(frame-1)*3] or object_get_field(obj,string_param)
		target_val = frames[frame*3]
		last_timecode = frame-1 > 0 and frames[(frame-1)*3-2] or last_timecode
		target_timecode = frames[frame*3-2]
		
		
		local time_from_last_timecode = _time - last_timecode
		local target_time_from_last_timecode = target_timecode - last_timecode
		if time_from_last_timecode == 0 or target_time_from_last_timecode == 0 then time_from_last_timecode = 1;target_time_from_last_timecode = 1 end --no nans
		
		local normalized_time_progress = time_from_last_timecode / target_time_from_last_timecode
		local interpolation_type = frames[frame*3-1]
		local offset = interpolate(normalized_time_progress,last_val,target_val,interpolation_type)
		
		
		local function get_min_max(val1,val2) 
			if val1<val2 then
				return val1,val2
			else
				return val2,val1
			end
		end
		
		local min_pos, max_pos = get_min_max(last_val,target_val) --target_val > last_val and last_val,target_val or target_val,last_val
		local new_val = min_pos+(max_pos-offset) --!!!
	--	local new_val = target_val > last_val and last_val+(target_val-offset)  or target_val+(last_val-offset)   --last_val-offset 
		object_set_field(obj,string_param, new_val )
		--print(normalized_time_progress)
		--print(time_from_last_timecode , target_time_from_last_timecode)
		--print(offset,normalized_time_progress)
		--print(new_val,target_val,last_val)
		
		--------------------
		
		
		
		--print(_time, frame)
		
		--local target = get_target(frames,_time)
		--local val1 , val2 = object_get_field(obj,string_param), target.val
		
		
		--if _time == 0 or target._time == 0 then _time = 1; target._time = 1; end;
		--local time_proportion = ( ( _time - target.last_time ) / ( target._time - target.last_time ) )
		----time_proportion = (time_proportion == nil )and  1 or time_proportion
		--print(math.floor(time_proportion*1000)/1000,target._time)
		--
		--local new_val = target.val -interpolate(time_proportion,val1,val2)
		--object_set_field(obj,string_param,new_val)
		----print(val1 , val2,new_val,time_proportion) --!! ВАЖНО !!
		_time = _time + love.timer.getDelta( )
		
	end;
	
	local func_end = function() 
		object_set_field(obj,string_param,final_val)
		if func_end then
			
			func_end()
		end
	end;
	
	local conditions = function() 
		return _time < frames[#frames-2] 
	end;
	
	local data = {
		func = func, 
		func_end = func_end,
		conditions = conditions	
	}
	Event:push(data)
end;
-----------------------------------------timer
function start_timer(timer,func_end)
	local func_end = func_end
	local timer = timer
	local time = 0
	
	local func = function() 
		local timestep = time + love.timer.getDelta( )
		time = timestep 

	end;
	
	local func_end = function() 
		if func_end then
			func_end()
		end
	end;
	
	local conditions = function() 
		return time < timer
	end;
	
	local data = {
		func = func, 
		func_end = func_end,
		conditions = conditions	
	}
	Event:push(data)
end
-----------------------------------------

return _manager