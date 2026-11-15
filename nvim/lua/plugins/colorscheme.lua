return {
  -- lush builds the danqing colorscheme (colors/danqing.lua); load it before anything paints.
  { "rktjmp/lush.nvim", lazy = false, priority = 1000 },
  { "LazyVim/LazyVim", opts = { colorscheme = "danqing" } },
}
