# ~/.config/bash/functions.sh
# Sourced from ~/.bashrc (interactive shells only).

# Interactive directory picker from zoxide history: Alt+D
c() {
    local dir

    dir="$(zoxide query -l | fzf \
        --height=40% \
        --reverse \
        --preview 'if command -v eza >/dev/null 2>&1; then eza -TL 1 --color=always {}; else ls -la --color=always {}; fi' \
        --bind 'ctrl-j:down,ctrl-k:up,enter:accept')" || return 0

    [[ -n "$dir" ]] && cd -- "$dir"
}

# Live content search (ripgrep + fzf), opens the match in the editor: Alt+G
rgi() {
    local rg_cmd='rg --hidden --column --line-number --no-heading --color=always --smart-case'
    local selection file line

    selection="$(
        fzf --ansi --disabled --query "${*:-}" \
            --height=70% --reverse \
            --bind "start:reload:$rg_cmd {q} || true" \
            --bind "change:reload:sleep 0.1; $rg_cmd {q} || true" \
            --delimiter : \
            --preview 'bat --color=always --highlight-line {2} {1}' \
            --preview-window 'right,55%,+{2}+3/3,~3'
    )" || return 0

    [[ -z "$selection" ]] && return 0

    file="$(cut -d: -f1 <<<"$selection")"
    line="$(cut -d: -f2 <<<"$selection")"

    ${EDITOR:-lvim} "+$line" -- "$file"
}

# Key bindings: clear the line, run the function as a normal command,
# so the prompt is rebuilt afterwards. The leading space keeps it out of history.
bind '"\ed": "\C-e\C-u c\C-m"'
bind '"\eg": "\C-e\C-u rgi\C-m"'
