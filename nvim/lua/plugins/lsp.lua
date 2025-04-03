return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      pyright = {},
      julials = {},
      vimls = {},
      r_language_server = {},
      bashls = {},
      lua_ls = {},
      yamlls = {},
      marksman = {
        filetypes = { "markdown", "rmd", "quarto" },
      },
      ltex = {
        filetypes = { "quarto", "rmd", "latex", "tex", "bib", "markdown", "gitcommit" },
        settings = {
          ltex = {
            enabled = { "quarto", "rmd", "latex", "tex", "bib", "markdown" },
            disabledRules = { ["en-US"] = { "CRIMINAL" } },
            language = "en-US",
            additionalRules = {
              motherTongue = "en-US",
              enablePickyRules = true,
              languageModel = "/home/seabass/ngram-data/",
              word2Vec = "/home/seabass/word2vec",
            },
          },
        },
      },
    },
    setup = {
      rust_analyzer = function()
        return true
      end,
    },
  },
}
