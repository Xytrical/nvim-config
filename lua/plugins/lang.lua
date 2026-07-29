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
  {
    'anurag3301/nvim-platformio.lua',
    cond = function()
      -- local platformioRootDir = vim.fs.root(vim.fn.getcwd(), { 'platformio.ini' }) -- cwd and parents
      local platformioRootDir = (vim.fn.filereadable 'platformio.ini' == 1) and vim.fn.getcwd() or nil
      if platformioRootDir then
        -- if platformio.ini file exist in cwd, enable plugin to install plugin (if not istalled) and load it.
        vim.g.platformioRootDir = platformioRootDir
      elseif (vim.uv or vim.loop).fs_stat(vim.fn.stdpath 'data' .. '/lazy/nvim-platformio.lua') == nil then
        -- if nvim-platformio not installed, enable plugin to install it first time
        vim.g.platformioRootDir = vim.fn.getcwd()
      else -- if nvim-platformio.lua installed but disabled, create Pioinit command
        vim.api.nvim_create_user_command('Pioinit', function() --available only if no platformio.ini and .pio in cwd
          vim.api.nvim_create_autocmd('User', {
            pattern = { 'LazyRestore', 'LazyLoad' },
            once = true,
            callback = function(args)
              if args.match == 'LazyRestore' then
                require('lazy').load { plugins = { 'nvim-platformio.lua' } }
              elseif args.match == 'LazyLoad' then
                local pio_install_status = require('platformio.utils').pio_install_check()
                if not pio_install_status then
                  return
                end
                vim.notify('PlatformIO loaded', vim.log.levels.INFO, { title = 'PlatformIO' })
                require('platformio').setup(vim.g.pioConfig)
                vim.cmd 'Pioinit'
              end
            end,
          })
          vim.g.platformioRootDir = vim.fn.getcwd()
          require('lazy').restore { plguins = { 'nvim-platformio.lua' }, show = false }
        end, {})
      end
      return vim.g.platformioRootDir ~= nil
    end,
    dependencies = {
      { 'akinsho/toggleterm.nvim' },
      { 'nvim-telescope/telescope.nvim' },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-lua/plenary.nvim' },
      { 'folke/which-key.nvim' },
      { 'nvim-treesitter/nvim-treesitter' },
    },
    config = function()
      require('platformio').setup {
        lsp = 'clangd',
        clangd_source = 'compiledb',
        menu_key = '<leader>\\',
      }
    end,
  },
}
