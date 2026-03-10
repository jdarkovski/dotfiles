-- Reproducible Mason tools across machines (macOS/Fedora).
-- Package names should match entries from `:Mason`.
---@type LazySpec
return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        -- Shell / Lua
        "bash-language-server",
        "shellcheck",
        "shfmt",
        "lua-language-server",
        "stylua",

        -- Config / docs
        "json-lsp",
        "yaml-language-server",
        "taplo",
        "marksman",

        -- Web / JS / TS
        "typescript-language-server",
        "eslint-lsp",
        "html-lsp",
        "css-lsp",
        "tailwindcss-language-server",

        -- Python
        "pyright",
        "ruff",

        -- Systems / backend
        "clangd",
        "cmake-language-server",
        "rust-analyzer",
        "gopls",
        "jdtls",

        -- Containers
        "dockerfile-language-server",

        -- Utility
        "tree-sitter-cli",
      })
    end,
  },
}
