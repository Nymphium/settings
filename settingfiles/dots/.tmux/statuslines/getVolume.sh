amixer -c "${SNDC}" | awk '
	BEGIN {
		mcnt = 0; scnt = 0; hcnt = 0;
		col = 196
	} ($0 ~ /Master/) || (mcnt > 0 && mcnt < 5) {mcnt++} mcnt == 5 {
		if($6 ~ /on/) col = 255;
		gsub(/[^0-9]/, "", $4); vol = $4; mcnt = 0
	} ($0 ~ /Headphone/) || (hcnt > 0 && hcnt < 6) {hcnt++} hcnt == 6 {
		hflg = $7 ~ /on/ ? "🎧" : ""; hcnt = 0
	} $0 ~ /Speaker/ || (scnt > 0 && scnt < 6) {scnt++} scnt == 6 {
		sflg = $7 ~ /on/ ? "🔊" : ""; scnt = 0
	} END {
		printf "#[fg=colour%d]%s%svol:%d%%> #[fg=colour27]", col, hflg, sflg, vol
	}'

