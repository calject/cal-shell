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
# 生成脚本(shell script)别名
# ========================== end ==========================

command=${$(<${file_path})[(f)1]##*!}
command_name=${file_path:t:r}
file_content+=("alias $command_name='${command:-'/bin/bash'} $file_path'")
_process "alias $command_name='${command:-'/bin/bash'} $file_path'" info
help_content+=("$command_name:$file_path")

# 查找所有定义别名(# !alias=xxx,xxx,xxx)并生成命令别名
for str (${(f)"$(<$file_path)"}) {
	[[ ${(M)str:#\# !alias=*} != '' ]] && {
	    for alias_name (${=${(s/,/)str##*=}}) {
		    file_content+="alias $alias_name='${command:-'/bin/bash'} $file_path'"
		    _process "alias $alias_name='${command:-'/bin/bash'} $file_path'" info
		    help_content+="$alias_name:$file_path"
	    }
	    break
	}
}

unset command command_name