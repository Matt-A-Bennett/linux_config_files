" setup Vundle
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" " alternatively, pass a path where Vundle should install plugins
" " call vundle#begin('~/some/path/here')

" " let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'tpope/vim-sensible'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'
" IGNORANT Plugin 'tpope/vim-fugitive'
Plugin 'jnurmine/Zenburn'
Plugin 'flazz/vim-colorschemes'
Plugin 'vim-scripts/indentpython.vim'
Plugin 'python-rope/ropevim'
Plugin 'davidhalter/jedi-vim'
Plugin 'ycm-core/YouCompleteMe'
Plugin 'vim-scripts/MatlabFilesEdition'
Plugin 'scrooloose/nerdtree'
Plugin 'jpalardy/vim-slime'
Plugin 'SirVer/ultisnips'
" IGNORANT Plugin 'honza/vim-snippets'
" IGNORANT Plugin 'w0rp/ale'
" IGNORANT Plugin 'sheerun/vim-polyglot'
" IGNORANT Plugin 'ludovicchabant/vim-gutentags'
" IGNORANT Plugin 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
" IGNORANT Plugin 'junegunn/fzf.vim'
" IGNORANT Plugin 'vim-airline/vim-airline'
" IGNORANT Plugin 'vim-airline/vim-airline-themes'
" IGNORANT Plugin 'airblade/vim-gitgutter'
" IGNORANT Plugin 'majutsushi/tagbar'

"" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" some things I've collected from online
" I want to override one of the defaults here, so load it now then overwrite
runtime! plugin/sensible.vim
set laststatus=1
set number
" set relativenumber
set nrformats= " don't interpret 007 as an octal (<C-a> will now make 008, not 010)
set encoding=utf-8
set wildmenu " list completion options when typing in command line mode
"set wildmode=longest,list " make it behave like bash autocomplete
set linebreak " wrap long lines at a character in 'breakat' (default " ^I!@*-+;:,./?") rather than at the last character that fits on the screen.
set history=200

set spell spelllang=en_gb
" <Leader>s changes the word to the first suggestion
:nnoremap <Leader>s a<C-X>s<Esc> 

syntax enable " highlight special words to aid readability

:autocmd InsertEnter * set cul " highlight line when in insert mode
:autocmd InsertLeave * set nocul " turn off above when leaving insert mode
let &t_SI = "\e[5 q" " cursor blinking bar on insert mode
let &t_EI = "\e[2 q" " cursor steady block on command mode
" optional reset cursor on start:
augroup myCmds
	au!
	autocmd VimEnter * silent !echo -ne "\e[2 q"
	augroup END

" With both on, searches with no capitals are case insensitive, while searches with a capital characters are case sensitive.
set smartcase
set ignorecase

" where new vim pane splits are positioned
set splitbelow
set splitright

" I was having trouble with my C^hjkl switching (after quiting vim, I couldn't
" switch tmux pane with C^hjkl...). Since I always have a tmux session up and
" the else statement below seems to work in all circumstances, I commnented
" out the if porion. I don't want to remove it straight away though...
" 
" vim split navigations working with tmux (ctrl+h,j,k,l)
if exists('$TMUX')
	function! TmuxOrSplitSwitch(wincmd, tmuxdir)
		let previous_winnr = winnr()
		silent! execute "wincmd " . a:wincmd
		if previous_winnr == winnr()
			call system("tmux select-pane -" . a:tmuxdir)
			redraw!
		endif
	endfunction

	let previous_title = substitute(system("tmux display-message -p '#{pane_title}'"), '\n', '', '')
	let &t_ti = "\<Esc>]2;vim\<Esc>\\" . &t_ti
	let &t_te = "\<Esc>]2;". previous_title . "\<Esc>\\" . &t_te

	nnoremap <silent> <C-h> :call TmuxOrSplitSwitch('h', 'L')<cr>
	nnoremap <silent> <C-j> :call TmuxOrSplitSwitch('j', 'D')<cr>
	nnoremap <silent> <C-k> :call TmuxOrSplitSwitch('k', 'U')<cr>
	nnoremap <silent> <C-l> :call TmuxOrSplitSwitch('l', 'R')<cr>
else
	map <C-h> <C-w>h
	map <C-j> <C-w>j
	map <C-k> <C-w>k
	map <C-l> <C-w>l
endif

" vim-slime lets me send visual selections from vim to a tmux pane of my
" choice. 
let g:slime_target = "tmux"
let g:slime_paste_file = "$HOME/.slime_paste"
" You can set the target manually using hitting C-c and then v.
" ":i.j"    means the ith window, jth pane
" I want the default to be below the vim I'm working in
let g:slime_default_config = {"socket_name": "default", "target_pane": "{down-of}"}
" and not to ask me about it even on the first time I use it 
let g:slime_dont_ask_default = 1
" make F9 a shortcut for sending N lines to the tmux pane
:map <F9> V<C-c><C-c>

" Ultisnips trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<c-s>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
" where ultisnips looks for snippets (I think you can add multiple items in
" the list)
let g:UltiSnipsSnippetDirectories=["/home/mattb/.vim/ultisnips"]

" vim remaps
" add blank lines without entering insert mode (default was to insert)
" nnoremap o o<Esc>
" nnoremap O O<Esc>

" autoclose parentheses - precede with ctrl-v to disable the autoclose (also, I found the auto quote closing annoying so I commented)
" inoremap " ""<left>
" inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>

" copy/paste-on-select (*) and copy/paste-with crtl+C (+) remap to \y \p and \Y \P
noremap <Leader>y "*y
noremap <Leader>p "*p
noremap <Leader>Y "+y
noremap <Leader>P "+p

" Theme options
set t_Co=256
" set background=dark
" colorscheme solarized
colorscheme zenburn

""" Hilight search and set numbers
set incsearch " show matches for patterns while they are being typed
set hlsearch " highlight all matches for searched pattern

" increase the PEP8 max characters
set cc=90

" Airline configuration
" IGNORANT let g:airline#extensions#tabline#enabled = 1
" IGNORANT let g:airline#extensions#tabline#formatter = 'default'

" Nerdtree configuration
map <C-n> :NERDTreeToggle<CR>
let NERDTreeIgnore=['\.pyc$', '\~$']

" close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

" Switching between buffers
" Set commands to switching between buffers
:nnoremap <Tab> :bnext!<CR>
:nnoremap <S-Tab> :bprevious!<CR>
" IGNORANT :nnoremap <C-X> :bp<bar>sp<bar>bn<bar>bd<CR>

" file searchs
" IGNORANT map <c-p> :files<cr>

" ale configuration
"""" better formatting fo worp/ale
" IGNORANT let g:ale_echo_msg_error_str = 'e'
" IGNORANT let g:ale_echo_msg_warning_str = 'w'
" IGNORANT let g:ale_echo_msg_format = '[%linter%] %s [%severity%] [%...code...%]'
"""" Enable completion where available.
" IGNORANT let g:ale_completion_enabled = 1
""" Customize linters that are turned on
" IGNORANT let g:ale_linters = {
	" IGNORANT \   'python': ['flake8'],
	" IGNORANT \}
" IGNORANT let g:ale_set_highlights = 0

" Fix keys
" IGNORANT set backspace=2

" IGNORANT nmap <F8> :TagbarToggle<CR>

" general scripting (I pulled these out from the python PEP8 below)
set tabstop=4
set softtabstop=4
set shiftwidth=4
" set textwidth=79
set expandtab " expand tabs into spaces
set autoindent
set showmatch " show the matching part of the pair for [] {} and ()

" matlab specific
"
" pyhon specific
" add PEP8 indentation
au BufNewFile,BufRead *.py " apparently this will only apply to .py files
	set fileformat=unix " avoid conversion issues when checking into GitHub and/or sharing with other users.
	let python_highlight_all = 1 " enable all Python syntax highlighting features
    
" YouCompleteMe has a few filetypes that it doesn't work on by default (no
" idea why). I removed markdown from this list and it seems to work just fine.
let g:ycm_filetype_blacklist = {
      \ 'tagbar': 1,
      \ 'notes': 1,
      \ 'netrw': 1,
      \ 'unite': 1,
      \ 'text': 1,
      \ 'vimwiki': 1,
      \ 'pandoc': 1,
      \ 'infolog': 1,
      \ 'leaderf': 1,
      \ 'mail': 1
      \}
