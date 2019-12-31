# ========================== 参数 ==========================
# var:
# opts: 命令参数哈希表数据
# opt:  当前处理命令参数
# var:  当前处理的命令入参
#
# function:
# _process:     (_process [message] [type]) 过程输出函数
# ========================== (配置/说明) ==========================
# opt: c
# argument: -c 清理脚本生成文件(默认为~/.cal-shell)
# ========================== end ==========================

# 清理执行环境文件
if [[ -n $CAL_STORAGE ]] {
    home=$CAL_STORAGE
}
[[ -d $home ]] || _error "存储目录未生成, cancel."

# 清理文件夹
_clear

if [[ -n $CAL_SHRC ]] {
    clear_zshrc=$CAL_SHRC
} elif [[ -n $shrc_file ]] {
    clear_zshrc=$clear_zshrc
} else {
    _error "清理环境文件不存在."
}

shrc_content=$(sed "s#source ${home}/${s_name}##g" $HOME/$clear_zshrc)

[[ -n $shrc_content ]] && {
    print $shrc_content > $HOME/$clear_zshrc
}

_success '清理完成.'
exit 0