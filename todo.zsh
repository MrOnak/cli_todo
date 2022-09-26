#!/usr/bin/env zsh
autoload colors
colors

FILE_DIR=~/.todos
FILE_TODO=$FILE_DIR"/todos.txt"
FILE_DONE=$FILE_DIR"/done.txt"
if [[ ! -d $FILE_DIR ]]; then echo "directory '$FILE_DIR' not found"; exit 1; fi
touch $FILE_TODO $FILE_DONE
GLYPH_TODO="   "
GLYPH_DONE="       "
TODOS=`comm $FILE_TODO $FILE_DONE | cut --fields 1 | grep -v -E "(^#|^\s*$)"`
DONES=`comm $FILE_TODO $FILE_DONE | cut --fields 3 -s | grep -v -E "(^#|^\s*$)"`

if [[ $# -ne 0 ]]; then
  COMMAND=$1
  shift
  case $COMMAND in
    add|a)
      echo $* >> $FILE_TODO;
      cat $FILE_TODO | grep -v -E "(^#|^\s*$)" | sort -u -o $FILE_TODO - ;;
    done|d)
      echo $TODOS | awk 'NR=='$1' {print;exit}' >> $FILE_DONE; 
      cat $FILE_DONE | grep -v -E "(^#|^\s*$)" | sort -u -o $FILE_DONE - ;;
    clean|c)
      echo $TODOS > $FILE_TODO
      echo "# this file contains completed todos" > $FILE_DONE ;;
    *)
      echo "Usage: $0 (add|done|clean|)"
      echo "  $0                  prints current open and completed todos"
      echo "  $0 add some task    adds 'some task' as open todo"
      echo "  $0 done N           marks the Nth todo as completed"
      echo "  $0 clean            clears completed todos off the list" ;;
  esac
else
  echo $fg_bold[default]"  my todos: "$reset_color
  if [[ -n $TODOS ]]; then 
    echo $TODOS | nl -s ") " -w2 | sed s/^/$fg[red]$GLYPH_TODO$reset_color/
  fi
  if [[ -n $DONES ]]; then
    echo $DONES | sed s/^/$fg[green]$GLYPH_DONE$reset_color/
  fi
fi

