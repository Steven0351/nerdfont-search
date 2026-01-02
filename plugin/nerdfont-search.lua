vim.api.nvim_create_user_command("NerdFontSearch", function(opts)
	require("nerdfont-search").search({ query = opts.args })
end, {
	nargs = "?",
	desc = "Search Nerd Font icons",
})
