# dotfiles

> My Linux configuration files

Applies to Debian-based distributions like Linux Mint 19 or Kali 2019 with i3 on MacBook Pro 13" Retina (2015).

Refer to [The best way to store your dotfiles: A bare Git repository](https://www.atlassian.com/git/tutorials/dotfiles) for tips on how to simplify dotfiles management. I only replaced the `config` alias with a more meaningful and less ambiguous `dotfiles` alias, like:

```
git init --bare $HOME/.cfg
alias dotfiles='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
dotfiles config --local status.showUntrackedFiles no
cat <<EOT >> $HOME/{.bashrc,.zshrc}

# Simplify dotfiles management
alias dotfiles='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'"
EOT
```
