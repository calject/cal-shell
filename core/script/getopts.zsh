
# ======== 读取命令参数脚本 ========
while {getopts $opt_str opt} {
    opts[$opt]="$OPTARG"
}
shift $(($OPTIND - 1))