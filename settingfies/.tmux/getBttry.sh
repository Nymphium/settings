COLOR=`acpi -b | awk '{print $4}' | sed -e "s/%//g" | awk '{if($1 < 10){print "#[fg=red]"}else if($1 < 20){print "#[fg=yellow]"}else{print "#[fg=black]"}}'`

BATTERY=`acpi -b | awk '{if($3=="Charging," || $3=="Unknown,"){print "Charging",$4}else{print $4,$5}}' | sed -e "s/,//g"`

echo "${COLOR}Battery:${BATTERY}"
