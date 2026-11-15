-- :colorscheme danqing — the spec lives in lua/lush_theme/danqing.lua
vim.opt.background = "light"
vim.g.colors_name = "danqing"
package.loaded["lush_theme.danqing"] = nil -- pick up edits on re-source
require("lush")(require("lush_theme.danqing"))
