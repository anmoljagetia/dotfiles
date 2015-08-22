# !/bin/bash
###########################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
###########################

######### Variables

dir=~/dotfiles                    # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory
files="atom
	icons
	node/npmrc
	zsh/oh-my-zsh
	zsh/zshrc
	vim/vim
	vim/vimrc
	tmux/tmux.conf
	tmux/tmux
	git/gitconfig
	bash/bashrc
	mongo/mongorc.js
	heroku/netrc
"    # list of files/folders to symlink in homedir
##########

# create dotfiles_old in homedir
echo -n "Creating $olddir for backup of any existing dotfiles in ~ ..."
mkdir -p $olddir
echo "done"

# change to the dotfiles directory
echo -n "Changing to the $dir directory ..."
cd $dir
echo "done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks from the homedir to any files in the ~/dotfiles directory specified in $files
for file in $files; do
	f=${file}
	f=${f##*/}
    echo "Moving any existing dotfiles from ~ to $olddir"
    mv ~/.$f ~/dotfiles_old/
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/.$f
done

bin_dir=~/dotfiles/bin
