() {
	typeset -A default; 
	COMP_IGNORES=${COMP_IGNORES:-${default}}
	COMP_IGNORES+=(
		lock # lock file
		a o # somewhat object files
		cmi cmo cma cmx cmxa opt run cache annot omc # OCaml
		out dvi lfs fdb_latexmk blg bbl aux log pdf fls synctex.gz # LaTeX
	);

	zstyle ':completion:*:*:'${EDITOR}':*' file-patterns '^*.('"${(j:|:)COMP_IGNORES}"')' '*:all-files'
}

add_comp_ignores () {
	COMP_IGNORES+=(${@})
	zstyle ':completion:*:*:'${EDITOR}':*' file-patterns '^*.('"${(j:|:)COMP_IGNORES}"')' '*:all-files'
}

remove_comp_ignores () {
	for e in $@; {
		for ((i = 1; i <= ${#COMP_IGNORES}; i++)) {
			[[ "${COMP_IGNORES[${i}]}" = "${e}" ]] &&\
				unset "COMP_IGNORES[${i}]"
		}
	}

	zstyle ':completion:*:*:'${EDITOR}':*' file-patterns '^*.('"${(j:|:)COMP_IGNORES}"')' '*:all-files'
}

