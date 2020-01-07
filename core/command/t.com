# ========================== 参数 ==========================
# var:
# opts: 命令参数哈希表数据
# opt:  当前处理命令参数
# var:  当前处理的命令入参
#
# function:
# _process:     (_process [message] [type]) 过程输出函数
# ========================== (配置/说明) ==========================
# opt: t
# argument: -t (git)使用Git管理同步到所有ssh连接上(需要配置服务器key到私有库上)
# ========================== end ==========================

_is_process=$is_process
is_process=1
[[ $sync_host != "" ]] && {
    command="
        if [[ ! -f ~/.zshrc ]]; then
            echo \"can't not found ~/.zshrc .\"
            exit 1
        fi
        source ~/.zshrc
        if [[ -z \$CAL_HOME ]] {
            if (($sync_create)) && [[ -n $sync_path ]] && [[ -n $sync_project ]] {
                cd $sync_path
                git clone $sync_project
                if [[ \$? == 0 ]] {
                    cd ${sync_project:t:r}
                    /bin/zsh ./calbuilder.zsh
                } else {
                    exit 1
                }
            }
        } else {
            cd \$CAL_HOME
            [[ -d .git ]] && {
                modify_file=\$(git status -s)
                [[ -n \$modify_file ]] && {
                    git reset --hard
                    print -l \${modify_file//?? /\$CAL_HOME/} | xargs -I {} rm -r {}
                }
                git pull
                /bin/zsh ./calbuilder.zsh
            } || {
                echo \"can not found .git in \$CAL_HOME\"
                exit 1
            }
        }
        exit
    "
    _process "======== 同步数据(git) ========" process
    for _host ($sync_host) {
        if [[ $_host != $hostname ]] {
            if [[ -z ${_host:#*@*} ]] || ([[ -f ~/.ssh/config ]] && {grep "[Hh]ost[ ]*['\"]*\b$_host\b['\"]*" ~/.ssh/config > /dev/null 2>&1}) {
                _process "同步到$_host ..." info
                err=$(ssh $_host $command 2>&1)
                if [[ $? == 0 ]] {
                    _process "同步$_host完成 ... [y]" info
                } else {
                    _process "同步$_host失败 ... [n]" notice
                    _failure $err
                }
            }
        }
    }
    _process "sync finish ..." info
} || {
    _process "sync_host is empty ..." notice
}

is_process=$_is_process
unset _is_process
