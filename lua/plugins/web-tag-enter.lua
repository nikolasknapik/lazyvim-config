return {
	{
		"nvim-mini/mini.pairs",
		config = function(_, opts)
			LazyVim.mini.pairs(opts)
			local pairs = require("mini.pairs")
			local original_cr = pairs.cr
			local web = { html = true, javascriptreact = true, typescriptreact = true }

			pairs.cr = function(key)
				if not web[vim.bo.filetype] or vim.g.minipairs_disable or vim.b.minipairs_disable then
					return original_cr(key)
				end
				local row, col = unpack(vim.api.nvim_win_get_cursor(0))
				local line = vim.api.nvim_get_current_line()
				local before, after = line:sub(1, col), line:sub(col + 1)
				local name = before:match("<([%w_:%.%-]+)[^<>]*>$")
				local closing = after:match("^</([%w_:%.%-]+)%s*>")
				local fragment = before:sub(-2) == "<>" and after:sub(1, 3) == "</>"
				if not (fragment or (name and name == closing and not before:match("/%s*>$"))) then
					return original_cr(key)
				end

				-- Only real syntax tags: leave strings, comments and comparisons alone.
				local ok, node = pcall(vim.treesitter.get_node, { pos = { row - 1, col - 1 } })
				local is_tag = false
				while ok and node do
					local kind = node:type()
					if kind == "jsx_opening_element" or kind == "start_tag" then
						is_tag = true
						break
					end
					node = node:parent()
				end
				if not is_tag then
					return original_cr(key)
				end

				local indent = before:match("^%s*")
				local extra = vim.bo.expandtab and string.rep(" ", vim.fn.shiftwidth()) or "\t"
				-- Stay in Insert mode, avoiding the user's InsertLeave autosave.
				return vim.api.nvim_replace_termcodes(
					"<CR><C-u>" .. indent .. extra .. "<CR><C-u>" .. indent .. "<Up><End>",
					true,
					false,
					true
				)
			end
		end,
	},
}
