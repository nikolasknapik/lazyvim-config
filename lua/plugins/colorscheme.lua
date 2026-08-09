return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      flavour = "mocha",
      transparent_background = true,
      integrations = {
        blink_cmp = true,
      },
      custom_highlights = function(colors)
        return {
          -- Distinguish Codeium ghost text from typed code without making it too faint.
          CodeiumSuggestion = { fg = colors.overlay2, style = { "italic" } },
          -- Terminal highlights cannot be partially transparent, so keep the
          -- current line fully transparent and emphasize only its line number.
          CursorLine = { bg = "none" },
          CursorLineNr = { fg = colors.lavender, style = { "bold" } },
        }
      end,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-mocha",
    },
  },
}
