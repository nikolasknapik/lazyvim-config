local M = {}

local function root_for(path)
  path = vim.fn.fnamemodify(path, ":p")
  return vim.fs.root(path, { ".git" }) or path
end

function M.set_root(path)
  local root = vim.fs.normalize(root_for(path))
  local active = Snacks.picker.get({ source = "explorer" })[1]
  if active then
    active:set_cwd(root)
    active:find()
  else
    Snacks.explorer({ cwd = root, follow_file = false })
  end
  return root
end

function M.toggle()
  local active = Snacks.picker.get({ source = "explorer" })[1]
  if active then
    active:close()
    return
  end
  M.set_root(LazyVim.root({ normalize = true }))
end

return M
