# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

fliptable() { echo "（╯°□°）╯ ┻━┻"; }

fuck() {
  killall -9 $2;
  if [ $? == 0 ]
  then
    echo
    echo " (╯°□°）╯︵$(echo $2|flip &2>/dev/null)"
    echo
  fi
}

# Powerline
if [ -f `which powerline-daemon` ]; then
  powerline-daemon -q
  POWERLINE_BASH_CONTINUATION=1
  POWERLINE_BASH_SELECT=1
  . /usr/share/powerline/bash/powerline.sh
fi

# Vagrant stuff
export VAGRANT_DEFAULT_PROVIDER=libvirt
export VAGRANT_HOME=/storage/vagrant

alias dockerclean='docker rm -v $(docker ps -a -q -f status=exited) ; docker rmi $(docker images -f "dangling=true" -q) ; docker volume rm $(docker volume ls -qf dangling=true)'
alias dockercleanup='docker rm -v $(docker ps -a -q -f status=exited)'
alias dockerimagesdf='docker images | awk '\''/MB/ { SUM += $7 } END { print SUM }'\'''
alias dockerimagescleanup='docker rmi $(docker images -f "dangling=true" -q)'
alias dockervolumescleanup='docker volume rm $(docker volume ls -qf dangling=true)'
alias dockerupdate='docker images | grep -v REPOSITORY | awk '\''{print $1}'\'' | xargs -L1 docker pull'


alias sl=ls
alias mdkir=mkdir
alias soruce=source
alias souce=source

# Short things are better

alias v=vagrant
alias g=git
alias d=docker

# Short things are better (git)
alias gs='git show --pretty=oneline'
alias gpom='git push origin master'
alias gpod='git push origin development'
alias grom='git reset --hard origin/master'
alias gp='git pull'

# Env Overload
alias utcdate='TZ=utc date'

# Just fun
alias fucking=sudo

# Stored Regular Expressions

alias reg_mac='echo [0-9a-f]{2}:[0-9a-f]{2}:[0-9a-f]{2}:[0-9a-f]{2}:[0-9a-f]{2}:[0-9a-f]{2}'
alias grep_mac='grep -E `reg_mac`'
alias reg_email='echo "[^[:space:]]+@[^[:space:]]+"'
alias reg_ip='echo "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b"'

# Reference
alias alphabet='echo a b c d e f g h i j k l m n o p q r s t u v w x y z'
alias unicode='echo ✓ ™  ♪ ♫ ☃ ° Ɵ ∫'
alias numalphabet='alphabet; echo 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6'
alias ascii='man ascii | grep -m 1 -A 65 --color=never Oct'

# Validate things
alias yamlcheck='python -c "import sys, yaml as y; y.safe_load(open(sys.argv[1]))"'
alias jsoncheck='jq "." >/dev/null <'
alias ppv='puppet parser validate'
alias prettyjson='python -m json.tool'

# Misc
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1])"'
alias bsc='git add .; git commit -a -m "Bull Shit Commit"; git push origin master'

validate_erb() {
          erb -P -x -T '-' $1 | ruby -c
  }

alias updateatom="wget -O /tmp/atom.rpm https://atom.io/download/rpm && pkexec dnf update -y /tmp/atom.rpm && rm /tmp/atom.rpm && apm update -c false"
alias dockviz="docker run -it --rm --privileged -v /var/run/docker.sock:/var/run/docker.sock nate/dockviz"

shopt -s checkwinsize
