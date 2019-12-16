# ========================== 参数 ==========================
# var:
# opts: 命令参数哈希表数据
# opt:  当前处理命令参数
# var:  当前处理的命令入参
#
# function:
# _process:     (_process [message] [type]) 过程输出函数
# ========================== (配置/说明) ==========================
# opt: m:
# argument: -m MODEL, 创建model拓展(将在$CAL_HOME/plugins目录下创建)
# ========================== end ==========================

plugin_file=$CAL_HOME/plugins/$var.plugin
[[ -d $CAL_HOME/plugins ]] || {
    mkdir $CAL_HOME/plugins
}
if [[ -f $plugin_file ]] {
    _error "file $plugin_file is existed."
} else {
    cp $core/template/plugin.tmp $CAL_HOME/plugins/$var.plugin
    _success "create $plugin_file finish."
}
exit 0
