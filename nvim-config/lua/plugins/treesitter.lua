local function select(query)
  return function()
    require("nvim-treesitter-textobjects.select").select_textobject(query, "textobjects")
  end
end

local function move(fn, query)
  return function()
    require("nvim-treesitter-textobjects.move")[fn](query, "textobjects")
  end
end

-- { key, name, query used by ]x / [x }
local objects = {
  { "f", "function", "@function.outer" },
  { "c", "class", "@class.outer" },
  { "a", "parameter", "@parameter.inner" },
}

local keys = {}
for _, object in ipairs(objects) do
  local key, name, move_query = unpack(object)
  local upper = key:upper()
  vim.list_extend(keys, {
    { "a" .. key, select("@" .. name .. ".outer"), mode = { "x", "o" }, desc = "Select outer " .. name },
    { "i" .. key, select("@" .. name .. ".inner"), mode = { "x", "o" }, desc = "Select inner " .. name },
    { "]" .. key, move("goto_next_start", move_query), mode = { "n", "x", "o" }, desc = "Next " .. name .. " start" },
    { "]" .. upper, move("goto_next_end", move_query), mode = { "n", "x", "o" }, desc = "Next " .. name .. " end" },
    {
      "[" .. key,
      move("goto_previous_start", move_query),
      mode = { "n", "x", "o" },
      desc = "Previous " .. name .. " start",
    },
    {
      "[" .. upper,
      move("goto_previous_end", move_query),
      mode = { "n", "x", "o" },
      desc = "Previous " .. name .. " end",
    },
  })
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
    branch = "main",
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    opts = {
      move = {
        set_jumps = true,
      },
    },
    keys = keys,
  },
}
