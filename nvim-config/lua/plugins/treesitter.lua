local function select(query)
  return function()
    require("nvim-treesitter-textobjects.select").select_textobject(query, "textobjects")
  end
end

-- Used as an expr mapping. When native_key is given and the window is in diff
-- mode, fall back to the builtin motion (e.g. ]c / [c for diff hunks).
local function move(fn, query, native_key)
  return function()
    if native_key and vim.wo.diff then
      return native_key
    end
    return ("<Cmd>lua require('nvim-treesitter-textobjects.move').%s(%q, 'textobjects')<CR>"):format(fn, query)
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
  -- ]c / [c are the builtin diff hunk motions; keep them in diff mode
  local native = key == "c"
  vim.list_extend(keys, {
    { "a" .. key, select("@" .. name .. ".outer"), mode = { "x", "o" }, desc = "Select outer " .. name },
    { "i" .. key, select("@" .. name .. ".inner"), mode = { "x", "o" }, desc = "Select inner " .. name },
    {
      "]" .. key,
      move("goto_next_start", move_query, native and "]c" or nil),
      mode = { "n", "x", "o" },
      expr = true,
      desc = "Next " .. name .. " start",
    },
    {
      "]" .. upper,
      move("goto_next_end", move_query),
      mode = { "n", "x", "o" },
      expr = true,
      desc = "Next " .. name .. " end",
    },
    {
      "[" .. key,
      move("goto_previous_start", move_query, native and "[c" or nil),
      mode = { "n", "x", "o" },
      expr = true,
      desc = "Previous " .. name .. " start",
    },
    {
      "[" .. upper,
      move("goto_previous_end", move_query),
      wode = { "n", "x", "o" },
      expr = true,
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
