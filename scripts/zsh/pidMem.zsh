ps -p $1 -o %mem | tr -dc "[:digit:]."
