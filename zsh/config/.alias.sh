# Misc
alias sudo='doas'
alias cp='cp -v'

alias cat='bat'
alias cap='bat --plain'

alias ls='eza --group-directories-first'

alias ll='ls -l'
alias la='ll -lah'

alias grep='rg'

# Systemd
alias sc='sudo systemctl'
alias scu='systemctl --user'

# Git aliases
alias gco='git checkout'
alias gls='git status'
alias gl='git log --topo-order --stat --pretty=format:"${_git_log_medium_format}"'
alias glg='git log --topo-order --all --graph --pretty=format:"${_git_log_oneline_format}"'
alias gap='git add --patch'
alias gd='git diff'
alias gdc='git diff --cached'
alias ggi='git commit'
alias ggia='git commit --amend --no-edit'
alias ggiae='git commit --amend'
alias gri='git rebase --interactive'

# Docker
alias d='docker'
alias dc='docker compose'
