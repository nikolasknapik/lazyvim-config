local function preview()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    vim.notify("Najprv ulož Markdown súbor.", vim.log.levels.WARN)
    return
  end
  local root = vim.fs.root(file, ".git") or LazyVim.root()
  local lp = require("livepreview")
  local config = require("livepreview.config").config
  local utils = require("livepreview.utils")
  -- The server captures uv.cwd() at startup. Restore it immediately afterwards.
  local previous = vim.uv.cwd()
  local changed, change_error = vim.uv.chdir(root)
  if not changed then error(change_error) end
  local ok, started = pcall(lp.start, file, config.port)
  vim.uv.chdir(previous)
  if not ok then vim.notify(tostring(started), vim.log.levels.ERROR); return end
  if not started then return end
  local relative = utils.get_relative_path(file, root)
  local url = ("http://%s:%d/%s"):format(config.address, config.port, vim.uri_encode(relative))
  utils.open_browser(url, config.browser)
end

return {
  { "iamcco/markdown-preview.nvim", enabled = false },
  {
    "brianhuster/live-preview.nvim",
    cmd = "LivePreview",
    opts = { address = "127.0.0.1", port = 5500, dynamic_root = false, sync_scroll = true, picker = "snacks.picker" },
    keys = {
      { "<leader>cp", preview, ft = "markdown", desc = "Markdown Preview (browser)" },
      { "<leader>cP", function() require("livepreview").close() end, ft = "markdown", desc = "Stop Markdown Preview" },
    },
  },
}
