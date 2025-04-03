return {
  {
    "saghen/blink.cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
      "saghen/blink.compat",
      "jc-doyle/cmp-pandoc-references",
    },
    opts = {
      sources = {
        compat = {
          "emoji",
          "pandoc_references",
        },
      },
    },
  },
}
