path=(
    $HOME/bin
    $HOME/usr/bin
    $HOME/.cargo/bin
    /opt/homebrew/bin
    /opt/homebrew/opt/llvm/bin
    /opt/homebrew/opt/openjdk/bin
    /usr/local/opt/llvm/bin
    /usr/local/bin
    /usr/local/sbin
    /usr/bin
    /usr/sbin
    /snap/bin
    /bin
    /sbin
)

alias as="a;s"
alias s="ls -F --color"
alias ss="ls -Falh --color"
alias e="nvim"
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
alias le="less -R --tabs=4 --no-init --LONG-PROMPT --ignore-case"
alias gr="grep --color"
alias hd="hexdump -C"
alias rrr="reset; stty susp undef"
alias z=" cd .."
alias zz=" cd ../.."
alias zzz=" cd ../../.."
alias zzzz=" cd ../../../.."
alias zzzzz=" cd ../../../../.."
alias sudo="sudo -E "
alias gdb="gdb -q"

if [ "$(uname)" = "Darwin" ]; then
    export HOMEBREW_NO_INSTALL_CLEANUP=1
    export HOMEBREW_NO_ANALYTICS=1

    alias o="open"
    alias ls="gls"
    alias tar="gtar"
    alias find="gfind"
    alias dircolors="gdircolors"
fi

autoload -Uz colors vcs_info compinit select-word-style
colors

if [[ "$HOME" = "/Users/seiya" ]]; then
    PROMPT="%{$fg[cyan]%}%~%{$reset_color%} %{$fg[red]%}%(?..<%?> )%{$reset_color%}%1(v|%F{green}%1v%f|) %E
$ %b"
else
    PROMPT="%{$fg[red]%}${HOST}%{$reset_color%} %{$fg[cyan]%}%~%{$reset_color%} %{$fg[red]%}%(?..<%?> )%{$reset_color%}%1(v|%F{green}%1v%f|) %E
$ %b"
fi

zstyle ':vcs_info:*' enable hg git svn
zstyle ':vcs_info:*' formats '[%b] '
zstyle ':vcs_info:*' actionformats '[%b|%a] '

fpath=(~/.zsh/completion /usr/local/share/zsh/site-functions $fpath)

HISTFILE=~/.zshhist
HISTSIZE=10000
SAVEHIST=10000
REPORTTIME=60

bindkey -e
select-word-style bash

setopt no_beep print_eight_bit
setopt extendedglob
setopt autocd autopushd pushdminus pushdsilent pushdtohome cdablevars
setopt append_history extended_history hist_ignore_dups
setopt hist_ignore_space hist_reduce_blanks inc_append_history
setopt auto_list auto_menu auto_param_slash auto_remove_slash
setopt list_types list_packed
setopt magic_equal_subst equals mark_dirs combining_chars interactive_comments

unsetopt nomatch

zstyle ':completion:*' use-cache true
zstyle ':completion:*:default' menu select=2
zstyle ':completion:*:*files'  ignored-parents parent pwd
zstyle ':completion:*:cd:*' directories
zstyle ':completion:*:cd:*' ignore-parents parent pwd

precmd (){
    psvar=()
    vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}

touchx() {
    touch $1
    chmod +x $1
}

if [[ -n $HOME/.zcompdump(#qN.mh+120) ]]; then
  compinit -d $HOME/.zcompdump
else
  compinit -C
fi;

source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
eval `dircolors ~/.zsh/dircolors-solarized/dircolors.ansi-light`
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

if [[ -f ~/.zshrc.local ]]; then
  source ~/.zshrc.local
fi

true
