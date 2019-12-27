
# ======== 检查zsh版本(最低要求5.2) ========
version_str=($(zsh --version))
versions=$version_str[2]
versions=(${(s/./)versions})
min_version=(5 0 2)

for i ({1..${#versions}}) {
    if [[ $versions[$i] -lt $min_version[$i] ]]; then
        print -P "%F{red}当前zsh版本过低,最低版本要求(${(j/./)min_version}),当前版本(${version_str[2]}).%f"
        exit 999
    fi
}

