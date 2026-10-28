# Detect OS type.
# Used for OS-specifc settings.
local OS_TYPE=$(uname)

# Custom PATH defintions.

if [[ "$OS_TYPE" == "Darwin" ]]; then
  # Default user-installed binaries.
  export PATH="$PATH:$HOME/.local/bin"

  # Map llvm toolchain installed from Homebrew.
  export PATH="$(brew --prefix llvm)/bin:$PATH"

  # Map ruby version installed from Homebrew.
  export PATH="$(brew --prefix ruby)/bin:/opt/homebrew/lib/ruby/gems/4.0.0/bin:$PATH"
  export PATH="$(brew --prefix ruby@3.2)/bin:$PATH"

fi

# `bun`
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Custom scripts bin directory.
export PATH="$HOME/Scripts/bin:$PATH"

# Alias definitions.
# `ls` aliases.
alias ls="ls -lhG"
alias la= "ls -a"

if [[ "$OS_TYPE" == "Linux" ]]; then
  alias ls="ls -lh --color=auto"  
fi

# Map `code` to VS-Code.
if [[ "$OS_TYPE" == "Darwin" ]]; then
  alias code="/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code"
fi

# `claude` aliases.
alias claude-d="claude --dangerously-skip-permissions"

# Make sure `python` is mapped to `python3`.
alias python="python3"

# Start and attach to a new tmux session or attach to an existing one.
# This will always open tmux by default, without leaving orphan sessions.

if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
  tmux attach || exec tmux new-session
  exit
fi

# Custom commands.
# Get process from full-format `ps` snapshot.
peg() {
  ps -ef | grep $1
}

# Use `prettier` from the CLI when installed through VS-Code.
prettier() {
  local -a paths
  paths=(
    "$HOME"/.vscode{,-server}/extensions/*/node_modules/prettier/bin/prettier.cjs(N)
  )

  if (( ${#paths} == 0 )); then
    echo "Prettier not found" >&2
    return 1
  fi

  node "${paths[-1]}" "$@"
}

# TAB complete system init.
autoload -Uz compinit && compinit -C

# Shell TAB completions.
# `bun` completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
