-- Bordered side panel and popups, with native editor splits preserved.
return {
  {
    "akinsho/bufferline.nvim",
    opts = function(_, opts)
      opts.options = vim.tbl_deep_extend("force", opts.options or {}, {
        separator_style = { " ", " " },
        indicator = { style = "icon", icon = "▎" },
        always_show_bufferline = true,
        offsets = {
          { filetype = "neo-tree", text = "", highlight = "BufferLineFill", separator = false },
          { filetype = "snacks_layout_box", text = "", highlight = "BufferLineFill", separator = false },
        },
      })
      -- One continuous rail; the selected tab joins the editor surface.
      -- Resolve the palette on each refresh so colorscheme changes still work.
      opts.highlights = function()
        local c = require("catppuccin.palettes").get_palette()
        local h = require("catppuccin.special.bufferline").get_theme()()
        for name, group in pairs(h) do
          group.bg = "NONE"
          group.italic = false
          if name:find("separator") then group.fg = group.bg end
        end
        h.fill = { bg = "NONE" }
        h.background = { fg = c.overlay1, bg = "NONE" }
        h.buffer_visible = { fg = c.subtext0, bg = "NONE" }
        h.buffer_selected = { fg = c.lavender, bg = "NONE", bold = true, italic = false }
        h.indicator_selected = { fg = c.lavender, bg = "NONE" }
        h.close_button_selected = { fg = c.overlay1, bg = "NONE" }
        return h
      end
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      -- The bufferline already shows the current file, so keep only
      -- diagnostics in the middle of the bottom statusline.
      local icons = LazyVim.config.icons
      opts.sections.lualine_c = {
        {
          "diagnostics",
          symbols = {
            error = icons.diagnostics.Error,
            warn = icons.diagnostics.Warn,
            info = icons.diagnostics.Info,
            hint = icons.diagnostics.Hint,
          },
        },
      }

      local structural_nodes = {
        annotation_type_declaration = "Interface",
        arrow_function = "Function",
        class_declaration = "Class",
        class_definition = "Class",
        class_specifier = "Class",
        constructor_declaration = "Constructor",
        enum_declaration = "Enum",
        enum_specifier = "Enum",
        function_declaration = "Function",
        function_definition = "Function",
        function_expression = "Function",
        function_item = "Function",
        interface_declaration = "Interface",
        method_declaration = "Method",
        method_definition = "Method",
        namespace_definition = "Namespace",
        object_declaration = "Object",
        record_declaration = "Struct",
        struct_item = "Struct",
        struct_specifier = "Struct",
        trait_definition = "Interface",
        union_specifier = "Struct",
      }

      local filetype_nodes = {
        haskell = { class = "Class", instance = "Interface", ["function"] = "Function" },
        html = { element = "Object" },
        javascript = { pair = "Property", variable_declarator = "Variable" },
        javascriptreact = { pair = "Property", variable_declarator = "Variable" },
        json = { pair = "Key" },
        json5 = { pair = "Key" },
        jsonc = { pair = "Key" },
        markdown = { section = "Text" },
        sql = {
          create_function = "Function",
          create_procedure = "Function",
          create_table = "Struct",
          create_trigger = "Event",
          create_view = "Interface",
        },
        toml = { pair = "Key", table = "Module", table_array_element = "Module" },
        typescript = {
          optional_parameter = "Variable",
          pair = "Property",
          property_signature = "Property",
          required_parameter = "Variable",
          type_alias_declaration = "Interface",
          variable_declarator = "Variable",
        },
        typescriptreact = {
          optional_parameter = "Variable",
          pair = "Property",
          property_signature = "Property",
          required_parameter = "Variable",
          type_alias_declaration = "Interface",
          variable_declarator = "Variable",
        },
        xml = { element = "Object" },
        yaml = { block_mapping_pair = "Key", flow_pair = "Key" },
      }

      local function clean_name(text)
        if not text then return nil end
        return text:gsub("^%s*['\"]", ""):gsub("['\"]%s*$", ""):gsub("^%s+", ""):gsub("%s+$", "")
      end

      local function node_name(node, filetype)
        if node:type() == "section" then
          local heading = node:named_child(0)
          if heading and (heading:type() == "atx_heading" or heading:type() == "setext_heading") then
            local text = vim.treesitter.get_node_text(heading, 0)
            return text:match("^%s*#+%s*(.-)%s*#*%s*$") or text:match("^%s*([^\r\n]+)")
          end
          return nil
        end

        if node:type() == "pair" or node:type() == "block_mapping_pair" or node:type() == "flow_pair" then
          local key = node:named_child(0)
          return key and clean_name(vim.treesitter.get_node_text(key, 0)) or nil
        end

        if node:type() == "table" or node:type() == "table_array_element" then
          local key = node:named_child(0)
          return key and clean_name(vim.treesitter.get_node_text(key, 0)) or nil
        end

        if node:type() == "element" then
          local start_tag = node:named_child(0)
          local tag = start_tag and start_tag:named_child(0)
          return tag and vim.treesitter.get_node_text(tag, 0) or nil
        end

        local name = node:field("name")[1] or node:field("pattern")[1]
        if not name and filetype == "kotlin" then
          local first = node:named_child(0)
          if first and (first:type() == "simple_identifier" or first:type() == "type_identifier") then name = first end
        end

        local declarator = node:field("declarator")[1]
        if not name and declarator then
          local text = vim.treesitter.get_node_text(declarator, 0)
          return clean_name(text:match("^(.-)%s*%(") or text)
        end

        if not name and node:type():find("^create_") then
          for child in node:iter_children() do
            if child:named() and child:type() == "object_reference" then
              name = child:field("name")[1]
              break
            end
          end
        end

        if not name and (node:type() == "arrow_function" or node:type() == "function_expression") then
          local parent = node:parent()
          name = parent and (parent:field("name")[1] or parent:field("key")[1])
          if not name then
            local parameters = node:field("parameters")[1]
            local first = parameters and parameters:named_child(0)
            name = first and (first:field("pattern")[1] or first)
          end
        end

        if not name and node:type() == "function_definition" and filetype == "lua" then
          local parent = node:parent()
          for _ = 1, 2 do
            if not parent then break end
            name = parent:field("name")[1]
            if name then break end
            if parent:type() == "assignment_statement" then name = parent:named_child(0) end
            parent = parent:parent()
          end
        end

        return name and vim.treesitter.get_node_text(name, 0) or nil
      end

      local function treesitter_breadcrumbs()
        local ok, parser = pcall(vim.treesitter.get_parser, 0)
        if not ok then return "" end

        local tree = parser:parse()[1]
        if not tree then return "" end

        local cursor = vim.api.nvim_win_get_cursor(0)
        local row, col = cursor[1] - 1, cursor[2]
        local line = vim.api.nvim_get_current_line()
        local first_text = line:find("%S")
        if first_text then col = math.max(col, first_text - 1) end
        local node = tree:root():named_descendant_for_range(row, col, row, col)
        local filetype = vim.bo.filetype
        local extra_nodes = filetype_nodes[filetype] or {}
        local parts = {}
        local seen = {}

        while node do
          local kind = structural_nodes[node:type()] or extra_nodes[node:type()]
          local name = kind and node_name(node, filetype)
          if name and not seen[name] then
            local icon = icons.kinds[kind] or ""
            table.insert(parts, 1, icon .. " " .. name:gsub("%%", "%%%%"))
            seen[name] = true
          end
          node = node:parent()
        end

        return table.concat(parts, "  ›  ")
      end

      local function file_breadcrumbs()
        local path = vim.api.nvim_buf_get_name(0)
        if path == "" then return (icons.kinds.File or "") .. " [No Name]" end

        path = LazyVim.norm(path)
        local root = LazyVim.root.get({ normalize = true })
        if root and path:sub(1, #root + 1) == root .. "/" then path = path:sub(#root + 2) end

        local parts = vim.split(path, "/", { plain = true, trimempty = true })
        if #parts == 0 then return "" end

        local ok, devicons = pcall(require, "nvim-web-devicons")
        local file_icon = ok and devicons.get_icon(parts[#parts], nil, { default = true }) or icons.kinds.File
        parts[#parts] = (file_icon or "") .. " " .. parts[#parts]

        for index, part in ipairs(parts) do
          parts[index] = part:gsub("%%", "%%%%")
        end
        return table.concat(parts, "  ›  ")
      end

      local function winbar_breadcrumbs()
        local file = file_breadcrumbs()
        local symbol = treesitter_breadcrumbs()
        return symbol == "" and file or file .. "  ›  " .. symbol
      end

      local function breadcrumbs()
        return {
          winbar_breadcrumbs,
          cond = function()
            return vim.bo.buftype == ""
          end,
          separator = "",
          padding = { left = 1, right = 0 },
        }
      end

      opts.winbar = { lualine_c = { breadcrumbs() } }
      opts.inactive_winbar = { lualine_c = { breadcrumbs() } }
    end,
  },
  {
    "LazyVim/LazyVim",
    init = function()
      vim.opt.winborder = "rounded"
      vim.opt.pumblend = 0
      vim.opt.winblend = 0
      vim.opt.fillchars:append({ vert = "│", horiz = "─", horizup = "┴", horizdown = "┬", vertleft = "┤", vertright = "├", verthoriz = "┼" })
    end,
  },
  {
    "folke/snacks.nvim",
    opts = {
      styles = { float = { border = "rounded" } },
      picker = {
        sources = {
          explorer = {
            layout = {
              preset = "sidebar",
              preview = false,
              layout = {
                backdrop = false,
                width = 36,
                min_width = 28,
                height = 0,
                position = "left",
                border = "rounded",
                title = " Explorer ",
                title_pos = "center",
                box = "vertical",
                { win = "input", height = 1, border = "bottom" },
                { win = "list", border = "none" },
                { win = "preview", title = "{preview}", height = 0.4, border = "top" },
              },
            },
          },
        },
      },
    },
  },
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        menu = { border = "rounded" },
        documentation = { window = { border = "rounded" } },
      },
      signature = { window = { border = "rounded" } },
    },
  },
  {
    "folke/which-key.nvim",
    opts = { win = { border = "rounded" } },
  },
  {
    "folke/noice.nvim",
    opts = {
      views = {
        cmdline_popup = { border = { style = "rounded" } },
        popupmenu = { border = { style = "rounded" } },
        hover = { border = { style = "rounded" } },
      },
    },
  },
}
