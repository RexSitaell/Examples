function doEvent(event)
  if event then
    local fun,context =  functionPathfinder( event.name )
    local args = event.args or {}
    
    fun(context,unpack(args))
    
  end
end




function functionPathfinder(str)
  local arg = str 
  local indexes 
  local self_context = false
  local fun , context
  
  indexes = findChars(arg,"[%.:]")
  
  if findChars(arg,":") then
    self_context = true
  end
  
  if indexes then
    fun = _G[string.sub(arg,1,indexes[1]-1)]
    for i = 1, #indexes-1 do
      fun = fun[string.sub(arg,indexes[i]+1,indexes[i+1]-1)]
    end
    
    if self_context  then
      context = fun
    end
    
    fun = fun[string.sub(arg,indexes[#indexes]+1)]
  else
    fun = _G[str]
  end

 return fun,context
end

function findChars(str,char)
  local result
  local t = {}
  local i = 0
  
  while true do
    i =  string.find(str,char,i+1)
    if i == nil then  break end
    t[#t+1] = i
    
  end
  if #t > 0 then result = t end
  return result
  
  
  
end


function is_exist(item)
 local result =  love.filesystem.getInfo(  item )
 
 if result ~= nil then
   return true
 else
   return false
 end
 
  
  end



function deepcopy(orig, copies)
    copies = copies or {}
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        if copies[orig] then
            copy = copies[orig]
        else
            copy = {}
            copies[orig] = copy
            for orig_key, orig_value in next, orig, nil do
                copy[deepcopy(orig_key, copies)] = deepcopy(orig_value, copies)
            end
            setmetatable(copy, deepcopy(getmetatable(orig), copies))
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end  


function IntTableConcat(t1,t2)
    for i=1,#t2 do
        t1[#t1+1] = t2[i]
    end
    return t1
end

function colorConvert(val)
  return 1/255*val
end


textColor = {
  r=colorConvert(111),
  g=colorConvert(126),
  b=colorConvert(145),
  a=1}
  
timer_mng = {}
  
function timer_setup(arg)
  local table = arg or {}
  table = { time = 0 , var = false }
  setmetatable(table,timer_mng)
  return table 
  end

function calc_timer(timer,dt)
  
  if timer.time > 0 then
    timer.time = timer.time - 1*dt
    timer.var  = true
  elseif timer.time < 0 then
    timer.time = 0 
    timer.var = false
  end
  
  return timer
end



function timer_mng.__call(self,arg,...) 

  if arg == "calc" then
    self = calc_timer(self,...)
  end
  
  if arg == "set" then
    self.time = ...
  end
  
  return self
    
  end
---------------------------------------------------------------------
self_math = {
  inc = function()
    end
  }

function self_math.adD(o,var)
  o = o+var
  return o
end

------------------------------------------------------------------------

function switch_bool (bool)
  if bool then
    bool = false
  else
    bool = true
  end
  
  
  return bool
end

fullscreen = false
function switch_fullscreen()
  
  fullscreen = switch_bool (fullscreen)
  love.window.setFullscreen(fullscreen, "desktop")

  if fullscreen then
    G_scale = 3.75
  else
    G_scale = 2
  end

  end
---------
function calc_len(array)
  local result = 0
  for _,_ in pairs(array) do
    result = result+1
  end
  
  return result
end
---------
--function get_len(str)
  
  --return string.len(str)
--end



function find_index_by_val(table,value)

  for key,val in pairs(table) do
    if val == value then

      return key
      
    end
    
  end
  
  return nil
end


ui_sectoring = {
  border_tab = 0,
  }

function Quit()
  love.event.quit()
end
------------------------------
--^^ старое барахло ^^
--VV новое барахло  VV
------------------------------
function string.divide(str,divider) 
	local divider = divider and "["..divider.."]" or "[.]"
	local result = {}
	
	
	local last_pos = 1
	local pos = 1
	local checked = false
	
	while not checked do 
		local divider_pos = string.find (str,divider,pos)
		
		if divider_pos then
			pos =  divider_pos + 1
			local idx = string.sub(str,last_pos,pos-2)
			table.insert(result,idx)
			last_pos = pos
		else
			local idx = string.sub(str,pos)
			table.insert(result,idx)
			checked = true
			break
		end
	end

	
	return result
end

---string_metatable
--local smt = {}
--smt.__call = function() print(1) end
--setmetatable(string,smt)
local unbuild_string = function(str)
	local str = str:sub(2,-1)
--	print(str)
	local fields = string.divide(str)
	
	local result = _G
	local string_result = ""
	
	for i = 1, #fields do
	
		local field = fields[i] 
		--print(field)
		string_result = string_result..field
		local is_func = string.find(field,"[(]",1)
		
		if is_func then 
		local func = field:sub(1,is_func-1) 
		
		local args = field:sub(is_func+2,string.find(field,"[)]",1)-2 ) --пока просто выкидывает всю строку
		
			--print(1,string_result,func,args)
			result = result[func](args)
			--print(11,result)
			string_result = tostring(result).."."
			--string_result = ""
		else
		--print(field)
		result = result[field]
			if i < #fields  then
			
			
			string_result=string_result.."."
			end
		end
		
	--	print(result,string_result)
	end
	--print(#fields)
		--print(result,string_result)
		return result
end

string.call = function(self)
	local var = "$"
	local first_char = self:sub(0,1) 
	if first_char ~= var then
		return self
	else
		return unbuild_string(self)
	end
	
end

inf = 1e309

-----------

--string()

