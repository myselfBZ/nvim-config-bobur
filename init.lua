vim.opt.number = true

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
    {
        "theprimeagen/harpoon"

    }
   
}
local opts = {}
local builtin = require("telescope.builtin")

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



-- On attach function to set key mappings
local on_attach = function(client, bufnr)
    local buf_map = function(bufnr, mode, lhs, rhs, opts)
        opts = vim.tbl_extend('force', {noremap = true, silent = true}, opts or {})
        vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
    end

    -- Mappings for LSP functionality
    buf_map(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
    buf_map(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
    buf_map(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
    buf_map(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
    buf_map(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
    buf_map(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
    buf_map(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')
end






lsp_config.pyright.setup{
    on_attach = on_attach,
    capabilities = capabilities
}
lsp_config.rust_analyzer.setup{

    on_attach = on_attach,
    capabilities = capabilities
}
lsp_config.gopls.setup{

    on_attach = on_attach,
    capabilities = capabilities
}
lsp_config.tsserver.setup{

    on_attach = on_attach,
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
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<C-k>'] = cmp.mapping(function(fallback)
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

local mark = require("harpoon.mark")
local ui = require("harpoon.ui")


--key maps 
vim.keymap.set('n', "<leader>a", mark.add_file)
vim.keymap.set('n', "<C-e>", ui.toggle_quick_menu)
vim.keymap.set('n', "<C-h>",function() ui.nav_file(1) end)
vim.keymap.set('n', "<C-t>",  function() ui.nav_file(2) end)
vim.keymap.set('n', "<C-n>", function() ui.nav_file(3) end)
vim.keymap.set('n', "<C-s>",  function() ui.nav_file(4) end)
vim.keymap.set('n', '<leader>gs', vim.cmd.Git)
vim.keymap.set('n', '<leader>b', "<cmd>q!<CR>")
vim.keymap.set('n', '<leader>w', vim.cmd.wq)

vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<leader>pg', builtin.live_grep, {})
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {})
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.api.nvim_set_keymap('n', '<leader>h', ':nohlsearch<CR>', { noremap = true, silent = true })


-- sets 
vim.opt.relativenumber = true
vim.opt.incsearch = true
vim.opt.scrolloff = 8
vim.opt.updatetime = 50




































