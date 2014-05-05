#You have to install "tmux-mem-cpu-load" before use this.
# >> https://github.com/thewtex/tmux-mem-cpu-load

tmux-mem-cpu-load 2 | sed -e "s/\(.*MB\).*]\ *\([0-9]*\.[0-9]%\) .*/Mem:\1 CPU:\2/"
