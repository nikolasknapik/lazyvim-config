local transparent_groups = {
  "Normal",
  "NormalNC",
  "EndOfBuffer",
  "SignColumn",
  "FoldColumn",
  "LineNr",
  "NeoTreeNormal",
  "NeoTreeNormalNC",
  "SnacksNormal",
  "SnacksNormalNC",
  "SnacksPicker",
  "SnacksPickerList",
  "SnacksPickerInput",
  "SnacksPickerPreview",
  "SnacksPickerBox",
}

local function apply_transparency()
  for _, group in ipairs(transparent_groups) do
    vim.api.nvim_set_hl(0, group, { bg = "none" })
  end
end

return {
  {
    "LazyVim/LazyVim",
    init = function()
      local augroup = vim.api.nvim_create_augroup("lazyvim_transparent_background", { clear = true })

      vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
        group = augroup,
        callback = apply_transparency,
      })

      vim.api.nvim_create_autocmd("User", {
        group = augroup,
        pattern = "VeryLazy",
        callback = apply_transparency,
      })

      vim.schedule(apply_transparency)
    end,
  },
}
