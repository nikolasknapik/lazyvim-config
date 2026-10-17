local projects_root = vim.env.NVIM_PROJECTS_ROOT or vim.fs.joinpath(vim.fn.expand("~"), "PERSONAL", "projects")


return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          projects = {
            dev = { projects_root },
            max_depth = 4,
            patterns = { ".git" },
            projects = {
              vim.fs.joinpath(projects_root, "Java_application"),
              vim.fs.joinpath(projects_root, "LeetCode"),
              vim.fs.joinpath(projects_root, "Corebound", "RealmSpoken"),
              vim.fs.joinpath(projects_root, "Corebound", "Autoskola"),
            },
            confirm = function(picker, item)
              picker:close()
              if not item then
                return
              end

              local project_dir = vim.fs.root(item.file, { ".git" }) or item.file
              vim.fn.chdir(project_dir)

              -- Restore the selected project's session, then reassert its root:
              -- sourcing a session can restore the previous global directory.
              local session = Snacks.dashboard.sections.session()
              if session then
                vim.cmd(session.action:sub(2))
              end
              vim.fn.chdir(project_dir)
              require("config.project-explorer").set_root(project_dir)

              -- A session saved from the dashboard can contain no active file.
              -- In that case, show the project's files instead of another dashboard.
              vim.defer_fn(function()
                local has_file = false
                for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
                  if
                    vim.api.nvim_buf_is_loaded(buffer)
                    and vim.bo[buffer].buftype == ""
                    and vim.api.nvim_buf_get_name(buffer) ~= ""
                  then
                    has_file = true
                    break
                  end
                end

                if not has_file then
                  Snacks.picker.files({ cwd = project_dir })
                end
              end, 100)
            end,
          },
        },
      },
    },
  },
}
