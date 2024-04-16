return {
    "folke/noice.nvim",
    opts = function(_, opts)
        opts.lsp = {
            hover = {
                silent = true
            },
            message = {
                enabled = false
            },
            progress = {
                enabled = false
            }
        }
    end
}
