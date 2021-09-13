local rs = game:GetService("RunService").Stepped

local scheduler = {
    result = nil,
    tasks = {};
}

scheduler.queue = function(f, desc, ...)
    local size = #scheduler.tasks + 1

    scheduler.tasks[size] = {
        desc = desc,
        func = f,
        args = {...};
    };

    repeat rs:wait() until ((scheduler.tasks[size] and scheduler.tasks[size].func) or nil) ~= f

    local ret = scheduler.result

    scheduler.result = nil

    return ret;
end

scheduler.start = function()
    spawn(function()
        while rs:wait() do
            for idx, current in pairs(scheduler.tasks) do
                if current then
                    local result = nil

                    spawn(function()
                        result = current.func(unpack(current.args))
                    end)

                    repeat rs:wait() until result ~= nil

                    scheduler.tasks[idx] = nil

                    scheduler.result = result

                    repeat rs:wait() until scheduler.result == nil
                end
            end

            rs:wait()
        end
    end)

    return 0;
end

return scheduler
