# ========================== 参数 ==========================
# var:
# opts: 命令参数哈希表数据
# opt:  当前处理命令参数
# var:  当前处理的命令入参
#
# function:
# _process:     (_process [message] [type]) 过程输出函数
# ========================== (配置/说明) ==========================
# opt: p:
# argument: -p HOME 设置生成脚本的存储路径(默认为~/.cal-shell)
# ========================== end ==========================

home=$(_handle_path $var $HOME)