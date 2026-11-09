# Detect OS type.
# Used for OS-specifc settings.
local OS_TYPE=$(uname)

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

# Run a reverse ssh tunnel from within a VM to the host.
# Use to forward ports from the VM to the host, example: `rssh 5173 npm run dev`.
rssh() {
    local port="$1"
    shift

    [[ -n "$SSH_CONNECTION" ]] || {
        echo "No SSH connection detected" >&2
        return 1
    }

    local host_ip="${SSH_CONNECTION%% *}"
    local host_user="paolo"
    local target="${host_user}@${host_ip}"

    # Automatically trust new host keys and verify authentication
    ssh -o StrictHostKeyChecking=accept-new \
        -o BatchMode=yes \
        -o ConnectTimeout=5 \
        "$target" true || return 1

    # Start reverse tunnel
    ssh -NT \
        -o BatchMode=yes \
        -o StrictHostKeyChecking=accept-new \
        -o ExitOnForwardFailure=yes \
        -R "127.0.0.1:${port}:127.0.0.1:${port}" \
        "$target" &

    local tunnel_pid=$!

    {
        "$@"
    } always {
        kill "$tunnel_pid" 2>/dev/null || true
        wait "$tunnel_pid" 2>/dev/null || true
    }
}

# Run once on the host to let a VM use rssh.
rssh-authorize() {
    local vm="$1"
    [[ -n "$vm" ]] || {
        echo "Usage: rssh-authorize user@vm" >&2
        return 1
    }

    # Get the VM's public key, creating one if needed
    local pubkey
    pubkey="$(ssh "$vm" '
        mkdir -p ~/.ssh && chmod 700 ~/.ssh
        [ -f ~/.ssh/id_ed25519 ] || ssh-keygen -q -t ed25519 -N "" -f ~/.ssh/id_ed25519
        cat ~/.ssh/id_ed25519.pub
    ')" || return 1

    [[ -n "$pubkey" ]] || {
        echo "Could not get the VM's public key" >&2
        return 1
    }

    # This key can open tunnels, but can't get a shell on the host
    local entry="command=\"true\",restrict,port-forwarding $pubkey"
    local auth="$HOME/.ssh/authorized_keys"

    mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh"
    touch "$auth" && chmod 600 "$auth"
    grep -qxF -- "$entry" "$auth" || print -r -- "$entry" >> "$auth"

    echo "Authorized $vm for rssh"
}

# TAB complete system init.
autoload -Uz compinit && compinit -C

# Shell TAB completions.
# `bun` completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Custom prompt.
PROMPT='%n@%m %1~ %# '
