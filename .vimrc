" All copied from different sources in internet. Feel free to copy and use.

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Identify platform {
    silent function! OSX()
        return has('macunix')
    endfunction
    silent function! LINUX()
        return has('unix') && !has('macunix') && !has('win32unix')
    endfunction
    silent function! WINDOWS()
        return  (has('win16') || has('win32') || has('win64'))
    endfunction
" }

" Windows Compatible {
	" On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
	" across (heterogeneous) systems easier.
	if WINDOWS()
	  set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
	endif	
    source $VIMRUNTIME/mswin.vim
    behave mswin
" }

" Vundle Configuration {
	filetype off                  " required for vundle

	" set the runtime path to include Vundle and initialize
	set rtp+=~/.vim/bundle/Vundle.vim
	call vundle#begin()
	
	" let Vundle manage Vundle, required
	Plugin 'VundleVim/Vundle.vim'

	Plugin 'scrooloose/nerdtree'
	Plugin 'bling/vim-airline'
	Plugin 'altercation/vim-colors-solarized'
	Plugin 'ctrlpvim/ctrlp.vim'
	Plugin 'bling/vim-bufferline'

	" All of your Plugins must be added before the following line
	call vundle#end()            " required for vundle
	filetype plugin indent on    " required for vundle
" }



" General {
	" No annoying sound on errors
	set noerrorbells visualbell t_vb=
	if has('autocmd')
		autocmd GUIEnter * set visualbell t_vb=
	endif

	set background=dark         " Assume a dark background

    " Allow to trigger background
    function! ToggleBG()
        let s:tbg = &background
        " Inversion
        if s:tbg == "dark"
            set background=light
        else
            set background=dark
        endif
    endfunction
    noremap <leader>bg :call ToggleBG()<CR>

    filetype plugin indent on   " Automatically detect file types.
    syntax on                   " Syntax highlighting
    set mouse=a                 " Automatically enable mouse usage
    set mousehide               " Hide the mouse cursor while typing
    scriptencoding utf-8

    if has('clipboard')
        if has('unnamedplus')  " When possible use + register for copy-paste
            set clipboard=unnamed,unnamedplus
        else         " On mac and Windows, use * register for copy-paste
            set clipboard=unnamed
        endif
    endif

    " Automatically switch to the current file directory when a new buffer is opened; 
    autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif

    "set autowrite                       " Automatically write a file when leaving a modified buffer
    set shortmess+=filmnrxoOtT          " Abbrev. of messages (avoids 'hit enter')
    set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
    set virtualedit=onemore             " Allow for cursor beyond last character
    set history=1000                    " Store a ton of history (default is 20)
    set spell                           " Spell checking on
    set hidden                          " Allow buffer switching without saving
    set iskeyword-=.                    " '.' is an end of word designator
    set iskeyword-=#                    " '#' is an end of word designator
    set iskeyword-=-                    " '-' is an end of word designator

    " Instead of reverting the cursor to the last position in the buffer, we
    " set it to the first line when editing a git commit message
    au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

    " http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
    " Restore cursor to file position in previous editing session
	function! ResCur()
		if line("'\"") <= line("$")
			normal! g`"
			return 1
		endif
	endfunction

	augroup resCur
		autocmd!
		autocmd BufWinEnter * call ResCur()
	augroup END

    " Setting up the directories {
        set backup                  " Backups are nice ...
        if has('persistent_undo')
            set undofile                " So is persistent undo ...
            set undolevels=1000         " Maximum number of changes that can be undone
            set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
        endif
	" }
" }


" Vim UI {
	
	" Use dark solarized scheme
	let g:solarized_termcolors=256
	let g:solarized_termtrans=1
	let g:solarized_contrast="normal"
	let g:solarized_visibility="normal"
	color solarized             " Load a colorscheme

    set tabpagemax=15               " Only show 15 tabs
    set showmode                    " Display the current mode

    set cursorline                  " Highlight current line

    highlight clear SignColumn      " SignColumn should match background
    highlight clear LineNr          " Current line number row will have same background color in relative mode
    "highlight clear CursorLineNr    " Remove highlight color from current line number

    if has('cmdline_info')
        set ruler                   " Show the ruler
        set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
        set showcmd                 " Show partial commands in status line and
                                    " Selected characters/lines in visual mode
    endif

    if has('statusline')
        set laststatus=2

        " Broken down into easily includeable segments
        set statusline=%<%f\                     " Filename
        set statusline+=%w%h%m%r                 " Options
        if !exists('g:override_spf13_bundles')
            set statusline+=%{fugitive#statusline()} " Git Hotness
        endif
        set statusline+=\ [%{&ff}/%Y]            " Filetype
        set statusline+=\ [%{getcwd()}]          " Current dir
        set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
    endif

    set backspace=indent,eol,start  " Backspace for dummies
    set linespace=0                 " No extra spaces between rows
    set number                      " Line numbers on
    set showmatch                   " Show matching brackets/parenthesis
    set incsearch                   " Find as you type search
    set hlsearch                    " Highlight search terms
    set winminheight=0              " Windows can be 0 line high
    set ignorecase                  " Case insensitive search
    set smartcase                   " Case sensitive when uc present
    set wildmenu                    " Show list instead of just completing
    set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
    set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
    set scrolljump=5                " Lines to scroll when cursor leaves screen
    set scrolloff=3                 " Minimum lines to keep above and below cursor
    set list
    set listchars=tab:¿\ ,trail:¿,extends:#,nbsp:. " Highlight problematic whitespace
" }

" Formatting {

    set nowrap                      " Do not wrap long lines
    set autoindent                  " Indent at the same level of the previous line
    set shiftwidth=4                " Use indents of 4 spaces
    set expandtab                   " Tabs are spaces, not tabs
    set tabstop=4                   " An indentation every four columns
    set softtabstop=4               " Let backspace delete indent
    set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
    set splitright                  " Puts new vsplit windows to the right of the current
    set splitbelow                  " Puts new split windows to the bottom of the current
    "set matchpairs+=<:>             " Match, to be used with %
    set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)
    "set comments=sl:/*,mb:*,elx:*/  " auto format comment blocks
    " Remove trailing whitespaces and ^M chars
    autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,perl,sql autocmd BufWritePre <buffer> call StripTrailingWhitespace() 
    "autocmd FileType go autocmd BufWritePre <buffer> Fmt
    autocmd BufNewFile,BufRead *.html.twig set filetype=html.twig
    autocmd FileType haskell,puppet,ruby,yml setlocal expandtab shiftwidth=2 softtabstop=2
	autocmd FileType html,javascript setlocal expandtab shiftwidth=2 softtabstop=2
	autocmd FileType html,javascript setlocal expandtab shiftwidth=2 softtabstop=2


" }

" Key (re)Mappings {

    let mapleader = ','

	" Easier moving in tabs and windows
	map <C-J> <C-W>j<C-W>_
	map <C-K> <C-W>k<C-W>_
	map <C-L> <C-W>l<C-W>_
	map <C-H> <C-W>h<C-W>_
	
	" Wrapped lines goes down/up to next row, rather than next line in file.
    noremap j gj
    noremap k gk
	
	" Cycle through buffers
	nnoremap <C-Tab> :bnext<CR>
	nnoremap <C-S-Tab> :bprevious<CR>
	
" }


" Plugin Configuration {
	" NerdTree {
        if isdirectory(expand("~/.vim/bundle/nerdtree"))
            map <C-e> <plug>NERDTreeTabsToggle<CR>
            map <leader>e :NERDTreeFind<CR>
            nmap <leader>nt :NERDTreeFind<CR>

            let NERDTreeShowBookmarks=1
            let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
            let NERDTreeChDirMode=0
            let NERDTreeQuitOnOpen=0
            let NERDTreeMouseMode=2
            let NERDTreeShowHidden=1
            let NERDTreeKeepTreeInNewTab=1
			let g:nerdtree_tabs_open_on_gui_startup=0
			" Close NerdTree if that is the only window present
			autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif			
        endif
    " }
	
	" ctrlp {
        if isdirectory(expand("~/.vim/bundle/ctrlp.vim/"))
            let g:ctrlp_working_path_mode = 'ra'
            nnoremap <silent> <D-t> :CtrlP<CR>
            nnoremap <silent> <D-r> :CtrlPMRU<CR>
            let g:ctrlp_custom_ignore = {
                \ 'dir':  '\.git$\|\.hg$\|\.svn$',
                \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$' }

            if executable('ag')
                let s:ctrlp_fallback = 'ag %s --nocolor -l -g ""'
            elseif executable('ack-grep')
                let s:ctrlp_fallback = 'ack-grep %s --nocolor -f'
            elseif executable('ack')
                let s:ctrlp_fallback = 'ack %s --nocolor -f'
            " On Windows use "dir" as fallback command.
            elseif WINDOWS()
                let s:ctrlp_fallback = 'dir %s /-n /b /s /a-d'
            else
                let s:ctrlp_fallback = 'find %s -type f'
            endif
            if exists("g:ctrlp_user_command")
                unlet g:ctrlp_user_command
            endif
            let g:ctrlp_user_command = {
                \ 'types': {
                    \ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
                    \ 2: ['.hg', 'hg --cwd %s locate -I .'],
                \ },
                \ 'fallback': s:ctrlp_fallback
            \ }            
        endif
    "}
	
	" vim-airline {
        " Set configuration options for the statusline plugin vim-airline.
        " Use the powerline theme and optionally enable powerline symbols.
        " To use the symbols ?, ?, ?, ?, ?, ?, and ?.in the statusline
        " segments add the following to your .vimrc.before.local file:
        "   let g:airline_powerline_fonts=1
        " If the previous symbols do not render for you then install a
        " powerline enabled font.

        " See `:echo g:airline_theme_map` for some more choices
        " Default in terminal vim is 'dark'
		if !exists('g:airline_theme')
			let g:airline_theme = 'solarized'
		endif
		if !exists('g:airline_powerline_fonts')
			" Use the default set of separators with a few customizations
			let g:airline_left_sep='›'  " Slightly fancier than '>'
			let g:airline_right_sep='‹' " Slightly fancier than '<'
		endif
    " }

" }




" Functions {

    " Initialize directories {
		function! InitializeDirectories()
			let parent = $HOME
			let prefix = 'vim'
			let dir_list = {
						\ 'backup': 'backupdir',
						\ 'views': 'viewdir',
						\ 'swap': 'directory' }

			if has('persistent_undo')
				let dir_list['undo'] = 'undodir'
			endif

			let g:consolidated_directory = $HOME . '/.vim/.tmp/'
			let common_dir = g:consolidated_directory . prefix
			
			for [dirname, settingname] in items(dir_list)
				let directory = common_dir . dirname . '/'
				if exists("*mkdir")
					if !isdirectory(directory)
						call mkdir(directory)
					endif
				endif
				if !isdirectory(directory)
					echo "Warning: Unable to create backup directory: " . directory
					echo "Try: mkdir -p " . directory
				else
					let directory = substitute(directory, " ", "\\\\ ", "g")
					exec "set " . settingname . "=" . directory
				endif
			endfor
		endfunction
		call InitializeDirectories()
    " }

    " Initialize NERDTree as needed {
		function! NERDTreeInitAsNeeded()
			redir => bufoutput
			buffers!
			redir END
			let idx = stridx(bufoutput, "NERD_tree")
			if idx > -1
				NERDTreeMirror
				NERDTreeFind
				wincmd l
			endif
		endfunction
    " }

    " Strip whitespace {
		function! StripTrailingWhitespace()
			" Preparation: save last search, and cursor position.
			let _s=@/
			let l = line(".")
			let c = col(".")
			" do the business:
			%s/\s\+$//e
			" clean up: restore previous search history, and cursor position
			let @/=_s
			call cursor(l, c)
		endfunction
    " }

    " Shell command {
		function! s:RunShellCommand(cmdline)
			botright new

			setlocal buftype=nofile
			setlocal bufhidden=delete
			setlocal nobuflisted
			setlocal noswapfile
			setlocal nowrap
			setlocal filetype=shell
			setlocal syntax=shell

			call setline(1, a:cmdline)
			call setline(2, substitute(a:cmdline, '.', '=', 'g'))
			execute 'silent $read !' . escape(a:cmdline, '%#')
			setlocal nomodifiable
			1
		endfunction

		command! -complete=file -nargs=+ Shell call s:RunShellCommand(<q-args>)
		" e.g. Grep current file for <search_term>: Shell grep -Hn <search_term> %
    " }
     
    function! s:ExpandFilenameAndExecute(command, file)
        execute a:command . " " . expand(a:file, ":p")
    endfunction
     
    

" }

" Use source code pro {
    " Set font according to system
    if !exists("g:spf13_no_big_font")
        if LINUX() && has("gui_running")
            set guifont=Source\ Code\ Pro\ 11,Andale\ Mono\ Regular\ 12,Menlo\ Regular\ 11,Consolas\ Regular\ 12,Courier\ New\ Regular\ 14
        elseif OSX() && has("gui_running")
            set guifont=Source\ Code\ Pro:h15,Andale\ Mono\ Regular:h12,Menlo\ Regular:h11,Consolas\ Regular:h12,Courier\ New\ Regular:h14
        elseif WINDOWS() && has("gui_running")
            set guifont=Source_Code_Pro:h10,Andale_Mono:h10,Menlo:h10,Consolas:h10,Courier_New:h10
        endif
    endif
" }

" Maximize Vim on start {
    if has("gui_running")
      " GUI is running or is about to start.
      " Maximize gvim window (for an alternative on Windows, see simalt below).
      if has("win16") || has("win32")
        au GUIEnter * simalt ~x
      elseif has("linux")
        set lines=999 columns=999
      endif
    endif
" }



