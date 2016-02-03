# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

export VISUAL=vim
export USE_CCACHE=1

# Disable <CTRL-d> used to logout of a login shell
set -o ignoreeof


################################################################################
# proper shell and screen colouring - Start
################################################################################
#
if [ -e /usr/share/terminfo/x/xterm-256color ]; then
  export TERM='xterm-256color'
else
  export TERM='xterm-color'
fi

# command prompt highlighting
PS1='\[\033[0;36m\]\u\[\033[1;35m\]@\[\033[0;32m\]\h \[\033[1;35m\]\W\[\033[0;36m\] \$ \[\033[0m\]'

# In order to use the 'light-theme' for colouring the shell and playing nice with 'screen',
# copy the predefined DIR_COLORS* theme into the users directory first:
#
#   cp /etc/DIR_COLORS.lightbgcolor ~/.dircolors
#
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# colorful 'man' pages
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline
#
################################################################################
# proper shell and screen colouring - End
################################################################################


# bash-git-prompt - https://github.com/magicmonty/bash-git-prompt
source ~/.bash-git-prompt/gitprompt.sh
GIT_PROMPT_ONLY_IN_REPO=1

# git-completion.bash - https://github.com/git/git/blob/master/contrib/completion/git-completion.bash
source ~/.git-completion.bash


################################################################################
# gnu screen related stuff - Start
################################################################################
#
# Generate a dafault prompt
PROMPT_COMMAND="echo -n -e '\033k\033\\'; $PROMPT_COMMAND"

# Set hostname initially for new windows
echo -n -e "\033k$(echo ${HOSTNAME} | cut -d . -f 1)\033\\"

# While ssh-ing to a remote host,
# extract its username and hostname and set it as window title in screen.
ssh () {
  ARGS=$@
  USER_SSH=""
  HOSTNAME_SSH=""
  USER_SET=0

  while [ "$1" ] ; do
    case "$1" in
      -l)
        USER_SSH="$2"
        USER_SET=1
        shift 2
        ;;
      *)
        if ! [[ $1 =~ ^- ]] ; then
          if [ $USER_SET == 0 ] ; then
            USER_SSH=$(echo -e "$1" | cut -d @ -f 1)
            HOSTNAME_SSH=$(echo -e "$1" | cut -d @ -f 2 | cut -d . -f 1)
          else
            HOSTNAME_SSH=$(echo -e "$1" | cut -d . -f 1)
          fi
        fi
        shift
        ;;
    esac
  done

  echo -n -e "\033k$(echo -e $USER_SSH"@"$HOSTNAME_SSH)\033\\"
  command ssh $ARGS
  echo -n -e "\033k$(echo ${HOSTNAME} | cut -d . -f 1)\033\\"
}
#
################################################################################
# gnu screen related stuff - End
################################################################################
