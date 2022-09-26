#!/usr/bin/env zsh
autoload colors
colors

FILE_DIR=~/.todos; FILE_TODO=$FILE_DIR"/todos.txt"; FILE_DONE=$FILE_DIR"/done.txt";
if [[ ! -d $FILE_DIR ]]; then echo "directory '$FILE_DIR' not found"; exit 1; fi
touch $FILE_TODO $FILE_DONE
GE=$reset_color
G=($fg[red]"   "$GE $fg[green]"   "$GE $fg[yellow]""$GE $fg[blue]""$GE)
TODOS=`comm $FILE_TODO $FILE_DONE | cut --fields 1 | grep -v -E "(^#|^\s*$)"`
DONES=`comm $FILE_TODO $FILE_DONE | cut --fields 3 -s | grep -v -E "(^#|^\s*$)"`

if [[ $# -ne 0 ]]; then
  COMMAND=$1
  shift
  case $COMMAND in
    add|a)
      echo $* >> $FILE_TODO;
      cat $FILE_TODO | grep -v -E "(^#|^\s*$)" | sort -u -o $FILE_TODO - ;;
    clean|c)
      echo $TODOS > $FILE_TODO
      echo "# this file contains completed todos" > $FILE_DONE ;;
    done|d)
      echo $TODOS | awk 'NR=='$1' {print;exit}' >> $FILE_DONE; 
      cat $FILE_DONE | grep -v -E "(^#|^\s*$)" | sort -u -o $FILE_DONE - ;;
    undo|u) 
      sed -i $1'd' $FILE_DONE ;;
    *)
      SELF=`basename $0`
      echo "Usage: $SELF (add|done|undo|clean|)"
      echo "  $SELF                  prints current open and completed todos"
      echo "  $SELF add some task    adds 'some task' as open todo"
      echo "  $SELF clean            clears completed todos off the list" ;;
      echo "  $SELF done N           marks the Nth todo as completed"
      echo "  $SELF undo N           marks the Nth completed todo as not done"
  esac
else
  echo $fg_bold[default]"  my todos: "$reset_color
  if [[ -n $TODOS ]]; then 
    echo $TODOS | nl -s ") " -w2 | \
      sed "s/^/$G[1]/;s/:high:/$G[3]/;s/:low:/$G[4]/"
  fi
  if [[ -n $DONES ]]; then
    echo $fg[yellow]"  ────────────────────────────────────────────"$reset_color
    echo $DONES | nl -s ") " -w2 | \
      sed "s/^/$G[2]/;s/:high:/$G[3]/;s/:low:/$G[4]/"
  fi
fi

