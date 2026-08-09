-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
  callback = function()
    if vim.bo.modified and vim.fn.expand("%") ~= "" then
      vim.cmd("write")
    end
  end,
})

-- Keep prose-focused Markdown buffers free of code completions and diagnostics.
local function markdown_list_enter()
  local line = vim.api.nvim_get_current_line()

  local indent, bullet, _, content = line:match("^(%s*)([-+*])%s+%[([ xX])%]%s*(.*)$")
  if bullet then
    if content:match("^%s*$") then
      return "<C-u>"
    end
    return "<C-g>u<CR>" .. indent .. bullet .. " [ ] "
  end

  indent, bullet, content = line:match("^(%s*)([-+*])%s+(.*)$")
  if bullet then
    if content:match("^%s*$") then
      return "<C-u>"
    end
    return "<C-g>u<CR>" .. indent .. bullet .. " "
  end

  local number, delimiter
  indent, number, delimiter, content = line:match("^(%s*)(%d+)([.)])%s+(.*)$")
  if number then
    if content:match("^%s*$") then
      return "<C-u>"
    end
    return "<C-g>u<CR>" .. indent .. (tonumber(number) + 1) .. delimiter .. " "
  end

  return "<CR>"
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "markdown.mdx" },
  callback = function(args)
    vim.b[args.buf].completion = false
    vim.diagnostic.enable(false, { bufnr = args.buf })
    vim.opt_local.spell = false

    vim.keymap.set("i", "<CR>", markdown_list_enter, {
      buffer = args.buf,
      expr = true,
      desc = "Continue Markdown list, numbered list, or checkbox",
    })
  end,
})
