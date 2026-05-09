#!/bin/bash
#
#
#Antagningsprov Bash Scripting till Chas Academy
#Gjort av: Erik Lindbom
#
#

idu=$(id -u) #Sätt id -u som variabel -u för användning i test
users=$(awk -F: '{print $1}' /etc/passwd) #Filtrera fält med : och printa $1 AWK från /etc/passwd. Detta inkluderar alla användare inkl system användare. alternativt: cut -d: -f1 /etc/passwd

if [ "$idu" -ne 0 ]; then        #Testa om användaren är UID 0 om inte avsluta script
        echo "Otilltäcklig behörighet, avslutar script"
       exit 1
fi
if [ $# -eq 0 ]; then           #Testa om inga argument gavs isf avsluta script, om $# (number of arg = 0) avsluta
        echo "Inga användarnamn gavs, avslutar script"
        exit 1
fi
for nuser in "$@"               #Sätt värdet av $@ till "nuser" variabeln per iteration
do
        useradd -m "$nuser"     #Skapa en användare, om /home inte finns så skapa /home
        home_dir="/home/$nuser"
        for folders in Documents Downloads Work         #Varje rotation körs mkdir för folders variabeln, rotation 1=Documents, rotation 2=Downloads, rotation 3=Work
        do
                mkdir -m 700 "$home_dir/$folders"       #Skapa directories,om perm är 600 kan ägare ej gå in
        done

                chown -R "$nuser:$nuser" "$home_dir"    #chown owner:group Byt ägare på den nya användarens home directory till den nya användaren, -R för recursively
                printf "%s\n\n" "<================================================================>" >> "$home_dir/welcome.txt"   #Formattering av välkomstmeddelande för lättläslighet
                printf "VÄLKOMMEN TILL SYSTEMET %s, ANDRA ANVÄNDARE FINNS NEDANFÖR\n\n" "$nuser" >> "$home_dir/welcome.txt" #%s=sätt in string placeholder. Första %s="$nuser" osv
                printf "%s\n\n" "<================================================================>" >> "$home_dir/welcome.txt"
                printf '%s\n' "$users" >> "$home_dir/welcome.txt"                 
                cat "$home_dir/welcome.txt"
done

