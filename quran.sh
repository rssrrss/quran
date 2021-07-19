#!/usr/bin/env sh
# function
# variable names, chapter is for the chapter number, schapter is for starting chapter, echapter is for end chapter.
usage() {
	echo
	echo "Usage:"
	echo "-l or --list     = List of Sura"
	echo "-s or --search  = Search for a keyword"
	echo "-eg or --example = print out some examples"
	echo "-h or --help     = print out this help message"
	echo "Example: Quran -h"
	exit
}
example() {
	echo
	echo "Quran kahf     = Will print out the complete sura Kahf"
	echo "Quran 18       = Will print out the 18th Sura in The Holy Quran"
	echo "Quran kahf:10  = Will print out the 10th verse of Sura Kahf"
	echo "Quran 18:10    = Will print out the 10th verse of 18th Sura in The Holy Quran"
	echo "Quran kahf:1-10  = Will print out the verse 1 to 10 of Sura kahf"
	echo "Quran 18:1-10    = Will print out the 1 to 10 verse of the 18th Sura in The Holy Quran"
	echo "Quran falaq-naas = Will print out Sura Falaq to Sura Naas"
	echo "Quran 113-114    = Will print out the 113th to 114th Sura in The Holy Quran"
	echo
}
verse_loop() {
while [ "$from" -le "$to" ]; do
	echo "With The Name Of Allah, The Most Merciful, The Most Gracious" >> sura.txt
	grep "\[$chapter:$from\]" /home/$USER/.local/share/Quran/q | sed 's/^\[.*:\(.*\)\]\s\(.*\)/\n\n[\1] \2/g' >> sura.txt
	from="$(( $from + 1 ))"
done
}
chapter_loop() {
	while [ "$schapter" -le "$echapter" ]; do
		#echo "With The Name Of Allah, The Most Merciful, The Most Gracious" >> sura.txt
		grep -w3 "\[$schapter:*" /home/$USER/.local/share/Quran/q | sed 's/^\[\(.*\)\]\s\(.*\)/\n\n[\1] \2/g' >> sura.txt
		schapter="$(( $schapter + 1 ))"
	done
}
opening_msg() {
	echo "With the name of Allah, The Most Merciful. The Most Gracious" >> sura.txt
	echo " " >> sura.txt
}
# End function

[ -z "$1" ] && usage
echo $1 | grep -- "-s\|--search" >> /dev/null
[ "$?" = 0 ] && grep -i "$2" /home/$USER/.local/share/Quran/q | sed 's/^\[\(.*\)\]\s\(.*\)/\n\n[\1] \2/g' | less
echo $1 | grep -- "-h\|--help" >> /dev/null
[ "$?" = 0 ] && usage
echo $1 | grep -- "-eg\|--example" >> /dev/null
[ "$?" = 0 ] && example
echo $1 | grep -- "-l\|--list" >> /dev/null
[ "$?" = 0 ] && sed -n '1,117p' /home/$USER/.local/share/Quran/q | less

# For digit interpretation

# General 
echo $1 | grep "^[[:digit:]]\+$" >> /dev/null
[ "$?" = 0 ] && grep -w3 "^\[$1:*" /home/$USER/.local/share/Quran/q | sed 's/^\[.*:\(.*\)\]\s\(.*\)/\n\n[\1] \2/g' | less

# Show verse
echo $1 | grep "^[[:digit:]]\+:[[:digit:]]\+$" >> /dev/null
[ "$?" = 0 ] && echo "$1" | sed 's/\(.*\):.*/\1/g' | xargs -I '{}' grep -m1 "^{}\.\s" /home/$USER/.local/share/Quran/q > sura.txt && opening_msg && grep "\[$1\]" /home/$USER/.local/share/Quran/q >> sura.txt && less sura.txt && rm sura.txt

# Verse range
echo $1 | grep "^[[:digit:]]\+:[[:digit:]]\+-[[:digit:]]\+$" >> /dev/null
[ "$?" = 0 ] && chapter="$(echo $1 | cut -d ':' -f1)" && from="$(echo $1 | sed 's/.*:\(.*\)-.*/\1/g')" && to="$(echo $1 | sed 's/.*-\(.*\)/\1/g')" && grep -m1 "^$chapter\.\s" /home/$USER/.local/share/Quran/q > sura.txt && verse_loop && less sura.txt && rm sura.txt

# chapter range
echo $1 | grep "^[[:digit:]]\+-[[:digit:]]\+$" | grep -v ":" >> /dev/null
[ "$?" = 0 ] && schapter="$(echo $1 | cut -d '-' -f1)" && echapter="$(echo $1 | cut -d '-' -f2)" && chapter_loop && less sura.txt && rm sura.txt

# For alphabetical interpretation

# General
echo $1 | grep "^[[:alpha:]]\+$" >> /dev/null
[ "$?" = 0 ] && achapter="$(grep -i -m1 "$1" /home/$USER/.local/share/Quran/q | cut -d '.' -f1)" && grep -w3 "^\[$achapter:*" /home/$USER/.local/share/Quran/q | sed 's/^\[.*:\(.*\)\]\s\(.*\)/\n\n[\1] \2/g' | less

# Show verse
echo $1 | grep "^[[:alpha:]]\+:[[:digit:]]\+$" >> /dev/null
#echo $1 | grep ":" && grep -v "-" && grep -i -m1 "$(echo $1 | cut -d ':' -f1)" /home/$USER/.local/share/Quran/q >> /dev/null
[ "$?" = 0 ] && verse="$(echo $1 | cut -d ':' -f2)" && chapter="$(echo $1 | cut -d ':' -f1 | xargs -I '{}' grep -i -m1 "{}" /home/$USER/.local/share/Quran/q | cut -d '.' -f1)" && grep -i -m1 "^$chapter\.\s" /home/$USER/.local/share/Quran/q > sura.txt && opening_msg && grep "\[$chapter:$verse\]" /home/$USER/.local/share/Quran/q >> sura.txt && less sura.txt && rm sura.txt

# Verse range
echo $1 | grep "^[[:alpha:]]\+:[[:digit:]]\+-[[:digit:]]\+$" >> /dev/null
#echo $1 | grep ":" && grep "-" && grep -i -m1 "$(echo $1 | cut -d ':' -f1)" /home/$USER/.local/share/Quran/q >> /dev/null
[ "$?" = 0 ] && chapter="$(echo $1 | cut -d ':' -f1 | xargs -I '{}' grep -i -m1 "{}" /home/$USER/.local/share/Quran/q | cut -d '.' -f1)" && from="$(echo $1 | sed 's/.*:\(.*\)-.*/\1/g')" && to="$(echo $1 | sed 's/.*-\(.*\)/\1/g')" && grep -i -m1 "^$chapter\.\s" /home/$USER/.local/share/Quran/q > sura.txt && verse_loop && less sura.txt && rm sura.txt

# chapter range
echo $1 | grep "^[[:alpha:]]\+-[[:alpha:]]\+$" >> /dev/null
#echo $1 | grep -v ":" && grep "[[:alpha:]]\+-[[:alpha:]]" /home/$USER/.local/share/Quran/q >> /dev/null
[ "$?" = 0 ] && schapter="$(echo $1 | cut -d '-' -f1 | xargs -I '{}' grep -i -m1 "{}" /home/$USER/.local/share/Quran/q | cut -d '.' -f1)" && echapter="$(echo $1 | cut -d '-' -f2 | xargs -I '{}' grep -i -m1 "{}" /home/$USER/.local/share/Quran/q | cut -d '.' -f1)" && chapter_loop && less sura.txt && rm sura.txt
