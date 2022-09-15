local function init()
	modules_storage = {}
	modules_storage.queue = {} --тут хранятся апдейт функции модулей
	modules_storage.update = function(dt)
		for key, _module in pairs(modules_storage.queue) do
			_module(dt)
		end
	end
	modules_storage.add = function(func,name)
		local name = name or #modules_storage.queue+1
		modules_storage.queue[name] = func
	end
end;

return init()