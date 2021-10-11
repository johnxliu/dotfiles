#Profiling
#zmodload zsh/zprof
#
# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
ZSH_THEME="robbyrussell"

# Uncomment following line if you want to  shown in the command execution time stamp 
# in the history command output. The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|
# yyyy-mm-dd
# HIST_STAMPS="mm/dd/yyyy"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(autojump)

source $ZSH/oh-my-zsh.sh

# User configuration

export EDITOR="vim"
export VISUAL="vim"
bindkey -v

#jk as ESC
bindkey -M viins 'jk' vi-cmd-mode

#search options
bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward
bindkey '^P' history-search-backward
bindkey '^N' history-search-forward  

#ctrl+l to write new command
bindkey '^L' push-line

setopt CORRECT

#ls after cd
function chpwd() {
  emulate -L zsh
  ls 
}

#fasd
#eval "$(fasd --init posix-alias zsh-hook)"

eval `dircolors ~/local/dircolors-solarized/dircolors.256dark`

#aliases location
source $HOME/.aliases

[[ -s /home/jxla/.autojump/etc/profile.d/autojump.sh ]] && source /home/jxla/.autojump/etc/profile.d/autojump.sh
#
#autoload -U compinit && compinit -u
#
# On slow systems, checking the cached .zcompdump file to see if it must be 
# regenerated adds a noticable delay to zsh startup.  This little hack restricts 
# it to once a day.  It should be pasted into your own completion file.
#
# The globbing is a little complicated here:
# - '#q' is an explicit glob qualifier that makes globbing work within zsh's [[ ]] construct.
# - 'N' makes the glob pattern evaluate to nothing when it doesn't match (rather than throw a globbing error)
# - '.' matches "regular files"
# - 'mh+24' matches files (or directories or whatever) that are older than 24 hours.
autoload -Uz compinit 
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
	compinit;
else
	compinit -C;
fi;

#Dont know what the following does
precmd() { RPROMPT="" }
function zle-line-init zle-keymap-select {
   VIM_PROMPT="%{$fg_bold[yellow]%} [% NORMAL]%  %{$reset_color%}"
   RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/}"
   #$EPS1
   zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

if [[ $TERM == xterm ]]; then TERM=xterm-256color; fi

## added by Miniconda3 4.5.12 installer
## >>> conda init >>>
## !! Contents within this block are managed by 'conda init' !!
#__conda_setup="$(CONDA_REPORT_ERRORS=false '/mnt/bigdrive/miniconda3/bin/conda' shell.bash hook 2> /dev/null)"
#if [ $? -eq 0 ]; then
#    \eval "$__conda_setup"
#else
#    if [ -f "/home/john/miniconda3/etc/profile.d/conda.sh" ]; then
## . "/home/john/miniconda3/etc/profile.d/conda.sh"  # commented out by conda initialize
#        CONDA_CHANGEPS1=false conda activate base
#    else
#        \export PATH="/home/john/miniconda3/bin:$PATH"
#    fi
#fi
#unset __conda_setup
## <<< conda init <<<

#PATH="/home/linuxbrew/.linuxbrew/bin${PATH:+:${PATH}}"; export PATH;
#PATH="/home/john/.cabal/bin${PATH:+:${PATH}}"; export PATH;

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
#__conda_setup="$('/home/john/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
#if [ $? -eq 0 ]; then
#    eval "$__conda_setup"
#else
#    if [ -f "/home/john/miniconda3/etc/profile.d/conda.sh" ]; then
#        . "/home/john/miniconda3/etc/profile.d/conda.sh"
#    else
#        export PATH="/home/john/miniconda3/bin:$PATH"
#    fi
#fi
#unset __conda_setup
# <<< conda initialize <<<

#[ -f "/home/john/.ghcup/env" ] && source "/home/john/.ghcup/env" # ghcup-env

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
