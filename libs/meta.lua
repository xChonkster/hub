if meta then return end

getgenv().meta = {}

meta.old = {
	__index = nil,
	__newindex = nil,
	__namecall = nil;
}

meta.main = {
	__index = {
		append = function(func)
			local old_func = meta.main.__index.func
			
			meta.main.__index.func = func
			
			return old_func
		end,
		
		func = function(...)
			return meta.old.__index(...)	
		end	
	},

	__newindex = {
		append = function(func)
			local old_func = meta.main.__newindex.func

			meta.main.__newindex.func = func

			return old_func
		end,

		func = function(...)
			return meta.old.__newindex(...)	
		end	
	},

	__namecall = {
		append = function(func)
			local old_func = meta.main.__namecall.func

			meta.main.__namecall.func = func

			return old_func
		end,
		func = function(...)
			return meta.old.__namecall(...)	
		end	
	},
}

meta.old.__index = hookmetamethod(game, "__index", function(...)
	return meta.main.__index.func(...)
end)
meta.old.__newindex = hookmetamethod(game, "__newindex", function(...)
	return meta.main.__newindex.func(...)
end)
meta.old.__namecall = hookmetamethod(game, "__namecall", function(...)
	return meta.main.__namecall.func(...)
end)
