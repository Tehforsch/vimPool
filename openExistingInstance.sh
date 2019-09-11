#!/bin/bash

# List all screen sessions which are running vim and get the process id of the last one
screenId=$(screen -ls | grep vim | grep -v Attached | cut -f 2 | tail -n 1)
maxNumVims=5

if [[ $screenId == "" ]]; then
    echo "No more screen vim screen sessions left - this is bad. Load $maxNumVim instances in the background and load vim normally:"
    for i in $( seq 1 $maxNumVims ); do
        screen -S vim -d -m $VIMEXE
    done
    exec $VIMEXE $@
else
    # cd the vim instance into the current directory
    # This is some screen magic that definitely shouldnt work but it does.
    # Basically we send keystrokes to the screen instance and just type
    # :cd $PWD<Enter>
    # (Enter is \015)
    currentDirectory=$(pwd)
    screen -S $screenId -X stuff ":cd $currentDirectory"$(echo -ne '\015')
    # Open the files given in the arguments
    for file in "$@"; do
        screen -S $screenId -X stuff ":e $file"$(echo -ne '\015')
    done
    # If the number of running vim instances is below $maxNumVims we better replace this one
    if [[ $(screen -ls | grep vim | wc -l) -lt $maxNumVims ]]; then
        # Start a new instance to replace this one:
        screen -S vim -d -m $VIMEXE
    fi
    # Now we re-attach the session
    screen -r $screenId
fi
