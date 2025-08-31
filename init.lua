vim.g.mapleader = " "

--Basic settings
vim.o.termguicolors = true
vim.o.number = true
vim.o.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.o.splitright = true
vim.o.splitbelow = true

-- Lazy.nvim bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Plugins
require("lazy").setup({

	-- Lualine
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					theme = "catppuccin",
					component_separators = "|",
					section_separators = "",
				},
			})
		end,
	},

	-- Visual Multi
	{
		"mg979/vim-visual-multi",
		branch = "master",
		lazy = false,
	},

	-- Nvim Tree
	{
		"nvim-tree/nvim-tree.lua",
		config = function()
			require("nvim-tree").setup({
				sync_root_with_cwd = true,
				respect_buf_cwd = true,
				update_focused_file = {
					enable = true,
					update_root = true,
				},
				view = {
					side = "right",
					width = 35,
				},
				filters = {
					dotfiles = false,
				},
			})
		end,
	},

	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("telescope").setup({
				defaults = {
					mappings = {
						i = {
							["<C-v>"] = require("telescope.actions").select_vertical,
							["<C-s>"] = require("telescope.actions").select_horizontal,
						},
						n = {
							["<C-v>"] = require("telescope.actions").select_vertical,
							["<C-s>"] = require("telescope.actions").select_horizontal,
						},
					},
				},
			})
		end,
	},

	-- Mason + LSP
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "pyright", "clangd" },
			})

			local lspconfig = require("lspconfig")
			local on_attach = function(_, bufnr)
				local opts = { buffer = bufnr, desc = "" }

				vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename,
					vim.tbl_extend("force", opts, { desc = "Rename Symbol" }))
				vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action,
					vim.tbl_extend("force", opts, { desc = "Code Action" }))
				vim.keymap.set("n", "<leader>m", function()
					vim.lsp.buf.format({ async = true })
				end, vim.tbl_extend("force", opts, { desc = "Format File" }))
				vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition,
					vim.tbl_extend("force", opts, { desc = "Go to definition" }))
			end

			local servers = { "lua_ls", "pyright", "clangd" }
			for _, server in ipairs(servers) do
				lspconfig[server].setup({ on_attach = on_attach })
			end
		end,
	},
	-- Completion
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = {
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				},
			})
		end,
	},

	{
		"echasnovski/mini.icons",
		config = function()
			require("mini.icons").setup()
		end,
	},




	-- Theme
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				transparent_background = true,
				integrations = {
					nvimtree = true,
					treesitter = true,
					cmp = true,
					telescope = true,
					mason = true,
				},
			})
			vim.cmd("colorscheme catppuccin")
		end,
	},
})

-- Transparent background fallback
vim.cmd([[
  highlight Normal guibg=NONE ctermbg=NONE
  highlight NormalNC guibg=NONE ctermbg=NONE
  highlight EndOfBuffer guibg=NONE ctermbg=NONE
]])

-- Nvim-tree keymap override
vim.api.nvim_create_autocmd("FileType", {
	pattern = "NvimTree",
	callback = function()
		local api = require("nvim-tree.api")
		vim.keymap.set("n", "<C-s>", function()
			api.node.open.horizontal()
		end, { buffer = true, noremap = true, silent = true, desc = "Open file horizontally" })
	end,
})

-- Keybindings
vim.keymap.set("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle File Tree" })
vim.keymap.set("n", "<C-f>", function()
	require("telescope.builtin").find_files()
end, { desc = "Telescope Find Files" })
vim.keymap.set("n", "-", "$", { desc = "Go to end of line" })
vim.keymap.set("n", "<leader>f", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "Search in current file" })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr, desc = "Go to implementation" })
vim.keymap.set("n", "gs", "<cmd>ClangdSwitchSourceHeader<CR>", { buffer = bufnr, desc = "Switch source/header" })
vim.keymap.set("n", "gd",vim.lsp.buf.definition , { buffer = bufnr, desc = "Go to definition" })
vim.keymap.set("n", "<leader>c", "zz", { desc = "Center view on cursor" })
vim.keymap.set("v", "-", "$", { desc = "Go to end of line in visual mode" })
vim.keymap.set("v", "_", "^", { desc = "Go to start of line in visual mode" })


-- Expr-style mapping: Toggle insert/normal mode with <Esc>
vim.keymap.set("n", "<Esc>", function()
	return vim.fn.mode() == "i" and "<Esc>" or "i"
end, {
	expr = true,
	desc = "Toggle Insert/Normal",
})
