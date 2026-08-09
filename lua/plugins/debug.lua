return {
  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require("dap")

      -- Java projects get their launch configurations from jdtls.
      -- Hide LazyVim's remote attach fallback so F5 cannot accidentally
      -- wait for a debugger on 127.0.0.1:5005.
      dap.configurations.java = vim.tbl_filter(function(config)
        return config.name ~= "Debug (Attach) - Remote"
      end, dap.configurations.java or {})
    end,
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "Debug: Start / Continue" },
      { "<F9>", function() require("dap").toggle_breakpoint() end, desc = "Debug: Toggle Breakpoint" },
      { "<F10>", function() require("dap").step_over() end, desc = "Debug: Step Over" },
      { "<F11>", function() require("dap").step_into() end, desc = "Debug: Step Into" },
      { "<S-F11>", function() require("dap").step_out() end, desc = "Debug: Step Out" },
      { "<F8>", function() require("dap").terminate() end, desc = "Debug: Stop" },
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    keys = {
      { "<F6>", function() require("dapui").toggle() end, desc = "Debug: Toggle UI" },
    },
  },
}
