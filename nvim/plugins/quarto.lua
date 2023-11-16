return {
  "quarto-dev/quarto-nvim",
  dependencies = {
    "jmbuhr/otter.nvim",
    "hrsh7th/nvim-cmp",
    "neovim/nvim-lspconfig",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = function()
    return {
      closePreviewOnExit = true,
      lspFeatures = {
        enabled = true,
        chunks = "curly",
        languages = { "r", "python", "julia", "bash", "lua", "html" },
        diagnostics = {
          enabled = true,
          triggers = { "BufWritePost" },
        },
        completion = {
          enabled = true,
        },
      },
      keymap = {
        hover = "K",
        definition = "gd",
        rename = "<leader>lR",
        references = "gr",
      },
    }
  end,
}
