return {
  {
    "milanglacier/yarepl.nvim",
    opts = function()
      local yarepl = require("yarepl")
      local ft_to_repl = {
        r = "radian",
        rmd = "radian",
        quarto = "radian",
        markdown = "radian",
        ["markdown.pandoc"] = "radian",
        python = "ipython",
        sh = "bash",
        REPL = "",
        julia = "julia",
      }
      local bufmap = vim.api.nvim_buf_set_keymap
      local autocmd = vim.api.nvim_create_autocmd
      local function run_cmd_with_count(cmd)
        return function()
          vim.cmd(string.format("%d%s", vim.v.count, cmd))
        end
      end
      autocmd("FileType", {
        pattern = { "r", "quarto", "markdown", "markdown.pandoc", "rmd", "python", "sh", "REPL", "julia" },
        group = my_augroup,
        desc = "set up REPL keymap",
        callback = function()
          local repl = ft_to_repl[vim.bo.filetype]
          bufmap(0, "n", "<leader>rs", "", {
            callback = run_cmd_with_count("REPLStart " .. repl),
            desc = "Start a REPL",
          })
          bufmap(0, "n", "<leader>rf", "", {
            callback = run_cmd_with_count("REPLFocus"),
            desc = "Focus on REPL",
          })
          bufmap(0, "n", "<leader>rv", "<CMD>Telescope REPLShow<CR>", {
            desc = "View REPLs in telescope",
          })
          bufmap(0, "n", "<leader>rh", "", {
            callback = run_cmd_with_count("REPLHide"),
            desc = "Hide REPL",
          })
          bufmap(0, "v", "<leader>s", "", {
            callback = run_cmd_with_count("REPLSendVisual"),
            desc = "Send visual region to REPL",
          })
          bufmap(0, "n", "<leader>ss", "", {
            callback = run_cmd_with_count("REPLSendLine"),
            desc = "Send current line to REPL",
          })
          -- `<leader>sap` will send the current paragraph to the
          -- buffer-attached REPL, or REPL 1 if there is no REPL attached.
          -- `2<Leader>sap` will send the paragraph to REPL 2. Note that `ap` is
          -- just an example and can be replaced with any text object or motion.
          bufmap(0, "n", "<leader>s", "", {
            callback = run_cmd_with_count("REPLSendMotion"),
            desc = "Send motion to REPL",
          })
          bufmap(0, "n", "<leader>rq", "", {
            callback = run_cmd_with_count("REPLClose"),
            desc = "Quit REPL",
          })
          bufmap(0, "n", "<leader>rc", "<CMD>REPLCleanup<CR>", {
            desc = "Clear REPLs.",
          })
          bufmap(0, "n", "<leader>rS", "<CMD>REPLSwap<CR>", {
            desc = "Swap REPLs.",
          })
          bufmap(0, "n", "<leader>r?", "", {
            callback = run_cmd_with_count("REPLStart"),
            desc = "Start an REPL from available REPL metas",
          })
          bufmap(0, "n", "<leader>ra", "<CMD>REPLAttachBufferToREPL<CR>", {
            desc = "Attach current buffer to a REPL",
          })
          bufmap(0, "n", "<leader>rd", "<CMD>REPLDetachBufferToREPL<CR>", {
            desc = "Detach current buffer to any REPL",
          })
        end,
      })
      return {
        buflisted = true,
        -- whether the REPL buffer should be a scratch buffer.
        scratch = true,
        -- the filetype of the REPL buffer created by `yarepl`
        ft = "REPL",
        -- How yarepl open the REPL window, can be a string or a lua function.
        -- See below example for how to configure this option
        wincmd = "vertical 100 split",
        -- The available REPL palattes that `yarepl` can create REPL based on
        metas = {
          radian = { cmd = "radian", formatter = yarepl.formatter.bracketed_pasting },
          ipython = { cmd = "ipython", formatter = yarepl.formatter.bracketed_pasting },
          python = { cmd = "python", formatter = yarepl.formatter.trim_empty_lines },
          R = { cmd = "R", formatter = yarepl.formatter.trim_empty_lines },
          julia = { cmd = "julia", formatter = yarepl.formatter.trim_empty_lines },
          -- bash version >= 4.4 supports bracketed paste mode. but macos
          -- shipped with bash 3.2, so we don't use bracketed paste mode for
          -- bash.
          bash = { cmd = "bash", formatter = yarepl.formatter.trim_empty_lines },
        },
        -- when a REPL process exits, should the window associated with those REPLs closed?
        close_on_exit = true,
        -- whether automatically scroll to the bottom of the REPL window after sending
        -- text? This feature would be helpful if you want to ensure that your view
        -- stays updated with the latest REPL output.
        scroll_to_bottom_after_sending = true,
      }
    end,
  },
}
