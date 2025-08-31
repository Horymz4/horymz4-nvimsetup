return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lsp",
    config = function()
      require "configs.lsp"
    end,
  },
{
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("nvim-tree").setup({
		{
  "nvim-tree/nvim-tree.lua",
  config = function()
    require("nvim-tree").setup({
      view = {
        side = "right",
        width = 35,
      },
      filters = {
        dotfiles = false,
      },
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "NvimTree",
      callback = function()
        vim.api.nvim_buf_set_keymap(0, "n", "<C-s>", ":lua require'nvim-tree.api'.node.open.horizontal()<CR>", { noremap = true, silent = true })
      end,
    })
  end,
},



	  })
    end,
  },
   
 {
  "windwp/nvim-autopairs",
  enabled = false,      

 },


  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },

  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
}
