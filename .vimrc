" Disable compatibility mode. We want VI iMproved, not VI!
set nocompatible

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sane text files
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set fileformat=unix
set encoding=utf-8

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Tabs
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set tabstop=4
set shiftwidth=4
set softtabstop=4

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Search
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Start searching when first character is typed (vs. after string is entered)
set incsearch
" Turn on search highlighting
set hlsearch

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Auto Completion
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable command line completion with <Tab> (for example, try `:color <Tab>`)
set wildmenu
" First tab completes to longest string and shows the the match list, then second tab completes to first full match and opens the wildmenu
set wildmode=longest:list,full

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remap Keys
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Remap ESC to ii
:imap ii <Esc>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" lightline (https://github.com/itchyny/lightline.vim)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set status line colorscheme (*before* editor colorscheme)
let g:lightline = {
      \ 'colorscheme': 'onedark',
      \ }

" Always display status line
set laststatus=2

" Use 256 colors (use this setting only if your terminal supports 256 colors)
set t_Co=256

" Hide '-- INSERT --' as mode information is already handled by lightline
set noshowmode

" Show relative line numbers
set number relativenumber

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Editor Clorscheme
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
packadd onedark " https://github.com/joshdick/onedark.vim
syntax enable
set background=dark
colorscheme onedark

"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

