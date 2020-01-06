local -A opts opt_str
opt_str+=($args)
# ======== 读取命令参数脚本 ========
while {getopts ${(j//)${(k)opt_str}:-''} opt} {
    opts[$opt]="$OPTARG"
}
shift $(($OPTIND - 1))