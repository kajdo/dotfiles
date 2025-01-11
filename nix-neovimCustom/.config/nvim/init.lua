-- Example: Configure LSP servers to use Nix-installed binaries
local lspconfig = require("lspconfig")

lspconfig.tsserver.setup({
  cmd = { "typescript-language-server", "--stdio" },
})

lspconfig.rust_analyzer.setup({
  cmd = { "rust-analyzer" },
})

lspconfig.clangd.setup({
  cmd = { "clangd" },
})

lspconfig.pylsp.setup({
  cmd = { "pylsp" },
})

-- Add more LSP configurations here
