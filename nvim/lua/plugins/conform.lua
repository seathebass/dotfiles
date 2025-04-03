return {
  "stevearc/conform.nvim",
  optional = true,
  opts = {
    formatters_by_ft = {
      python = { "black" },
      quarto = { "custom_prettier" },
      rmd = { "custom_prettier" },
      markdown = { "custom_prettier" },
      rust = { "rustfmt" },
      sql = { "sqlfmt" },
    },
    log_level = vim.log.levels.ERROR,
    -- Conform will notify you when a formatter errors
    notify_on_error = true,
    formatters = {
      custom_prettier = {
        command = "prettier",
        args = {
          "--stdin-filepath",
          "--prose-wrap",
          "always",
          "--parser",
          "markdown",
        },
        stdin = true,
      },
    },
  },
}
