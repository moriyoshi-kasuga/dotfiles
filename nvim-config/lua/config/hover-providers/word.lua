local async = require("hover.async")

--- @param _params Hover.Provider.Params
--- @param done fun(result?: Hover.Provider.Result)
local function execute(_params, done)
  async.run(function()
    local word = vim.fn.expand("<cword>")

    local process = async.await(2, vim.system, {
      "dict",
      "-d",
      "dictd-db-eng-jpn",
      word,
    })

    ---@diagnostic disable-next-line: undefined-field
    local line = process.code == 0 and process.stdout or process.stderr

    done({ lines = { line }, filetype = "markdown" })
  end)
end

--- @type Hover.Provider
return {
  name = "Dictionary",
  priority = 100,
  enabled = function()
    local word = vim.fn.expand("<cword>")
    return #vim.spell.check(word) == 0
  end,
  execute = execute,
}
