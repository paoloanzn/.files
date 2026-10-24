# Created by `pipx` on 2025-01-23 14:27:48
export PATH="$PATH:/Users/paolo/.local/bin"

# Alias

() {
    local OS_TYPE=$(uname)

    if [[ "$OS_TYPE" == "Darwin" ]]; then
        # MACOS
        alias ls="ls -lhG"
        alias code="/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code"
        alias brew-clang="$(brew --prefix llvm)/bin/clang"
        export PATH="$(brew --prefix llvm)/bin:$PATH"

    elif [[ "$OS_TYPE" == "Linux" ]]; then
        # LINUX
        alias ls="ls -lh --color=auto"
    fi

    # UNIVERSAL
    alias claude-d="claude --dangerously-skip-permissions"
    alias src="source ~/.zshrc"
    alias note="cd ~/Documents/notes && vim"
    alias notes="cd ~/Documents/notes && ls"
    alias cfg="vim ~/.zshrc"
    alias python="python3"
    #alias yolo="claude --permission-mode=bypassPermissions"
    
    if [ -z "$TMUX" ] && [ "$TERM" = "xterm-kitty" ]; then
      tmux attach || exec tmux new-session && exit;
    fi
}

# bun completions
[ -s "/Users/paolo/.bun/_bun" ] && source "/Users/paolo/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# scripts
export PATH="/Users/paolo/scripts/bin:$PATH"

# Prompt
# PROMPT="%F{46}%n%f%F{46}@%f%F{46}%m%f %B%F{33}%d%f%b %?>"
export PATH="/opt/homebrew/opt/ruby/bin:/opt/homebrew/lib/ruby/gems/4.0.0/bin:$PATH"
export PATH="/opt/homebrew/opt/ruby@3.2/bin:$PATH"

autoload -Uz compinit && compinit -C


vterm_printf() {
    if [ -n "$TMUX" ] \
        && { [ "${TERM%%-*}" = "tmux" ] \
            || [ "${TERM%%-*}" = "screen" ]; }; then
        # Tell tmux to pass the escape sequences through
        printf "\ePtmux;\e\e]%s\007\e\\" "$1"
    elif [ "${TERM%%-*}" = "screen" ]; then
        # GNU screen (screen, screen-256color, screen-256color-bce)
        printf "\eP\e]%s\007\e\\" "$1"
    else
        printf "\e]%s\e\\" "$1"
    fi
}
