#!/bin/bash

#####
# these are commands and sequences to run when in new environments
# and to memorize to use on foreign machines
# on foreign machines, this script is meant to be pulled from the 
# repo and used to get a sense of the system, as well as begin 
# preliminary dignostics
# 
# TODO: output to file, decide on which commands will be must useful, 
# prompt to continue before executing commands that will scroll the
# window(want to print to a txt for logging and convenience, but 
# dont want to make it necessary to open to read output, which
# defeats the purpose of color coding and formatting), generalize
# helper function so it can draw header as well, organize clean
# up code into fn, organize setup code into fn, add starting
# animation, prevent commands from writing over footer
#####

# starting animation
## arguments 
# $1 : rows
# $2 : cols
play_animation () {
    clear
    #tput cup $(( $1 / 2 )) $(( $2 / 2 ))
    #tput rev
    # test
    K="0"
    #while [ $K -lt 5 ]; do
    while true; do
        for j in {1..7}; do
            tput cup $(( $1 / 2 )) $(( $2 / 2 - 3))
            tput setaf $j
            echo -n "T"
	    # j -1 + 7 is more clear and debuggable than j + 6
            tput setaf $(( ($j - 1 + 7 - 1) % 7 + 1))
            echo -n "E"
            tput setaf $(( ($j - 2 + 7 - 1) % 7 + 1))
            echo -n "S"
            tput setaf $(( ($j - 3 + 7 - 1) % 7 + 1))
            echo -n "T"
            tput setaf $(( ($j - 4 + 7 - 1) % 7 + 1))
            echo -n "I"
            tput setaf $(( ($j - 5 + 7 - 1) % 7 + 1))
            echo -n "N"
            tput setaf $(( ($j - 6 + 7 - 1) % 7 + 1))
            echo -n "G"
            #tput setaf $(( ($j + 6) % 7 + 1))
	    #echo -n "E"
	    #tput setaf $(( ($j + 5) % 7 + 1))
	    #echo -n "S"
	    #tput setaf $(( ($j + 4) % 7 + 1))
	    #echo -n "T"
	    #sleep 0.5
            sleep 0.025
        done
        (( K++ ))
    done
    tput sgr0
    # end test
    clear
}

# draw footer helper fn
draw_footer () {
tput cup $(( $ROWS - 3 )) 0
tput srg0
I="0"
while [ $I -lt 2 ]; do
    C=0
    while [ $C -lt $COLS ]; do
       echo -n "#"
       (( C++ ))
    done
    (( I++ ))
done
}

# 
cleanup () {
    unset $COLS
    unset $ROWS
    tput sgr0
    # show cursor
    tput cnorm
    clear
}

# set up
init () {
    echo -e "$COLS\n$ROWS"
    # hide cursor
    tput civis
    # starting animation
    play_animation $ROWS $COLS
    # header and footer
}

###############################################################
###############################################################
###############################################################
###############################################################
###############################################################

## START

clear 

# get window dimensions
COLS="$(tput cols)"
ROWS="$(tput lines)"

init 
exit 1


# print heading
I="0"
#C="0"
R="0"
ro="$ROWS-2"
while [ $I -lt 2 ]; do
    C="0"
    while [ $C -lt $COLS ]; do
        echo -n "#"
	(( C++ ))
    done
    echo
    (( I++ ))
done

## print header
# position cursor
tput cup 2 $(( $COLS / 2 - 2))
# Pretty colors
#
tput setaf 1
echo -n "N"
# 
tput setaf 2
echo -n "E"
# 
tput setaf 4
echo -n "T"
# 
tput setaf 6
echo -n "W"
#
#tput setaf 5
#echo -n "O"
#
#tput setaf 6
#echo -n "R"
#
#tput setaf 7
#echo -n "K"
# turn off all attributes
tput sgr0

tput cup 3 $(( $COLS / 2 - 6 ))
tput rev
echo " network.sh "
tput sgr0

#tput cup 5 32
#echo "$(( $COLS / 2 ))"
# tmp watch
#DATE='date +%Y%m%d'
DATE="$( date +%F )"
TIME="$( date +%T )"
ET="0"
while [ $ET -lt 61 ]; do
    tput setaf 1
    # show date
    tput cup 2 $(( $COLS - 10 ))
    echo "$DATE"
    # show system time
    tput cup 3 $(( $COLS - 8 ))
    echo "$TIME"
    # show elapsed time
    tput cup 4 $(( $COLS - 1 ))
    echo -en "$ET"
    tput sgr0
    draw_footer

    ## main program
    # pipe each output to txt? would solve scroll problem with screencapture, 
    # as cool as that is 

    # TASK - print working directory
    tput cup 6 0
    tput setaf 1
    echo "PWD"
    #echo "PWD" | tee "./$DATE.txt"
    tput sgr0
    pwd
    #echo "$(pwd)" | tee -a "./$DATE.txt"
    #echo >> "./$DATE.txt"
    # echo | tee -a "./$DATE.txt"
    echo
    
    # TASK - who and whoami
    #tput cup 8 0
    tput setaf 1
    echo "WHO" 
    #echo "WHO" | tee -a "./$DATE.txt"
    tput sgr0
    who
    #who | tee -a "./$DATE.txt"
    echo
    
    tput setaf 1
    echo "WHOAMI"
    #echo "WHOAMI" | tee -a "./$DATE.txt"
    tput sgr0
    whoami
    #echo >> "./$DATE.txt"
    echo

    # TASK - disk utility
    #tput cup 10 0
    tput setaf 1
    echo "DISKUTIL"
    tput sgr0
    diskutil list

    # TASK - netstat
    tput setaf 1
    echo "NETSTAT"
    tput sgr0
    netstat

    # TASK
    # run top once showing 3 processes highest in cpu usage, then crop off the header 
    # containing unnecessary system wide info
    #tput cup 12 0
    tput setaf 1
    echo "TOP"
    tput sgr0
    top -l 1 -n 3 -o cpu | tail -n 4
    echo
    
    #printf '\rReady to exit?(y/n)'
    # exit prompt
    read -p "Ready to exit?(y/n) " RESPONSE;
    if [ "$RESPONSE" == "y" ]; then
	# get screenshot of output
	# -w ,
	#screencapture -P -o -r -m -a  -i "./$DATE.png"
	break
    fi
#    else sleep 60 reprompt

    ## end main program

    (( ET++ ))
    sleep 1
done

#for i in {1..10}; do
#    echo
#done

cleanup()