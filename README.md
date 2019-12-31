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
    * `shell` : shell、zshell脚本(示例脚本 $CAL_HOME/shell/system/*.zsh)
    * `alias` : alias 别名定义文件(示例文件 $CAL_HOME/alias/system.alias)
    * `export`: export 全局变量定义文件(示例文件 $CAL_HOME/export/system.exp)
    * `func`  : function 函数定义文件(示例文件 $CAL_HOME/func/process.func)
    * `other` : 其它model拓展, 示例: `php`脚本, models中加入`php`,并取消`php_*`注释后执行`calbuilder`后可执行`hello_php`命令执行示例脚本输出`hello world php.`
    
![Image text](https://raw.githubusercontent.com/calject/resources/master/cal-shell/images/cal_shell_directory.png)
    
3. (添加/修改)文件后，执行`calbuilder`后即可使用生成的脚本别名。
    * 脚本别名默认以脚本文件名为别名
        * 例: `shell/system/calfind.zsh`帮助脚本别名命令为`calfind`，在任意位置执行`calfind [command]`即可执行
    * 若需要新的自定义别名，在文件中添加`# !alias=xxxx,xxx`，多个命令别名以英文`,`号分割
        * 例: `shell/system/calfind.zsh`中已定义别名`calhelp`,在任意地方执行`calhelp [command]`效果与`calfind [command]`命令相同

### 内置命令

#### `calfind`|`calhelp` 查找项目生成的alias命令或function

![Image text](https://raw.githubusercontent.com/calject/resources/master/cal-shell/images/calfind.png)

#### `cdcal` 切换到项目目录下(cd $CAL_HOME) 

#### `sourbash` ===> (source ~/.bash_profile)

#### `sourzshrc` ===> (source ~/.zshrc)

#### `vimbash` ===> (vim ~/.bash_profile)

#### `vimzshrc` ===> (vim ~/.zshrc)

* `calbuilder.conf`文件

```conf
# ======== 项目配置参数 ========
# 生成文件夹路径及名称
home=~/.cal-shell

# 构建命令别名
s_command=calbuilder

# 生成资源文件名
s_name=cal-shell.sources

# ======== 同步服务器ssh配置 ========
# 不存在cal-shell项目是否clone项目(0: 关闭自动clone 1:开启自动clone) 默认关闭
sync_create=0
# clone项目地址,替换为自己的项目地址(使用ssh连接地址),示例(git@github.com:calject/cal-shell.git)
sync_project=git@github.com:calject/cal-shell.git
# clone项目路径,默认为(~)家目录下(注: 路径使用''标识字符)
sync_path='~'
# 待同步的ssh连接主机名(.ssh/config 下定义的Host, 例 api-a)
sync_host=()

# ======== model配置参数(拓展部分在后面加入对应的model,示例: models=(shell php python perl java),默认实现shell、alias、export、func、expand) ========
models=(shell alias export func)

# model配置参数(suffix: 文件规则参数; path: 扫描脚本路径参数)
types=(suffix path)

# ======== suffix(加载的文件规则可使用通配符[plugin仅支持后缀匹配*.xx或.zsh],示例: .sh *.sh *cal*.zsh *_plugin.sh ...) ========
shell_suffix=(*.h *.sh *.zsh)
alias_suffix=(*.alias)
export_suffix=(*.exp)
func_suffix=(*.func)
plugin_suffix=(*.plugin)
# expand_suffix=()

# ======== path(model扫描的文件或目录([.或者空]代表当前项目路径),示例: shell ./shell /Users/calject/shell ~/.shell ~/.shell/do.sh ...) ========
shell_path=(shell zsh)
alias_path=(alias)
export_path=(export)
func_path=(func)
plugin_path=(plugins)
# expand_path=()

# ======== plugin(拓展示例php脚本拓展[在models中加入php以开启]) ========
php_suffix=(*.php)
php_path=(php)

python_suffix=(*.py)
python_path=()
```