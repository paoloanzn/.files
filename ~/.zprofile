# Detect OS type.
# Used for OS-specifc settings.
local OS_TYPE=$(uname)

# Custom PATH defintions.
if [[ "$OS_TYPE" == "Darwin" ]]; then
  # Init Homebrew environment variables.
  eval "$(/opt/homebrew/bin/brew shellenv)"

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

# MacPorts Installer addition on 2026-10-06_at_09:55:47: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.

