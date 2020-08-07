" Modeline and Notes {
" vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={,} foldlevel=0 foldmethod=marker spell:
"
"iasdfafafd:
"                    __ _ _____              _
"         ___ _ __  / _/ |___ /      __   __(_)_ __ ___
"        / __| '_ \| |_| | |_ \ _____\ \ / /| | '_ ` _ \
"        \__ \ |_) |  _| |___) |_____|\ V / | | | | | | |
"        |___/ .__/|_| |_|____/        \_/  |_|_| |_| |_|
"            |_|
"
"   This is the personal .vimrc file of Steve Francia.
"   While much of it is beneficial for general use, I would
"   recommend picking out the parts you want and understand.
"
"   You can find me at http://spf13.com
"
"   Copyright 2014 Steve Francia
"
"   Licensed under the Apache License, Version 2.0 (the "License");
"   you may not use this file except in compliance with the License.
"   You may obtain a copy of the License at
"
"       http://www.apache.org/licenses/LICENSE-2.0
"
"   Unless required by applicable law or agreed to in writing, software
"   distributed under the License is distributed on an "AS IS" BASIS,
"   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
"   See the License for the specific language governing permissions and
"   limitations under the License.
" }

" Environment {
    " kuroi, gruvbox, solarized, default
    let g:colorscheme="solarized"
    let g:background="light"
    " ctags, gtags
    let g:tag_cscope="ctags"
" }

" Use plugs config {
    if filereadable(expand("~/.vimrc.plugs"))
        source ~/.vimrc.plugs
    endif
" }

" General {

"    set background=dark         " Assume a dark background

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

    " if !has('gui')
        "set term=$TERM          " Make arrow and other keys work
    " endif
    filetype plugin indent on   " Automatically detect file types.
    syntax on                   " Syntax highlighting
    set mouse=a                 " Automatically enable mouse usage
    set mousehide               " Hide the mouse cursor while typing
    scriptencoding utf-8
    set encoding=utf-8
    set termencoding=utf-8
    set fileencodings=utf-8,gbk,latinl

    if has('clipboard')
        if has('unnamedplus')  " When possible use + register for copy-paste
            set clipboard=unnamed,unnamedplus
        else         " On mac and Windows, use * register for copy-paste
            set clipboard=unnamed
        endif
    endif

    " Most prefer to automatically switch to the current file directory when
    " a new buffer is opened; to prevent this behavior, add the following to
    " your .vimrc.before.local file:
    "   let g:spf13_no_autochdir = 1
    if !exists('g:spf13_no_autochdir')
        autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif
        " Always switch to the current file directory
    endif

    "set autowrite                       " Automatically write a file when leaving a modified buffer
    set shortmess+=filmnrxoOtT          " Abbrev. of messages (avoids 'hit enter')
    set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
    set virtualedit=onemore             " Allow for cursor beyond last character
    set history=1000                    " Store a ton of history (default is 20)
    set nospell                           " Spell checking on
    set hidden                          " Allow buffer switching without saving
    set iskeyword-=.                    " '.' is an end of word designator
    set iskeyword-=#                    " '#' is an end of word designator
    set iskeyword-=-                    " '-' is an end of word designator

    " Instead of reverting the cursor to the last position in the buffer, we
    " set it to the first line when editing a git commit message
    au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

    " http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
    " Restore cursor to file position in previous editing session
    " To disable this, add the following to your .vimrc.before.local file:
    "   let g:spf13_no_restore_cursor = 1
    if !exists('g:spf13_no_restore_cursor')
        function! ResCur()
            if line("'\"") <= line("$")
                silent! normal! g`"
                return 1
            endif
        endfunction

        augroup resCur
            autocmd!
            autocmd BufWinEnter * call ResCur()
        augroup END
    endif

    " Setting up the directories {
        set backup                  " Backups are nice ...
        if has('persistent_undo')
            set undofile                " So is persistent undo ...
            set undolevels=1000         " Maximum number of changes that can be undone
            set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
        endif

        " To disable views add the following to your .vimrc.before.local file:
        "   let g:spf13_no_views = 1
        if !exists('g:spf13_no_views')
            " Add exclusions to mkview and loadview
            " eg: *.*, svn-commit.tmp
            let g:skipview_files = [
                \ '\[example pattern\]'
                \ ]
        endif
    " }

" }

" Vim UI {
"    set t_Co=256
"    set termguicolors
    function! SetDefaultColorscheme()
        if filereadable(expand("~/.vim/plugged/vim-colors-solarized/colors/solarized.vim"))
            let g:solarized_termcolors=256
            let g:solarized_termtrans=0
            let g:solarized_contrast="normal"
            let g:solarized_visibility="normal"
            color solarized             " Load a colorscheme
        else
            color default
        endif
    endfunction

    if g:background ==? "light"
        set background=light
    else
        set background=dark
    endif

    if g:colorscheme ==? "kuroi"
        if filereadable(expand("~/.vim/plugged/kuroi.vim/colors/kuroi.vim"))
            color kuroi
        else
            call SetDefaultColorscheme()
        endif
    elseif g:colorscheme ==? "gruvbox"
        if filereadable(expand("~/.vim/plugged/gruvbox/colors/gruvbox.vim"))
            color gruvbox
        else
            call SetDefaultColorscheme()
        endif
    else
        call SetDefaultColorscheme()
    endif

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
    set foldenable                  " Auto fold code
    set list
    set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace

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
    " To disable the stripping of whitespace, add the following to your
    " .vimrc.before.local file:
    let g:spf13_keep_trailing_whitespace = 1
    autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,perl,sql autocmd BufWritePre <buffer> if !exists('g:spf13_keep_trailing_whitespace') | call StripTrailingWhitespace() | endif
    "autocmd FileType go autocmd BufWritePre <buffer> Fmt
    autocmd BufNewFile,BufRead *.html.twig set filetype=html.twig
    autocmd FileType haskell,puppet,ruby,yml setlocal expandtab shiftwidth=2 softtabstop=2
    " preceding line best in a plugin but here for now.

    autocmd BufNewFile,BufRead *.coffee set filetype=coffee

    " Workaround vim-commentary for Haskell
    autocmd FileType haskell setlocal commentstring=--\ %s
    " Workaround broken colour highlighting in Haskell
    autocmd FileType haskell,rust setlocal nospell

" }

" Key (re)Mappings {

    " The default leader is '\', but many people prefer ',' as it's in a standard
    " location. To override this behavior and set it back to '\' (or any other
    " character) add the following to your .vimrc.before.local file:
    "   let g:spf13_leader='\'
    if !exists('g:spf13_leader')
        let mapleader = ','
    else
        let mapleader=g:spf13_leader
    endif
    if !exists('g:spf13_localleader')
        let maplocalleader = '_'
    else
        let maplocalleader=g:spf13_localleader
    endif

    " The default mappings for editing and applying the spf13 configuration
    " are <leader>ev and <leader>sv respectively. Change them to your preference
    " by adding the following to your .vimrc.before.local file:
    "   let g:spf13_edit_config_mapping='<leader>ec'
    "   let g:spf13_apply_config_mapping='<leader>sc'
    if !exists('g:spf13_edit_config_mapping')
        let s:spf13_edit_config_mapping = '<leader>ev'
    else
        let s:spf13_edit_config_mapping = g:spf13_edit_config_mapping
    endif
    if !exists('g:spf13_apply_config_mapping')
        let s:spf13_apply_config_mapping = '<leader>sv'
    else
        let s:spf13_apply_config_mapping = g:spf13_apply_config_mapping
    endif

    " Easier moving in tabs and windows
    " The lines conflict with the default digraph mapping of <C-K>
    " If you prefer that functionality, add the following to your
    " .vimrc.before.local file:
    "   let g:spf13_no_easyWindows = 1
    if !exists('g:spf13_no_easyWindows')
        map <C-J> <C-W>j<C-W>_
        map <C-K> <C-W>k<C-W>_
        map <C-L> <C-W>l<C-W>_
        map <C-H> <C-W>h<C-W>_
    endif

    " Wrapped lines goes down/up to next row, rather than next line in file.
    noremap j gj
    noremap k gk

    " End/Start of line motion keys act relative to row/wrap width in the
    " presence of `:set wrap`, and relative to line for `:set nowrap`.
    " Default vim behaviour is to act relative to text line in both cases
    " If you prefer the default behaviour, add the following to your
    " .vimrc.before.local file:
    "   let g:spf13_no_wrapRelMotion = 1
    if !exists('g:spf13_no_wrapRelMotion')
        " Same for 0, home, end, etc
        function! WrapRelativeMotion(key, ...)
            let vis_sel=""
            if a:0
                let vis_sel="gv"
            endif
            if &wrap
                execute "normal!" vis_sel . "g" . a:key
            else
                execute "normal!" vis_sel . a:key
            endif
        endfunction

        " Map g* keys in Normal, Operator-pending, and Visual+select
        noremap $ :call WrapRelativeMotion("$")<CR>
        noremap <End> :call WrapRelativeMotion("$")<CR>
        noremap 0 :call WrapRelativeMotion("0")<CR>
        noremap <Home> :call WrapRelativeMotion("0")<CR>
        noremap ^ :call WrapRelativeMotion("^")<CR>
        " Overwrite the operator pending $/<End> mappings from above
        " to force inclusive motion with :execute normal!
        onoremap $ v:call WrapRelativeMotion("$")<CR>
        onoremap <End> v:call WrapRelativeMotion("$")<CR>
        " Overwrite the Visual+select mode mappings from above
        " to ensure the correct vis_sel flag is passed to function
        vnoremap $ :<C-U>call WrapRelativeMotion("$", 1)<CR>
        vnoremap <End> :<C-U>call WrapRelativeMotion("$", 1)<CR>
        vnoremap 0 :<C-U>call WrapRelativeMotion("0", 1)<CR>
        vnoremap <Home> :<C-U>call WrapRelativeMotion("0", 1)<CR>
        vnoremap ^ :<C-U>call WrapRelativeMotion("^", 1)<CR>
    endif

    " The following two lines conflict with moving to top and
    " bottom of the screen
    " If you prefer that functionality, add the following to your
    " .vimrc.before.local file:
    "   let g:spf13_no_fastTabs = 1
    if !exists('g:spf13_no_fastTabs')
        map <S-H> gT
        map <S-L> gt
    endif

    " Stupid shift key fixes
    if !exists('g:spf13_no_keyfixes')
        if has("user_commands")
            command! -bang -nargs=* -complete=file E e<bang> <args>
            command! -bang -nargs=* -complete=file W w<bang> <args>
            command! -bang -nargs=* -complete=file Wq wq<bang> <args>
            command! -bang -nargs=* -complete=file WQ wq<bang> <args>
            command! -bang Wa wa<bang>
            command! -bang WA wa<bang>
            command! -bang Q q<bang>
            command! -bang QA qa<bang>
            command! -bang Qa qa<bang>
        endif

        cmap Tabe tabe
    endif

    " Yank from the cursor to the end of the line, to be consistent with C and D.
    nnoremap Y y$

    " Code folding options
    nmap <leader>f0 :set foldlevel=0<CR>
    nmap <leader>f1 :set foldlevel=1<CR>
    nmap <leader>f2 :set foldlevel=2<CR>
    nmap <leader>f3 :set foldlevel=3<CR>
    nmap <leader>f4 :set foldlevel=4<CR>
    nmap <leader>f5 :set foldlevel=5<CR>
    nmap <leader>f6 :set foldlevel=6<CR>
    nmap <leader>f7 :set foldlevel=7<CR>
    nmap <leader>f8 :set foldlevel=8<CR>
    nmap <leader>f9 :set foldlevel=9<CR>

    " Most prefer to toggle search highlighting rather than clear the current
    " search results. To clear search highlighting rather than toggle it on
    " and off, add the following to your .vimrc.before.local file:
    "   let g:spf13_clear_search_highlight = 1
    if exists('g:spf13_clear_search_highlight')
        nmap <silent> <leader>/ :nohlsearch<CR>
    else
        nmap <silent> <leader>/ :set invhlsearch<CR>
    endif


    " Find merge conflict markers
    map <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>

    " Shortcuts
    " Change Working Directory to that of the current file
    cmap cwd lcd %:p:h
    cmap cd. lcd %:p:h

    " Visual shifting (does not exit Visual mode)
    vnoremap < <gv
    vnoremap > >gv

    " Allow using the repeat operator with a visual selection (!)
    " http://stackoverflow.com/a/8064607/127816
    vnoremap . :normal .<CR>

    " For when you forget to sudo.. Really Write the file.
    cmap w!! w !sudo tee % >/dev/null

    " Some helpers to edit mode
    " http://vimcasts.org/e/14
    cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>
    map <leader>ew :e %%
    map <leader>es :sp %%
    map <leader>ev :vsp %%
    map <leader>et :tabe %%

    " Adjust viewports to the same size
    map <Leader>= <C-w>=

    " Map <Leader>ff to display all lines with keyword under cursor
    " and ask which one to jump to
    nmap <Leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

    " Easier horizontal scrolling
    map zl zL
    map zh zH

    " Easier formatting
    nnoremap <silent> <leader>q gwip

    " FIXME: Revert this f70be548
    " fullscreen mode for GVIM and Terminal, need 'wmctrl' in you PATH
    map <silent> <F11> :call system("wmctrl -ir " . v:windowid . " -b toggle,fullscreen")<CR>

" }

" Plugins {

    " TextObj Sentence {
        if count(g:spf13_plug_groups, 'writing')
            augroup textobj_sentence
              autocmd!
              autocmd FileType markdown call textobj#sentence#init()
              autocmd FileType textile call textobj#sentence#init()
              autocmd FileType text call textobj#sentence#init()
            augroup END
        endif
    " }

" TextObj Quote {
    if count(g:spf13_plug_groups, 'writing')
        augroup textobj_quote
            autocmd!
            autocmd FileType markdown call textobj#quote#init()
            autocmd FileType textile call textobj#quote#init()
            autocmd FileType text call textobj#quote#init({'educate': 0})
        augroup END
    endif
" }

" ale {
    if isdirectory(expand("~/.vim/plugged/ale"))
        let g:ale_sign_column_always = 1
        let g:ale_set_highlights = 1
        let g:ale_lint_on_text_changed = 'never'
        let g:ale_lint_on_enter = 0
        let g:ale_linters_explicit = 1
        let g:ale_sign_error = '✗'
        let g:ale_sign_warning = '⚡'
        nnoremap <leader>st :ALEToggle<CR>
        nnoremap <leader>sp :ALEPreviousWrap<CR>
        nnoremap <leader>sn :ALENextWrap<CR>
        nnoremap <leader>sd :ALEDetail<CR>
        let g:ale_linters = {
        \   'c': ['gcc', 'cppcheck', 'clang'],
        \   'c++': ['gcc', 'cppcheck', 'clang'],
        \   'sh': ['shell', 'shellcheck'],
        \   'python': ['pylint'],
        \}
        let g:ale_fixer = {
        \   'c': ['clang-format'],
        \   'cpp': ['clang-format'],
        \   'sh': ['shmft'],
        \}
    endif
" }

" Ctags {
    set tags=./.tags;/,~/.tags
" }

" cscope {
    if has("cscope")
        set csto=0
        set cst
        set csverb
        set cspc=9
        if g:tag_cscope ==? "ctags"
            set cscopeprg=/usr/bin/cscope
        else
            set cscopeprg="gtags-cscope"
        endif
    endif
"}

" Gtags {
    if g:tag_cscope ==? "gtags" && executable('gtags-cscope') && executable('gtags')
        set cscopeprg="cscope"
        if filereadable(expand("~/.vim/plugged/gtags/gtags.vim"))
        source ~/.vim/autoload/gtags.vim
        endif
        if filereadable(expand("~/.vim/plugged/gtags/gtags-cscope.vim"))
        source ~/.vim/autoload/gtags-cscope.vim
        endif
        let GtagsCscope_Auto_Load = 1
        let CtagsCscope_Auto_Map = 1
        let GtagsCscope_Quiet = 1
    endif
" }

" gutentags {
    if isdirectory(expand("~/.vim/plugged/vim-gutentags"))
        let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']
        let g:gutentags_ctags_tagfile = '.tags'
        let s:vim_tags = expand('~/.cache/tags')
        let g:gutentags_cache_dir = s:vim_tags
        let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
        let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
        let g:gutentags_ctags_extra_args += ['--c-kinds=+px']
        let g:gutentags_modules = []
        if executable('ctags')
            let g:gutentags_modules += ['ctags']
        endif
        if g:tag_cscope ==? "gtags" && executable('gtags-cscope') && executable('gtags')
            let g:gutentags_modules += ['gtags_cscope']
        endif
        let g:gutentags_ctags_extra_args += ['--output-format=e-ctags']
    "    let g:gutentags_auto_add_gtags_cscope = 0
    endif
" }

" gutentags_plus {
    if isdirectory(expand("~/.vim/plugged/gutentags_plus"))
        let gutentags_plus_nomap = 1
        noremap <silent> <c-\>s :GscopeFind s <C-R><C-W><cr>
        noremap <silent> <c-\>g :GscopeFind g <C-R><C-W><cr>
        noremap <silent> <c-\>c :GscopeFind c <C-R><C-W><cr>
        noremap <silent> <c-\>t :GscopeFind t <C-R><C-W><cr>
        noremap <silent> <c-\>e :GscopeFind e <C-R><C-W><cr>
        noremap <silent> <c-\>f :GscopeFind f <C-R>=expand("<cfile>")<cr><cr>
        noremap <silent> <c-\>i :GscopeFind i <C-R>=expand("<cfile>")<cr><cr>
        noremap <silent> <c-\>d :GscopeFind d <C-R><C-W><cr>
        noremap <silent> <c-\>a :GscopeFind a <C-R><C-W><cr>
        noremap <silent> <c-\>k :GscopeKill<cr>
    endif
" }

" vim-preview {
    if isdirectory(expand("~/.vim/plugged/vim-preview"))
        autocmd FileType qf nnoremap <silent><buffer> p :PreviewQuickfix<cr>
        autocmd FileType qf nnoremap <silent><buffer> P :PreviewClose<cr>
"        noremap <Leader>u :PreviewScroll -1<cr> " 往上滚动预览窗口
"        noremap <leader>d :PreviewScroll +1<cr> "  往下滚动预览窗口
    endif
" }
" NerdTree {
    if isdirectory(expand("~/.vim/plugged/nerdtree"))
        map <C-e> <plug>NERDTreeTabsToggle<CR>
        map <leader>e :NERDTreeFind<CR>
        nmap <leader>nt :NERDTreeFind<CR>

        let NERDTreeShowBookmarks=1
        let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
        let NERDTreeChDirMode=0
        let NERDTreeQuitOnOpen=1
        let NERDTreeMouseMode=2
        let NERDTreeShowHidden=1
        let NERDTreeKeepTreeInNewTab=1
        let g:nerdtree_tabs_open_on_gui_startup=0
        let g:nerdtree_tabs_synchronize_view = 0
    endif
" }

" Tabularize {
    "if isdirectory(expand("~/.vim/plugged/tabular"))
    "    nmap <Leader>a& :Tabularize /&<CR>
    "    vmap <Leader>a& :Tabularize /&<CR>
    "    nmap <Leader>a= :Tabularize /^[^=]*\zs=<CR>
    "    vmap <Leader>a= :Tabularize /^[^=]*\zs=<CR>
    "    nmap <Leader>a=> :Tabularize /=><CR>
    "    vmap <Leader>a=> :Tabularize /=><CR>
    "    nmap <Leader>a: :Tabularize /:<CR>
    "    vmap <Leader>a: :Tabularize /:<CR>
    "    nmap <Leader>a:: :Tabularize /:\zs<CR>
    "    vmap <Leader>a:: :Tabularize /:\zs<CR>
    "    nmap <Leader>a, :Tabularize /,<CR>
    "    vmap <Leader>a, :Tabularize /,<CR>
    "    nmap <Leader>a,, :Tabularize /,\zs<CR>
    "    vmap <Leader>a,, :Tabularize /,\zs<CR>
    "    nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
    "    vmap <Leader>a<Bar> :Tabularize /<Bar><CR>
    "endif
" }

    " JSON {
        nmap <leader>jt <Esc>:%!python -m json.tool<CR><Esc>:set filetype=json<CR>
        let g:vim_json_syntax_conceal = 0
    " }

    " PyMode {
        " Disable if python support not present
        if !has('python') && !has('python3')
            let g:pymode = 0
        endif

        if isdirectory(expand("~/.vim/plugged/python-mode"))
            let g:pymode_lint_checkers = ['pyflakes']
            let g:pymode_trim_whitespaces = 0
            let g:pymode_options = 0
            let g:pymode_rope = 0
        endif
    " }

    " LeaderF {
        if isdirectory(expand("~/.vim/plugged/leaderf/"))
            let g:Lf_ShortcutB = '<leader>fb'
            let g:Lf_ShortcutF = '<leader>f'
            noremap <leader>fm :LeaderfMru<cr>
            noremap <leader>fu :LeaderfFunction!<cr>
            noremap <leader>ft :LeaderfTag<cr>
            noremap <leader>fr :LeaderfRgInteractive<cr>
            let g:Lf_StlSeparator = { 'left': "▶", 'right': "◀", 'font': "DejaVu Sans Mono for Powerline" }

            let g:Lf_RootMarkers = ['.project', '.root', '.svn', '.git']
            let g:Lf_WildIgnore = {
                \ 'dir': ['.svn','.git','.hg'],
                \ 'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]']
            \ }
            let g:Lf_WorkingDirectoryMode = 'Ac'
            let g:Lf_WindowHeight = 0.30
            let g:Lf_CacheDirectory = expand('~/.vim/cache')
            let g:Lf_ShowRelativePath = 0
            let g:Lf_HideHelp = 1
            let g:Lf_StlColorscheme = 'powerline'
            let g:Lf_PreviewResult = {'Function':0, 'BufTag':0}
            let g:Lf_PreviewCode = 1
            let g:Lf_DefaultExternalTool= ""
        endif
    "}

    " TagBar {
        if isdirectory(expand("~/.vim/plugged/tagbar/"))
            nnoremap <silent> <leader>tt :TagbarToggle<CR>
        endif
    "}

    " Rainbow {
        if isdirectory(expand("~/.vim/plugged/rainbow/"))
            let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle
            let bg = &background
            if bg ==? "dark"
                let g:rainbow_conf = {
                \	'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
	            \}
            else
                let g:rainbow_conf = {
                \	'ctermfgs': ['darkblue', 'darkyellow', 'darkcyan', 'darkmagenta'],
	            \}
            endif
        endif
    "}

    " YouCompleteMe {
        if count(g:spf13_plug_groups, 'youcompleteme')
            let g:ycm_add_preview_to_completeopt = 0
            let g:ycm_show_diagnostics_ui = 0
            let g:ycm_server_log_level = 'info'
            let g:ycm_min_num_identifier_candidate_chars = 2
            let g:ycm_collect_identifiers_from_comments_and_strings = 1
            let g:ycm_complete_in_strings=1
            let g:ycm_key_invoke_completion = '<c-z>'
            set completeopt=menu,menuone
            let g:ycm_key_list_select_completion=['<c-n>']
            let g:ycm_key_list_previous_completion=['<c-p>']

"            noremap <c-z> <NOP>

            let g:ycm_semantic_triggers =  {
                \ 'c,cpp,python,java,go,erlang,perl': ['re!\w{2}'],
                \ 'cs,lua,javascript': ['re!\w{2}'],
                \ }
        endif
    " }
    " echodoc {
        if isdirectory(expand("~/.vim/plugged/echodoc"))
"            set noshowmode
            set cmdheight=2
            let g:echodoc_enable_at_startup = 1
            let g:echodoc_type = 'echo'
        endif
    " }
    " Snippets {
        if isdirectory(expand("~/.vim/plugged/ultisnips"))
"            let g:UltiSnipsExpandTrigger="<tab>"
"            let g:UltiSnipsJumpForwardTrigger="<c-p>"
"            let g:UltiSnipsJumpBackwardTrigger="<c-n>"
        endif
        
    " }

    " FIXME: Isn't this for Syntastic to handle?
    " Haskell post write lint and check with ghcmod
    " $ `cabal install ghcmod` if missing and ensure
    " ~/.cabal/bin is in your $PATH.
    if !executable("ghcmod")
        autocmd BufWritePost *.hs GhcModCheckAndLintAsync
    endif

    " UndoTree {
        if isdirectory(expand("~/.vim/plugged/undotree/"))
            nnoremap <Leader>u :UndotreeToggle<CR>
            " If undotree is opened, it is likely one wants to interact with it.
            let g:undotree_SetFocusWhenToggle=1
        endif
    " }

    " indent_guides {
        if isdirectory(expand("~/.vim/plugged/vim-indent-guides/"))
            let g:indent_guides_start_level = 2
            let g:indent_guides_guide_size = 1
            let g:indent_guides_enable_on_vim_startup = 1
        endif
    " }

    " Wildfire {
    let g:wildfire_objects = {
                \ "*" : ["i'", 'i"', "i)", "i]", "i}", "ip"],
                \ "html,xml" : ["at"],
                \ }
    " }

    " vim-airline {
        " Set configuration options for the statusline plugin vim-airline.
        " Use the powerline theme and optionally enable powerline symbols.
        " To use the symbols , , , , , , and .in the statusline
        " segments add the following to your .vimrc.before.local file:
        " If the previous symbols do not render for you then install a
        " powerline enabled font.

        " See `:echo g:airline_theme_map` for some more choices
        " Default in terminal vim is 'dark'
        if isdirectory(expand("~/.vim/plugged/vim-airline-themes/"))
            set t_Co=256
            set laststatus=2
            let g:airline_theme='random'
            let g:airline_powerline_fonts = 1                   " support powerline fonts(works in gvim)

            " show status of tabs and buffers
            let g:airline#extensions#tabline#enabled = 1        " enable tabline
            let g:airline#extensions#tabline#left_sep = '▶'     " seprate of buffers active
            let g:airline#extensions#tabline#left_alt_sep = '»' " seprate of buffers inactive
            let g:airline#extensions#tabline#buffer_nr_show = 1 " show index of buffers

            let g:airline#extensions#whitespace#enabled = 0     " close space counts

            if !exists('g:airline_symbols')
                let g:airline_symbols = {}
            endif
            " support full font symbol
            if 1
                " unicode symbols
"                let g:airline_left_sep = '»'
                let g:airline_left_sep = '▶'
"                let g:airline_right_sep = '«'
                let g:airline_right_sep = '◀'
                let g:airline_symbols.crypt = '🔒'
"                let g:airline_symbols.linenr = '☰'
"                let g:airline_symbols.linenr = '␊'
"                let g:airline_symbols.linenr = '␤'
                let g:airline_symbols.linenr = '¶'
"                let g:airline_symbols.maxlinenr = ''
                let g:airline_symbols.maxlinenr = '㏑'
                let g:airline_symbols.branch = '⎇'
                let g:airline_symbols.paste = 'ρ'
"                let g:airline_symbols.paste = 'Þ'
"                let g:airline_symbols.paste = '∥'
                let g:airline_symbols.spell = 'Ꞩ'
                let g:airline_symbols.notexists = 'Ɇ'
                let g:airline_symbols.whitespace = 'Ξ'
            else
                " powerline symbols
                let g:airline_left_sep = ''
                let g:airline_left_alt_sep = ''
                let g:airline_right_sep = ''
                let g:airline_right_alt_sep = ''
                let g:airline_symbols.branch = ''
                let g:airline_symbols.readonly = ''
                let g:airline_symbols.linenr = '☰'
                let g:airline_symbols.maxlinenr = ''
            endif
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

        " To specify a different directory in which to place the vimbackup,
        " vimviews, vimundo, and vimswap files/directories, add the following to
        " your .vimrc.before.local file:
        "   let g:spf13_consolidated_directory = <full path to desired directory>
        "   eg: let g:spf13_consolidated_directory = $HOME . '/.vim/'
        if exists('g:spf13_consolidated_directory')
            let common_dir = g:spf13_consolidated_directory . prefix
        else
            let common_dir = parent . '/.' . prefix
        endif

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
     
    function! s:EditSpf13Config()
        call <SID>ExpandFilenameAndExecute("tabedit", "~/.vimrc")
        execute bufwinnr(".vimrc") . "wincmd w"
        call <SID>ExpandFilenameAndExecute("vsplit", "~/.vimrc.local")
        execute bufwinnr(".vimrc.local") . "wincmd w"
        call <SID>ExpandFilenameAndExecute("split", "~/.vimrc.plugs")
        execute bufwinnr(".vimrc.local") . "wincmd w"
    endfunction
     
    execute "noremap " . s:spf13_edit_config_mapping " :call <SID>EditSpf13Config()<CR>"
    execute "noremap " . s:spf13_apply_config_mapping . " :source ~/.vimrc<CR>"


" }

" Use local vimrc if available {
    if filereadable(expand("~/.vimrc.local"))
        source ~/.vimrc.local
    endif
" }
