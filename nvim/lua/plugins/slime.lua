return {
  -- slime (REPL integration)
  {
    "jpalardy/vim-slime",
    keys = {
      { "<leader>rc", "<cmd>SlimeConfig<cr>", desc = "Slime Config" },
      { "<leader>rs", ":'<,'>SlimeSend<CR>", mode = "v", desc = "Slime Send" },
    },
    init = function()
      -- these two should be set before the plugin loads
      vim.g.slime_target = "wezterm"
      vim.g.slime_no_mappings = true
    end,
    config = function()
      vim.g.slime_suggest_default = true
      vim.g.slime_ignore_unlisted = false
      vim.g.slime_bracketed_paste = true
    end,
  },
}
