local fiber = require('fiber')
local channel = fiber.channel(10)
local timer = {}

function timer.setInterval(sleep, cb)
	channel:put({
		cb = cb;
		ut = os.time();
		sleep = sleep;
	})
end

function timer.setTimeout(sleep, cb)
	channel:put({
		cb = cb;
		ut = os.time();
		sleep = sleep;
		destroy = true;
	})
end

timer.fiber_object = fiber.create(
	function()
		local task = {}
		repeat
			for i = #task, 1, -1 do
				local current_task = task[i] 
				local current_time = os.time()
				if current_time - current_task.ut >= current_task.sleep then
					if current_task.destroy then
						table.remove(task, i)
					else
						current_task.ut = current_time
					end
					
					fiber.create(current_task.cb)
				end
			end

			-- Плучили какие-то данные из канала
			local res = channel:get(1)
			if type(res) == 'table' then
				table.insert(task, res)
			end
		until false
	end
)

return timer