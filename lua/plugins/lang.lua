return {
  {
    'greggh/claude-code.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('claude-code').setup()
      vim.keymap.set('n', '<leader>cc', '<cmd>ClaudeCode<CR>', { desc = 'Toggle Claude Code' })
    end,
  },

  {
    'davidmh/mdx.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  },

  {
    'olexsmir/gopher.nvim',
    ft = 'go',
    config = function(_, opts)
      require('gopher').setup(opts)
      vim.keymap.set('n', '<leader>gsj', '<cmd>GoTagAdd json<CR>', { desc = 'Add json struct tags' })
      vim.keymap.set('n', '<leader>gsy', '<cmd>GoTagAdd yaml<CR>', { desc = 'Add yaml struct tags' })
      vim.keymap.set('n', '<leader>ife', '<cmd>GoIfErr<CR>', { desc = 'Add go if error != nil block' })
    end,
    build = function()
      vim.cmd.GoInstallDeps()
    end,
  },
}
