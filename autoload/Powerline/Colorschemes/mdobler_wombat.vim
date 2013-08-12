" Solarized-like color scheme for Powerline, works well with my wombat theme
" N = no focus
" 16 hex colors as defined on http://ethanschoonover.com/solarized
" blue gradient replaced by grayscale
call Pl#Hi#Allocate({
  \ 'base03'  : [8,   0x1c1c1c],
  \ 'base02'  : [0,   0x262626],
  \ 'base01'  : [10,  0x4e4e4e],
  \ 'base00'  : [11,  0x585858],
  \ 'base0'   : [12,  0x808080],
  \ 'base1'   : [14,  0x8a8a8a],
  \ 'base2'   : [7,   0xd7d7af],
  \ 'base3'   : [15,  0xffffd7],
  \ 'yellow'  : [3,   0xb58900],
  \ 'orange'  : [9,   0xcb4b16],
  \ 'red'     : [1,   0xdc322f],
  \ 'magenta' : [5,   0xd33682],
  \ 'violet'  : [13,  0x6c71c4],
  \ 'blue'    : [4,   0x268bd2],
  \ 'cyan'    : [6,   0x2aa198],
  \ 'green'   : [2,   0x5f8700],
	\ })

let g:Powerline#Colorschemes#mdobler_wombat#colorscheme = Pl#Colorscheme#Init([
	\ Pl#Hi#Segments(['SPLIT'], {
		\ 'n': ['base3',  'base02'],
		\ 'N': ['base3',  'base02'],
		\ 'i': ['base3',  'base02'],
		\ }),
	\
	\ Pl#Hi#Segments(['mode_indicator'], {
		\ 'n': ['base2',  'blue',     ['bold']],
		\ 'i': ['base3',  'orange',   ['bold']],
		\ 'v': ['base3',  'magenta',  ['bold']],
		\ 'r': ['base3',  'violet',   ['bold']],
		\ 's': ['base3',  'yellow',   ['bold']],
		\ }),
	\
	\ Pl#Hi#Segments(['branch'], {
		\ 'n': ['base2',   'base02'],
		\ 'N': ['base02',  'base02'],
		\ 'i': ['base2',   'base00'],
		\ }),
	\
  \ Pl#Hi#Segments(['scrollpercent', 'raw', 'filesize'], {
		\ 'n': ['cyan',   'base02'],
		\ 'N': ['base00',  'base02'],
		\ 'i': ['red',   'base02'],
		\ }),
	\
	\ Pl#Hi#Segments(['fileinfo', 'filename'], {
		\ 'n': ['base1',   'base02',   ['bold']],
		\ 'N': ['base0',  'base02' ],
		\ }),
	\
	\ Pl#Hi#Segments(['fileinfo.filepath'], {
		\ 'n': ['base0'],
		\ 'N': ['base0'],
		\ }),
	\
	\ Pl#Hi#Segments(['static_str'], {
		\ 'n': ['base3',   'green'],
		\ 'N': ['base01',  'base02'],
		\ 'i': ['base3',   'blue'],
		\ }),
	\
	\ Pl#Hi#Segments(['fileinfo.flags'], {
		\ 'n': ['red', 'base02', ['bold']],
		\ 'N': ['base0', 'base02'],
		\ 'i': ['red'],
		\ }),
	\
	\ Pl#Hi#Segments(['currenttag', 'fileformat', 'fileencoding', 'pwd', 'filetype', 'rvm:string', 'rvm:statusline', 'virtualenv:statusline'], {
		\ 'n': ['base00', 'base02'],
		\ }),
	\
	\ Pl#Hi#Segments(['charcode', 'currhigroup'], {
		\ 'n': ['base01', 'base02'],
		\ }),
	\
	\ Pl#Hi#Segments(['lineinfo'], {
		\ 'n': ['cyan',   'base02',  ['bold']],
		\ 'N': ['base2',  'base02'],
		\ 'i': ['red',  'base02', ['bold']],
		\ }),
	\
	\ Pl#Hi#Segments(['errors'], {
		\ 'n': ['red',  'base2',  ['bold']],
		\ }),
	\
	\ Pl#Hi#Segments(['lineinfo.line.tot'], {
		\ 'n': ['blue'],
		\ 'N': ['base2'],
		\ 'i': ['yellow'],
		\ }),
	\
	\ Pl#Hi#Segments(['paste_indicator', 'ws_marker'], {
		\ 'n': ['base3', 'yellow', ['bold']],
		\ }),
	\
	\ Pl#Hi#Segments(['gundo:static_str.name', 'command_t:static_str.name'], {
		\ 'n': ['orange',   'base02',     ['bold']],
		\ 'N': ['base1',  'base02',  ['bold']],
		\ }),
	\
	\ Pl#Hi#Segments(['gundo:static_str.buffer', 'command_t:raw.line'], {
		\ 'n': ['yellow',  'base02'],
		\ 'N': ['base1',  'base02'],
		\ }),
	\
	\ Pl#Hi#Segments(['gundo:SPLIT', 'command_t:SPLIT'], {
		\ 'n': ['base3',  'base02'],
		\ 'N': ['base0',  'base03'],
		\ }),
	\
	\ Pl#Hi#Segments(['lustyexplorer:static_str.name', 'minibufexplorer:static_str.name', 'nerdtree:raw.name', 'tagbar:static_str.name'], {
		\ 'n': ['base2',   'green',   ['bold']],
		\ 'N': ['base02',  'base1'],
		\ }),
	\
	\ Pl#Hi#Segments(['lustyexplorer:static_str.buffer', 'tagbar:static_str.buffer'], {
		\ 'n': ['base3',   'base01'],
		\ 'N': ['base02',  'base01'],
		\ }),
	\
	\ Pl#Hi#Segments(['lustyexplorer:SPLIT', 'minibufexplorer:SPLIT', 'nerdtree:SPLIT', 'tagbar:SPLIT'], {
		\ 'n': ['base2',  'base2'],
		\ 'N': ['base2',  'base2'],
		\ }),
	\
	\ Pl#Hi#Segments(['ctrlp:focus', 'ctrlp:byfname'], {
		\ 'n': ['base03', 'base01'],
		\ }),
	\
	\ Pl#Hi#Segments(['ctrlp:prev', 'ctrlp:next', 'ctrlp:pwd'], {
		\ 'n': ['base3', 'base00'],
		\ }),
	\
	\ Pl#Hi#Segments(['ctrlp:item'], {
		\ 'n': ['base3', 'violet', ['bold']],
		\ }),
	\
	\ Pl#Hi#Segments(['ctrlp:marked'], {
		\ 'n': ['base1', 'base01', ['bold']],
		\ }),
	\
	\ Pl#Hi#Segments(['ctrlp:count'], {
		\ 'n': ['base3', 'violet'],
		\ }),
	\
	\ Pl#Hi#Segments(['ctrlp:SPLIT'], {
		\ 'n': ['base3', 'base03'],
		\ }),
	\ ])
