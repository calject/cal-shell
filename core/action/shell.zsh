# ========================== 参数 ==========================
# var:
# model:        当前处理的model分类
# file_path:    当前处理的脚本或程序文件路径
# file_content: 写入$model.source文件的内容数组
# help_content: 命令help文件内容数组,写入格式[command:file_path]
#
# function:
# _process:     (_process [message] [type]) 过程输出函数
# _cmd_alias:   根据当前文件名及(# !alias=xxx,xxx,...)生成alias别名命令,必要参数term: 命令执行环境命令(/bin/bash /bin/zsh ...)
# ========================== 说明 ==========================
# 生成脚本(shell script)别名
# ========================== end ==========================

command=${$(<${file_path})[(f)1]##*!}
_cmd_alias
unset command