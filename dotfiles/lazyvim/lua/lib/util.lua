local M = {}

--- そのパスが存在するかどうか
---@param file string file path
---@return boolean suc
---@return string? errmsg
function M.exists(file)
  local ok, err, code = os.rename(file, file)
  if not ok then
    if code == 13 then
      -- Permission denied, but it exists
      return true
    end
  end
  return ok, err
end

function M.eval_option(option)
  if type(option) == "function" then
    option = option()
  end
  if type(option) == "thread" then
    assert(coroutine.status(option) == "suspended", "If option is a thread it must be suspended")
    local co = coroutine.running()
    -- Schedule ensures `coroutine.resume` happens _after_ coroutine.yield
    -- This is necessary in case the option coroutine is synchronous and
    -- gives back control immediately
    vim.schedule(function()
      coroutine.resume(option, co)
    end)
    option = coroutine.yield()
  end
  return option
end

--- `ojb` が `nil` でなければ `obj` を返す,
--- `ojb` が `nil` であれば `nonNullObj`を返す
---@generic T
---@param obj nil | T
---@param nonNullObj T
---@return T
function M.requireNonNullElse(obj, nonNullObj)
  return obj and obj or nonNullObj
end

--- telescope で選択したファイルのパスを返す
--- これを使用する際は coroutine を使用してください
--- local run = coroutine.wrap(function()
---   local path = myutils.getChoiceFilePath()
---   -- ... このあとで path を使ってコードを実行する
--- end)
---@return string
function M.getChoiceFilePath()
  local co = coroutine.running()
  local cb = function(p)
    coroutine.resume(co, p)
  end
  cb = vim.schedule_wrap(cb)
  require("telescope.builtin").find_files({
    prompt_title = "Select a File",
    shorten_path = false,
    attach_mappings = function(prompt_bufnr, _)
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        cb(getmetatable(selection).cwd .. "/" .. selection[1])
      end)
      return true
    end,
  })
  return M.eval_option(coroutine.yield())
end

function M.getDebugPath()
  local debug = vim.fn.expand("%:p:h") .. "/.debug/"
  if not M.exists(debug) then
    os.execute("mkdir " .. debug)
  end
  return debug .. vim.fn.expand("%:r")
end

--- > 文字を置換してくれる
--- @param cmd string
--- @return string
function M.substitute(cmd)
  cmd = cmd:gsub("$fileExtension", vim.fn.expand("%:e"))
  cmd = cmd:gsub("$fileBase", vim.fn.expand("%:r"))
  cmd = cmd:gsub("$filePath", vim.fn.expand("%:p"))
  cmd = cmd:gsub("$file", vim.fn.expand("%"))
  cmd = cmd:gsub("$dir", vim.fn.expand("%:p:h"))
  cmd = cmd:gsub("$debugPath", M.getDebugPath())
  return cmd
end

return M
