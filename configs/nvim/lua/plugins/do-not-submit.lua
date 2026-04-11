-- Highlight "DO NOT SUBMIT" with a bright red background to catch accidental commits.
-- Code at module level runs when lazy.nvim requires this spec file, before plugins load.

local function set_hl()
	vim.api.nvim_set_hl(0, "DoNotSubmit", { fg = "#ffffff", bg = "#ff0000", bold = true })
end

local function apply_match()
	-- Guard against duplicate matches in the same window.
	for _, m in ipairs(vim.fn.getmatches()) do
		if m.group == "DoNotSubmit" then
			return
		end
	end
	vim.fn.matchadd("DoNotSubmit", "DO NOT SUBMIT")
end

-- Set now, and re-set after every colorscheme change (colorschemes call `highlight clear`).
set_hl()
vim.api.nvim_create_autocmd("ColorScheme", { callback = set_hl })

-- BufWinEnter: covers every buffer displayed in a window after startup.
-- VimEnter: covers the initial buffer opened at startup.
vim.api.nvim_create_autocmd({ "BufWinEnter", "VimEnter" }, {
	callback = apply_match,
})

-- Apply to windows already open when lazy.nvim loads this spec (e.g. live config reload).
vim.schedule(function()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		vim.api.nvim_win_call(win, function()
			apply_match()
		end)
	end
end)

return {}
