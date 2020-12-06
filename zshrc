export LANG="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LC_MONETARY="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_TIME="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export EDITOR=noa

bindkey -e

fpath+=(~/.zsh/zsh-completions/src)
path=(
    "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
    $HOME/bin(N-/)
    $HOME/usr/bin(N-/)
    $HOME/.cargo/bin(N-/)
    /usr/local/opt/llvm/bin/(N-/)
    /usr/local/bin(N-/)
    /usr/local/sbin(N-/)
    /usr/X11(N-/)
    /Library/Tex/texbin(N-/)
    /usr/games(N-/)
    /usr/bin(N-/)
    /usr/sbin(N-/)
    /snap/bin(N-/)
    /bin(N-/)
    /sbin(N-/)
)

HISTFILE=~/.zshhist
HISTSIZE=10000
SAVEHIST=10000
REPORTTIME=60

alias as="a;s"
alias s="ls -F --color"
alias ss="ls -Falh --color"
alias c=" clear"
alias v="vim"
alias m="make"
alias a="cd"
alias p="popd"
alias q=" exit"
alias t="tmux -u"
alias ta="tmux attach"
alias td=" tmux detach"
alias tn="tmux renamew"
alias g="git"
alias gs=" g s"
alias tig="tig --all"
alias tree="tree -CphuN"
alias le="less -R --tabs=4 --no-init --LONG-PROMPT --ignore-case"
alias gr="grep --color"
alias du="du -h"
alias hd="hexdump -C"
alias a2l="addr2line -Cfipe"
alias py="ipython3"
alias r="rails"
alias f=fdfind
alias b="bundle exec"
alias ag="ag -t"
alias rrr="reset; stty susp undef"
alias z=" cd .."
alias zz=" cd ../.."
alias zzz=" cd ../../.."
alias zzzz=" cd ../../../.."
alias zzzzz=" cd ../../../../.."
alias sudo="sudo -E "
alias halt="sudo halt -p"
alias reboot="sudo reboot -p"
alias gdb="gdb -q"

if [ "$(uname)" = "Darwin" ]; then
    alias tac="tail -r"
    alias o="open"
    alias ls="gls"
    alias tar="gtar"
    alias find="gfind"
    alias dircolors="gdircolors"
    alias docker-up='docker-machine start default; eval "$(docker-machine env default)"'
fi

autoload -Uz colors vcs_info compinit select-word-style
colors
compinit -c

select-word-style bash

if [[ "$(hostname)" = *Mac*.local ]]; then
    PROMPT="%{$fg[cyan]%}%~%{$reset_color%} %{$fg[red]%}%(?..<%?> )%{$reset_color%}%1(v|%F{green}%1v%f|) %E
$ %b"
else
    PROMPT="%{$fg[red]%}${HOST}%{$reset_color%} %{$fg[cyan]%}%~%{$reset_color%} %{$fg[red]%}%(?..<%?> )%{$reset_color%}%1(v|%F{green}%1v%f|) %E
$ %b"
fi

zstyle ':vcs_info:*' enable hg git svn
zstyle ':vcs_info:*' formats '[%b] '
zstyle ':vcs_info:*' actionformats '[%b|%a] '

stty susp undef

setopt no_beep print_eight_bit
setopt auto_cd auto_pushd
setopt append_history extended_history hist_ignore_dups
setopt hist_ignore_space hist_reduce_blanks inc_append_history
setopt auto_list auto_menu auto_param_slash auto_remove_slash
setopt list_types list_packed
setopt magic_equal_subst equals mark_dirs combining_chars
unset promptcr

source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
eval `dircolors ~/.zsh/dircolors-solarized/dircolors.ansi-light`
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

zstyle ':completion:*' use-cache true
zstyle ':completion:*:default' menu select=2
zstyle ':completion:*:*files'  ignored-parents parent pwd
zstyle ':completion:*:*:(vim):*'  ignored-patterns '*~' '~*'
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:cd:*' directories
zstyle ':completion:*:cd:*' ignore-parents parent pwd
zstyle -e ':completion:*:sudo:*' command-path 'reply=($path)'
zstyle ':completion:*:ping:*' hosts amazonaws.com 8.8.8.8
zstyle ':completion:*:processes' command "ps -u $USER -o pid,stat,%cpu,%mem,cputime,command"

precmd (){
    psvar=()
    vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}

touchx() {
    touch $1
    chmod +x $1
}

man() {
    env \
        LESS_TERMCAP_mb=$(printf "\e[1;34m") \
        LESS_TERMCAP_md=$(printf "\e[1;34m") \
        LESS_TERMCAP_me=$(printf "\e[0m") \
        LESS_TERMCAP_se=$(printf "\e[0m") \
        LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
        LESS_TERMCAP_ue=$(printf "\e[0m") \
        LESS_TERMCAP_us=$(printf "\e[1;32m") \
            man "$@"
}

[ -f ~/.zshlocal ] && source ~/.zshlocal
true
