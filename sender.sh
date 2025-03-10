#!/bin/bash
pid=$$
echo "pr:"$pid
trap 'pkill -P $pid; exit' INT

cdef='\e[0m' #color default
cred='\e[0;31m' #color red
cgreen='\e[0;32m' #color green
usr=$(whoami)
chatlog='chat.log'
ip=$(hostname -I | cut -d " " -f 1)
brd=$(ip a | grep $ip | cut -d " " -f 8)

export CHATPIPE="4532ggfT"
echo $usr > $CHATPIPE
./alive.sh &

echo "WELCOME TO LAST CHAT!"

helpmex="\nCOMMANDS\n\tusername: change username\n\tsend: send message\n\texit: quit chat\n\tdebug: send debug messages every 2s\n\thelp: print this message\n"
echo -e $helpmex

while [[ true ]]
do
	echo -n "> "
	read i

	if [[ $i == "help" ]]
	then
		echo "[$(date +%r)] $usr: help"
		echo -e $helpmex
	fi

	if [[ $i == "username" ]]
	then
		oldusr=$usr
		echo -ne "${cred}new username: $cdef"
		read usr
		echo $usr > $CHATPIPE
		echo "[$(date +%r)] new username: $oldusr -> $usr" | nc -q 0 -buN $brd 4444
	fi

	if [[ $i == "send" ]]
	then
		echo -ne "${cgreen}message: $cdef"
		read mex
		echo "[$(date +%r)] $usr: $mex" | nc -q 0 -buN $brd 4444
	fi

	if [[ $i == "debug" ]]
	then
		i=0
		while [[ true ]]
		do
			mex="deb"$i
			echo -ne "${cgreen}message: $cdef $mex\n"
			echo "[$(date +%r)] $usr: $mex" | nc -q 0 -buN $brd 4444
			i=$(( $i+1 ))
			sleep 2
		done
	fi

	if [[ $i == "exit" ]]
	then
		exit
	fi
done
