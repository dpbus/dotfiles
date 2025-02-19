FILES="gemrc gitconfig tmux.conf vimrc_local zprofile zshrc"

for f in $FILES
do
  echo "Symlinking $f to ~/.$f"
  ln -si "$PWD/$f" "$HOME/.$f"
done

echo "Symlinking ghostty to ~/.config/"
ln -si "$PWD/ghostty" "$HOME/.config"

git clone https://github.com/braintreeps/vim_dotfiles.git ~/.vim

echo "Cloning github repos to ~/Projects/"
cd ~/Projects
PAGE=1
curl "https://api.github.com/users/dpbus/repos?page=$PAGE&per_page=100" |
  grep -e 'ssh_url*' |
  cut -d \" -f 4 |
  xargs -L1 git clone

echo "DONE!"
