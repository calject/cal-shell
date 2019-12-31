#!/bin/zsh

# !alias=calhelp
# 查找项目命令位置 calfind [command]
# 示例: $ calfind calfdind >>> calfind  /Users/canl/cal-shell/shell/system/calfind.sh

local -a content
local commandName

while {read alias} {
    commandName=${alias%:*}
    [[ -n ${(M)commandName:#*${1}*} ]] && {
        content+=(${commandName} "%F{green}${alias##*:}%f")
    }
} < $CAL_HPATH

[[ -n $content ]] && print -P -aC 2 $content || print -P "%F{red}no match.%f"
