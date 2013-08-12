" Recalculate the trailing whitespace warning when idle, and after saving
autocmd CursorHold,BufWritePost,InsertLeave * unlet! b:statusline_trailing_space_warning

function! Powerline#Functions#GetFilepath() " {{{
	" Recalculate the filepath when cwd changes.
	let cwd = getcwd()
	if exists("b:Powerline_cwd") && cwd != b:Powerline_cwd
		unlet! b:Powerline_filepath
	endif
	let b:Powerline_cwd = cwd

	if exists('b:Powerline_filepath')
		return b:Powerline_filepath
	endif

	let dirsep = has('win32') && ! &shellslash ? '\' : '/'
	let filepath = expand('%:p')

	if empty(filepath)
		return ''
	endif

	let ret = ''

	if g:Powerline_stl_path_style == 'short'
		" This displays the shortest possible path, relative to ~ or the
		" current directory.  Generate several possible path representations,
		" select the shortest one

		" relative path. keep parent dirs as '..'
		" "src/foo/bar" -> "s/f/b"
		" "../foo/bar" -> "../f/b"
		" "../../foo/bar" -> "../../f/b"
		let fpath = split(fnamemodify(expand('%'), ':.:h'), dirsep, 1)
		let fpath_shortparts = map(fpath, 'v:val==".." ? ".." : v:val[0]')
		let relpath = join(fpath_shortparts, dirsep) . dirsep
		" convert '../../' to '.../'
		" let relpath = substitute(relpath, '/\.\.', '.', 'g')

		" absolute path.  use shortcut for $HOME
		" "/home/user/src/foo/bar" -> "~/s/f/b"
		" "/etc/foo/bar" -> "/e/f/b"
		let mod = (exists('+acd') && &acd) ? ':p:~:h' : ':p:~:.:h'
		let fpath = split(fnamemodify(filepath, mod), dirsep, 1)
		let fpath_shortparts = map(fpath, 'v:val[0]')
		let abspath = join(fpath_shortparts, dirsep) . dirsep

		let ret = relpath
		if len(abspath) < len(relpath)
			let ret = abspath
		endif
	elseif g:Powerline_stl_path_style == 'relative'
		" Display a relative path, similar to the %f statusline item
		let ret = fnamemodify(filepath, ':~:.:h') . dirsep
	elseif g:Powerline_stl_path_style == 'full'
		" Display the full path, similar to the %F statusline item
		let ret = fnamemodify(filepath, ':h') . dirsep
	endif

	if ret == ('.' . dirsep)
		let ret = ''
	endif

	let b:Powerline_filepath = ret
	return ret
endfunction " }}}
function! Powerline#Functions#GetShortPath(threshold) " {{{
	let fullpath = split(expand('%:~'), '[/\\]')

	if len(fullpath) > a:threshold
		let fullpath = [fullpath[0], '…'] +  fullpath[-a:threshold + 1 :]
	endif

	return join(fullpath, '/')
endfunction " }}}
function! Powerline#Functions#GetMode() " {{{
	let mode = mode()

	if mode ==# 'v'
		let mode = get(g:, "Powerline_mode_v", "VISUAL")
	elseif mode ==# 'V'
		let mode = get(g:, "Powerline_mode_V", "V⋅LINE ")
	elseif mode ==# ''
		let mode = get(g:, "Powerline_mode_cv", "V⋅BLCK")
	elseif mode ==# 's'
		let mode = get(g:, "Powerline_mode_s", "SELECT")
	elseif mode ==# 'S'
		let mode = get(g:, "Powerline_mode_S", "S⋅LINE ")
	elseif mode ==# ''
		let mode = get(g:, "Powerline_mode_cs", "S⋅BLCK")
	elseif mode =~# '\vi'
		let mode = get(g:, "Powerline_mode_i", "INSERT")
	elseif mode =~# '\v(R|Rv)'
		let mode = get(g:, "Powerline_mode_R", "REPLACE")
	else
		" Fallback to normal mode
		let mode = get(g:, "Powerline_mode_n", "NORMAL")
	endif

	return mode
endfunction " }}}
function! Powerline#Functions#GetFilesize() " {{{
	let bytes = getfsize(expand("%:p"))

	if bytes <= 0
		return ''
	endif

	if bytes < 1024
		return bytes . 'B'
	else
		return (bytes / 1024) . 'kB'
	endif
endfunction "}}}
function! Powerline#Functions#GetCharCode() " {{{
	" Get the output of :ascii
	redir => ascii
	silent! ascii
	redir END

	if match(ascii, 'NUL') != -1
		return 'NUL'
	endif

	" Zero pad hex values
	let nrformat = '0x%02x'

	let encoding = (&fenc == '' ? &enc : &fenc)

	if encoding == 'utf-8'
		" Zero pad with 4 zeroes in unicode files
		let nrformat = '0x%04x'
	endif

	" Get the character and the numeric value from the return value of :ascii
	" This matches the two first pieces of the return value, e.g.
	" "<F>  70" => char: 'F', nr: '70'
	let [str, char, nr; rest] = matchlist(ascii, '\v\<(.{-1,})\>\s*([0-9]+)')

	" Format the numeric value
	let nr = printf(nrformat, nr)

	return "'". char ."' ". nr
endfunction "}}}
function! Powerline#Functions#GetWSMarker() " {{{
	" Return '...' if trailing white space is detected
	" Return '' otherwise
	if ! exists("b:statusline_trailing_space_warning")
		if search('\s$', 'nw') != 0
			let b:statusline_trailing_space_warning = ' … '
		else
			let b:statusline_trailing_space_warning = ''
		endif
	endif
	return b:statusline_trailing_space_warning
endfunction " }}}
