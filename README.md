# cal-shell

## 项目说明

> 一个自定义脚本命令生成器, 自动生成脚本或程序别名文件(alias xx=xxx), source自定义函数文件及其它脚本文件

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

## v1.1 (添加自动同步功能 [-s|-t])

* -h
```
-c -- -c 清理脚本生成文件(默认为~/.cal-shell)
-h -- -h 帮助命令
-m -- -m MODEL, 创建model拓展(将在$CAL_HOME/plugins目录下创建)
-p -- -p HOME 设置生成脚本的存储路径(默认为~/.cal-shell)
-s -- -s (rsync)使用rsync管理同步到所有ssh连接上,scp文件传输
-t -- -t (git)使用Git管理同步到所有ssh连接上(需要配置服务器key到私有库上)
-v -- -v 设置显示执行过程
```

1. 在`calbuilder.conf`中配置`sync_xxx`项目
2. 执行`calbuilder -s`(使用scp传输) 或 `calbuilder -t`(使用git管理,需要配置ssh key)命令同步

* `calbuilder -t` 使用git管理项目(在各服务器s上t通过git更新项目)
* `calbuilder -s` 使用scp管理(从本机传输到各服务器上并执行`calbuilder`命令构建)

* 示例

![Image text](https://raw.githubusercontent.com/calject/resources/master/cal-shell/gif/cal_builder_s.gif)

## 安装

### 安装一 (推荐)

* 合并命令

```bash
git clone https://github.com/calject/cal-shell.git && cd cal-shell && /bin/zsh ./calbuilder.zsh -v && source ~/.zshrc
```

* gif示例

![Image text](https://raw.githubusercontent.com/calject/resources/master/cal-shell/gif/cal_builder_install_1.gif)

### 安装二 (由于`githubusercontent.com`被屏蔽,需要科学上网)

```shell
/bin/zsh -c "$(wget https://raw.githubusercontent.com/calject/resources/master/cal-shell/install.zsh -O -)" && source ~/.zshrc
```
或者
```shell
/bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/calject/resources/master/cal-shell/install.zsh)" && source ~/.zshrc
```

* gif示例

![Image text](https://raw.githubusercontent.com/calject/resources/master/cal-shell/gif/cal_builder_install_2.gif)

### 安装三 (补充)

1. clone项目到任意目录或者`fork`到自己的github账户，然后执行`git clone`

```
git clone https://github.com/calject/cal-shell.git
```

2. 在项目目录下执行`/bin/zsh ./calbuilder.zsh && source ~/.zshrc`命令

3. 执行完成后在任意位置执行`calbuilder`(可在`calbuilder.conf`中修改该命令别名)构建


## 使用说明

1. 在任意目录下编写脚本或其它文件
2. 在`calbuilder.conf`配置中对应项目添加脚本路径
    * `shell` : shell、zshell脚本(示例脚本shell/system/*.zsh)
    * `alias` : alias 别名定义文件(示例文件alias/system.alias)
    * `export`: export 全局变量定义文件(示例文件export/system.exp)
    * `func`  : function 函数定义文件(示例文件func/process.func)
    * `other` : 其它model拓展, 示例: `php`脚本, models中加入`php`,并取消`php_*`注释后执行`calbuilder`后可执行`hello_php`命令执行示例脚本输出`hello world php.`
3. (添加/修改)文件后，执行`calbuilder`后即可使用生成的脚本别名。
    * 脚本别名默认以脚本文件名为别名
        * 例: `shell/system/calfind.zsh`帮助脚本别名命令为`calfind`，在任意位置执行`calfind [command]`即可执行
    * 若需要新的自定义别名，在文件中添加`# !alias=xxxx,xxx`，多个命令别名以英文`,`号分割
        * 例: `shell/system/calfind.zsh`中已定义别名`calhelp`,在任意地方执行`calhelp [command]`效果与`calfind [command]`命令相同