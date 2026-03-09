# ------------------------------------------------------------
# oh-my-zsh installation directory
# ------------------------------------------------------------

export ZSH="$HOME/.oh-my-zsh"

# ------------------------------------------------------------
# oh-my-zsh plugins
# ------------------------------------------------------------

plugins=(
  git
  fzf
  zsh-autocomplete
  zsh-autosuggestions
  zsh-history-substring-search
  zsh-syntax-highlighting
)

if [[ -f "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
else
  echo "oh-my-zsh is not installed at $ZSH. Run ./install.sh." >&2
fi

# ------------------------------------------------------------
# plugin colours
# ------------------------------------------------------------

# zsh-autosuggestions:
# soft grey suggestion text
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#666666"

# zsh-syntax-highlighting:
# keep most things neutral, use red for errors
typeset -A ZSH_HIGHLIGHT_STYLES

# default text
ZSH_HIGHLIGHT_STYLES[default]='fg=#bbbbbb'

# commands that exist
ZSH_HIGHLIGHT_STYLES[command]='fg=#bbbbbb'

# builtins / aliases / functions
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#aaaaaa'
ZSH_HIGHLIGHT_STYLES[alias]='fg=#aaaaaa'
ZSH_HIGHLIGHT_STYLES[function]='fg=#aaaaaa'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#aaaaaa'

# paths and arguments
ZSH_HIGHLIGHT_STYLES[path]='fg=#999999'
ZSH_HIGHLIGHT_STYLES[arg0]='fg=#bbbbbb'

# strings / quotes
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#888888'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#888888'

# options / flags
ZSH_HIGHLIGHT_STYLES[option]='fg=#999999'

# unknown / bad commands in red
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red,bold'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#777777'

# history substring search colours
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='fg=#aaaaaa,bold'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='fg=red,bold'

# ------------------------------------------------------------
# history configuration
# ------------------------------------------------------------

setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_VERIFY

# ------------------------------------------------------------
# completion configuration
# ------------------------------------------------------------

# case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# interactive completion menu
zstyle ':completion:*' menu select

# ------------------------------------------------------------
# terminal title
# ------------------------------------------------------------

precmd() { print -Pn "\e]0;%~ (%b)\a" }

# ------------------------------------------------------------
# shell tools
# ------------------------------------------------------------

if ! command -v fd >/dev/null 2>&1 && command -v fdfind >/dev/null 2>&1; then
  alias fd="fdfind"
fi

command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"
command -v atuin >/dev/null 2>&1 && eval "$(atuin init zsh)"
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"

# ------------------------------------------------------------
# local machine-specific overrides
# ------------------------------------------------------------

[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
