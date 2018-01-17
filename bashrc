# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=100000
HISTFILESIZE=200000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='\[\033[01;32m\][\D{%d %b %T}] ${debian_chroot:+($debian_chroot)}\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
    ;;
*)
    ;;
esac

# Update bash history after every command
export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
alias hcl='history -c; history -r;' # re-read history file

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ] && [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto -h'
    #alias dir='ls --color=auto --format=vertical'
    #alias vdir='ls --color=auto --format=long'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi
export EDITOR=/usr/bin/vim

export PATH=$PATH:$HOME/bin

if [ "$PS1" != "" -a "${STARTED_TMUX:-x}" = x -a "${SSH_TTY:-x}" != x ]; then
    STARTED_TMUX=1; export STARTED_TMUX
    DATE=`date +"%a_%H․%M"`
    FIRST_UNATTACHED=`tmux list-session | grep -v attached | perl -ne '/(^.+?):/ && (print "$1") && exit'`
    if [ "$FIRST_UNATTACHED" ]; then
        tmux attach-session -t $FIRST_UNATTACHED && exit 0
    else
        tmux new-session -s $DATE && exit 0
    fi
    echo "tmux failed to start"
fi


export LESSCHAR=utf8

# GPG-AGENT
which gpg-agent > /dev/null
if [ "$?" -eq 0 ]; then
 if test -f $HOME/.gpg-agent-info && kill -0 `cut -d: -f 2 $HOME/.gpg-agent-info` 2>/dev/null; then
 export GPG_AGENT_INFO=`cat $HOME/.gpg-agent-info`
 elif [ -d ~/.gnupg ]; then
 eval `gpg-agent --daemon --default-cache-ttl 86400 --max-cache-ttl 700000`
 echo $GPG_AGENT_INFO >$HOME/.gpg-agent-info
 fi
 export GPG_TTY=`tty`
fi
# / GPG-AGENT

# https://github.com/junegunn/fzf#installation
if [ -f ~/.fzf.bash ]; then
    source ~/.fzf.bash
    export FZF_DEFAULT_COMMAND='ag -g ""'
    export FZF_TMUX=1
    export FZF_TMUX_HEIGHT="40%"
    export FZF_CTRL_T_OPTS="--select-1 --exit-0"

    _fzf_compgen_path() {
        ag -g "" "$1"
    }

    _gen_fzf_default_opts() {
        local base03="234"
        local base02="235"
        local base01="240"
        local base00="241"
        local base0="244"
        local base1="245"
        local base2="254"
        local base3="230"
        local yellow="136"
        local orange="166"
        local red="160"
        local magenta="125"
        local violet="61"
        local blue="33"
        local cyan="37"
        local green="64"

        # Solarized Dark color scheme for fzf
        export FZF_DEFAULT_OPTS="
        --color fg:-1,bg:-1,hl:$blue,fg+:$base2,bg+:$base02,hl+:$blue
        --color info:$yellow,prompt:$yellow,pointer:$base3,marker:$base3,spinner:$yellow
        "
    }
    _gen_fzf_default_opts
fi
# End of fzf

. ~/bin/z.sh
