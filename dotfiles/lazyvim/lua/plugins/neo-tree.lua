return {
  "nvim-neo-tree/neo-tree.nvim",
  keys = {
    { "<leader>e", mode = "n", "<cmd>Neotree focus<cr>", desc = "Neotree focus." },
    { "<leader>o", mode = "n", "<cmd>Neotree close<cr>", desc = "Neotree close." },
  },
  opts = {
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
    },
    filesystem = {
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignore = true,
        hide_hidden = true,
        hiden_by_name = {
          "node_modules",
        },
        never_show = {
          ".DS_Store",
        },
      },
    },
    window = {
      mappings = {
        h = "parent_or_close",
        l = "child_or_open",
      },
    },
  },
}
