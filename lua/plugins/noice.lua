return {
  {
    "folke/noice.nvim",
    opts = {
      lsp = {
        -- Keep K documentation clear of the cursor line, including its border.
        hover = {
          opts = {
            relative = "cursor",
            anchor = "auto",
            position = { row = 2, col = 0 },
            size = { max_width = 70, max_height = 10 },
          },
        },
        -- Keep automatic hints compact and leave a gap around the cursor line.
        signature = {
          auto_open = { enabled = true },
          opts = {
            relative = "cursor",
            anchor = "auto",
            position = { row = 2, col = 0 },
            size = { max_width = 60, max_height = 4 },
          },
        },
        -- Keep LSP diagnostics working, but hide noisy background progress
        -- messages such as "Publish Diagnostics" from jdtls.
        progress = {
          enabled = false,
        },
      },
    },
  },
}
