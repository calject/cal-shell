
local -A opts

source $CAL_HOME/core/function/system.func

[[ -f $_path ]] && {
    # ======== 读取命令参数脚本 ========
    while {getopts ${"$(<$CAL_STORAGE/system/opts/$(_md5 $_path).o)"[(f)1]} opt} {
        opts[$opt]="$OPTARG"
    }
    shift $(($OPTIND - 1))
}