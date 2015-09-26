ACPI=$(which acpi)

if [[ ${#ACPI} -gt 1 ]]; then
	${ACPI} -b | awk '{gsub(/[^0-9]/,"",$4);if($4*1<=10){bg="#[bg=colour226]"}else if($4*1<=20){bg="#[bg=colour196]"}{printf"%s#[fg=colour202]Bat:%s%%",bg,$4}}/remain/{printf" %s",$5}{printf"＞"}'
fi

