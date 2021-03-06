#!/bin/zsh

# ========================== 说明 ==========================
# # v1.1
# 修改适配5.0.2版本写法
# [[ $xxx ]] => [[ -n $xxx ]]
# ========================== end ==========================

(($+CAL_HOME)) || {
    CAL_HOME=`pwd`
}

local core=$CAL_HOME/core
local opt_str s_command argument_str='' s_name is_process shrc_file='.zshrc' conf_file='calbuilder.conf'
local -a -U models types help_content opt_help_content file_content source_content system_content fpath_content
local -A opts contents

# ======== source core script && set opt ========
source $core/script/check.zsh
source $core/function/system.func
trap "_handle_exit_code" EXIT

# ======== 读取配置参数 ========
while {read conf} {
    [[ -n ${(M)conf:#*=*} && -n ${conf:#\#*} ]] && {
        eval ${conf//\*/\\\*}
    }
} < $CAL_HOME/$conf_file

((_index=${models[(I)fpath]})) && {
    models[$_index]=()
    models=(fpath $models)
}

for opt_path ($(print -l $core/command/**/*(.))) {
    [[ ${opt_path:e} == 'com' ]] && {
        argument=$(sed 's/#[ ]*argument:[ ]*\(.*\)/\1/gp;d' $opt_path)
        [[ -n $argument ]] && {
            argument_str+="'-${opt_path:t:r}[$argument]' \\    "
            opt_help_content+=("\-${opt_path:t:r} -- $argument")
        }
        opt_str+=$(sed 's/#[ ]*opt:[ ]*\(.*\)/\1/gp;d' $opt_path)
    }
}
unset argument

# ======== 配置参数 ========
source $core/script/getopts.zsh
for opt (${(k)opts}) {
    var=$opts[$opt]
    opt_command=$core/command/${opt}.com
    [[ -f $opt_command ]] && {
        source $opt_command
    }
    unset var
}

# ======== 检查环境 ========
[[ -f $HOME/.zshrc && $(<$HOME/.zshrc) == *source*$HOME/.bash_profile* ]] && {
    shrc_file='.bash_profile'
}

_process "======== 清理数据 ========" process
# (注): 删除生成的命令文件夹 [[ 简单判断一下 是否存在该目录 && 非根目录(/) && 非家目录(~|~/|.|./) && 非当前执行目录($(pwd)) ]]
[[ -d $home && $home != '/' && $home != $HOME && $home != (~?|~|.|.?) && $home != $(pwd) ]] && {
    # (注): 判断下目录下是否存在cal-shell.sources文件(判断为命令生成的目录及文件，否则不执行删除)
    [[ -f $home/$s_name ]] && {
        _process "rm -rf ${home}" info
        rm -rf ${home}
    }
} || {
    # ======== 目录存在且未符合清理条件, 检查命令输入是否强制清理 ========
    [[ -d $home ]] && {
        print -nP "当前清理目录(%F{red}${home}%f)检查文件失败,是否继续(%F{yellow}y%f/%F{red}n%f): "
        read -q is_run
        print
        if [[ $is_run == 'y' && $home != $HOME && $home != / && $home != ~ ]]  {
            _process "rm -rf $home" notice
            rm -rf $home
        } else {
            _error "cancel"
        }
    }
}

_process "======== 创建存储目录 ========" processln
_mkdir system sources helps fpath

_process "======== 处理并写出到文件 ========" processln
for model ($models) {
    (( ${types[(I)path]} )) || _error "types path error."
    model_path=${model}_path
    sh_paths=(${(P)model_path})
    [[ -n $sh_paths ]] && {
        [[ -z $plugin_suffix ]] && plugin_suffix=(plugin)
        if [[ -f $core/action/$model.zsh ]] {
            source_path=$core/action/$model.zsh
        } else {
            source_path=$(_get_plugin_file_path $model $CAL_HOME)
        }
        [[ -z $source_path ]] && continue
        model_suffix=${model}_suffix
        rule=${${${(j/|/)${(P)model_suffix}}//./\\.}//\*/.\*}
        for file_path ($(_get_all_file_path "$sh_paths" $CAL_HOME)) {
            [[ -d $file_path ]] && continue
            [[ $file_path =~ ($rule)$ ]] &&  {
                source $source_path
            }
        }
        if [[ -n $file_content ]] {
            file_source_path=$home/sources/$model.source
            _process "输出到资源文件 >>> $file_source_path" put
            print -l $file_content >> $file_source_path
            source_content+=("source $file_source_path")
        } elif (($_write)) {
            unset _write
        } else {
            _process "扫描model[$model]生成内容为空." notice
        }
        unset source_path model_suffix file_content file_source_path
    } || {
        _process "扫描model[$model]目录为空." notice
    }
}

_process "======== 定义项目变量及命令 ========" processln

source $core/script/export.zsh

for _system_content ($system_content) {
    _process $_system_content info
}

system_content+="\n"
system_content+=${${"$(<$core/template/system.tmp)"//\$command\$/${s_command}}//\$arguments\$/${argument_str}}

_process "======== 生成资源文件 ========" processln
_process "输出到资源文件 >>> $home/sources/system.source" put
print -l ${(u)system_content} > $home/sources/system.source
source_content=("source $home/sources/system.source" $source_content)
source_content+="fpath=($home/fpath \$fpath)"
source_content+="autoload -Uz compinit && compinit -u"

_process "输出到资源文件 >>> $home/helps/command.help" put
_process "输出到资源文件 >>> $home/$s_name" put
# 输出help及根sources文件($s_name[cal-shell.sources])
print -l $help_content > $home/helps/command.help
print -l $opt_help_content > $home/helps/opt_command.help
print -l $source_content > $home/$s_name

_process "======== 写入系统环境变量 ========" processln
_process "检查写入环境文件: $shrc_file" info

if [[ $shrc_file == '.zshrc' ]] {
    if [[ $(<$HOME/.zshrc) == *source?${home}/${s_name}* ]] {
        _process "($home/$s_name) already source in .zshrc ." notice
    } else {
        _process "source $home/$s_name >>> .zshrc " put
        print "source $home/$s_name" >> $HOME/.zshrc
    }
} else {
    if [[ $(<$HOME/.bash_profile) == *source?${home}/${s_name}* ]] {
        _process "检查执行.bash_profile文件 [n]" info
        _process "($home/$s_name) already source in .bash_profile ." notice
    } else {
        _process "检查.bash_profile文件 [y]" info
        _process "source $home/$s_name >>> .bash_profile " put
        print "source $home/$s_name" >> $HOME/.bash_profile
    }
}

_process
_success "builder finish"
