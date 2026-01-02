local M = {}

function M.search(opts)
	opts = opts or {}

	-- Data file is in the plugin root directory
	local plugin_root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h:h")
	local data_file = plugin_root .. "/nerd-fonts-data.txt"

	if vim.fn.filereadable(data_file) ~= 1 then
		vim.notify("nerdfont-search: data file not found at " .. data_file, vim.log.levels.ERROR)
		return
	end

	local fzf_lua_ok, fzf_lua = pcall(require, "fzf-lua")
	if not fzf_lua_ok then
		vim.notify("nerdfont-search: fzf-lua is required", vim.log.levels.ERROR)
		return
	end

	local lines = {}
	for line in io.lines(data_file) do
		table.insert(lines, line)
	end

	fzf_lua.fzf_exec(lines, {
		prompt = "Nerd Fonts> ",
		query = opts.query or "",
		preview = "echo {}",
		actions = {
			["default"] = function(selected)
				if not selected or #selected == 0 then
					return
				end

				-- Extract the icon (last field)
				local icon = selected[1]:match("%s([^%s]+)%s*$")
				if icon then
					-- Insert at cursor position
					local pos = vim.api.nvim_win_get_cursor(0)
					local line = vim.api.nvim_get_current_line()
					local before = line:sub(1, pos[2])
					local after = line:sub(pos[2] + 1)
					vim.api.nvim_set_current_line(before .. icon .. after)
					-- Move cursor after inserted icon
					vim.api.nvim_win_set_cursor(0, { pos[1], pos[2] + #icon })
				end
			end,
			["ctrl-y"] = function(selected)
				if not selected or #selected == 0 then
					return
				end

				-- Extract the icon (last field)
				local icon = selected[1]:match("%s([^%s]+)%s*$")
				if icon then
					-- Copy to system clipboard
					vim.fn.setreg("+", icon)
					vim.notify("Copied to clipboard: " .. icon, vim.log.levels.INFO)
				end
			end,
		},
		fzf_opts = {
			["--preview-window"] = "up:1",
		},
		winopts = {
			height = 0.6,
			width = 0.8,
		},
	})
end

return M
