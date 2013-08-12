case $# in
	1 )
		path=$1
		name=$(echo "$path" | sed 's!^.*/!!; s/.git$//')
		remote_branch="master"
		;;
	2 )
		path=$1
		name=$2
		remote_branch="master"
		;;
	3 )
		path=$1
		name=$2
		remote_branch=$3
		;;
	* )
		echo "usage: $0 <path> [local_name [remote_branch]]"
		exit 1
esac

this_script_file=$(readlink -e $0)
# use subshell to move to toplevel and add subtree
(
echo "going to toplevel of working tree"
cd $(git rev-parse --show-toplevel) || exit 1
echo "some sanity checks to make sure we're in the right repository"
[ -x _vim/bundle/update.sh ] || exit 2
[ $this_script_file -ef _vim/bundle/add_vimbundle.sh ] || exit 3 

pwd
echo "adding branch ${remote_branch} of ${path} as subtree in _vim/bundle/${name}"
git subtree add --prefix _vim/bundle/${name} ${path} ${remote_branch} --squash
if [ $? -gt 0 ]; then
	exitcode=$?
	echo "failed to add subtree, exit code: ${exitcode}"
	exit ${exitcode}
else
	echo "adding update command to _vim/bundle/update.sh:"
	echo "git subtree pull --prefix _vim/bundle/${name} ${path} ${remote_branch} --squash" | tee -a _vim/bundle/update.sh
fi
)
