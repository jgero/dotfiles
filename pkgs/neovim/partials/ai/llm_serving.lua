local M = {}

function M.setup(cfg)
	M.cfg = cfg
	vim.api.nvim_create_autocmd("VimLeavePre", {
		callback = M.stop_process,
		group = vim.api.nvim_create_augroup("LlmServingCleanup", { clear = true }),
	})
	vim.keymap.set("n", "<Leader>ai", M.start_process, { desc = "start [a][i] (AI/LLM) completion" })
	vim.keymap.set("n", "<Leader>sai", M.stop_process, { desc = "[s]top [a][i] (AI/LLM) completion" })
end

function M.start_process()
	if M.llama_cpp_job then
		return
	end
	vim.notify("starting backend for LLM completion")
	M.llama_cpp_job = vim.system({
		M.cfg.command,
		"-m",
		M.cfg.model_path,
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
	}, { text = true }, function(_)
		M.is_stopped = true
	end)
end

-- Function to stop the process
function M.stop_process()
	if M.llama_cpp_job and M.llama_cpp_job.pid then
		-- Attempt to gracefully shut down the process
		M.llama_cpp_job:kill(15) -- SIGTERM

		-- Give it a short time to shut down gracefully
		local shutdown_timeout = 5000 -- milliseconds
		local poll_rate = 100   -- milliseconds
		local shutdown_success = vim.wait(
			shutdown_timeout,
			function() return M.is_stopped end,
			poll_rate
		)

		-- If graceful shutdown failed, force kill
		if not shutdown_success and M.llama_cpp_job.pid then
			print("killing process with PID " .. M.llama_cpp_job.pid)
			-- Use :kill() instead of :shutdown() for a hard kill
			M.llama_cpp_job:kill(9) -- SIGKILL
		end
		M.llama_cpp_job = nil
	end
end

return M
