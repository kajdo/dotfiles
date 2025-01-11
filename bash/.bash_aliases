# fun stuff
alias neofetch='fastfetch'
alias wget='wget2'
alias cat='bat -p'
alias linutil='curl -fsSL https://christitus.com/linuxdev | sh'

alias wifi-list='nmcli d wifi list'
alias docker-ip='sudo docker inspect -f "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}"'
alias lzd='sudo $(which lazydocker)'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'

# personal alias(es)
alias ls='lsd --group-dirs first'

# individual starters
alias wttr='clear && curl wttr.in'
alias dns="grep '^nameserver' /run/systemd/resolve/resolv.conf"
alias govcurrent='cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor'
alias powersave='sudo cpupower frequency-set --governor powersave'
alias performance='sudo cpupower frequency-set --governor performance'
# alias governors='cpufreq-info --governors'
alias governors='cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_available_governors'

# development
alias gg='lazygit'
alias py='python -c "import sys; print(eval(sys.argv[1]))"'
alias peer='aider --model openrouter/deepseek/deepseek-chat --chat-language english --no-auto-commits --subtree-only'
alias peer-or='aider --model openrouter/deepseek/deepseek-chat --chat-language english --no-auto-commits --subtree-only'
alias peer-ds='aider --model deepseek/deepseek-chat --chat-language english --no-auto-commits --subtree-only'
alias peer-o1='aider --model o1-mini --chat-language english --no-auto-commits --subtree-only'

# some individual stuff
alias clock='tty-clock -c'

# Tmux aliases
alias nmux='tmux new -s'
alias cmux='tmux new -As'