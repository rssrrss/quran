#!/usr/bin/env sh
[ -d "$HOME/.local/share/" ] && mkdir -p $HOME/.local/share/Quran && cp Quran.txt $HOME/.local/share/Quran/ && val=yes || echo "$HOME/.local/share/ directory does not exist"
[ "$val" = "yes" ] && [ -d "$HOME/.local/bin/" ] && cp Quran $HOME/.local/bin/ && chmod +x $HOME/.local/bin/Quran || echo "$HOME/.local/bin/ directory does not exist"
