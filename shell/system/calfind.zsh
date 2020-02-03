#!/bin/zsh

# [arg] : e - 搜索全文内容(包括注释)
# [arg] : h - 显示帮助文档信息

# [help] : 查找项目命令位置 calfind [command]

# [alias] : calhelp

# [param]: $1 - 示例参数选项

# 示例:
# $ calfind calfdind
# $ calfind /Users/canl/cal-shell/shell/system/calfind.sh

local -a content is_show_help
local commandName _path=$0

source $CAL_OPTS

if (($+opts[h])) || (($+opts[e])) {
    is_show_help=1
}

while {read alias} {
    command_name=${alias%%:*}
    command_content=${alias#*:}
    if ((($+opts[e])) && [[ -n ${(M)alias:#*$1*} ]]) || [[ -n ${(M)command_name:#*$1*} ]] {
        content+=(${command_name} "%F{green}${command_content%%:*}%f")
        if (($is_show_help)) && [[ $command_content == *:* ]] {
            helps=(${(s/{br}/)${command_content#*:}})
            for help ($helps) {
                content+=(" " "%F{blue}$help%f")
            }
        }
    }
} < $CAL_HPATH

[[ -n $content ]] && print -P -aC 2 $content || print -P "%F{red}no match.%f"
