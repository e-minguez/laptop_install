# ~/.bash_logout
HISTFILE=~/.bash_history
awk 'NR==FNR && !/^#/{lines[$0]=FNR;next} lines[$0]==FNR' "$HISTFILE" "$HISTFILE" > "$HISTFILE.compressed" &&
mv "$HISTFILE.compressed" "$HISTFILE"
