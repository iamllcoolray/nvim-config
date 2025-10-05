return {
	{
		"saghen/blink.cmp",
		event = "InsertEnter",
		dependencies = {
			"neovim/nvim-lspconfig",
			"williamboman/mason-lspconfig.nvim",
			"L3MON4D3/LuaSnip",
			"rafamadriz/friendly-snippets",
		},
		config = function()
			local blink = require("blink.cmp")

			blink.setup({
				keymap = { preset = "default" },
				completion = {
					accept = { auto_brackets = { enabled = true } },
					list = { selection = { preselect = true, auto_insert = true } },
				},
				signature = { enabled = true },
			})

			-- Load VSCode-style snippets
			require("luasnip.loaders.from_vscode").lazy_load()

			-- Integrate Blink completions into all LSPs
			local capabilities = blink.get_lsp_capabilities()
			local lspconfig = require("lspconfig")

			require("mason-lspconfig").setup_handlers({
				function(server_name)
					lspconfig[server_name].setup({
						capabilities = capabilities,
					})
				end,
			})
		end,
	},

	-- Disable nvim-cmp (Kickstart includes it by default)
	{ "hrsh7th/nvim-cmp", enabled = false },
}
