vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4

vim.opt.shiftwidth = 4

vim.opt.expandtab = true

vim.opt.smartindent = true
vim.g.mapleader = " "
vim.opt.autoindent = true

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
local plugins = {
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.6',
        -- or                              , branch = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", 
            "MunifTanjim/nui.nvim",
        }
    },
    {
        "williamboman/mason.nvim"
    },
    {
        "williamboman/mason-lspconfig.nvim"
    },
    {
        "neovim/nvim-lspconfig"
    },
    {
        'nvim-telescope/telescope-ui-select.nvim'
    },
    {
        'hrsh7th/nvim-cmp'
    },
    {
        'L3MON4D3/LuaSnip'
    },
    {
        'saadparwaiz1/cmp_luasnip'
    },
    {
        'luasnip.loaders.from_vscode'
    },
    {
        'rafamadriz/friendly-snippets'
    },
    {
        'hrsh7th/cmp-nvim-lsp'                                                                                                           
    },
    {
        'tpope/vim-fugitive'
    },
   
}
local opts = {}
local builtin = require("telescope.builtin")

function ToggleNeotree()
    local neotree_open = vim.g.neotree_open or 0
    if neotree_open == 1 then
        vim.cmd('Neotree close')
        vim.g.neotree_open = 0
    else
        vim.cmd('Neotree filesystem reveal left')
        vim.g.neotree_open = 1
    end
end
-- This is your opts table

local config = require("nvim-treesitter.configs")
config.setup({
    ensure_installed = { "lua", "go", "javascript", "python", "rust"},
    highlight = { enable = true },
    indent = { enable = true },  
})
require("lazy").setup(plugins, opts)
require("catppuccin").setup()
require("mason").setup()
require("mason-lspconfig").setup{
    ensure_installed = {
        "rust_analyzer",  -- Rust
        "tsserver",       -- JavaScript
        "pyright",        -- Python

    }
}

vim.cmd("colorscheme catppuccin")

local lsp_config = require("lspconfig")
local capabilities = require('cmp_nvim_lsp').default_capabilities()
lsp_config.pyright.setup{
    capabilities = capabilities
}
lsp_config.rust_analyzer.setup{

    capabilities = capabilities
}
lsp_config.gopls.setup{

    capabilities = capabilities
}
lsp_config.tsserver.setup{

    capabilities = capabilities
}

-- This is your opts table
require("telescope").setup {
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {
      }

    }
  }
}
require("telescope").load_extension("ui-select")

local cmp = require'cmp'
require("luasnip.loaders.from_vscode").lazy_load()
cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<C-n>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    }, {
        { name = 'buffer' },
    })
})
vim.g.ale_linters = {
    rust = {'cargo', 'rls', 'rustc'}
}
require("neo-tree").setup()

--key maps 
vim.keymap.set('n', '<leader>gs', vim.cmd.Git)
vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<leader>pg', builtin.live_grep, {})
vim.keymap.set('n', '<C-n>', ':lua ToggleNeotree()<CR>',{noremap = true, silent = true})
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {})
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.api.nvim_set_keymap('n', '<leader>h', ':nohlsearch<CR>', { noremap = true, silent = true })



























-- sets 
vim.opt.incsearch = true
vim.opt.termguicolors= true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 50
vim.opt.colorcolumn = "80"
vim.api.nvim_set_hl(0, "Normal", {bg="none"})
vim.api.nvim_set_hl(0, "NormalFloat", {bg="none"})











