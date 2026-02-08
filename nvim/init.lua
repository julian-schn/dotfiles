-- ── Options ────────────────────────────────────────
vim.g.mapleader = " " -- space as leader key

local opt = vim.opt

opt.number = true -- line numbers
opt.relativenumber = true -- relative line numbers (great for jumping)
opt.signcolumn = "yes" -- always show sign column (avoids layout shift)

opt.tabstop = 4 -- tab width
opt.shiftwidth = 4 -- indent width
opt.expandtab = true -- spaces instead of tabs
opt.smartindent = true -- auto-indent new lines

opt.wrap = false -- no line wrapping
opt.scrolloff = 8 -- keep 8 lines visible above/below cursor
opt.sidescrolloff = 8 -- keep 8 columns visible left/right

opt.ignorecase = true -- case-insensitive search...
opt.smartcase = true -- ...unless you use capitals

opt.splitright = true -- new vertical splits go right
opt.splitbelow = true -- new horizontal splits go below

opt.undofile = true -- persistent undo across sessions
opt.swapfile = false -- no swap files (git handles recovery)

opt.termguicolors = true -- true color support
opt.background = "light" -- light mode, obviously

opt.clipboard = "unnamedplus" -- use system clipboard
opt.mouse = "a" -- mouse support (no shame in that)

opt.updatetime = 250 -- faster CursorHold events
opt.timeoutlen = 300 -- faster key sequence completion

-- ── Keymaps ────────────────────────────────────────
local map = vim.keymap.set

-- Clear search highlighting with Escape
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Move between splits with Ctrl + hjkl
map("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to split below" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to split above" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })

-- Move selected lines up/down in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Keep cursor centered when scrolling
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- Quick save
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })

-- ── Plugin Manager (lazy.nvim) ─────────────────────
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- ── Plugins ────────────────────────────────────────
require("lazy").setup({
    -- Colorscheme: catppuccin latte — pastel light theme
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        priority = 1000,
        config = function()
            require("catppuccin").setup({ flavour = "latte" })
            vim.cmd.colorscheme("catppuccin")
        end,
    },

    -- Treesitter: better syntax highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter").setup()
            vim.treesitter.language.register("bash", "zsh")
        end,
    },

    -- Telescope: fuzzy finder (uses your ripgrep + fd)
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
            { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Grep in files" },
            { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Open buffers" },
            { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help tags" },
        },
    },

    -- Mini.statusline: lightweight status bar
    {
        "echasnovski/mini.statusline",
        version = false,
        config = function()
            require("mini.statusline").setup()
        end,
    },

    -- Mini.pairs: auto-close brackets, quotes
    {
        "echasnovski/mini.pairs",
        version = false,
        event = "InsertEnter",
        config = function()
            require("mini.pairs").setup()
        end,
    },
}, {
    -- lazy.nvim UI settings
    ui = { border = "rounded" },
    checker = { enabled = false }, -- don't auto-check for plugin updates
})
