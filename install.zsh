#!/bin/zsh
# ========================== 说明 ==========================
# 项目安装脚本
# 安装完成执行 source $shrc_file[.bash_file/.zshrc]
# ========================== end ==========================

# 在当前目录下 clone cal-shell 项目
git clone https://github.com/calject/cal-shell.git

[[ -d $(pwd)/cal-shell ]] || {
    print -P "%F{red}cal-shell目录不存在.%f"
    exit 1
}
cd cal-shell
git checkout z5.0.2
source $(pwd)/calbuilder.zsh
print -P "%F{green}执行[ source $HOME/$shrc_file ]完成.%f"