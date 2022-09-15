--модуль предоставляет доступ к переменным пути и загрузочным таблицам
--------------------------------------------------------------
local working_directory = love.filesystem.getWorkingDirectory( );
local save_directory = love.filesystem.getSaveDirectory( )

local script_path = love.filesystem.getWorkingDirectory( ).."/Sitael/engine/scripts/"; --строка должна браться из конфига
local default_script_path = script_path;

local current_build_path = "Sitael/engine/current_build/"; --строка должна браться из конфига  
local default_current_build_path = current_build_path;

local lib_queue = {"concord","ui","builder"} --должно браться из конфига
local default_queue = lib_queue;
--------------------------------------------------------------

local setup = function()
	_G.engine = {}
	
	engine.format_path = function(path,sep,old_sep)
		return path:gsub(old_sep or "/",sep)
	end
	
	
	
	engine.Get_save_directory = function(sep)
		local result = save_directory;
		if sep then result = engine.format_path(result,sep)  end
		return result;
	end
	
	engine.Get_working_directory = function(sep)
		local result = working_directory;
		if sep then result = engine.format_path(result,sep)  end
		return result;
	end
	
	engine.Get_script_path = function()
		return script_path;
	end
	
	engine.Set_script_path = function(path)
		if path then
			script_path = love.filesystem.getWorkingDirectory( ).."/Sitael/"..path;
		else
			script_path = default_script_path;
		end;
	end
	
	engine.Get_current_build_path = function(sep)
	  local result = current_build_path
		if sep then result = engine.format_path(result,sep)  end
		return result;
	end
	
	engine.Set_current_build_path = function(path)
		if path then
			current_build_path = love.filesystem.getWorkingDirectory( ).."/Sitael/"..path;
		else
			current_build_path = default_current_build_path;
		end;
	end
	
	engine.Get_lib_queue = function()
		return lib_queue;
	end;
	
	engine.Set_lib_queue = function(queue)
		if queue then
			lib_queue = queue;
		else
			lib_queue = default_lib_queue;
		end
	end;
	
	
	engine.run_explorer = function(arg)
	  local path = engine.format_path(arg,"\\")
		
		if path == "save" then
			path = engine.Get_save_directory("\\")
		end;
		
		os.execute("@Sitael\\exp.bat "..path)
	end;
	
end
return setup