# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
PATH="$PATH:$HOME/tools"
PATH="$PATH:$HOME/tools/lua-language-server-3.6.4-linux-x64/bin"
PATH="$PATH:$HOME/tools/jdt-language-server-1.9.0-202203031534/bin"
PATH="$PATH:$HOME/scripts"
export PATH

# aliases
alias ptask='task project:$(git rev-parse --show-toplevel | xargs basename)'

# add fzf keybindings
if [ -x "$(command -v fzf)"  ]
then
    source /usr/share/fzf/shell/key-bindings.bash
fi

# bind ctrl-f to the tmux session switcher
bind -x '"\C-f": "selectProject.sh"'

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc
