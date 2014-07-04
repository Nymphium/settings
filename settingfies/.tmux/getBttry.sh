ACPIB=`acpi -b`

if [ ${#ACPIB} -gt 1 ]; then
	COLOR=`acpi -b | sed -e "s/.* \([0-9]*\)%.*/\1/g" | \
		awk '{
			if($1 <= 10){
				print "#[fg=yellow,bg=colour196]"
			}else if($1 <= 20){
				print "#[fg=black,bg=yellow]"
			}else{
				print "#[fg=colour76,bg=colour235]"
			}
		}'`

	BATTERY=`acpi -b | \
		awk '{
			if($3=="Charging," || $3=="Unknown,"){
				print "Charging",$4
			}else{
				print $4,$5
			}
		}' | \

		sed -e "s/,\|\s$//g" -e "s/%/%%/"`

	printf "${COLOR}Bat:${BATTERY}＞"
fi
