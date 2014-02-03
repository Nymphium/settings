acpi -b | awk '{print $4}' | sed -e "s/%//g" | awk '{if($1 < 10){print "#[fg=red]"}else if($1 < 20){print "#[fg=yellow]"}else if($1 >20){print "#[fg=black]"}}'
