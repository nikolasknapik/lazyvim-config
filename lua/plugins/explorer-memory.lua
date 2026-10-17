return {
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader>e", function() require("config.project-explorer").toggle() end, desc = "Explorer (project root)" },
      { "<leader>fe", function() require("config.project-explorer").toggle() end, desc = "Explorer (project root)" },
    },
  },
}
