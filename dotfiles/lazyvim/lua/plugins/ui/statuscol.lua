-- return {}
return {
  {
    "luukvbaal/statuscol.nvim",
    event = "BufReadPre",
    config = function()
      local builtin = require("statuscol.builtin")
      require("statuscol").setup({
        bt_ignore = { "terminal", "nofile", "ddu-ff", "ddu-ff-filter" },
        relculright = true,
        segments = {
          -- {
          --   sign = {
          --     namespace = { "diagnostic/signs" },
          --     maxwidth = 1,
          --   },
          -- },
          {
            text = {
              function(args)
                if not args.rnu and not args.nu then
                  return ""
                end
                if args.virtnum ~= 0 then
                  return "%="
                end

                local tmp_lnum = args.rnu and (args.relnum > 0 and args.relnum or (args.nu and args.lnum or 0))
                  or args.lnum
                local lnum = string.format("%3d", tmp_lnum)

                if args.relnum == 0 and args.rnu then
                  return lnum .. "%="
                else
                  return "%=" .. lnum
                end
              end,
            },
            condition = { true, builtin.not_empty },
            sign = {
              maxwidth = 1,
              colwidth = 1,
              wrap = true,
            },
          },
          {
            text = { " " },
            sign = {
              maxwidth = 1,
              colwidth = 1,
              wrap = true,
            },
          },
          {
            sign = {
              namespace = { "gitsigns" },
              maxwidth = 1,
              colwidth = 1,
              wrap = true,
            },
          },
        },
      })
    end,
  },
}
