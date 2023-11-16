local formatters = {
  r = { "styler" },
  python = { "black" },
  quarto = { "custom_prettier" },
  rmd = { "custom_prettier" },
  markdown = { "custom_prettier" },
  rust = { "rustfmt" },
  julia = { "juliafmt" },
}
return {
  "stevearc/conform.nvim",
  formatters_by_ft = formatters,
  format_on_save = {
    lsp_fallback = true,
    timeout_ms = 2000,
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
    juliafmt = {
      command = "juliafmt",
      args = {
        "-e",
        "using JuliaFormatter; println(format_text(String(read(stdin))))",
      },
      stdin = true,
    },
  },
}
