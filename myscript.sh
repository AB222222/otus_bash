#!/bin/bash

echo "Starting script ..."

if ( set -o noclobber; echo "$$" > mylockfile) 2> /dev/null;
        then
	trap 'rm -f mylockfile; exit $?' INT TERM EXIT KILL

                linecount=$(cat wcfile)
                echo $linecount

                tail -n +$linecount access-4560-644067.log > temptailfile

                echo -e "\nThe first string:"
                awk '{print $4}' temptailfile | head -n 1
                echo -e "\nThe last string:"
                awk '{print $4}' temptailfile | tail -n 1


                echo -e "\nTop 10 IPs:"
                awk '{print $1}' temptailfile | sort | uniq -c | sort -r | head -n 10
                echo -e "\nTop 12 web-addresses:"
                awk '{print $7}' temptailfile | sort | uniq -c | sort -r | head -n 12
                echo -e "\nAll errors since the last script run:"
                awk '$9 >= 400 {print}' temptailfile
                echo -e "\nAll return codes since the last script run:"
                awk '{print $9}' temptailfile | sort | uniq -c | sort -r

                wc access-4560-644067.log | awk '{print $1}' > wcfile
        sleep 10
        rm -f mylockfile
        trap - INT TERM EXIT
else
    	echo "Failed to acquire lockfile: mylockfile."
        echo "Held by $(cat mylockfile)"
fi

