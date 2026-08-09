return {
  {
    "LazyVim/LazyVim",
    keys = {
      {
        "<leader>aC",
        function()
          vim.cmd("botright split | vertical resize 50 | terminal codex")
          vim.cmd("startinsert")
        end,
        desc = "Codex (terminal split)",
      },
    },
  },
}
