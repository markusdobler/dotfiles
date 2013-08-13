# Test setup taken from Sexy bash prompt by twolfson:
#  * https://github.com/twolfson/sexy-bash-prompt

# Set color codes according to terminal capabilities

function set_colors () {
	if [[ $COLORTERM = gnome-* && $TERM = xterm ]]  && infocmp gnome-256color >/dev/null 2>&1; then export TERM=gnome-256color
	elif [[ $TERM != dumb ]] && infocmp xterm-256color >/dev/null 2>&1; then export TERM=xterm-256color
	fi

	# If we are on a colored terminal
	if tput setaf 1 &> /dev/null; then
		# Reset the shell from our `if` check
		tput sgr0

		bold="\[$(tput bold)\]"
		underline="\[$(tput smul)\]"
		standout="\[$(tput smso)\]"
		normal="\[$(tput sgr0)\]"
		black="\[$(tput setaf 0)\]"
		red="\[$(tput setaf 1)\]"
		green="\[$(tput setaf 2)\]"
		yellow="\[$(tput setaf 3)\]"
		blue="\[$(tput setaf 4)\]"
		magenta="\[$(tput setaf 5)\]"
		cyan="\[$(tput setaf 6)\]"
		white="\[$(tput setaf 7)\]"
	else
	# Otherwise, use ANSI escape sequences for coloring
	  # Original colors from fork
		bold=""
		underline=""
		standout=""
		normal="\[\033[00m\]"
		black="\[\033[0;30m\]"
		red="\[\033[0;31m\]"
		green="\[\033[0;32m\]"
		yellow="\[\033[0;33m\]"
		blue="\[\033[0;34m\]"
		magenta="\[\033[0;35m\]"
		cyan="\[\033[0;36m\]"
		white="\[\033[0;37m\]"
	fi
}

function is_hg_repository {
	hg root > /dev/null 2>&1
}

function is_git_repository {
	git branch > /dev/null 2>&1
}

function get_git_changes () {
	# How many files are in the staging area (s), modified in the working tree (w) and untracked (u) ?
	local git_status_porc="$(git status --porcelain 2> /dev/null)"
	local git_changes_staging_area=$(echo "$git_status_porc" | grep -e "^[MADRC]." | wc -l 2> /dev/null)
	local git_changes_working_tree=$(echo "$git_status_porc" | grep -e "^.[DM]" | wc -l 2> /dev/null)
	local git_changes_untracked=$(echo "$git_status_porc" | grep -e '??' | wc -l 2> /dev/null)

	[[ $git_changes_staging_area -gt 0 ]] && vcs_changes="${vcs_changes}${git_changes_staging_area}s"
	[[ $git_changes_working_tree -gt 0 ]] && vcs_changes="${vcs_changes}${git_changes_working_tree}w"
	[[ $git_changes_untracked -gt 0 ]] && vcs_changes="${vcs_changes}${git_changes_untracked}u"
}

function get_git_remote () {
	# Set arrow icon based on status against remote.
	local remote_pattern="# Your branch is (.*) of"
	local diverge_pattern="# Your branch and (.*) have diverged"
	local remote
	if [[ ${git_status} =~ ${remote_pattern} ]]; then
		if [[ ${BASH_REMATCH[1]} == "ahead" ]]; then
			remote="↑"
		else
			remote="↓"
		fi
	else
		remote=""
	fi
	if [[ ${git_status} =~ ${diverge_pattern} ]]; then
		remote="↕"
	fi
	vcs_additional="$remote"
}

function get_git_branch () {
	# Get the name of the branch.
	local branch_pattern="^# On branch ([^${IFS}]*)"
	if [[ ${git_status} =~ ${branch_pattern} ]]; then
		branch=${BASH_REMATCH[1]}
	else
		# Not on a branch
		# Try to find a branch that contains this commit, mark in yellow
		branch=$(git describe --contains --all HEAD 2> /dev/null)
		local error_code=$?
		branch="${yellow}${branch}${normal}"
		if [[ $error_code -gt 0 ]]; then
			# Commit is completely detached, show SHA1 in red
			branch=$(git rev-parse --short HEAD 2> /dev/null)
			branch="${red}${branch}${normal}"
		fi
	fi
}

function get_git_prompt_vars {
	# Capture the output of the "git status" command.
	local git_status="$(git status 2> /dev/null)"

	vcs_symbol="±"
	get_git_changes
	get_git_remote
	get_git_branch
}

function get_hg_changes () {
# How many files are modified (m), untracked (u), ... ?
	local hg_commit_line=$(echo "$hg_summary" | grep -e '^commit' 2> /dev/null)
	vcs_changes=$(echo $hg_commit_line | sed 's/\(\([0-9]\+\) \(.\)\)\?[^0-9]*/\2\3/g' 2> /dev/null)
}

function get_hg_bookmark_or_branch () {
	# Show bookmark instead of branch name if active bookmark exists
	local bookmarks=$(echo "$hg_summary" | grep -e "^bookmarks:" | sed 's/bookmarks://' 2> /dev/null)
	local bookmark=$(echo "$bookmarks" | sed 's/[^*]\<\S\+//g; s/[*]//g')
	if [[ -n "$bookmark" ]]; then
		branch="$bookmark"
		return
	fi
	branch=$(echo "$hg_summary" | grep -e "^branch:" | sed 's/branch: //' 2> /dev/null)
	if [[ -z $branch ]]; then
		branch="<unknown branch>"
	fi
	# Mark branch yellow if not a head revision (and no bookmark)
	local id=$(echo "$hg_summary" | grep -e "^parent:" | sed 's/^parent:.*:\([0-9a-f]\+\).*/\1/' 2> /dev/null)
	#   Check whether id is in list of heads
	hg heads | grep changeset | grep -q ${id}
	local id_in_heads=$?
	if [[ $id_in_heads -gt 0 ]]; then
		branch="${yellow}${branch}${normal}"
	fi
}

function get_hg_prompt_vars {
	# Capture the output of the "hg status" command.
	local hg_summary="$(hg summary 2> /dev/null)"

	vcs_symbol="☿"
	vcs_additional=""
	get_hg_changes
	get_hg_bookmark_or_branch
}


function set_vcs_prompt () {
	local vcs_symbol branch vcs_changes vcs_remote
	if is_git_repository ; then
		get_git_prompt_vars
	elif is_hg_repository ; then
		get_hg_prompt_vars
	else
		VCS=''
		return
	fi
	[[ -n $vcs_changes ]] && vcs_changes=":${vcs_changes}"
	VCS="(${vcs_symbol}${branch}${vcs_changes})${vcs_additional}"
}

# Return the prompt symbol to use, colorized based on the return value of the
# previous command.
function set_prompt_symbol () {
	if test $1 -eq 0 ; then
		PROMPT_SYMBOL="${yellow}\$"
	else
		PROMPT_SYMBOL="${red}\$"
	fi
}

# Determine active Python virtualenv details.
function set_virtualenv () {
	if test -z "$VIRTUAL_ENV" ; then
		PYTHON_VIRTUALENV=""
	else
		local virtualenv=$(basename "$VIRTUAL_ENV")
		PYTHON_VIRTUALENV="${blue}[${virtualenv}]${normal}"
	fi
}


function set_bash_prompt () {
	local last_exit_status=$?
	local bold underline standout normal black red green yellow blue magenta cyan white
	ORIGTERM="${TERM}"
	local TERM
	local USER AT HOST COLON DIR RESET SPACE PROMPT_SYMBOL PYTHON_VIRTUALENV VCS

	set_colors
	set_prompt_symbol $last_exit_status
	set_virtualenv

	set_vcs_prompt

	USER="${cyan}\u"
	AT="${normal}@"
	HOST="${magenta}\h"
	COLON="${normal}:"
	DIR="${normal}${bold}\w${normal}"
	RESET="${normal}"
	SPACE=" "

	case $ORIGTERM in
		screen | xterm | xterm-256color | gnome-256color )
			SET_TERMINAL_TITLE="\[\033]0;\u@\h: \w\007\]"
				;;
		screen.linux | linux )
			SET_TERMINAL_TITLE=""
			;;
		* )
			SET_TERMINAL_TITLE="<try to set or unset terminal title in ~/.bash_prompt>"
			;;
	esac

	PS1="${SET_TERMINAL_TITLE}${PYTHON_VIRTUALENV}${USER}${AT}${HOST}${COLON}${DIR}"
	PS1="${PS1}${VCS}${PROMPT_SYMBOL}${RESET}${SPACE}"
}

PROMPT_COMMAND=set_bash_prompt
