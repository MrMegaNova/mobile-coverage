echo "============================================================"
echo "                    MOBILE COVERAGE TESTER                  "
echo "============================================================"

check_coverage () {
	#Clean old files
	rm -f cordinates.txt temp.pos
	#Ask address
	read -p "Please type address and / or city:" pos
	#Clean field and ask API
	pos=$(echo $pos | sed "s/ /+/g")
	wget -q "https://nominatim.openstreetmap.org/search?q=$pos&format=json&polygon=1&addressdetails=1" -O temp.pos
	jq '.[0].lat, .[0].lon' temp.pos > cordinates.txt
	rm -f temp.pos
	sed -i 's|["]||g' cordinates.txt
	address_check=$(head -n1 cordinates.txt)
	if [ "$address_check" != "null" ]
	then
		echo "Cordinates: $(cat cordinates.txt)"
	fi	
	rm -f coordinates.txt
}

check_coverage

while [ "$address_check" = "null" ]
do
	echo "Unable to find address, please try with: Street City Country"
	check_coverage
done
