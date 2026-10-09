
-- lua/custom/plugins/treesitter.lua
return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
    branch = "master",
    main = "nvim-treesitter.configs",
    opts = {
      ensure_installed = {
        "lua", "vim", "vimdoc", "javascript", "typescript",
        "python", "html", "css", "java", "go", "rust",
        "c", "cpp", "perl", "ruby", "php", "markdown",
        "markdown_inline", "zig",
      },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = false },
    },
  },
}
 
