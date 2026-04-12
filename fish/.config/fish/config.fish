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



if status is-interactive
    atuin init fish | source
end
