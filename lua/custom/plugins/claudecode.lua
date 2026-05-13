-- lua/custom/plugins/claudecode.lua
-- Claude Code IDE integration for Neovim
-- Requires: Claude Code CLI → curl -fsSL https://claude.ai/install.sh | bash
-- Then authenticate: claude login

return {
  "coder/claudecode.nvim",
  dependencies = {
    "folke/snacks.nvim", -- terminal window provider
  },
  config = true,
  opts = {
    -- If `claude` isn't on your PATH after install, point to it explicitly:
    -- terminal_cmd = "~/.claude/local/claude",

    terminal = {
      split_side = "right",
      split_width_percentage = 0.35,
      provider = "snacks",
      auto_close = true,
    },

    focus_after_send = true,
    track_selection = true,
  },
}
