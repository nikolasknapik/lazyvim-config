return {
  {
    "Exafunction/codeium.nvim",

    -- disable start toogle on start
      init = function()
    vim.api.nvim_create_autocmd("InsertEnter", {
      once = true,
      callback = function()
        vim.schedule(function()
          require("codeium").disable()
        end)
      end,
    })
  end,

    opts = function(_, opts)
      -- Codeium reports harmless events such as an ignored stale suggestion
      -- through debug notifications. Hide those while keeping info, warnings,
      -- and errors visible.
      require("codeium.notify").debug = function() end

      -- Markdown is used for notes and prose, so AI ghost-text is distracting.
      opts.virtual_text = opts.virtual_text or {}
      opts.virtual_text.filetypes = vim.tbl_extend("force", opts.virtual_text.filetypes or {}, {
        markdown = false,
        ["markdown.mdx"] = false,
      })

      return opts
    end,
  },
}
