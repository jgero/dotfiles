local progress = require("fidget.progress")
local M = {}
local llama_cpp_job = nil

function M.setup(cfg)
	llama_cpp_job = vim.system({
		cfg.command,
		"-m",
		cfg.model_path,
		"--port",
		"8012",
		"-ngl",
		"99",
		"-fa",
		"-ub",
		"1024",
		"-b",
		"1024",
		"-t",
		"8",
		"--ctx-size",
		"0",
		"--cache-reuse",
		"256"
	}, { text = true }, function(out)
		M.is_stopped = true
	end
	)
	vim.api.nvim_create_autocmd("VimLeavePre", {
		callback = M.stop_process,
		group = vim.api.nvim_create_augroup("LlmServingCleanup", { clear = true }),
	})
end

-- Function to stop the process
function M.stop_process()
	if llama_cpp_job and llama_cpp_job.pid then
		-- Attempt to gracefully shut down the process
		llama_cpp_job:kill(15) -- SIGTERM

		-- Give it a short time to shut down gracefully
		local shutdown_timeout = 5000 -- milliseconds
		local poll_rate = 100   -- milliseconds
		local shutdown_success = vim.wait(
			shutdown_timeout,
			function() return M.is_stopped end,
			poll_rate
		)

		-- If graceful shutdown failed, force kill
		if not shutdown_success and llama_cpp_job.pid then
			print("killing process with PID " .. llama_cpp_job.pid)
			-- Use :kill() instead of :shutdown() for a hard kill
			llama_cpp_job:kill(9) -- SIGKILL
		end
		M.indicator:finish()
	end
end

return M
