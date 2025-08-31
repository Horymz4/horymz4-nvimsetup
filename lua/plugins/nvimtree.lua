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
}
