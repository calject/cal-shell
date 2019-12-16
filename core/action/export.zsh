# ========================== 参数 ==========================
# var:
# model:        当前处理的model分类
# file_path:    当前处理的脚本或程序文件路径
# file_content: 写入$model.source文件的内容数组
# help_content: 命令help文件内容数组,写入格式[command:file_path]
#
# function:
# _process:     (_process [message] [type]) 过程输出函数
# ========================== 说明 ==========================
# 执行全局变量设置(export xxx)文件
# ========================== end ==========================

_process "source $file_path" info
file_content+=("source $file_path")