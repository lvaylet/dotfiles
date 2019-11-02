# dotfiles

> My Linux configuration files

Applies to Debian-based distributions like Linux Mint 19 or Kali 2019 with i3 on MacBook Pro 13" Retina (2015).

Refer to [The best way to store your dotfiles: A bare Git repository](https://www.atlassian.com/git/tutorials/dotfiles) for tips on how to simplify dotfiles management. I only replaced the `config` alias with a more meaningful and less ambiguous `dotfiles` alias.

Install these dotfiles onto a new system with:
```
# Create and ignore folder where repo is going to be cloned to avoid weird recursion problems
mkdir $HOME/.cfg
echo ".cfg" >> $HOME/.gitgnore

# Clone dotfiles into bare repository
git clone --bare git@github.com:lvaylet/dotfiles.git $HOME/.cfg

# Define alias in current shell scope as well as .bashrc/.zshrc
alias dotfiles='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
cat <<EOT >> $HOME/{.bashrc,.zshrc}

# Simplify dotfiles management
alias dotfiles='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'"
EOT

# Check out the actual content from the bare repository
config checkout <branch-name>

# Ignore untracked files in this specific (local) repository
dotfiles config --local status.showUntrackedFiles no
```

Commit new or updated files with:
```
dotfiles status
dotfiles add .vimrc
dotfiles commit -m "add .vimrc"
dotfiles push
```
