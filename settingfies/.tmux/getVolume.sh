echo `amixer -c 0 set Headphone 0%- | grep Left | grep -v channel | sed -e "s/\[//" | sed -e "s/%.*//" | sed -e "s/^.* //g"`
