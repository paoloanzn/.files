" Enable syntax highligh.
syntax on

" Set theme.
colorscheme habamax

" TAB configuration.
set tabstop=2
set expandtab

" Set 2 column for `>>` and `<<` commands.
set shiftwidth=2

" Enable Auto indent.
set ai

" Enable position relative line numbers.
set number
set ruler

" Enable mouse support.
set mouse=a

" Choose regexp engine automatically.
" NOTE: If not set to `0` (means `choose the engine automaticially`) Typescript syntax highlighting may crash the editor.
set regexpengine=0

" Override comments's color.
" Sets the foreground color of syntax-highlighted comments to green in terminals using the cterm color interface.
highlight Comment ctermfg=green

" Custom commands.
" Macos clipboard support.
if has('mac')
  command! Paste r !pbpaste
  command! -range=% Copy <line1>,<line2>w !pbcopy

  nnoremap +p :r !pbpaste<CR>
  vnoremap +c :w !pbcopy<CR>
endif




