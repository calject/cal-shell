# ========================== 参数 ==========================
# var:
# opts: 命令参数哈希表数据
# opt:  当前处理命令参数
# var:  当前处理的命令入参
#
# function:
# _process:     (_process [message] [type]) 过程输出函数
# ========================== (配置/说明) ==========================
# opt: s
# argument: -s (rsync)使用rsync管理同步到所有ssh连接上,scp文件传输
# ========================== end ==========================

_is_process=$is_process
is_process=1
[[ $sync_host != "" ]] && {
    command="
        if [[ ! -f ~/.zshrc ]]; then
            echo \"can't not found ~/.zshrc .\"
            exit 1
        fi
        if [[ -d $sync_path/${CAL_HOME:t:r} ]] {
            cd $sync_path/${CAL_HOME:t:r}
            /bin/zsh ./calbuilder.zsh
            exit
        } else {
            echo '$sync_path/${CAL_HOME:t:r} 目录不存在.'
            exit 1
        }
    "
    _process "======== 同步数据(rsync) ========" process
    for _host ($sync_host) {
        if [[ $_host != $hostname ]] {
            if [[ ${_host:#*@*} == '' ]] || ([[ -f ~/.ssh/config ]] && {grep "[Hh]ost[ ]*['\"]*\b$_host\b['\"]*" ~/.ssh/config > /dev/null 2>&1}) {
                _process "同步到$_host ..." info
                err=$(rsync -av -e ssh --exclude='.*' $CAL_HOME $_host:$sync_path)
                if [[ $? == 0 ]] {
                    _process "rsync同步$_host完成 ... [y]" info
                } else {
                    _process "rsync同步$_host失败 ... [n]" notice
                }
                err=$(ssh $_host $command 2>&1)
                if [[ $? == 0 ]] {
                    _process "同步$_host完成 ...      [y]" info
                } else {
                    _process "同步$_host失败 ...      [n]" notice
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
