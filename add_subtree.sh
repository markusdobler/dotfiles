#!/bin/bash

function die () {
	local errorcode=$1
	local msg=$2
	echo "${msg}"
	exit ${errorcode}
}

case $# in
	2 )
		remote_path=$1
		local_prefix=$2
		remote_branch="master"
		;;
	3 )
		remote_path=$1
		local_prefix=$2
		remote_branch=$3
		;;
	* )
		echo "usage: $0 <remote_path> <local_prefix> [remote_branch]"
		exit 1
esac

this_script_file=$(readlink -e $0)
# use subshell to move to toplevel and add subtree
(
echo "going to toplevel of working tree"
cd $(git rev-parse --show-toplevel) || die 1 "Can't change to toplevel"
echo "some sanity checks to make sure we're in the right repository and the local prefix is set correctly"
[ ${this_script_file} -ef add_subtree.sh ] || die 2 "This doesn't seem to be the repository this script lives in"
[ -z "${local_prefix}" ] && die 3 "<local_prefix> not set"
[ -e "${local_prefix}" ] && die 4 "'${local_prefix}' already exists"
parent=$(dirname "${local_prefix}")
[ -d ${parent} ] || die 5 "Please create directory '${parent}' first"

echo "adding branch ${remote_branch} of ${remote_path} as subtree in ${local_prefix}"
git subtree add --prefix ${local_prefix} ${remote_path} ${remote_branch} --squash
exitcode=$?
if [ ${exitcode} -gt 0 ]; then
	echo "failed to add subtree, exit code: ${exitcode}"
	exit ${exitcode}
else
	update_script="${local_prefix}/update_subtree.sh"
	if [ -e ${update_script} ]
	then
		update_script=$(mktemp -u "${local_prefix}/update_subtree_XXX.sh")
	fi
	echo "adding update command to ${update_script}:"
	(	echo "#! /bin/bash"
		echo "#"
		echo "# This is a git subtree from ${remote_path}.  Update with:"
		echo "git subtree pull --prefix ${local_prefix} ${remote_path} ${remote_branch} --squash"
	) | tee "${update_script}"
	git add  "${update_script}"
	git commit --amend -C HEAD "${update_script}"
fi
)
