loadstring(game:HttpGet("https://github.com/xChonkster/hub/blob/main/libs/meta.lua?raw=true"))()

local spoof = {
	types = {
		impersonator = 0,
		get_hook = 1,
		set_hook = 2,
		lock = 3,
	},
	hooks = {};
}

spoof.add_hook = function(hook_type, args)
	local idx = #spoof.hooks + 1
	
	spoof.hooks[hook_type] = args
	
	return {
		remove = function()
			spoof.hooks[idx] = nil
		end,
		
		spoof.hooks,
		idx;
	}
end

spoof.impersonator = function(inst, prop, real)
	return spoof.add_hook(spoof.types.impersonator, {
		instance = inst,
		property = prop,
		real = real,
		fake = inst[prop];
	})
end

local old_index;
old_index = meta.main.__index.append(function(...)
	local tbl = {...}
	local self, idx = tbl[1], tbl[2]
	
	for type, hook in pairs(spoof.hooks) do
		if hook and type == spoof.types.impersonator and self == hook.instance and idx == hook.property then
			return hook.fake
		end
	end
	
	return old_index(...)
end)

local old_new_index;
old_new_index = meta.main.__newindex.append(function(...)
	local tbl = {...}
	local self, idx, val = tbl[1], tbl[2], tbl[3]
	
	for type, hook in pairs(spoof.hooks) do
		if hook and type == spoof.types.impersonator and self == hook.instance and idx == hook.property then
			hook.fake = val
			
			return old_new_index(self, idx, hook.real)
		end
	end

	return old_new_index(...)
end)

return spoof
