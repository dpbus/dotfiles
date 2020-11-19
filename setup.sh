FILES="gemrc gitconfig tmux.conf vimrc_local zshrc"

for f in $FILES
do
  echo "Symlinking $f to ~/.$f"
  ln -si "$PWD/$f" "$HOME/.$f"
done

git clone https://github.com/braintreeps/vim_dotfiles.git ~/.vim

echo "DONE!"
