# Preferred editor for local and remote sessions
export EDITOR='nvim'

# Remove whole word with Shift+Backspace
bindkey '^H' backward-kill-word
bindkey '5~' kill-word

# Allow Ctrl-z to toggle between suspend and resume
function Resume {
  fg
  zle push-input
  BUFFER=""
  zle accept-line
}
zle -N Resume
bindkey "^Z" Resume
