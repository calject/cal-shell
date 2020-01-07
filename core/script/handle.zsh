# ========================== 参数 ==========================
# 必要全局参数:
# file_path:    当前处理的脚本或程序文件路径
# file_content: 写入$model.source文件的内容数组
# help_content: 命令help文件内容数组,写入格式[command:file_path]
#
# 必要执行参数:
# term: 当前生成的别名命令执行解析(例: /bin/bash /bin/zsh /usr/bin/sh ...)
#
# function:
# _process:     (_process [message] [type]) 过程输出函数
# ========================== 说明 ==========================
# 文件内容处理
# ========================== end ==========================

[[ -n $term ]] && {
    local command_name content
    local -a _help_content _arg_help_content _boot_content _arguments_content
    local -A _arg_content
    command_name=${file_path:t:r}
    _alias="alias $command_name='$term $file_path'"
    # 查找所有定义别名(# !alias=xxx,xxx,xxx)并生成命令别名
    for str (${(f)"$(<$file_path)"}) {
        for _file_path ($(print $CAL_HOME/core/script/handle/*.zsh)) {
            [[ -n ${(M)str:#(\#|//)*\[${_file_path:t:r}\]*} ]] && {
                content=${${str#*:}/ }
                source $_file_path
            }
        }
    }
    [[ -n $_boot_content ]] && _boot_content=$(_trim $_boot_content)" "
    _alias_content="alias $command_name='${_boot_content}$term $file_path'"
    file_content+=("$_alias_content")
    _process "$_alias_content" info
    help_content+=($command_name:$file_path:${(j/{br}/)_help_content}{br}${(j/{br}/)_arg_help_content})
    [[ -n ${(k)_arg_content} ]] && {
        _arguments_content=('_arguments -w -S -s')
        for _arg (${(k)_arg_content}) {
            _arguments_content+=("'-${_arg}[$_arg_content[$_arg]]'")
        }
        if (($+global_fpath)) && (($+global_fpath[$file_path])) {
            print $_arguments_content >> $global_fpath[$file_path]
        } else {
            _fpath_content=("#compdef $file_path" "$_arguments_content")
            print -l $_fpath_content > $home/fpath/_sys_${file_path:t:r}.f
        }
        [[ -d $home/system/opts ]] || mkdir -p $home/system/opts
        print ${(j//)${(k)_arg_content}} > $home/system/opts/$(md5 -qs $file_path).o
    }
    unset command_name content _alias _arg_content _help_content _arg_help_content _boot_content _arguments_content
}