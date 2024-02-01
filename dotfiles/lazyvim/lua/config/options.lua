-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.autoformat = false -- disable auto format
vim.g["qs_highlight_on_keys"] = { "f", "F", "t", "T" }
vim.opt.spelllang = "en,cjk"
vim.o.clipboard = ""

vim.o.wrap = true
vim.o.mouse = "" -- disable mouse

vim.opt.list = false

-- local function replace_markdown(var)
--   if type(var) == "table" then
--     return vim.tbl_map(replace_markdown, var)
--   elseif type(var) == "string" then
--     return var
--       :gsub("%[([^%]]+)%]%([^%)]+%)", "[%1]()")
--       :gsub("<b>", "**")
--       :gsub("</b>", "**")
--       :gsub("<i>", "*")
--       :gsub("</i>", "*")
--   end
-- end

-- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(function(_, result, ctx, config)
--   local file_extension = vim.fn.expand("%:e")
--   if file_extension ~= "java" and file_extension ~= "class" and file_extension ~= "kt" then
--     return vim.lsp.handlers.hover(_, result, ctx, config)
--   end
--   config = config or {}
--   config.focus_id = ctx.method
--   if not (result and result.contents) then
--     return
--   end
--   local contents = result.contents
--   contents = replace_markdown(contents)
--   local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(contents)
--   if vim.tbl_isempty(markdown_lines) then
--     return
--   end
--   return vim.lsp.util.open_floating_preview(markdown_lines, "markdown", config)
-- end, { border = "rounded" })

vim.filetype.add({
  extension = {
    mdx = "markdown",
  },
})
