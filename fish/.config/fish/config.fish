set -x TMPDIR /home/alex24/tmp
if status is-interactive
    # Commands to run in interactive sessions can go here
end

if test -f ~/.config/fish/aliases.fish
	    source ~/.config/fish/aliases.fish
end

fish_add_path ~/.config/composer/vendor/bin
fish_add_path /home/alex24/.config/composer/vendor/bin
fish_add_path /home/alex24/vendor/bin

zoxide init fish | source

bind \ed 'c'
bind \ef 'fsearch'
set -x FZF_DEFAULT_OPTS '--bind=ctrl-j:down,ctrl-k:up'
bind \cj down-or-search
bind \ck up-or-search

set -x GEMINI_API_KEY "AIzaSyAd5YcGO7CuikqP1TU5urF7S_H7jjCgsMw"
abbr -a ai gemini-cli
abbr -a grok python3 ~/grok.py

alias cs6 "WINEPREFIX=~/.wine32 wine '/home/alex24/.wine/dosdevices/c:/Program Files/Adobe/Adobe Photoshop CS6 (64 Bit)/Photoshop.exe'"

# opam configuration
source /home/alex24/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true

starship init fish | source
navi widget fish | source

function rgrep
    if test -z "$argv"
        echo "Usage: rgrep <search_term>"
        return 1
    end
    
    set query $argv[1]
    
    set result (rg --color=always -n "$query" | \
        fzf --ansi \
            --preview-window="right:60%" \
            --preview "bat --color=always --highlight-line {2} {1}")
    
    if test -n "$result"
        set file (echo $result | cut -d: -f1)
        set line (echo $result | cut -d: -f2)
        lvim "$file" +"$line"
    end
end

alias rfind='rg --files | fzf --preview "bat --color=always {}" --bind "enter:execute(lvim {})"'

bind \cf 'rgrep (read -P "Search: ")'
bind \cg 'rfind'




if status is-interactive
    atuin init fish | source
end
