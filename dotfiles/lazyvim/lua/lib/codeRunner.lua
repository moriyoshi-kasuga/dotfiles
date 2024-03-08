local M = {}

local util = require("lib.util")

M.supported_filetypes = {
  c = {
    run = "${compile} && $debugPath",
    compile = "gcc $file -o $debugPath",
    debug = "gcc -g $file -o $debugPath",
  },
  cpp = {
    run = "${compile} && $debugPath",
    runStdio = "${compile} && $debugPath < ${input}",
    compile = "g++ -std=c++23 $file -o $debugPath",
    debug = "g++ -std=c++23 -Wall -DAL -O2 $file -o $debugPath",
  },
  py = {
    run = "python3 $file",
  },
  rs = {
    run = "rustc $file && ./$fileBase",
  }
}

function M.RunCode()
  local file_extension = vim.fn.expand("%:e")
  local selected_cmd = ""
  local term_cmd = "bot 10 new | term "

  if M.supported_filetypes[file_extension] then
    local choices = vim.tbl_keys(M.supported_filetypes[file_extension])

    if #choices == 0 then
      vim.notify("It doesn't contain any command", vim.log.levels.WARN, { title = "Code Runner" })
    elseif #choices == 1 then
      selected_cmd = M.supported_filetypes[file_extension][choices[1]]
      vim.cmd(term_cmd .. util.substitute(selected_cmd))
      vim.api.nvim_buf_set_keymap(0, "n", "q", ":bd!<cr>", { noremap = true, silent = true })
    else
      vim.ui.select(choices, { prompt = "Choose a command: " }, function(choice)
        local filetypes = M.supported_filetypes[file_extension]
        selected_cmd = filetypes[choice]
        if selected_cmd then
          local run = coroutine.wrap(function()
            selected_cmd = selected_cmd:gsub("${compile}", filetypes["compile"])
            selected_cmd = selected_cmd:gsub("${debug}", filetypes["debug"])
            if selected_cmd:find("${input}") then
              selected_cmd = selected_cmd:gsub("${input}", util.getChoiceFilePath())
            end
            util.open_buf("CodeRunner", term_cmd .. util.substitute(selected_cmd))
          end)
          run()
        end
      end)
    end
  else
    vim.notify("The filetype isn't included in the list", vim.log.levels.WARN, { title = "Code Runner" })
  end
end

return M
