return {
  "nvim-neo-tree/neo-tree.nvim",
  keys = {
    { "<leader>o", mode = "n", "<cmd>Neotree close<cr>", desc = "Neotree close." },
    { "<leader>e", mode = "n", "<cmd>Neotree focus<cr>", desc = "Neotree focus." },
    { "<leader>ge", mode = "n", "<cmd>Neotree git_status<cr>", desc = "Git Explorer" },
    { "<leader>be", mode = "n", "<cmd>Neotree buffers<cr>", desc = "Buffer Explorer" },
  },
  opts = {
    event_handlers = {
      {
        event = "neo_tree_buffer_enter",
        handler = function(_)
          vim.cmd([[
          setlocal number
          setlocal relativenumber
        ]])
        end,
      },
    },
    commands = {
      parent_or_close = function(state)
        local node = state.tree:get_node()
        if (node.type == "directory" or node:has_children()) and node:is_expanded() then
          state.commands.toggle_node(state)
        else
          require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
        end
      end,
      child_or_open = function(state)
        local node = state.tree:get_node()
        if node.type == "directory" or node:has_children() then
          if not node:is_expanded() then -- if unexpanded, expand
            state.commands.toggle_node(state)
          else -- if expanded and has children, seleect the next child
            require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
          end
        else -- if not a directory just open it
          state.commands.open(state)
        end
      end,
      toggle_compact = function(state)
        state.group_empty_dirs = not state.group_empty_dirs
        require("neo-tree.sources.manager").refresh()
      end,
      copy_path = function(state)
        -- NeoTree is based on [NuiTree](https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/tree)
        -- The node is based on [NuiNode](https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/tree#nuitreenode)
        local node = state.tree:get_node()
        local filepath = node:get_id()
        local filename = node.name
        local modify = vim.fn.fnamemodify

        local results = {
          filepath,
          modify(filepath, ":."),
          modify(filepath, ":~"),
          filename,
          modify(filename, ":r"),
          modify(filename, ":e"),
        }

        vim.ui.select({
          "1. Absolute path: " .. results[1],
          "2. Path relative to CWD: " .. results[2],
          "3. Path relative to HOME: " .. results[3],
          "4. Filename: " .. results[4],
          "5. Filename without extension: " .. results[5],
          "6. Extension of the filename: " .. results[6],
        }, { prompt = "Choose to copy to clipboard:" }, function(choice)
          if choice then
            local i = tonumber(choice:sub(1, 1))
            if i then
              local result = results[i]
              vim.fn.setreg("*", result)
              vim.notify("Copied: " .. result)
            else
              vim.notify("Invalid selection")
            end
          else
            vim.notify("Selection cancelled")
          end
        end)
      end,
      open_terminal = function(state)
        local node = state.tree:get_node()
        local filepath = node:get_id()
        filepath = vim.fn.fnamemodify(filepath, ":p:h")
        Snacks.terminal(nil, { cwd = filepath })
      end,
    },
    filesystem = {
      filtered_items = {
        visible = true,
        group_empty_dirs = false,
        hide_dotfiles = false,
        hide_gitignore = true,
        hide_hidden = true,
        never_show = {
          ".DS_Store",
        },
      },
    },
    window = {
      mappings = {
        h = "parent_or_close",
        l = "child_or_open",
        Y = {
          "copy_path",
          desc = "Copy Path to Clipboard",
        },
        I = "toggle_compact",
        T = "open_terminal",
      },
    },
  },
}
