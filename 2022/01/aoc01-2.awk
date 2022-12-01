awk '/[1-9][0-9]+/ { s+= $1 } /^$/ {  i++; print s; s=0 } END { i++; print s; }' aocdata01 | sort -n | tail -3 | awk '{ s+= $1; } END { print s; }'
