ps -p $1 -o %cpu | tr -dc "[:digit:]."
