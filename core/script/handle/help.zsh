# ========================== 参数 ==========================
# 必要全局参数:
# file_path:        当前处理的脚本或程序文件路径
# file_content:     写入$model.source文件的内容数组
# help_content:     命令help文件内容数组,写入格式[command:file_path]
# content:          tag对应的内容即([xxx]: {$2}) {$2}部分的内容
# delimiter:        内容分割符
# _help_content:    当前文件帮助内容
#
# function:
# _process:     (_process [message] [type]) 过程输出函数
# ========================== 说明 ==========================
# 根据(# [help]: xxx) 内容生成xxx帮助文件内容
# ========================== end ==========================

_help_content+=($content)
