FILES="gemrc gitconfig zshrc"

for f in $FILES
do
  echo "Symlinking $f to ~/.$f"
  ln -si "$PWD/$f" "$HOME/.$f"
done

echo "DONE!"
