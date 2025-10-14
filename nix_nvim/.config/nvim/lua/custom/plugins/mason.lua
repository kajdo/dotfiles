-- lua/custom/plugins/mason.lua

-- Define the default state for mason (disabled for NixOS)
local is_mason_enabled = false

-- Use a global variable check to override the default state
-- This global variable will be set in your main config file (init.lua)
if vim.g.enable_mason_on_wsl == true then
	is_mason_enabled = true
end

return {
	"williamboman/mason.nvim",
	-- Dynamically set 'enabled' based on the check above
	enabled = is_mason_enabled,

	-- Configuration for mason (will only run if enabled = true)
	config = function()
		require("mason").setup({
			-- Your mason configuration here
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
			log_level = vim.log.levels.INFO,
			max_concurrent_installers = 4,
		})
	end,

	-- -- If you use mason-lspconfig, you'd include it here
	-- {
	-- 	"williamboman/mason-lspconfig.nvim",
	-- 	enabled = is_mason_enabled,
	-- 	dependencies = { "williamboman/mason.nvim" },
	-- 	config = function()
	-- 		require("mason-lspconfig").setup({
	-- 			-- Your mason-lspconfig configuration here (e.g., auto-install)
	-- 			automatic_installation = true,
	-- 		})
	-- 	end,
	-- },
}
