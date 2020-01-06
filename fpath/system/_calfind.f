#compdef $CAL_HOME/shell/system/calfind.zsh

local -a commands

while {read alias} {
    commands+=(${alias%:*})
} < $CAL_HPATH

compadd $commands
