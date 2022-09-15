local clicker = {}
	clicker.dummy_currency = "dummy"
	clicker.cost_multiplier = 1.7
	clicker.val_multiplier = 1.6
	clicker.start_cost = 1
	
	clicker.cycle = 0

	clicker.currencies = {}
	clicker.sources = {}
	clicker.wait_list = {}
	clicker.update = function(dt)
		--sprint(1)
		for key,currency in pairs(clicker.currencies) do
			local wait_idx = key
			if not clicker.wait_list[wait_idx] and currency.val + currency.income <= currency.max_val  then
				clicker.wait_list[wait_idx] = true
				currency.val = currency.val + currency.income
				start_timer(currency.update_time, function() clicker.wait_list[wait_idx] = false  end)
			end
			
		end
	end
	
	clicker.new_currency = function(params)
		local name = params.name or #clicker.currencies+1
		local start_val = params.start_Val or 0
		local income = params.income or 0
		local update_time = params.update_time or 0
		local max_val = params.max_val or inf
		local result = {}
		
		result.val = start_val
		result.income = income
		result.update_time = update_time
		result.max_val = max_val
		
		clicker.currencies[name] = result
	end
	
	clicker.get_currency = function(name)
		local result = clicker.currencies[name]
		if result then 
			return result 
		else
			error("clicker.get_currency: invalid name "..name,2)
		end
	end
	
	clicker.set_currency = function(name,val,income,update_time,max_val)
		local name = name or clicker.dummy_currency
		val = val or clicker.currencies[name].val 
		income = income or clicker.currencies[name].income
		update_time = update_time or clicker.currencies[name].update_time
		max_val = max_val or clicker.currencies[name].max_val
		
		clicker.currencies[name].val = val
		clicker.currencies[name].income = income
		clicker.currencies[name].update_time = update_time
		clicker.currencies[name].max_val = max_val
	end
	
	clicker.call_source = function(name)
		local source = clicker.get_source(name)
		
		local val = clicker.get_currency(source.currency).val
		local enough_val = val >= source.cost 
		if enough_val then
			local reward_val = clicker.get_currency(source.currency).val + source.reward.val
			local reward_income = clicker.get_currency(source.currency).val + source.reward.income 
			clicker.set_currency(source.currency,reward_val,reward_income)
			--обновить, или обновляется само? забыл
			source.step = source.step + 1
			source.cost = source.cost * source.cost_multipler
			source.reward.val = source.reward.val * source.val_multipler
			source.reward.income = source.reward.income * source.val_multipler	
		end
	end
	
	clicker.new_source = function(params)
		local name = params.name or #clicker.sources+1
		local currency = params.currency or clicker.dummy_currency
		local start_cost = params.start_cost or clicker.start_cost
		local cost_multipler = params.cost_multiplier or clicker.cost_multiplier
		local val_multiplier = params.val_multiplier or clicker.val_multiplier
		local reward = params.reward or {}
		
		local result = {}
		result.cost = start_cost
		result.currency = currency
		result.cost_multipler = cost_multipler
		result.val_multiplier = val_multiplier
		result.reward = reward or { currency = clicker.dummy_currency, val = 0, income = 0} 
		result.step = 1
		
		clicker.sources[name] = result
	end
	
	clicker.get_source = function(name)
		local result = clicker.sources[name]
		if result then 
			return result
		else
			error("clicker.get_source: invalid name "..name,2)
		end
	end
	
	clicker.new_currency({name = clicker.dummy_currency })
	modules_storage.add(clicker.update,"clicker")
return clicker