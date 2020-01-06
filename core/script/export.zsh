# ========================== 参数 ==========================
# var:
# system_content: 系统变量内容数组
#
# function:
# _process:     (_process [message] [type]) 过程输出函数
# ========================== 说明 ==========================
# 配置 export 全局变量
# ========================== end ==========================

for user_script ($(print $CAL_HOME/core/user/script/*.zsh)) {
    system_content+=("export CAL_${user_script:t:r:u}=$user_script")
}

# export
system_content+="export CAL_HOME=$CAL_HOME"
system_content+="export CAL_SHRC=$shrc_file"
system_content+="export CAL_FUNC=$CAL_HOME/func"
system_content+="export CAL_SYSTEM_FUNC=$CAL_HOME/func/system.func"
system_content+="export CAL_STORAGE=$home"
system_content+="export CAL_LIB=$home/sources/func.source"
system_content+="export CAL_HPATH=$home/helps/command.help"
system_content+="export CAL_H_OPT_PATH=$home/helps/opt_command.help"
system_content+="export CAL_FPATH=$home/fpath"
