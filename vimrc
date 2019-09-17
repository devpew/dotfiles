set mouse=a " Enable mouse for scolling and resizing
set hlsearch " Automatically highlight search results
set nocompatible  " required, but i don't know what is it
filetype off  " required by vundle, but if i will need it in the future i can turn it on after the last Vundle command. like that - filetype plugin indent on
set exrc "If this option is turned on we could use different .vimrc config files based on directory


set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

let g:ackprg = 'ag --nogroup --nocolor --column' "This command change ack search to ag search. it's much powerful
Plugin 'mileszs/ack.vim' " Inmpover search

nmap <leader>a :Ack 
nmap <leader>A :Ack <cword><CR>

Plugin 'inkarkat/vim-CompleteHelper'
Plugin 'inkarkat/vim-ingo-library'

" Markdown. The tabular plugin must come before vim-markdown 

Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
set nofoldenable


Plugin 'MarcWeber/vim-addon-mw-utils'

Plugin 'EntryComplete'

Plugin 'iamcco/mathjax-support-for-mkdp' "Plugin that can help me edit .md file with browser
Plugin 'iamcco/markdown-preview.vim' "Plugin that can help me edit .md file with browser

let g:EntryComplete_Sources = glob('~/Nextcloud/sales/txt/projects/*.txt', 0, 1)

" ==== plugin manager
Plugin 'VundleVim/Vundle.vim'

" ==== helpers
Plugin 'vim-scripts/L9'

" ==== File tree
Plugin 'scrooloose/nerdtree'

" ==== Completion
"Plugin 'Valloric/YouCompleteMe'

" ==== Git
"gitgutter - Vim plugin which shows a git diff in the gutter (sign column) and stages/undoes hunks.
"Plugin 'airblade/vim-gitgutter'

"vim-fugitive - best Git wrapper of all time.
"Plugin 'tpope/vim-fugitive'

" ==== syntax helpers
" Syntastic is a syntax checking plugin for Vim created by Martin Grenfell. It runs files through external syntax checkers and displays any resulting errors to the user. This can be done on demand, or automatically as files are saved.
"Plugin 'scrooloose/syntastic'

" Surround.vim is all about surroundings parentheses, brackets, quotes, XML tags, and more. The plugin provides mappings to easily delete, change and add such surroundings in pairs.
Plugin 'tpope/vim-surround'

Plugin 'cakebaker/scss-syntax.vim'

"Plugin 'othree/yajs.vim'
"Plugin 'mitsuhiko/vim-jinja'
"Plugin 'octol/vim-cpp-enhanced-highlight'
"Plugin 'ap/vim-css-color'
Plugin 'Vimjas/vim-python-pep8-indent'
Plugin 'moll/vim-node'

" ==== moving / searching
Plugin 'easymotion/vim-easymotion'
Plugin 'ctrlpvim/ctrlp.vim'

" ==== snippets
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'

Plugin 'powerline/powerline'

" Plugin 'ierton/xkb-switch'
Plugin 'lyokha/vim-xkbswitch'

Plugin 'scrooloose/nerdcommenter'

" Status bar on bottom
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" ==== PLUGIN THEMES
Plugin 'morhetz/gruvbox'

call vundle#end()
filetype plugin indent on

" ==== Colors and other basic settings

"colorscheme gruvbox
"set guifont=Monospace\ 10

set guifont=Droid\ Sans\ Mono\ for\ Powerline\ 10
let g:Powerline_symbols = 'unicode'

let g:airline_powerline_fonts=1
let g:gruvbox_contrast_dark="meduim"

if !exists('g:airline_symbols')
    let g:airline_symbols = {} 
endif





" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'

" airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

set fillchars+=vert:\$
"syntax enable
set background=dark
set ruler
set hidden
set number
set laststatus=2
set smartindent
set st=4 sw=4 et
set shiftwidth=4
set tabstop=4
"let &colorcolumn="80"
:set guioptions-=m  "remove menu bar
:set guioptions-=T  "remove toolbar
:set guioptions-=r  "remove right-hand scroll bar
:set guioptions-=L  "remove left-hand scroll bar
":set lines=999 columns=999

" ==== NERDTREE
let NERDTreeIgnore = ['__pycache__', '\.pyc$', '\.o$', '\.so$', '\.a$', '\.swp', '*\.swp', '\.swo', '\.swn', '\.swh', '\.swm', '\.swl', '\.swk', '\.sw*$', '[a-zA-Z]*egg[a-zA-Z]*', '.DS_Store']

let NERDTreeShowHidden=1
let g:NERDTreeWinPos="left"
let g:NERDTreeDirArrows=0
map <C-t> :NERDTreeToggle<CR>

" ==== Syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_javascript_mri_args = "--config=$HOME/.jshintrc"
let g:syntastic_python_checkers = [ 'pylint', 'flake8', 'pep8', 'pyflakes', 'python']
let g:syntastic_yaml_checkers = ['jsyaml']
let g:syntastic_html_tidy_exec = 'tidy5'

" === flake8
let g:flake8_show_in_file=1

" ==== snippets
let g:UltiSnipsExpandTrigger="<C-p>"
"let g:UltiSnipsJumpForwardTrigger="<C-o>"
"let g:UltiSnipsJumpBackwardTrigger="<C-i>"
let g:UltiSnipsListSnippets="<C-o>"
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
"let g:UltiSnipsSnippetDirectories=["UltiSnips"]
let g:UltiSnipsSnippetDirectories=[$HOME.'/.vim/UltiSnips']

" ==== Easymotion
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1
nmap f <Plug>(easymotion-s)

" ==== moving around
nmap <silent> <A-Up> :wincmd k<CR>
nmap <silent> <A-Down> :wincmd j<CR>
nmap <silent> <A-Left> :wincmd h<CR>
nmap <silent> <A-Right> :wincmd l<CR>

" ==== disable mouse
"set mouse=c

" ==== disable swap file warning
set shortmess+=A

" ==== custom commands
command JsonPretty execute ":%!python -m json.tool"
set secure

vmap <C-c> "+y

set clipboard=unnamedplus

nmap <silent> <F8> <Plug>MarkdownPreview        " for normal mode
imap <silent> <F8> <Plug>MarkdownPreview        " for insert mode
nmap <silent> <F9> <Plug>StopMarkdownPreview    " for normal mode
imap <silent> <F9> <Plug>StopMarkdownPreview    " for insert mode

" let g:mkdp_path_to_chrome = "/usr/bin/google-chrome-stable"
let g:mkdp_path_to_chrome = "/usr/bin/firefox"
" Path to the chrome or the command to open chrome (or other modern browsers).
" If set, g:mkdp_browserfunc would be ignored.

let g:mkdp_browserfunc = 'MKDP_browserfunc_default'
" Callback Vim function to open browser, the only parameter is the url to open.

let g:mkdp_auto_start = 1
" Set to 1, Vim will open the preview window on entering the Markdown
" buffer.

let g:mkdp_auto_open = 1
" Set to 1, Vim will automatically open the preview window when you edit a
" Markdown file.

let g:mkdp_auto_close = 1
" Set to 1, Vim will automatically close the current preview window when
" switching from one Markdown buffer to another.

let g:mkdp_refresh_slow = 0
" Set to 1, Vim will just refresh Markdown when saving the buffer or
" leaving from insert mode. With default 0, it will automatically refresh
" Markdown as you edit or move the cursor.

let g:mkdp_command_for_global = 0
" Set to 1, the MarkdownPreview command can be used for all files,
" by default it can only be used in Markdown files.

let g:mkdp_open_to_the_world = 0
" Set to 1, the preview server will be available to others in your network.
" By default, the server only listens on localhost (127.0.0.1).


"Markdown block code
au FileType markdown :vmap \q di~~~~<ENTER><ENTER>~~~~<ESC>kP
au FileType markdown nmap <leader>q ddi~~~~<ENTER>~~~~<ENTER><ESC>kP

"Markdown inline code
au FileType markdown :vmap \w di``<ESC>hp
au FileType markdown nmap <leader>w diwi``<ESC>hp

"Markdown link
au FileType markdown nmap <leader>l i![alt text](https://www.link.com)<ESC>

"Markdown table
 

"Markdown bold
au FileType markdown :vmap \b di****<ESC>hhp
au FileType markdown nmap <leader>b diwi****<ESC>hhp

"Markdown italiq
au FileType markdown :vmap \i di**<ESC>hp
au FileType markdown nmap <leader>i diwi**<ESC>hp

"Markdown Tabularize
"au FileType markdown :vmap \t :'<,'>Tabularize /|<ENTER>
    





" ---------------
" Tabular
" ---------------
nmap <Leader>t= :Tabularize /=<CR>
vmap <Leader>t= :Tabularize /=<CR>
nmap <Leader>t: :Tabularize /:\zs<CR>
vmap <Leader>t: :Tabularize /:\zs<CR>
nmap <Leader>t, :Tabularize /,\zs<CR>
vmap <Leader>t, :Tabularize /,\zs<CR>
nmap <Leader>t> :Tabularize /=>\zs<CR>
vmap <Leader>t> :Tabularize /=>\zs<CR>

"Automatically call Tabular to align on | for Cucumber tables.
"inoremap <silent> <Bar> <Bar><Esc>:call <SID>align()<CR>a
"function! s:align()
"  let p = '^\s*|\s.*\s|\s*$'
"  if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
"    let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
"    let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
"    Tabularize/|/l1
"    normal! 0
"    call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
"  endif
"endfunction






nmap <leader>m ggi---<ENTER>title: My Awesome Post<ENTER>tags: ['some', 'tags', 'here']<ENTER>status: draft<ENTER>---<ESC>

"When i open NerdTree it opens it with current directory
autocmd vimenter * silent! lcd %:p:h

"set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz

"check spelling
"set spell spelllang=ru,en
"set spell spelllang=en
"autocmd BufRead,BufNewFile *.md setlocal spell
"autocmd BufRead,BufNewFile *.txt setlocal spell
"autocmd FileType gitcommit setlocal spell
"autocmd FileType *.md splllang=ru,en spell
"autocmd BufRead,BufNewFile *.md setlocal spell spelllang=ru,en

" ---- Automatic keyboard layout switching upon entering/leaving insert mode
" ---- using xkb-switch utility and plugin xkbswitch
" ----
let g:XkbSwitchEnabled = 1
let g:XkbSwitchIMappings = ['ru']
let g:XkbSwitchNLayout = 'us'
let g:XkbSwitchILayout = 'us'
" loading xkbswitch on BufRead when bufhidden=delete will clash xkbswitch
" function imappings_load() and plugin EnhancedJumps as soon as both will do
" redir simultaneously!
let g:XkbSwitchLoadOnBufRead = 0
let g:XkbSwitchSkipIMappings =
            \ {'c'   : ['.', '>', ':', '{<CR>', '/*', '/*<CR>'],
            \  'cpp' : ['.', '>', ':', '{<CR>', '/*', '/*<CR>']}
let g:XkbSwitchSkipFt = [ 'conque_term' ]
let g:XkbSwitchAssistNKeymap = 1    " for commands r and f
let g:XkbSwitchAssistSKeymap = 1    " for search lines
let g:XkbSwitchDynamicKeymap = 1
let g:XkbSwitchKeymapNames = {'ru' : 'russian-jcukenwin'}
