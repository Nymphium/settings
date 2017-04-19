ACPI=$(which acpi)

if [[ ${#ACPI} -gt 1 ]]; then
	${ACPI} -b | awk '{fgnum=202;gsub(/[^0-9]/,"",$4);if($4*1<=10){bg="#[bg=colour196]";fgnum=255}else if($4*1<=20){bg="#[bg=colour226]"}{printf"%s#[fg=colour%s]Bat:%s%%",bg,fgnum,$4}}/remain/{printf" %s",$5}/charged/{printf" Charged"}{printf"#[bg=colour235]＞"}'
fi

