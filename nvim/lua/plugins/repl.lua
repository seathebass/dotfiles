return {
    {
        "milanglacier/yarepl.nvim",
        opts = function()
            local yarepl = require("yarepl")
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
                require('telescope').load_extension 'REPLShow'
                }
        end,
    },
}
