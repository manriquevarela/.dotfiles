-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- Disable Swap Files
vim.opt.swapfile = false

-- Enable Persistent Undo (Undotree)
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath('state') .. '/undo'
