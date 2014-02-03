acpi -b | awk '{if($3=="Charging," || $3=="Unknown,"){print "Charging",$4}else{print $4,$5}}' | sed -e "s/,//g"
