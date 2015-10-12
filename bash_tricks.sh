# Aliases
#========

# I'm a bad typist

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
alias ascii='man ascii | grep -m 1 -A 63 --color=never Oct'

# Simple but easy
alias ssh300='ssh-add -t 300'

# Validate things
alias yamlcheck='python -c "import sys, yaml as y; y.safe_load(open(sys.argv[1]))"'
alias jsoncheck='jq "." >/dev/null <'
alias ppv='puppet parser validate'

# Misc
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1])"'
alias bsc='git add .; git commit -a -m "Bull Shit Commit"; git push origin master'

# Functions
#==========

# Get to the top of a git tree
cdp () {

  TEMP_PWD=`pwd`
  while ! [ -d .git ]; do
  cd ..
  done
  OLDPWD=$TEMP_PWD

}


# Interact with gerrit
gerrit () {

    if [ $1 = "wip" ]; then
        commit_sha=`git rev-parse HEAD`
        if [ -z $commit_sha ]; then
            echo "Not in git directory?"
            return 1
        fi
        gerrit review $commit_sha --workflow -1
        return $?
    fi
    username=`git config gitreview.username`
    #username='spencer.krum@hp.com'

    ssh -o VisualHostKey=no -p 29418 $username@review.openstack.org gerrit $*
}
export -f gerrit

# Check out a Pull request from github
function pr() {
  id=$1
  if [ -z $id ]; then
      echo "Need Pull request number as argument"
      return 1
  fi
  git fetch origin pull/${id}/head:pr_${id}
  git checkout pr_${id}
}


# I used to run this every now and then, now I don't have to think
function cleanfloat() {
    for ip in `nova floating-ip-list | awk '/ - / {print $4}'`
        do echo $ip
        nova floating-ip-delete $ip
    done
}

# Connect to windows for fun
gobook() {
    ssh -N -f -L 3389:localhost:3389 telescope.fqdn
    rdesktop -K -u nibz -p $WINDOWS_PASSWORD -g 95% localhost
}


# Have vim inspect command history
vim () {
    last_command=$(history | tail -n 2 | head -n 1)
    if [[ $last_command =~ 'git grep' ]] && [[ "$*" =~ :[0-9]+:$ ]]; then
        line_number=$(echo $* | awk -F: '{print $(NF-1)}')
        /usr/bin/vim +${line_number} ${*%:${line_number}:}
    else
        /usr/bin/vim $*
    fi
}

# maybe this can be used like 'bc' ?
pcp () {
    python -c "print $@"
}



# Eject after burning
wodim () {
    /usr/bin/wodim -v $1
    eject -T
}
