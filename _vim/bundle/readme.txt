http://endot.org/2011/05/18/git-submodules-vs-subtrees-for-vim-plugins/

git subtree add --prefix _vim/bundle/powerline https://github.com/markusdobler/vim-powerline.git  master --squash
git subtree pull --prefix .vim/bundle/vim-fugitive https://github.com/tpope/vim-fugitive.git master --squash
