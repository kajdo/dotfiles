# update
alias UU='cd /etc/nixos && sudo nix flake update && sudo nixos-rebuild switch'

# fun stuff
alias neofetch='fastfetch'
alias wget='wget2'
alias cat='bat -p'
alias linutil='curl -fsSL https://christitus.com/linuxdev | sh'
alias fin='cd /home/kajdo/git/aktienator/ && ./nix_start'
alias chat='cd /home/kajdo/git/opencode-dev-container && docker compose run opencode-dev'

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

# development & ai fun
alias gg='lazygit'
alias py='python -c "import sys; print(eval(sys.argv[1]))"'
alias peer='aider --model openrouter/google/gemini-2.5-flash-preview:thinking --chat-language english --no-auto-commits --subtree-only --no-suggest-shell-commands --dark-mode --no-show-model-warnings --lint-cmd flake8 --no-auto-lint --cache-prompts'
alias peergoogle='aider --model openrouter/google/gemini-2.0-flash-exp:free  --chat-language english --no-auto-commits --subtree-only --no-suggest-shell-commands'
alias peerchat='aider --model openrouter/deepseek/deepseek-chat --chat-language english --no-suggest-shell-commands --llm-history-file ~/tmp/.aider.llm.history --chat-history-file ~/tmp/.aider.chat.history.md --input-history-file ~/tmp/.aider.input.history --no-show-model-warnings'
alias peer-or='aider --model openrouter/deepseek/deepseek-chat --chat-language english --no-auto-commits --subtree-only'
alias peer-ds='aider --model deepseek/deepseek-chat --chat-language english --no-auto-commits --subtree-only'
alias peer-o1='aider --model o1-mini --chat-language english --no-auto-commits --subtree-only'
alias ai='chatblade -c mini'

# some individual stuff
alias clock='tty-clock -c -C 4'

# Tmux aliases
alias nmux='tmux new -s'
alias cmux='tmux new -As'
