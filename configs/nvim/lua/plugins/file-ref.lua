-- Copy a file reference for the current visual selection, plus the actual
-- content of the selection.
-- Reference format: @path/to/file#start-end (e.g. @app.ts#5-10).
--
-- Usage: select lines in visual mode, then press <leader>cr.
-- The reference is copied to the system clipboard (+).

local function copy_file_ref()
	-- '< and '> are set when leaving visual mode.
	local start_line = vim.fn.line("'<")
	local end_line = vim.fn.line("'>")

	-- Path relative to cwd.
	local abs_path = vim.api.nvim_buf_get_name(0)
	local cwd = vim.fn.getcwd()
	local rel_path = abs_path

	-- Strip cwd prefix (with trailing slash) if present.
	if abs_path:sub(1, #cwd + 1) == cwd .. "/" then
		rel_path = abs_path:sub(#cwd + 2)
	end

	local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
	local range = start_line == end_line and tostring(start_line) or string.format("%d-%d", start_line, end_line)
	local ref = string.format("@%s#%s\n\n%s", rel_path, range, table.concat(lines, "\n"))

	vim.fn.setreg("+", ref)
	vim.notify(string.format("Copied: %s", ref), vim.log.levels.INFO)
end

-- Map in visual mode; <Esc> exits visual and sets '< / '> before the function runs.
vim.keymap.set("v", "<leader>cr", function()
	local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
	vim.api.nvim_feedkeys(esc, "x", false)
	copy_file_ref()
end, { desc = "Copy file reference for selected lines (@file#start-end)" })

return {}
