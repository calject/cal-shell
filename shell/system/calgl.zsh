#!/bin/zsh

# 更新项目代码

local remote branch isProcess=0
local -a remotes

# source process.func
source $CAL_FUNC/process.func

remotes=($(git remote))
branch=$(git branch | awk '/\*.*/{print $2}')

[[ ${remotes} ]] || {
    error "fatal: No remote repository specified.  Please, specify either a URL or a
remote name from which new revisions should be fetched."
}

[[ ${remotes[(I)origin]} ]] && {
    remote='origin'
} || {
    remote=${remotes[1]}
}
process "cd $CAL_HOME" info
cd $CAL_HOME

process "remote prune ${remote}" info
git remote prune ${remote}

process "fetch ${remote} ${branch}" info
git fetch ${remote} ${branch}

process "pull ${remote} ${branch}" info
git pull ${remote} ${branch}
