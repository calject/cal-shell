# cal-shell

## 项目说明

> 一个自定义脚本命令生成器, 自动生成脚本或程序别名文件(alias xx=xxx), source自定义函数文件及其它脚本文件

* 注: `zsh`版本要求最低为`5.2.0`, 运行`zsh --version`查看当前版本

* 示例(自动生成)
```
# alisa
alias calfind="/bin/zsh $CAL_HOME/shell/system/calfind.zsh"
alias calfind="/bin/zsh $CAL_HOME/shell/system/calgl.zsh"

# source
source $CAL_HOME/alias/system.alias
source $CAL_HOME/export/system.exp
source $CAL_HOME/func/process.func
```

## 安装

### 安装一

```shell
/bin/zsh -c "$(wget https://raw.githubusercontent.com/calject/cal-shell/master/install.zsh -O -)"
```
或者
```shell
/bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/calject/cal-shell/master/install.zsh)"
```

### 安装二

1. clone项目到任意目录或者`fork`到自己的github账户，然后执行`git clone`

```
git clone https://github.com/calject/cal-shell.git
```

2. 在项目目录下执行`/bin/zsh calbuilder.zsh && source .zshrc`命令

