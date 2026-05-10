#!/bin/bash
#
#
#Antagningsprov Bash Scripting till Chas Academy
#Gjort av: Erik Lindbom
#
#

idu=$(id -u) #Sätt id -u som variabel -u för användning i test

if [ "$idu" -ne 0 ]; then        #Testa om användaren är UID 0 om inte avsluta script
        echo "Otilltäcklig behörighet, avslutar script"
       exit 1
fi
if [ $# -eq 0 ]; then           #Testa om inga argument gavs isf avsluta script, om $# (number of arg = 0) avsluta
        echo "Inga användarnamn gavs, avslutar script"
        exit 1
fi
for nuser in "$@"               #$@ Håller skriptargumenten
do
        useradd -m "$nuser"	#Skapa alla användare 
done
for nuser in "$@"		#$@ Behåller samma värde från första, för att använda i mkdir loopen nedan.
do
        home_dir="/home/$nuser"	#Sätter denna path för att köra mkdir hos nya användare. 
        for folders in Documents Downloads Work         #När alla användare har gjorts, så görs mapparna.  
        do
                mkdir -m 700 "$home_dir/$folders"       #Skapa directories,om perm är 600 kan ägare ej gå in
        done

                chown -R "$nuser:$nuser" "$home_dir"    # Byt ägare på den nya användarens home directory till den nya användaren, -R för recursively
                users=$(awk -F: '$3 >= 1000 {print $1}' /etc/passwd) #Splitta linjerna med :, kolla om UID ($3) är över 1000, om så är fallet, printa användarnamnet ($1)
	       	printf "Välkommen %s\n" "$nuser" >> "$home_dir/welcome.txt" #%s=sätt in string placeholder. Första %s="$nuser" osv
                printf '%s\n' "$users" >> "$home_dir/welcome.txt" #Skicka användarnamn från passwd till welcome.txt
                cat "$home_dir/welcome.txt" #Cat för lättläslighet av output.
done

