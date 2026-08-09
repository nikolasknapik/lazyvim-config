return {
  {
    "folke/noice.nvim",
    opts = {
      lsp = {
        -- Keep LSP diagnostics working, but hide noisy background progress
        -- messages such as "Publish Diagnostics" from jdtls.
        progress = {
          enabled = false,
        },
      },
    },
  },
}
