vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = false,
})
return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      r_language_server = {},
      rust_analyzer = {},
      julials = {},
      vimls = {},
      pyright = {},
      bashls = {},
      lua_ls = {},
      yamlls = {},
      sqlls = {},
      ltex = {
        filetypes = { "quarto", "rmd", "latex", "tex", "bib", "markdown", "gitcommit" },
        settings = {
          ltex = {
            enabled = { "quarto", "rmd", "latex", "tex", "bib", "markdown" },
            additionalRules = {
              languageModel = { "$HOME/.ngram-plug/en/" },
            },
            language = "en-US",
          },
        },
      },
    },
  },
}
