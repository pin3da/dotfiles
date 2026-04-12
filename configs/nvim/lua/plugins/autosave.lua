-- Auto-write the buffer 500 ms after the user stops typing.
-- CursorHold / CursorHoldI fire after `updatetime` ms of no input.
vim.opt.updatetime = 500

local function save_if_modified(buf)
	if vim.bo[buf].modified and vim.bo[buf].buftype == "" and vim.api.nvim_buf_get_name(buf) ~= "" then
		vim.cmd("silent! write")
	end
end

vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
	desc = "Auto-write buffer after updatetime ms of inactivity",
	callback = function(args)
		save_if_modified(args.buf)
	end,
})

return {}
