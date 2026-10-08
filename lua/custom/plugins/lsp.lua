-- lua/custom/plugins/lsp.lua
return {
  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      -- Setup mason
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",        -- Lua
          "ts_ls",         -- JavaScript/TypeScript
          "pyright",       -- Python
          "jdtls",         -- Java
          "gopls",         -- Go
          "rust_analyzer", -- Rust
          "clangd",        -- C/C++
          "perlnavigator", -- Perl
          "ruby_lsp",      -- Ruby
          "intelephense",  -- PHP
          "marksman",      -- Markdown
          "zls",           -- Zig
        },
      })

      -- LSP keymaps (set when LSP attaches)
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          map("gd", require("telescope.builtin").lsp_definitions, "Goto Definition")
          map("gr", require("telescope.builtin").lsp_references, "Goto References")
          map("gI", require("telescope.builtin").lsp_implementations, "Goto Implementation")
          map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type Definition")
          map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "Document Symbols")
          map("<leader>rn", vim.lsp.buf.rename, "Rename")
          map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
          map("K", vim.lsp.buf.hover, "Hover Documentation")
          map("gD", vim.lsp.buf.declaration, "Goto Declaration")
        end,
      })

      -- Get capabilities for LSP
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

      -- Configure lua_ls with custom settings
      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT",
            },
            diagnostics = {
              globals = { "vim", "love" },
            },
            workspace = {
              library = {
                vim.env.VIMRUNTIME,
                "${3rd}/love2d/library",
              },
              checkThirdParty = false,
            },
          },
        },
      })
    
      -- Configure pyright to detect .venv automatically (Windows-compatible)
      vim.lsp.config("pyright", {
        capabilities = capabilities,
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "workspace",
            },
          },
        },
        before_init = function(_, config)
          -- Look for .venv in the current working directory
          local path_sep = package.config:sub(1, 1) -- Gets '\' on Windows, '/' on Unix
          local venv_path = vim.fn.getcwd() .. path_sep .. ".venv"
          
          if vim.fn.isdirectory(venv_path) == 1 then
            -- On Windows, use Scripts instead of bin
            local python_path
            if path_sep == "\\" then
              python_path = venv_path .. "\\Scripts\\python.exe"
            else
              python_path = venv_path .. "/bin/python"
            end
            
            -- Only set if the python executable exists
            if vim.fn.filereadable(python_path) == 1 then
              config.settings.python.pythonPath = python_path
            end
          end
        end,
      })
     
      -- Configure gopls with custom settings
      vim.lsp.config("gopls", {
        capabilities = capabilities,
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
            },
            staticcheck = true,
          },
        },
      })

      -- Configure rust_analyzer with custom settings
      vim.lsp.config("rust_analyzer", {
        capabilities = capabilities,
        settings = {
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
            },
            checkOnSave = {
              command = "clippy",
            },
          },
        },
      })

      -- Configure clangd with custom settings
      vim.lsp.config("clangd", {
        capabilities = capabilities,
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          "--function-arg-placeholders=true",
        },
      })

      -- Configure remaining servers with default settings
      local default_servers = { "ts_ls", "jdtls", "perlnavigator", "ruby_lsp", "intelephense", "marksman" }
      for _, server in ipairs(default_servers) do
        vim.lsp.config(server, {
          capabilities = capabilities,
        })
      end

      -- Enable all configured servers
      vim.lsp.enable({ 
        "lua_ls", 
        "ts_ls", 
        "pyright", 
        "jdtls", 
        "gopls", 
        "rust_analyzer", 
        "clangd",
        "perlnavigator",
        "ruby_lsp",
        "intelephense",
        "marksman",
      })
    end,
  },
}
