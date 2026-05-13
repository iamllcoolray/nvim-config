
-- lua/custom/plugins/telescope.lua
return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          mappings = {
            i = {
              ["<C-u>"] = false,
              ["<C-d>"] = false,
              ["<C-j>"] = "move_selection_next",
              ["<C-k>"] = "move_selection_previous",
            },
          },
          file_ignore_patterns = {
            "node_modules", ".git/", "%.lock", "lazy-lock.json",
            "%.class", "target/", "dist/", "build/",
          },
        },
        pickers = {
          find_files = { hidden = true },
        },
      })
      pcall(require("telescope").load_extension, "fzf")
    end,
  },
}
 
