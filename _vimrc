set nocompatible " enable non-vi features
call pathogen#infect()
call pathogen#helptags()

set backspace=2   " erlaubt das Löschen mit [BS] und [DEL] über das Zeilenende, Indent und Insertstart
" set fileformat=unix   " damit vermeidet man EOL und EOF Probleme, wenn diese Dateien von anderen OS kommen

set history=100   " keep 100 ex commands
set laststatus=2   " always a status line

set encoding=utf-8
set t_Co=256 " Explicitly tell Vim that the terminal supports 256 colors (suggested by powerline


" use swap file; when writing to a file, make a temporary backup of the
" original file (deleted when writing finished without error)
set swapfile
set nobackup
set writebackup

" Tell vim to remember certain things when we exit
"  '10 : marks will be remembered for up to 10 previously edited files
"  "100 : will save up to 100 lines for each register
"  :20 : up to 20 lines of command-line history will be remembered
"  % : saves and restores the buffer list
"  n... : where to save the viminfo files
set viminfo='10,\"100,:20,%,n~/.viminfo

" Syntaxhighlighting
filetype plugin indent on
syntax enable

set showcmd   " shows (partial) commands in status line
" set number   " zeige Zeilennummerierung
" set ruler   " show cursor position

set ignorecase " ignore case when pattern is lowercase
set smartcase " if pattern contains capital letters, search is case sensitive
set incsearch   " while typing, show matched pattern
set hlsearch   " search pattern highlighting

"# tabstop equals four spaces
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent  "new line has same indentation as last one

set mousemodel=popup      " show a context menu if clicking in selection


" In GUI:
"    * use nice colorscheme
"    * show tab as "»···", trailing spaces as "·", non breaking space as "‗"
"        show "…" at beginning and end of lines that go beyond the screen
"        reduce contrast of these items
if has("gui_running")
	"colorscheme wombat
	colorscheme solarized
	set background=dark
	set list listchars=tab:»·,trail:·,precedes:…,extends:…,nbsp:‗
	highlight SpecialKey guibg=bg
	let g:solarized_visibility="low"
endif

if v:version < 700
	let VCSCommandDisableAll = 1
endif

" see unsaved changes
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

" disable xdvi's status output to stdout
let g:Tex_ViewRule_dvi = 'xdvi -expertmode 1'

" (nearly) bash like tab completion for file names
" (completely bash like would be without 'full')
" first <tab>: complete as much as possible
" second <tab>: list possible file names
" subsequent <tab>s: cycle through completion options
set wildmode=longest,list,full
set wildmenu

set wrap
"set linebreak
"set showbreak=\\\ 
" when we reload, tell vim to restore the cursor to the saved position
augroup JumpCursorOnEdit
 au!
 autocmd BufReadPost *
 \ if expand("<afile>:p:h") !=? $TEMP |
 \ if line("'\"") > 1 && line("'\"") <= line("$") |
 \ let JumpCursorOnEdit_foo = line("'\"") |
 \ let b:doopenfold = 1 |
 \ if (foldlevel(JumpCursorOnEdit_foo) > foldlevel(JumpCursorOnEdit_foo - 1)) |
 \ let JumpCursorOnEdit_foo = JumpCursorOnEdit_foo - 1 |
 \ let b:doopenfold = 2 |
 \ endif |
 \ exe JumpCursorOnEdit_foo |
 \ endif |
 \ endif
 " Need to postpone using "zv" until after reading the modelines.
 autocmd BufWinEnter *
 \ if exists("b:doopenfold") |
 \ exe "normal zv" |
 \ if(b:doopenfold > 1) |
 \ exe "+".1 |
 \ endif |
 \ unlet b:doopenfold |
 \ endif
augroup END

"With the following (for example, in vimrc), you can visually select text then press ~ to convert the text to UPPER CASE, then to lower case, then to Title Case. Keep pressing ~ until you get the case you want.
function! TwiddleCase(str)
  if a:str ==# toupper(a:str)
    let result = tolower(a:str)
  elseif a:str ==# tolower(a:str)
    let result = substitute(a:str,'\(\<\w\+\>\)', '\u\1', 'g')
  else
    let result = toupper(a:str)
  endif
  return result
endfunction
vnoremap ~ ygv"=TwiddleCase(@")<CR>Pgv


" Leave insert mode after 15 seconds of no input:
au CursorHoldI * stopinsert
au InsertEnter * let updaterestore=&updatetime | set updatetime=15000
au InsertLeave * let &updatetime=updaterestore

" Type the word lorem and it expands to an entire paragraph of Lorem ipsum
iab lorem Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras sollicitudin quam eget libero pulvinar id condimentum velit sollicitudin. Proin cursus scelerisque dui ac condimentum. Nullam quis tellus leo. Morbi consectetur, lectus a blandit tincidunt, tortor augue tincidunt nisi, sit amet rhoncus tortor velit eu felis.

" Highlight cursorline ONLY in the active window and only in GUI:
if has("gui_running")
	set cursorline
	au WinEnter * setlocal cursorline
	au WinLeave * setlocal nocursorline
endif

" Repeat last recorded macro
map Q @@
" Reselect visual block after indent/outdent 
vnoremap < <gv
vnoremap > >gv
" Easy split navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" Force Saving Files that Require Root Permission
cmap w!! %!sudo tee > /dev/null %

" undofile - This allows you to use undos after exiting and restarting
" This, like swap and backups, uses .vim-undo first, then ~/.vim/undo
if exists("+undofile")
	if isdirectory($HOME . '/.vim/undo') == 0
		:silent !mkdir -p ~/.vim/undo
	endif
	set undodir=./.vim-undo//
	set undodir+=~/.vim/undo//
	set undofile
endif

" Use tab for auto completion, but still retain tabbing functionality if you are not typing a word
function! SuperTab()
	if (strpart(getline('.'),col('.')-2,1)=~'^\W\?$')
		return "\<Tab>"
	else
		return "\<C-n>"
	endif
endfunction
imap <Tab> <C-R>=SuperTab()<CR>

" Work with diverse indentation conventions? Switch between them more gently, without the abrupt, jarring transition of a direct 'set tabstop'.
function Tabanim(desired)
	if a:desired < &tabstop
		let direction = -1
	else
		let direction = 1
	endif
	while a:desired != &tabstop
		sleep 70m
		let &tabstop = &tabstop + direction
		redraw
	endwhile
	let &shiftwidth = &tabstop
endfunction

" pyflakes currently not working on tango
let b:did_pyflakes_plugin = 1

" Setup vim-powerline
let g:Powerline_symbols = 'compatible'
let g:Powerline_stl_path_style = 'short'
let g:Powerline_theme = 'mdobler'
let g:Powerline_colorscheme = 'mdobler_wombat'

let g:tagbar_type_scala = {
    \ 'ctagstype' : 'Scala',
    \ 'kinds'     : [
        \ 'p:packages:1',
        \ 'V:values',
        \ 'v:variables',
        \ 'T:types',
        \ 't:traits',
        \ 'o:objects',
        \ 'a:aclasses',
        \ 'c:classes',
        \ 'r:cclasses',
        \ 'm:methods'
    \ ]
\ }

" diverse key mappings

" Repeat last recorded macro
map Q @@
" Reselect visual block after indent/outdent 
vnoremap < <gv
vnoremap > >gv
" Easy split navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" Force Saving Files that Require Root Permission
cmap w!! %!sudo tee > /dev/null %

" ctrl-l clears search highlighting
if exists(":nohls")
  nnoremap <silent> <C-L> :nohls<CR><C-L>
endif

" F5 -- refresh
map <F6> :GundoToggle<CR>
map <F7> :TagbarToggle<CR>
map <F8> :SyntasticToggleMode<CR>
map <F9> :wa<Bar>make<CR>

" ctrl-g ctrl-t inserts current time stamp, with a menu to select different
" formats
inoremap <silent> <C-G><C-T> <C-R>=repeat(complete(col('.'),map(["%Y-%m-%d %H:%M:%S","%Y-%m-%d","%H:%M:%S","%a, %d %b %Y %H:%M:%S %z","%a %b %d %T %Z %Y"],'strftime(v:val)')+[localtime()]),0)<CR>
