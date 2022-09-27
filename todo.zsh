#!/usr/bin/env zsh
autoload colors
colors
# ensure files exist, load lists
FILE_DIR=~/.todos; FILE_TODO=$FILE_DIR"/todos.txt"; FILE_DONE=$FILE_DIR"/done.txt";
if [[ ! -d $FILE_DIR ]]; then echo "directory '$FILE_DIR' not found"; exit 1; fi
touch $FILE_TODO $FILE_DONE
TODOS=$(<$FILE_TODO)
DONES=$(<$FILE_DONE)
# prepare glyphs. if you want to use plain ASCII, I recommend o, x, !, _
GE=$reset_color
G=($fg[red]"   "$GE $fg[green]"   "$GE $fg_bold[yellow]""$GE $fg[yellow]""$GE)
# run commands
if [[ $# -ne 0 ]]; then
  COMMAND=$1
  shift
  case $COMMAND in
    add|a)      echo $* >> $FILE_TODO ;;
    clean|c)    echo -n "" > $FILE_DONE ;;
    done|d)     echo $TODOS | awk 'NR=='$1' {print;exit}' >> $FILE_DONE; sed -i $1'd' $FILE_TODO ;;
    rename|r)   sed -i $1'd' $FILE_TODO; shift; echo $* >> $FILE_TODO ;;
    trash|t)    sed -i $1'd' $FILE_TODO ;;
    undo|u)     echo $DONES | awk 'NR=='$1' {print;exit}' >> $FILE_TODO; sed -i $1'd' $FILE_DONE ;;
    *)
      SELF=`basename $0`
      echo "Usage: $SELF (add|clean|done|rename|trash|undo|)"
      echo "  $SELF                        prints current open and completed todos"
      echo "  $SELF add some task          adds 'some task' as open todo"
      echo "  $SELF clean                  clears completed todos off the list"
      echo "  $SELF done N                 marks the Nth todo as completed"
      echo "  $SELF rename N new descr.    renames Nth open task to 'new descr.'"
      echo "  $SELF trash N                deletes the Nth open todo"
      echo "  $SELF undo N                 marks the Nth completed todo as not done" ;;
  esac
  # re-sort and clean both files
  grep -v -E "(^#|^\s*$)" $FILE_TODO | sort -u -o $FILE_TODO -
  grep -v -E "(^#|^\s*$)" $FILE_DONE | sort -u -o $FILE_DONE -
else
  #echo $fg_bold[default]"  my todos"$reset_color
  if [[ -n $TODOS ]]; then 
    echo $TODOS | nl -s ") " -w2 | sed "s/^/$G[1]/;s/:high:/$G[3]/;s/:low:/$G[4]/"
  fi
  if [[ -n $DONES ]]; then
    echo $fg[yellow]"  ────────────────────────────────────────────"$reset_color
    echo $DONES | nl -s ") " -w2 | sed -E "s/^/$G[2]/;s/(:high:|:low:)\s*//"
  fi
fi

