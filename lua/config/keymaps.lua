-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

require("which-key").add({
  { "<leader>r", group = "Run code" },
})

vim.keymap.set("n", "<leader>rc", function()
  -- only real file buffers
  if vim.bo.buftype ~= "" then
    vim.notify("Not a file buffer", vim.log.levels.WARN)
    return
  end

  local file = vim.fn.expand("%:p")
  if file == "" then
    vim.notify("No file name", vim.log.levels.WARN)
    return
  end

  if vim.fn.expand("%:e") ~= "c" then
    vim.notify("Not a .c file", vim.log.levels.WARN)
    return
  end

  if vim.bo.modified then
    vim.cmd("write")
  end

  local dir = vim.fn.fnamemodify(file, ":h")
  local bin = vim.fn.expand("%:t:r")
  local is_windows = vim.fn.has("win32") == 1
  local executable = is_windows and (bin .. ".exe") or bin
  local run_command = is_windows and (".\\" .. executable) or ("./" .. executable)

  local cmd = table.concat({
    "cd " .. vim.fn.shellescape(dir),
    "clang -Wall -Wextra " .. vim.fn.shellescape(file) .. " -o " .. vim.fn.shellescape(executable),
    vim.fn.shellescape(run_command),
  }, " && ")

  vim.cmd("botright split | resize 12 | terminal " .. cmd)
end, { desc = "Run C code" })

vim.keymap.set("n", "<leader>rp", function()
  if vim.bo.buftype ~= "" or vim.bo.filetype ~= "python" then
    vim.notify("Open a Python file first", vim.log.levels.WARN)
    return
  end

  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    vim.notify("Save the Python file first", vim.log.levels.WARN)
    return
  end

  local python = vim.env.VIRTUAL_ENV and (vim.env.VIRTUAL_ENV .. "/bin/python") or "python3"
  if vim.fn.executable(python) ~= 1 then
    vim.notify("Python interpreter not found: " .. python, vim.log.levels.ERROR)
    return
  end

  vim.cmd.write()
  vim.cmd("botright 12new")
  vim.fn.jobstart({ python, "-u", file }, {
    cwd = vim.fs.dirname(file),
    term = true,
  })
  vim.cmd.startinsert()
end, { desc = "Run Python code" })

vim.keymap.set("n", "<leader>rj", function()
  if vim.bo.buftype ~= "" or vim.bo.filetype ~= "java" then
    vim.notify("Open a Java file first", vim.log.levels.WARN)
    return
  end

  local file = vim.api.nvim_buf_get_name(0)
  local project_root = vim.fs.find("pom.xml", {
    path = vim.fs.dirname(file),
    upward = true,
  })[1]

  if not project_root then
    vim.notify("No pom.xml found above this Java file", vim.log.levels.ERROR)
    return
  end

  if vim.bo.modified then
    vim.cmd.write()
  end

  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local source = table.concat(lines, "\n")
  if not source:match("static%s+void%s+main%s*%(") then
    vim.notify("This class has no main() method", vim.log.levels.ERROR)
    return
  end

  local package = source:match("package%s+([%w_.]+)%s*;")
  local class = vim.fn.fnamemodify(file, ":t:r")
  local main_class = package and (package .. "." .. class) or class
  local root = vim.fs.dirname(project_root)

  local cmd = table.concat({
    "cd " .. vim.fn.shellescape(root),
    "mvn compile",
    "java -cp target/classes " .. vim.fn.shellescape(main_class),
  }, " && ")

  vim.cmd("botright 15split | terminal " .. cmd)
end, { desc = "Run Java code" })

vim.keymap.set(
  "n",
  "<leader>ai",
  "<cmd>Copilot toggle<CR>", {
     desc = "Toggle Copilot",
  }
)

vim.keymap.set("i", "<C-l>", function ()
  require("blink.cmp").show()
end, { desc = "Show completion list" })
