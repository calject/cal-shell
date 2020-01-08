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
    local command_name content file_help_content
    local -a _help_content _boot_content _txt_content
    local -A _arg_content _alt_content
    command_name=${file_path:t:r}
    _alias="alias $command_name='$term $file_path'"
    # 检查并执行所有tag([xxx] : )相关操作
    for str (${(f)"$(<$file_path)"}) {
        for _file_path ($(print $CAL_HOME/core/script/handle/*.zsh)) {
            [[ -n ${(M)str:#(\#|//)*\[${_file_path:t:r}\]*} ]] && {
                content=${${str#*:}/ }
                source $_file_path
            }
        }
    }
    # 检查[boot]执行参数并生成alias命令
    [[ -n $_boot_content ]] && _boot_content=$(_trim $_boot_content)" "
    _alias_content="alias $command_name='${_boot_content}$term $file_path'"
    file_content+=("$_alias_content")
    _process "$_alias_content" info
    # 检查tag相关help变量并写入帮助文件内容
    for _tag (print $CAL_HOME/core/script/handle/*.zsh) {
        tag_help_content=_${_tag:t:r}_help_content
        [[ -n ${(P)tag_help_content} ]] && {
            file_help_content+=({br}${(j/{br}/)${(P)tag_help_content}})
        }
    }
    help_content+=($command_name:$file_path:${(j/{br}/)_help_content}"$file_help_content")

    # ======== 输出补全脚本 ========
    # 补全脚本写入函数
    function _write_fpath () {
        if (($+global_fpath)) && (($+global_fpath[$file_path])) {
            print $1 >> $global_fpath[$file_path]
        } else {
            _fpath_content=("#compdef $file_path" "$1")
            print -l $_fpath_content > $home/fpath/_sys_${file_path:t:r}.f
        }
    }

    [[ -n ${(k)_arg_content} ]] && {
        _arguments_content=('_arguments -w -S -s')
        for _arg (${(k)_arg_content}) {
            _arguments_content+=("'-${_arg}[$_arg_content[$_arg]]'")
        }
        _write_fpath "$_arguments_content"
        [[ -d $home/system/opts ]] || mkdir -p $home/system/opts
        print ${(j//)${(k)_arg_content}} > $home/system/opts/$(_md5 $file_path).o
    }

    [[ -n ${(k)_alt_content} ]] && {
        _alternative_content=("_alternative 'args:custom arg:((")
        for _alt (${(k)_alt_content}) {
            _alternative_content+=("$_alt\\\\:\"$_alt_content[$_alt]\"")
        }
        _alternative_content+=("))'")
        _write_fpath "$_alternative_content"
    }

    [[ -n $_txt_content ]] && {
        _write_fpath "compadd $_txt_content"
    }

    unset command_name content _alias _arg_content _alt_content _txt_content _help_content _boot_content _arguments_content _alternative_content
}