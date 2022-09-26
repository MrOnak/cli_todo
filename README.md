# zsh commandline todo manager

This is a todo list manager for zsh. It was born out of curiosity and
wanting to learn coreutils.

![screenshot](screenshot.jpg)

## usage

* `todo` lists currently open and completed tasks
* `todo add some task` adds 'some task' to the list of open tasks
* `todo done N` marks the Nth task as completed
* `todo clean` purges completed tasks off the lists

You can mark a task as high priority by including `:high:` somewhere
in the task name. Similarily you can mark a task as low priority by
adding `:low:` somewhere in the task name.

## requirements

Currently this requires zsh due to how I handle colors in the script.
The zsh color syntax was chosen for convenience, you can replace it with
color escape codes and get rid of the color autoloading.

It also requires a nerdfont for checkmark glyphs. You can change the 
glyphs back to ASCII by replacing the `GLYPH_*` variables. 

## setup 

Both open and completed todos are stored in text files. I do recommend
creating a directory like `~/.todos` manually and changing the `FILE_DIR`
variable to an absolute path. Files will be automatically created if they
don't exist.

You might also want to symlink the `todo` script to `~/.local/bin` or 
another directory in your `PATH` for ease of access.

