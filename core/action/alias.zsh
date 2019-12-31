# ========================== 参数 ==========================
# var:
# model:        当前处理的model分类
# file_path:    当前处理的脚本或程序文件路径
# file_content: 写入$model.source文件的内容数组
# help_content: 命令help文件内容数组,写入格式[command:file_path]
#
# function:
# _process:     (_process [message] [type]) 过程输出函数
# _cmd_alias:   根据当前文件名及(# !alias=xxx,xxx,...)生成alias别名命令,
#                   必要参数:
#                       term:           命令执行解析(/bin/bash /bin/zsh ...)
#                   可选参数:
#                       alias_prefix:   命令别名前缀(默认为 '# !alias=')
# ========================== 说明 ==========================
# 执行alias别名声明文件
# ========================== end ==========================

_process "source $file_path" info
file_content+=("source $file_path")
for name ($(/usr/bin/sed 's#^alias \([a-zA-Z_-]*\)=.*#\1#gp;d' $file_path | /usr/bin/sed 's/#.*//g')) {
    [[ -n $name ]] && {
        help_content+=("$name:$file_path")
    }
}