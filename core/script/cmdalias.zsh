# ========================== 参数 ==========================
# 必要全局参数:
# file_path:    当前处理的脚本或程序文件路径
# file_content: 写入$model.source文件的内容数组
# help_content: 命令help文件内容数组,写入格式[command:file_path]
#
# 必要执行参数:
# term: 当前生成的别名命令执行解析(例: /bin/bash /bin/zsh /usr/bin/sh ...)
#
# 可选执行参数:
# alias_prefix: 命令别名前缀(默认为 '# !alias=')
#
# function:
# _process:     (_process [message] [type]) 过程输出函数
# ========================== 说明 ==========================
# 根据文件路劲生成alias别名命令
# ========================== end ==========================

[[ $+term ]] && {
    command_name=${file_path:t:r}
    file_content+=("alias $command_name='$term $file_path'")
    _process "alias $command_name='$term $file_path'" info
    help_content+=("$command_name:$file_path")

    # 查找所有定义别名(# !alias=xxx,xxx,xxx)并生成命令别名
    for str (${(f)"$(<$file_path)"}) {
        [[ ${(M)str:#${alias_prefix:='# !alias='}*} ]] && {
            for alias_name (${=${(s/,/)str##*=}}) {
                file_content+="alias $alias_name='$term $file_path'"
                _process "alias $alias_name='$term $file_path'" info
                help_content+="$alias_name:$file_path"
            }
            break
        }
    }
    unset command_name
}