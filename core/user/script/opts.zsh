
local -A opts

[[ -f $_path ]] && {
    # ======== 读取命令参数脚本 ========
    while {getopts ${"$(<$CAL_STORAGE/system/opts/$(/sbin/md5 -qs $_path).o)"[(f)1]} opt} {
        opts[$opt]="$OPTARG"
    }
    shift $(($OPTIND - 1))
}