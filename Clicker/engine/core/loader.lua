local loader = {};
--setmetatable(loader, {__index = _G});
--_ENV = loader;
------------------------------------------------
--[[
Загружает все доступные в папке библиотеки и
присуждает им имена в глобальном окружении,
соответствующие названиям файлов
]]--
------------------------------------------------
loader.default_path = "libs//"
loader.lib_list = {}
------------------------------------------------
loader.static_lib_queue = engine.Get_lib_queue() 
--{"concord","ui",}--позволяет подключить библиотеки в определенном порядке
------------------------------------------------
loader.build_table = function(list,path) --конвертирует static_lib_queue в таблицу для подключения
	local result = {}
	for _,val in pairs(list) do
		local file = {path.. val,val}
		table.insert(result,file)
	end;
	return result;
end;

loader.do_require = function(file,file_path) --выполняет модуль, если он - функция
	_G[file] = require(file_path);
	if type(_G[file]) == "function" then
		_G[file] = _G[file]() or _G[file]; 
		--на случай если функция не возвращает таблицу, а строит модуль сама
	end;
end

loader.requireFiles = function(list)
	for _, file in ipairs(list) do
		print("connected "..file[1])
		if file[1]:sub(-4,-1) == ".lua" then 
		--для модулей
			local file, file_path = file[2]:sub(1,-5),file[1]:sub(1, -5);
			loader.do_require(file, file_path)
		else 
		--для пакетов
			loader.do_require(file[2], file[1]);
		end;
  end;
end;

loader.enumerate = function (folder) -- создает таблицу cо всеми объектами в папке
	local result = {}
  local items = love.filesystem.getDirectoryItems(folder)
  for _, item in ipairs(items) do
    local file = {folder  .. item,item};
    table.insert(result, file);
  end
	return result;
end

loader.run = function(path,mode)
	local path = path or loader.default_path;
	if mode == "auto" or nil then
		loader.requireFiles(loader.enumerate(path));
	elseif mode == "manually" then
		loader.requireFiles(loader.build_table(loader.static_lib_queue,path))
	end
end;

return loader.run