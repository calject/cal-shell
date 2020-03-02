# ========================== 参数 ==========================
# 必要全局参数:
# file_path:            当前处理的脚本或程序文件路径
# file_content:         写入$model.source文件的内容数组
# help_content:         命令help文件内容数组,写入格式[command:file_path]
# arg_content:          命令参数内容
# content:              tag对应的内容即([xxx]: {$2}) {$2}部分的内容
# delimiter:            内容分割符
# _boot_content:        启动引导参数(示例[boot]:sudo   ==>  sudo /bin/zsh xxx.zsh)
#
# function:
# _process:     (_process [message] [type]) 过程输出函数
# ========================== 说明 ==========================
# 根据(# [boot]: xxx) 内容 添加别名命令启动前缀命令(xxx)
# ========================== end ==========================

_boot_content+=($content)
