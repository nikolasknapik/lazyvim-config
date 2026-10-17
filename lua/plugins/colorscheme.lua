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
        local muted = "#9399b2"
        local active_number = "#cdd6f4"
        return {
          -- Distinguish Copilot ghost text from typed code without making it too faint.
          CopilotSuggestion = { fg = colors.overlay2, style = { "italic" } },
          -- Emphasize the line number while keeping the editor surface uniform.
          CursorLine = { bg = "none" },
          CursorLineNr = { fg = active_number, bg = "NONE", bold = true },
          Normal = { fg = colors.text, bg = "NONE" },
          NormalNC = { fg = colors.text, bg = "NONE" },
          EndOfBuffer = { bg = "NONE" },
          SignColumn = { bg = "NONE" },
          FoldColumn = { bg = "NONE" },
          LineNrAbove = { fg = muted, bg = "NONE" },
          LineNrBelow = { fg = muted, bg = "NONE" },
          SnacksIndent = { fg = muted, bg = "NONE" },
          SnacksIndentScope = { fg = "#a6adc8", bg = "NONE" },
          SnacksPickerTree = { fg = muted, bg = "NONE" },
          LineNr = { fg = muted, bg = "NONE" },
          NormalFloat = { fg = colors.text, bg = "NONE" },
          FloatBorder = { fg = muted, bg = "NONE" },
          FloatTitle = { fg = colors.lavender, bg = "NONE", bold = true },
          WinSeparator = { fg = muted, bg = "NONE" },
          SnacksNormal = { fg = colors.text, bg = "NONE" },
          SnacksNormalNC = { fg = colors.text, bg = "NONE" },
          SnacksPickerPreview = { fg = colors.text, bg = "NONE" },
          SnacksPickerPreviewBorder = { fg = muted, bg = "NONE" },
          SnacksPickerPreviewTitle = { fg = colors.lavender, bg = "NONE", bold = true },
          SnacksPickerInputTitle = { fg = colors.lavender, bg = "NONE", bold = true },
          SnacksPickerListTitle = { fg = colors.lavender, bg = "NONE", bold = true },
          SnacksPickerList = { fg = colors.text, bg = "NONE" },
          SnacksPickerInput = { fg = colors.text, bg = "NONE" },
          SnacksPickerTitle = { fg = colors.lavender, bg = "NONE", bold = true },
          SnacksPickerBoxTitle = { fg = colors.lavender, bg = "NONE", bold = true },
          SnacksPickerInputBorder = { fg = muted, bg = "NONE" },
          SnacksPickerListBorder = { fg = muted, bg = "NONE" },
          SnacksPickerBox = { fg = colors.text, bg = "NONE" },
          SnacksPicker = { fg = colors.text, bg = "NONE" },
          SnacksPickerBorder = { fg = muted, bg = "NONE" },
          SnacksPickerBoxBorder = { fg = muted, bg = "NONE" },
          -- Snacks GitHub pickers need a foreground fallback when Catppuccin's
          -- diff highlight groups define only a background color.
          SnacksGhNormalFloat = { fg = colors.text },
          -- Match picker surfaces and titles to the transparent editor.
          SnacksPickerReadable = { fg = colors.text, bg = "NONE" },
          SnacksPickerReadableBorder = { fg = muted, bg = "NONE" },
          SnacksPickerReadableTitle = { fg = colors.lavender, bg = "NONE", style = { "bold" } },
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
