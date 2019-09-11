Problem: Opening vim on a really slow file-system takes very long. Even if no plugins are used it may still take a couple of seconds which is annoying. 
Solution: Have multiple screen instances with vim open in the background at all times and instead of opening vim, the command vim just attaches to an existing screen session, changes directory into the current folder and opens the files that are passed as arguments.

To use:
1. Set the environment variable VIMEXE to your preferred vim executable.
2. Create an alias for the script openExistingVimInstance. This will attach to a running screen session with vim and replace it with a new instance. If no previous screen instance with vim exists it will open two new ones (so you always have a backup one)
